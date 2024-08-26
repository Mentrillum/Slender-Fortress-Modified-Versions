#if defined _sf2_npc_included
 #endinput
#endif
#define _sf2_npc_included

#pragma semicolon 1

#define SF2_BOSS_PAGE_CALCULATION 512.0
#define SF2_BOSS_COPY_SPAWN_MIN_DISTANCE 800.0 // The default minimum distance boss copies can spawn from each other.

#define SF2_BOSS_ATTACK_MELEE 0

static int g_NpcGlobalUniqueID = 0;

static SF2BossProfileData g_NpcProfileData[MAX_BOSSES];

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
bool g_NpcRaidHitbox[MAX_BOSSES] = { false, ... };
static float g_NpcSoundMusicLoop[MAX_BOSSES][Difficulty_Max];
static int g_NpcAllowMusicOnDifficulty[MAX_BOSSES];
static char g_NpcName[MAX_BOSSES][Difficulty_Max][SF2_MAX_PROFILE_NAME_LENGTH];
static bool g_NpcHasFakeCopiesEnabled[MAX_BOSSES][Difficulty_Max];
static float g_NpcBlinkLookRate[MAX_BOSSES];
static float g_NpcBlinkStaticRate[MAX_BOSSES];
static float g_NpcStepSize[MAX_BOSSES];
static int g_NpcTeleporters[MAX_BOSSES][MAX_NPCTELEPORTER];
static int g_NpcModelMaster[2049];

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

int g_SlenderEnt[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };

static float g_NpcAddSpeed[MAX_BOSSES];
static float g_NpcAddAcceleration[MAX_BOSSES];
static float g_NpcIdleLifetime[MAX_BOSSES][Difficulty_Max];

static float g_NpcScareRadius[MAX_BOSSES];
static float g_NpcScareCooldown[MAX_BOSSES];

static bool g_NpcHasPlayerScareSpeedBoost[MAX_BOSSES];
static float g_NpcPlayerSpeedBoostDuration[MAX_BOSSES];

static bool g_NpcHasPlayerScareReaction[MAX_BOSSES];
static int g_NpcPlayerScareReactionType[MAX_BOSSES];

static bool g_NpcHasPlayerScareReplenishSprint[MAX_BOSSES];
static float g_NpcPlayerScareReplenishSprintAmount[MAX_BOSSES];

static int g_NpcTeleportType[MAX_BOSSES] = { -1, ... };

static bool g_NpcHasDeathCamEnabled[MAX_BOSSES] = { false, ... };

static bool g_NpcHasProxyWeaponsEnabled[MAX_BOSSES] = { false, ... };

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

static bool g_NpcShouldBeAffectedBySight[MAX_BOSSES];

static int g_NpcDefaultTeam[MAX_BOSSES];

static bool g_NpcWasKilled[MAX_BOSSES];

Handle timerMusic = null; //Planning to add a bosses array on.

bool NPCGetBossName(int npcIndex = -1, char[] buffer, int bufferLen, char profile[SF2_MAX_PROFILE_NAME_LENGTH] = "")
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
	g_OnEntityDestroyedPFwd.AddFunction(null, EntityDestroyed);
	g_OnEntityTeleportedPFwd.AddFunction(null, EntityTeleported);
	g_OnPlayerLookAtBossPFwd.AddFunction(null, OnPlayerLookAtBoss);

	NPCChaserInitialize();
	SetupNPCGlows();
}

void NPC_InitializeAPI()
{
	g_OnBossAddedFwd = new GlobalForward("SF2_OnBossAdded", ET_Ignore, Param_Cell);
	g_OnBossSpawnFwd = new GlobalForward("SF2_OnBossSpawn", ET_Ignore, Param_Cell);
	g_OnBossDespawnFwd = new GlobalForward("SF2_OnBossDespawn", ET_Ignore, Param_Cell);
	g_OnBossRemovedFwd = new GlobalForward("SF2_OnBossRemoved", ET_Ignore, Param_Cell);
	g_OnBossFinishSpawningFwd = new GlobalForward("SF2_OnBossFinishSpawning", ET_Ignore, Param_Cell);
	g_OnClientCaughtByBossFwd = new GlobalForward("SF2_OnClientCaughtByBoss", ET_Ignore, Param_Cell, Param_Cell);

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
	CreateNative("SF2_IsBossSpawning", Native_IsBossSpawning);
	CreateNative("SF2_DespawnBoss", Native_DespawnBoss);

	CreateNative("SF2_GetBossPathFollower", Native_GetBossPathFollower);
	CreateNative("SF2_GetBossMaster", Native_GetBossMaster);
	CreateNative("SF2_GetBossIdleLifetime", Native_GetBossIdleLifetime);
	CreateNative("SF2_GetBossState", Native_GetBossState);
	CreateNative("SF2_SetBossState", Native_SetBossState);

	CreateNative("SF2_GetBossEyePosition", Native_GetBossEyePosition);
	CreateNative("SF2_GetBossEyePositionOffset", Native_GetBossEyePositionOffset);

	CreateNative("SF2_GetBossTeleportThinkTimer", Native_GetBossTeleportThinkTimer);
	CreateNative("SF2_SetBossTeleportThinkTimer", Native_SetBossTeleportThinkTimer);
	CreateNative("SF2_GetBossTeleportTarget", Native_GetBossTeleportTarget);

	CreateNative("SF2_GetBossGoalPosition", Native_GetBossGoalPosition);

	CreateNative("SF2_GetBossTimeUntilNoPersistence", Native_Nothing);
	CreateNative("SF2_SetBossTimeUntilNoPersistence", Native_Nothing);
	CreateNative("SF2_GetBossTimeUntilAlert", Native_GetBossCurrentChaseDuration);
	CreateNative("SF2_SetBossTimeUntilAlert", Native_SetBossCurrentChaseDuration);

	CreateNative("SF2_GetProfileFromBossIndex", Native_GetProfileData);
	CreateNative("SF2_GetProfileFromName", Native_GetProfileDataEx);

	CreateNative("SF2_SpawnBossEffects", Native_SpawnBossEffects);

	CreateNative("SF2_CanBossBeSeen", Native_CanBossBeSeen);
}

static void EntityDestroyed(CBaseEntity ent, const char[] classname)
{
	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC.FromEntity(ent.index);
	if (controller.IsValid())
	{
		NPCOnDespawn(controller, ent);
	}
}

static void EntityTeleported(CBaseEntity teleporter, CBaseEntity activator)
{
	int flags = teleporter.GetProp(Prop_Data, "m_spawnflags");
	if (((flags & TRIGGER_CLIENTS) != 0 && (flags & TRIGGER_NPCS)) || (flags & TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS) != 0)
	{
		SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(NPCGetFromEntIndex(activator.index));
		if (controller.IsValid())
		{
			// A boss took a teleporter, remove it from our list if possible
			SF2_BaseBoss boss = SF2_BaseBoss(controller.EntIndex);
			ArrayList teleporters = boss.Teleporters;
			int index = teleporters.FindValue(teleporter.index);
			if (index != -1)
			{
				teleporters.Erase(index);
			}
		}
		else
		{
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(i);
				if (!npc.IsValid())
				{
					continue;
				}

				SF2_BaseBoss boss = SF2_BaseBoss(npc.EntIndex);
				if (!SF2_ChaserEntity(npc.EntIndex).IsValid() && !SF2_StatueEntity(npc.EntIndex).IsValid())
				{
					continue;
				}

				if (boss.Target == activator)
				{
					// The boss target took a teleporter and the boss can follow, add the teleporter to the list of teleporters
					boss.Teleporters.Push(teleporter.index);
				}
			}
		}
	}
	else
	{
		for (int i = 0; i < MAX_BOSSES; i++)
		{
			SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(i);
			if (!controller.IsValid())
			{
				continue;
			}

			SF2_BaseBoss boss = SF2_BaseBoss(controller.EntIndex);
			if (!SF2_ChaserEntity(controller.EntIndex).IsValid() && !SF2_StatueEntity(controller.EntIndex).IsValid())
			{
				continue;
			}

			// Currently a boss is chasing this entity but the boss cannot follow, abort the chase state
			if (boss.Target == activator)
			{
				boss.Target = CBaseEntity(-1);
				boss.OldTarget = CBaseEntity(-1);

				// OR if we're supposed to endlessly chase, despawn us otherwise that'd lead to some bad moments
				if (SF_IsRaidMap() || SF_BossesChaseEndlessly() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsSlaughterRunMap())
				{
					controller.UnSpawn();
				}

				if (controller.Type == SF2BossType_Chaser)
				{
					if (view_as<SF2NPC_Chaser>(controller).GetProfileData().ChasesEndlessly)
					{
						controller.UnSpawn();
					}
				}
			}
		}
	}
}

static void OnPlayerLookAtBoss(SF2_BasePlayer client, SF2NPC_BaseNPC boss)
{
	switch (boss.Type)
	{
		case SF2BossType_Statue:
		{
			if (g_PlayerPreferences[client.index].PlayerPreference_ShowHints && !client.HasHint(PlayerHint_Blink))
			{
				client.ShowHint(PlayerHint_Blink);
			}
		}
	}
}

void NPCOnDespawn(SF2NPC_BaseNPC controller, CBaseEntity entity, bool killed = false)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	controller.GetProfile(profile, sizeof(profile));
	int bossIndex = controller.Index;
	SF2BossProfileData data;
	data = controller.GetProfileData();
	Call_StartForward(g_OnBossDespawnFwd);
	Call_PushCell(bossIndex);
	Call_Finish();

	//Turn off all slender's effects in order to prevent some bugs.
	SlenderRemoveEffects(bossIndex, true);

	if (controller.Type == SF2BossType_Statue)
	{
		Despawn_Statue(SF2NPC_Statue(bossIndex), entity);
	}
	else
	{
		Despawn_Chaser(bossIndex);
	}

	if (g_BossPathFollower[bossIndex] != view_as<PathFollower>(0) && g_BossPathFollower[bossIndex].IsValid())
	{
		g_BossPathFollower[bossIndex].Invalidate();
	}

	if (data.DespawnEffects != null)
	{
		if (killed && data.HideDespawnEffectsOnDeath)
		{
			// Do nothing
		}
		else
		{
			StringMapSnapshot snapshot = data.DespawnEffects.Snapshot();
			char key[64];
			snapshot.GetKey(GetRandomInt(0, snapshot.Length - 1), key, sizeof(key));
			ArrayList effects;
			data.DespawnEffects.GetValue(key, effects);
			float pos[3], ang[3];
			CBaseEntity(NPCGetEntIndex(bossIndex)).GetAbsOrigin(pos);
			CBaseEntity(NPCGetEntIndex(bossIndex)).GetAbsAngles(ang);
			SlenderSpawnEffects(effects, bossIndex, false, pos, ang, _, _, true);
			delete snapshot;
		}
	}

	if (data.EngineSound[0] != '\0')
	{
		StopSound(entity.index, SNDCHAN_STATIC, data.EngineSound);
	}

	if (NPCGetFlags(bossIndex) & SFF_HASSTATICLOOPLOCALSOUND)
	{
		char loopSound[PLATFORM_MAX_PATH];
		GetBossProfileStaticLocalSound(profile, loopSound, sizeof(loopSound));

		if (loopSound[0] != '\0')
		{
			StopSound(entity.index, SNDCHAN_STATIC, loopSound);
		}
	}
	if (SF_IsRaidMap() || SF_BossesChaseEndlessly() || data.Healthbar)
	{
		controller.Flags = controller.Flags & ~SFF_NOTELEPORT;
	}

	g_SlenderEnt[bossIndex] = INVALID_ENT_REFERENCE;
	if (data.Healthbar && g_HealthBar != -1)
	{
		int npcIndex = 0;
		for (npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{
			if (NPCGetUniqueID(npcIndex) == -1)
			{
				continue;
			}
			data = NPCGetProfileData(npcIndex);
			if (data.Healthbar)
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

void NPCOnConfigsExecuted()
{
	g_NpcGlobalUniqueID = 0;
}

bool NPCIsValid(int npcIndex)
{
	return npcIndex >= 0 && npcIndex < MAX_BOSSES && NPCGetUniqueID(npcIndex) != -1;
}

int NPCGetUniqueID(int npcIndex)
{
	return g_NpcUniqueID[npcIndex];
}

int NPCGetFromUniqueID(int NPCUniqueID)
{
	if (NPCUniqueID == -1)
	{
		return -1;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == NPCUniqueID)
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

bool NPCGetProfile(int npcIndex, char[] buffer, int bufferLen)
{
	strcopy(buffer, bufferLen, g_SlenderProfile[npcIndex]);
	return true;
}

SF2BossProfileData NPCGetProfileData(int npcIndex)
{
	return g_NpcProfileData[npcIndex];
}

void NPCSetProfileData(int npcIndex, SF2BossProfileData value)
{
	g_NpcProfileData[npcIndex] = value;
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
	for (int i = 1; i <= MaxClients; i++)
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
		SF2BossProfileData data;
		data = NPCGetProfileData(i);
		if (data.IsPvEBoss)
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
			for(int client = 1;client <= MaxClients; client++)
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
						case Difficulty_Normal:
						{
							strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackNormal);
						}
						case Difficulty_Hard:
						{
							strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackHard);
						}
						case Difficulty_Insane:
						{
							strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackInsane);
						}
						case Difficulty_Nightmare:
						{
							strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackNightmare);
						}
						case Difficulty_Apollyon:
						{
							strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackApollyon);
						}
					}
					if (currentMusicTrack[0] != '\0')
					{
						timerMusic = CreateTimer(NPCGetSoundMusicLoop(i, difficulty), BossMusic, i, TIMER_FLAG_NO_MAPCHANGE);
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
				}
			}
			break;
		}
	}
}

bool MusicActive()
{
	if (timerMusic != null)
	{
		return true;
	}
	return false;
}

bool BossHasMusic(char[] profile)
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

bool BossMatchesCurrentMusic(char[] profile)
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

void GetBossMusic(char[] buffer,int bufferLen)
{
	int difficulty = g_DifficultyConVar.IntValue;
	switch (difficulty)
	{
		case Difficulty_Normal:
		{
			strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackNormal);
			strcopy(buffer, bufferLen, currentMusicTrackNormal);
		}
		case Difficulty_Hard:
		{
			strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackHard);
			strcopy(buffer, bufferLen, currentMusicTrackHard);
		}
		case Difficulty_Insane:
		{
			strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackInsane);
			strcopy(buffer, bufferLen, currentMusicTrackInsane);
		}
		case Difficulty_Nightmare:
		{
			strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackNightmare);
			strcopy(buffer, bufferLen, currentMusicTrackNightmare);
		}
		case Difficulty_Apollyon:
		{
			strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackApollyon);
			strcopy(buffer, bufferLen, currentMusicTrackApollyon);
		}
	}
}

static Action BossMusic(Handle timer, any bossIndex)
{
	int difficulty = g_DifficultyConVar.IntValue;
	float time = NPCGetSoundMusicLoop(bossIndex, difficulty);
	SF2BossProfileData data;
	data = NPCGetProfileData(bossIndex);
	if (!data.IsPvEBoss && time > 0.0 && (g_NpcAllowMusicOnDifficulty[bossIndex] & difficulty))
	{
		if (bossIndex > -1)
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(bossIndex, profile, sizeof(profile));
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && currentMusicTrack[0] != '\0')
				{
					StopSound(i, MUSIC_CHAN, currentMusicTrack);
				}
			}
			timerMusic = CreateTimer(time, BossMusic, bossIndex, TIMER_FLAG_NO_MAPCHANGE);
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

bool NPCGetRaidHitbox(int npcIndex)
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

bool NPCGetRainbowOutlineState(int npcIndex)
{
	return g_SlenderUseRainbowOutline[npcIndex];
}

void NPCSetAddSpeed(int npcIndex, float amount)
{
	g_NpcAddSpeed[npcIndex] += amount;
}

void NPCSetAddAcceleration(int npcIndex, float amount)
{
	g_NpcAddAcceleration[npcIndex] += amount;
}

float NPCGetAddSpeed(int npcIndex)
{
	return g_NpcAddSpeed[npcIndex];
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

SF2NPC_BaseNPC NPCGetCopyMaster(SF2NPC_BaseNPC controller)
{
	return SF2NPC_BaseNPC(g_SlenderCopyMaster[controller.Index]);
}

SF2NPC_BaseNPC NPCGetCompanionMaster(SF2NPC_BaseNPC controller)
{
	return SF2NPC_BaseNPC(g_SlenderCompanionMaster[controller.Index]);
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

float NPCGetScareReplenishSprintAmount(int npcIndex)
{
	return g_NpcPlayerScareReplenishSprintAmount[npcIndex];
}

int NPCGetTeleportType(int npcIndex)
{
	return g_NpcTeleportType[npcIndex];
}

bool NPCGetFakeCopyState(int npcIndex, int difficulty)
{
	return g_NpcHasFakeCopiesEnabled[npcIndex][difficulty];
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

bool NPCGetAffectedBySightState(int npcIndex)
{
	return g_NpcShouldBeAffectedBySight[npcIndex];
}

void NPCSetAffectedBySightState(int npcIndex, bool state)
{
	g_NpcShouldBeAffectedBySight[npcIndex] = state;
}

int NPCGetDefaultTeam(int npcIndex)
{
	return g_NpcDefaultTeam[npcIndex];
}

void NPCSetDefaultTeam(int npcIndex, int team)
{
	g_NpcDefaultTeam[npcIndex] = team;
}

bool NPCGetWasKilled(int npcIndex)
{
	return g_NpcWasKilled[npcIndex];
}

void NPCSetWasKilled(int npcIndex, bool state)
{
	g_NpcWasKilled[npcIndex] = state;
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

	if (NPCGetType(npcIndex) == SF2BossType_Statue)
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
void NPCGetEyePosition(int npcIndex, float buffer[3], const float defaultValue[3] = { 0.0, 0.0, 0.0 })
{
	buffer[0] = defaultValue[0];
	buffer[1] = defaultValue[1];
	buffer[2] = defaultValue[2];

	if (!NPCIsValid(npcIndex))
	{
		return;
	}

	int npcEnt = NPCGetEntIndex(npcIndex);
	if (!npcEnt || npcEnt == INVALID_ENT_REFERENCE)
	{
		return;
	}

	float pos[3], eyePosOffset[3];
	CBaseEntity(npcEnt).GetAbsOrigin(pos);
	NPCGetEyePositionOffset(npcIndex, eyePosOffset);

	AddVectors(pos, eyePosOffset, buffer);
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

	int slender = NPCGetEntIndex(bossIndex);

	switch (teleportType)
	{
		case 0:
		{
			if (NPCGetFlags(bossIndex) & SFF_STATICONRADIUS && slender != INVALID_ENT_REFERENCE && slender)
			{
				float slenderPos[3], buffer[3];
				CBaseEntity boss = CBaseEntity(slender);
				boss.GetAbsOrigin(slenderPos);

				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsValidClient(i) ||
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
			SF2_ChaserEntity chaser = SF2_ChaserEntity(slender);
			if (chaser.IsValid())
			{
				if (chaser.State == STATE_ALERT || chaser.State == STATE_CHASE || chaser.State == STATE_ATTACK || chaser.State == STATE_STUN || chaser.State == STATE_DEATH)
				{
					return false;
				}

				if (GetGameTime() < g_SlenderTimeUntilKill[bossIndex])
				{
					return false;
				}
			}

			SF2_StatueEntity statue = SF2_StatueEntity(slender);
			if (statue.IsValid())
			{
				if (statue.IsMoving)
				{
					return false;
				}

				if (GetGameTime() < g_SlenderStatueIdleLifeTime[bossIndex])
				{
					return false;
				}
			}
		}
	}

	return true;
}

bool SelectProfile(SF2NPC_BaseNPC npc, const char[] profile, int additionalBossFlags = 0, SF2NPC_BaseNPC npcCopyMaster = SF2_INVALID_NPC, bool spawnCompanions = true, bool playSpawnSound = true, bool showPvEMessage = true)
{
	if (!IsProfileValid(profile))
	{
		if (!npcCopyMaster.IsValid())
		{
			LogSF2Message("Could not select profile for boss %d: profile %s is invalid!", npc.Index, profile);
			return false;
		}
	}
	npc.Remove();

	npc.SetProfile(profile);

	SF2BossProfileData profileData;
	g_BossProfileData.GetArray(profile, profileData, sizeof(profileData));

	int bossType = GetBossProfileType(profile);

	g_NpcUniqueID[npc.Index] = g_NpcGlobalUniqueID++;
	g_NpcProfileData[npc.Index] = profileData;
	g_NpcType[npc.Index] = bossType;

	g_NpcModelScale[npc.Index] = GetBossProfileModelScale(profile);

	g_NpcModelSkin[npc.Index] = GetBossProfileSkin(profile);

	g_NpcModelSkinMax[npc.Index] = GetBossProfileSkinMax(profile);

	g_NpcModelBodyGroups[npc.Index] = GetBossProfileBodyGroups(profile);

	g_NpcModelBodyGroupsMax[npc.Index] = GetBossProfileBodyGroupsMax(profile);

	g_NpcRaidHitbox[npc.Index] = GetBossProfileRaidHitbox(profile);

	g_NpcHasIgnoreNavPrefer[npc.Index] = GetBossProfileIgnoreNavPrefer(profile);

	g_NpcBlinkLookRate[npc.Index] = GetBossProfileBlinkLookRate(profile);
	g_NpcBlinkStaticRate[npc.Index] = GetBossProfileBlinkStaticRate(profile);

	g_NpcStepSize[npc.Index] = GetBossProfileStepSize(profile);

	g_NpcHasDiscoMode[npc.Index] = GetBossProfileDiscoModeState(profile);
	g_NpcDiscoRadiusMin[npc.Index] = GetBossProfileDiscoRadiusMin(profile);
	g_NpcDiscoRadiusMax[npc.Index] = GetBossProfileDiscoRadiusMax(profile);

	g_NpcHasFestiveLights[npc.Index] = GetBossProfileFestiveLightState(profile);
	g_NpcFestiveLightBrightness[npc.Index] = GetBossProfileFestiveLightBrightness(profile);
	g_NpcFestiveLightDistance[npc.Index] = GetBossProfileFestiveLightDistance(profile);
	g_NpcFestiveLightRadius[npc.Index] = GetBossProfileFestiveLightRadius(profile);
	GetBossProfileDiscoPosition(profile, g_NpcDiscoModePos[npc.Index]);
	GetBossProfileFestiveLightPosition(profile, g_NpcFestiveLightPos[npc.Index]);
	GetBossProfileFestiveLightAngles(profile, g_NpcFestiveLightAng[npc.Index]);

	g_SlenderUseCustomOutlines[npc.Index] = GetBossProfileCustomOutlinesState(profile);
	g_SlenderUseRainbowOutline[npc.Index] = GetBossProfileRainbowOutlineState(profile);

	g_NpcHasProxyWeaponsEnabled[npc.Index] = GetBossProfileProxyWeapons(profile);

	g_NpcHasDrainCreditsState[npc.Index] = GetBossProfileDrainCreditState(profile);
	g_NpcHasProxySpawnEffectEnabled[npc.Index] = GetBossProfileProxySpawnEffectState(profile);
	g_NpcProxySpawnEffectZOffset[npc.Index] = GetBossProfileProxySpawnEffectZOffset(profile);

	if (SF_IsSlaughterRunMap())
	{
		NPCSetFlags(npc.Index, GetBossProfileFlags(profile) | additionalBossFlags | SFF_NOTELEPORT);
	}
	else
	{
		NPCSetFlags(npc.Index, GetBossProfileFlags(profile) | additionalBossFlags);
	}

	GetBossProfileEyePositionOffset(profile, g_SlenderEyePosOffset[npc.Index]);
	GetBossProfileEyeAngleOffset(profile, g_SlenderEyeAngOffset[npc.Index]);

	GetBossProfileHullMins(profile, g_SlenderDetectMins[npc.Index]);
	GetBossProfileHullMaxs(profile, g_SlenderDetectMaxs[npc.Index]);

	GetBossProfileRenderColor(profile, g_SlenderRenderColor[npc.Index]);

	g_SlenderRenderFX[npc.Index] = GetBossProfileRenderFX(profile);
	g_SlenderRenderMode[npc.Index] = GetBossProfileRenderMode(profile);

	npc.CopyMaster = SF2_INVALID_NPC;
	npc.CompanionMaster = SF2_INVALID_NPC;

	g_NpcShouldBeAffectedBySight[npc.Index] = false;

	g_NpcDefaultTeam[npc.Index] = g_DefaultBossTeamConVar.IntValue;

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcHasFakeCopiesEnabled[npc.Index][difficulty] = GetBossProfileFakeCopies(profile, difficulty);
		g_NpcSoundMusicLoop[npc.Index][difficulty] = GetBossProfileSoundMusicLoop(profile, difficulty);
		g_NpcIdleLifetime[npc.Index][difficulty] = GetBossProfileIdleLifetime(profile, difficulty);
		g_SlenderStaticRadius[npc.Index][difficulty] = GetBossProfileStaticRadius(profile, difficulty);
		g_SlenderStaticRate[npc.Index][difficulty] = GetBossProfileStaticRate(profile, difficulty);
		g_SlenderStaticRateDecay[npc.Index][difficulty] = GetBossProfileStaticRateDecay(profile, difficulty);
		g_SlenderStaticGraceTime[npc.Index][difficulty] = GetBossProfileStaticGraceTime(profile, difficulty);
		g_SlenderTeleportMinRange[npc.Index][difficulty] = GetBossProfileTeleportRangeMin(profile, difficulty);
		g_SlenderTeleportMaxRange[npc.Index][difficulty] = GetBossProfileTeleportRangeMax(profile, difficulty);
		g_NpcHasTeleportAllowed[npc.Index][difficulty] = GetBossProfileTeleportAllowed(profile, difficulty);
		g_NpcTeleportTimeMin[npc.Index][difficulty] = GetBossProfileTeleportTimeMin(profile, difficulty);
		g_NpcTeleportTimeMax[npc.Index][difficulty] = GetBossProfileTeleportTimeMax(profile, difficulty);
		g_NpcTeleportRestPeriod[npc.Index][difficulty] = GetBossProfileTeleportTargetRestPeriod(profile, difficulty);
		g_NpcTeleportStressMin[npc.Index][difficulty] = GetBossProfileTeleportTargetStressMin(profile, difficulty);
		g_NpcTeleportStressMax[npc.Index][difficulty] = GetBossProfileTeleportTargetStressMax(profile, difficulty);
		g_NpcTeleportPersistencyPeriod[npc.Index][difficulty] = GetBossProfileTeleportTargetPersistencyPeriod(profile, difficulty);
		g_NpcJumpscareDistance[npc.Index][difficulty] = GetBossProfileJumpscareDistance(profile, difficulty);
		g_NpcJumpscareDuration[npc.Index][difficulty] = GetBossProfileJumpscareDuration(profile, difficulty);
		g_NpcJumpscareCooldown[npc.Index][difficulty] = GetBossProfileJumpscareCooldown(profile, difficulty);
		g_NpcModelSkinDifficulty[npc.Index][difficulty] = GetBossProfileSkinDifficulty(profile, difficulty);
		g_NpcModelBodyGroupsDifficulty[npc.Index][difficulty] = GetBossProfileBodyGroupsDifficulty(profile, difficulty);
		g_SlenderMaxCopies[npc.Index][difficulty] = GetBossProfileMaxCopies(profile, difficulty);

		g_SlenderProxyDamageVsEnemy[npc.Index][difficulty] = GetBossProfileProxyDamageVsEnemy(profile, difficulty);
		g_SlenderProxyDamageVsBackstab[npc.Index][difficulty] = GetBossProfileProxyDamageVsBackstab(profile, difficulty);
		g_SlenderProxyDamageVsSelf[npc.Index][difficulty] = GetBossProfileProxyDamageVsSelf(profile, difficulty);
		g_SlenderProxyControlGainHitEnemy[npc.Index][difficulty] = GetBossProfileProxyControlGainHitEnemy(profile, difficulty);
		g_SlenderProxyControlGainHitByEnemy[npc.Index][difficulty] = GetBossProfileProxyControlGainHitByEnemy(profile, difficulty);
		g_SlenderProxyControlDrainRate[npc.Index][difficulty] = GetBossProfileProxyControlDrainRate(profile, difficulty);
		g_SlenderMaxProxies[npc.Index][difficulty] = GetBossProfileMaxProxies(profile, difficulty);
		g_NpcProxySpawnChanceMin[npc.Index][difficulty] = GetBossProfileProxySpawnChanceMin(profile, difficulty);
		g_NpcProxySpawnChanceMax[npc.Index][difficulty] = GetBossProfileProxySpawnChanceMax(profile, difficulty);
		g_NpcProxySpawnChanceThreshold[npc.Index][difficulty] = GetBossProfileProxySpawnChanceThreshold(profile, difficulty);
		g_NpcProxySpawnNumMin[npc.Index][difficulty] = GetBossProfileProxySpawnNumberMin(profile, difficulty);
		g_NpcProxySpawnNumMax[npc.Index][difficulty] = GetBossProfileProxySpawnNumberMax(profile, difficulty);
		g_NpcProxySpawnCooldownMin[npc.Index][difficulty] = GetBossProfileProxySpawnCooldownMin(profile, difficulty);
		g_NpcProxySpawnCooldownMax[npc.Index][difficulty] = GetBossProfileProxySpawnCooldownMax(profile, difficulty);
		g_SlenderProxyTeleportMinRange[npc.Index][difficulty] = GetBossProfileProxyTeleportRangeMin(profile, difficulty);
		g_SlenderProxyTeleportMaxRange[npc.Index][difficulty] = GetBossProfileProxyTeleportRangeMax(profile, difficulty);
		g_NpcDrainCreditAmount[npc.Index][difficulty] = GetBossProfileDrainCreditAmount(profile, difficulty);
	}

	ArrayList arrayNames;

	arrayNames = GetBossProfileNames(profile);
	arrayNames.GetString(Difficulty_Normal, g_NpcName[npc.Index][1], sizeof(g_NpcName[][]));

	strcopy(g_NpcName[npc.Index][0], sizeof(g_NpcName[][]), g_NpcName[npc.Index][1]);

	arrayNames.GetString(Difficulty_Hard, g_NpcName[npc.Index][2], sizeof(g_NpcName[][]));

	arrayNames.GetString(Difficulty_Insane, g_NpcName[npc.Index][3], sizeof(g_NpcName[][]));

	arrayNames.GetString(Difficulty_Nightmare, g_NpcName[npc.Index][4], sizeof(g_NpcName[][]));

	arrayNames.GetString(Difficulty_Apollyon, g_NpcName[npc.Index][5], sizeof(g_NpcName[][]));

	arrayNames = null;

	g_NpcHasJumpscareOnScare[npc.Index] = GetBossProfileJumpscareOnScare(profile);

	g_NpcScareRadius[npc.Index] = GetBossProfileScareRadius(profile);
	g_NpcScareCooldown[npc.Index] = GetBossProfileScareCooldown(profile);

	g_NpcHasPlayerScareSpeedBoost[npc.Index] = GetBossProfileSpeedBoostOnScare(profile);
	g_NpcPlayerSpeedBoostDuration[npc.Index] = GetBossProfileScareSpeedBoostDuration(profile);

	g_NpcHasPlayerScareReaction[npc.Index] = GetBossProfileScareReactionState(profile);
	g_NpcPlayerScareReactionType[npc.Index] = GetBossProfileScareReactionType(profile);

	g_NpcHasPlayerScareReplenishSprint[npc.Index] = GetBossProfileScareReplenishState(profile);
	g_NpcPlayerScareReplenishSprintAmount[npc.Index] = GetBossProfileScareReplenishAmount(profile);

	g_NpcTeleportType[npc.Index] = GetBossProfileTeleportType(profile);

	g_SlenderTeleportIgnoreChases[npc.Index] = GetBossProfileTeleportIgnoreChases(profile);

	g_SlenderTeleportIgnoreVis[npc.Index] = GetBossProfileTeleportIgnoreVis(profile);

	g_SlenderProxiesAllowNormalVoices[npc.Index] = GetBossProfileProxyAllowNormalVoices(profile);

	g_NpcDeathMessageDifficultyIndexes[npc.Index] = GetBossProfileChatDeathMessageDifficultyIndexes(profile);

	g_NpcAddSpeed[npc.Index] = 0.0;
	g_NpcAddAcceleration[npc.Index] = 0.0;

	// Deathcam values.
	npc.DeathCamEnabled = GetBossProfileDeathCamState(profile);
	g_SlenderDeathCamScareSound[npc.Index] = GetBossProfileDeathCamScareSound(profile);
	g_SlenderPublicDeathCam[npc.Index] = GetBossProfilePublicDeathCamState(profile);
	g_SlenderPublicDeathCamSpeed[npc.Index] = GetBossProfilePublicDeathCamSpeed(profile);
	g_SlenderPublicDeathCamAcceleration[npc.Index] = GetBossProfilePublicDeathCamAcceleration(profile);
	g_SlenderPublicDeathCamDeceleration[npc.Index] = GetBossProfilePublicDeathCamDeceleration(profile);
	g_SlenderPublicDeathCamBackwardOffset[npc.Index] = GetBossProfilePublicDeathCamBackwardOffset(profile);
	g_SlenderPublicDeathCamDownwardOffset[npc.Index] = GetBossProfilePublicDeathCamDownwardOffset(profile);
	g_SlenderDeathCamOverlay[npc.Index] = GetBossProfileDeathCamOverlayState(profile);
	g_SlenderDeathCamOverlayTimeStart[npc.Index] = GetBossProfileDeathCamOverlayStartTime(profile);
	g_SlenderDeathCamTime[npc.Index] = GetBossProfileDeathCamTime(profile);

	g_SlenderFakeTimer[npc.Index] = null;
	g_SlenderEntityThink[npc.Index] = null;
	g_SlenderDeathCamTimer[npc.Index] = null;
	g_SlenderDeathCamTarget[npc.Index] = INVALID_ENT_REFERENCE;
	g_SlenderNextTeleportTime[npc.Index] = 0.0;
	g_SlenderTimeUntilKill[npc.Index] = -1.0;
	g_SlenderNextJumpScare[npc.Index] = -1.0;
	g_SlenderTimeUntilNextProxy[npc.Index] = -1.0;

	g_SlenderCustomOutroSong[npc.Index] = profileData.OutroMusic;

	for (int i = 1; i <= MaxClients; i++)
	{
		g_SlenderTeleportPlayersRestTime[npc.Index][i] = -1.0;
	}

	g_SlenderTeleportTarget[npc.Index] = INVALID_ENT_REFERENCE;
	g_SlenderProxyTarget[npc.Index] = INVALID_ENT_REFERENCE;
	g_SlenderTeleportMaxTargetStress[npc.Index] = 9999.0;
	g_SlenderTeleportMaxTargetTime[npc.Index] = -1.0;
	g_SlenderNextTeleportTime[npc.Index] = -1.0;
	g_SlenderTeleportTargetTime[npc.Index] = -1.0;

	g_SlenderAddCompanionsOnDifficulty[npc.Index] = false;

	if (!profileData.IsPvEBoss)
	{
		if (g_Enabled)
		{
			g_SlenderThink[npc.Index] = CreateTimer(0.3, Timer_SlenderTeleportThink, npc.UniqueID, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			if (g_NpcDefaultTeam[npc.Index] == TFTeam_Blue || g_NpcDefaultTeam[npc.Index] == TFTeam_Red)
			{
				g_SlenderThink[npc.Index] = CreateTimer(0.3, Timer_SlenderRespawnThink, npc.UniqueID, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				g_SlenderThink[npc.Index] = CreateTimer(0.3, Timer_SlenderTeleportThink, npc.UniqueID, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}

	switch (bossType)
	{
		case SF2BossType_Chaser:
		{
			NPCChaserOnSelectProfile(npc.Index);
		}
		case SF2BossType_Statue:
		{
			NPCStatueOnSelectProfile(npc.Index);
		}
	}

	if (npcCopyMaster.IsValid())
	{
		npc.CopyMaster = npcCopyMaster;
		g_SlenderNextJumpScare[npc.Index] = g_SlenderNextJumpScare[npcCopyMaster.Index];
	}
	else
	{
		if (profileData.IsPvEBoss && showPvEMessage && profileData.PvESpawnMessagesArray != null && profileData.PvESpawnMessagesArray.Length > 0)
		{
			char prefix[PLATFORM_MAX_PATH], message[PLATFORM_MAX_PATH];
			strcopy(prefix, sizeof(prefix), profileData.PvESpawnMessagePrefix);
			if (prefix[0] == '\0')
			{
				prefix = "[SF2]";
			}
			int messageIndex = GetRandomInt(0, profileData.PvESpawnMessagesArray.Length - 1);
			profileData.PvESpawnMessagesArray.GetString(messageIndex, message, sizeof(message));
			if (StrContains(message, "[BOSS]", true) != -1)
			{
				ReplaceString(message, sizeof(message), "[BOSS]", g_NpcName[npc.Index][1]);
			}
			int chatLength = strlen(prefix) + strlen(message);
			if (chatLength > 255)
			{
				LogSF2Message("WARNING! PvE spawn message %i has greater than 255 characters on boss index %i, shorten the length of this message.", messageIndex + 1, npc.Index);
			}
			else
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsValidClient(i) || !g_PlayerEliminated[i])
					{
						continue;
					}
					CPrintToChat(i, "{royalblue}%s {default}%s", prefix, message);
				}
			}
		}
		if (playSpawnSound)
		{
			SF2BossProfileSoundInfo soundInfo;
			GetBossProfileIntroSounds(profile, soundInfo);
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i))
				{
					continue;
				}
				if (g_Enabled)
				{
					if (profileData.IsPvEBoss && !g_PlayerEliminated[i])
					{
						continue;
					}
				}
				soundInfo.EmitSound(true, i);
			}
		}
		if (g_Enabled && !profileData.IsPvEBoss && timerMusic == null)
		{
			bool allowMusic = false;
			float time;
			for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
			{
				if (g_NpcSoundMusicLoop[npc.Index][difficulty] > 0.0)
				{
					allowMusic = true;
					g_NpcAllowMusicOnDifficulty[npc.Index] |= difficulty;
				}
			}
			if (allowMusic)
			{
				time = g_NpcSoundMusicLoop[npc.Index][g_DifficultyConVar.IntValue];
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

				if ((g_NpcAllowMusicOnDifficulty[npc.Index] & g_DifficultyConVar.IntValue) && time > 0.0)
				{
					timerMusic = CreateTimer(time, BossMusic, npc.Index, TIMER_FLAG_NO_MAPCHANGE);
					for(int client = 1; client <= MaxClients; client++)
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
								case Difficulty_Normal:
								{
									strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackNormal);
								}
								case Difficulty_Hard:
								{
									strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackHard);
								}
								case Difficulty_Insane:
								{
									strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackInsane);
								}
								case Difficulty_Nightmare:
								{
									strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackNightmare);
								}
								case Difficulty_Apollyon:
								{
									strcopy(currentMusicTrack, sizeof(currentMusicTrack), currentMusicTrackApollyon);
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
								SF2NPC_BaseNPC npcCompanion = AddProfile(compProfile, _, _, false, false, false);
								if (npcCompanion.IsValid())
								{
									npcCompanion.CompanionMaster = npc;
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
						g_SlenderAddCompanionsOnDifficulty[npc.Index] = true;
					}
					if (StrContains(spawnType, "on_spawn", false) != -1)
					{
						npc.AddCompanions();
					}
				}
			}
		}
	}

	Call_StartForward(g_OnBossAddedFwd);
	Call_PushCell(npc.Index);
	Call_Finish();

	if (!npc.IsCopy)
	{
		LogSF2Message("Boss profile %s has been added to the game.", profile);
	}

	return true;
}

SF2NPC_BaseNPC AddProfile(const char[] name, int additionalBossFlags = 0, SF2NPC_BaseNPC npcCopyMaster = SF2_INVALID_NPC, bool spawnCompanions = true, bool playSpawnSound = true, bool showPvEMessage = true)
{
	if (SF_IsRenevantMap() && GetRoundState() != SF2RoundState_Escape)
	{
		return SF2_INVALID_NPC; // Stop spawning bosses before all pages are picked up in Renevant.
	}
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(i);
		if (!npc.IsValid())
		{
			if (SelectProfile(npc, name, additionalBossFlags, npcCopyMaster, spawnCompanions, playSpawnSound, showPvEMessage))
			{
				return npc;
			}

			break;
		}
	}

	return SF2_INVALID_NPC;
}

void NPCAddCompanions(SF2NPC_BaseNPC npc)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	npc.GetProfile(profile, sizeof(profile));
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
		maxWeight += companionInfo.Weight[npc.Difficulty];
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

		float weight = companionInfo.Weight[npc.Difficulty];
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
			SF2NPC_BaseNPC npcCompanion = AddProfile(compProfile, _, _, false, false);
			if (npcCompanion.IsValid())
			{
				npcCompanion.CompanionMaster = npc;
			}
		}
		else
		{
			LogSF2Message("Companion boss profile %s is invalid, skipping boss...", compProfile);
		}
	}
	delete companionsToAdd;
}

bool GetSlenderModel(int bossIndex, int modelState = 0, char[] buffer, int bufferLen)
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
	}
	return true;
}

bool NPCFindUnstuckPosition(SF2_BaseBoss boss, float lastPos[3], float destination[3])
{
	SF2NPC_BaseNPC controller = boss.Controller;
	PathFollower path = controller.Path;
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(boss.index);
	CNavArea area = TheNavMesh.GetNearestNavArea(lastPos, _, _, _, false);
	area.GetCenter(destination);
	float tempMaxs[3];
	npc.GetBodyMaxs(tempMaxs);
	float traceMins[3];
	traceMins[0] = g_SlenderDetectMins[controller.Index][0] - 5.0;
	traceMins[1] = g_SlenderDetectMins[controller.Index][1] - 5.0;
	traceMins[2] = 0.0;

	float traceMaxs[3];
	traceMaxs[0] = g_SlenderDetectMaxs[controller.Index][0] + 5.0;
	traceMaxs[1] = g_SlenderDetectMaxs[controller.Index][1] + 5.0;
	traceMaxs[2] = tempMaxs[2];
	TR_TraceHullFilter(destination, destination, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntityEx);
	if (GetVectorSquareMagnitude(destination, lastPos) <= SquareFloat(16.0) || TR_DidHit())
	{
		SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(area, 400.0);
		int areaCount = collector.Count();
		ArrayList areaArray = new ArrayList(1, areaCount);
		int validAreaCount = 0;
		for (int i = 0; i < areaCount; i++)
		{
			areaArray.Set(validAreaCount, i);
			validAreaCount++;
		}

		int randomArea = 0, randomCell = 0;
		areaArray.Resize(validAreaCount);
		area = NULL_AREA;
		while (validAreaCount > 1)
		{
			randomCell = GetRandomInt(0, validAreaCount - 1);
			randomArea = areaArray.Get(randomCell);
			area = collector.Get(randomArea);
			area.GetCenter(destination);

			TR_TraceHullFilter(destination, destination, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntityEx);
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
				break;
			}
		}

		delete collector;
		delete areaArray;
	}
	path.GetClosestPosition(destination, destination, path.FirstSegment(), 400.0);
	if (GetVectorSquareMagnitude(destination, lastPos) > SquareFloat(8.0))
	{
		return true;
	}

	Segment first = path.FirstSegment();
	if (first != NULL_PATH_SEGMENT)
	{
		int attempts = 0;
		Segment next = NULL_PATH_SEGMENT;
		while (attempts <= 2)
		{
			next = path.NextSegment(first);
			if (next == NULL_PATH_SEGMENT)
			{
				break;
			}
			float segmentPos[3], temp[3];
			next.GetPos(segmentPos);
			path.GetClosestPosition(segmentPos, temp, next, 800.0);
			if (GetVectorSquareMagnitude(temp, lastPos) > SquareFloat(64.0))
			{
				destination = temp;
				return true;
			}
			first = next;
			attempts++;
		}
	}

	SF2BossProfileData data;
	data = controller.GetProfileData();

	int ent = -1;
	char targetName[64];
	if (data.IsPvEBoss)
	{
		ArrayList spawnPointList = new ArrayList();

		while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
			if (!StrContains(targetName, "minigames_boss_spawnpoint", false))
			{
				spawnPointList.Push(ent);
			}
		}

		if (spawnPointList.Length > 0)
		{
			ent = spawnPointList.Get(GetRandomInt(0, spawnPointList.Length - 1));
		}

		delete spawnPointList;

		if (!IsValidEntity(ent))
		{
			return false;
		}

		CBaseEntity(ent).GetAbsOrigin(destination);
		return true;
	}

	if (SF_IsBoxingMap())
	{
		ArrayList spawnPointList = new ArrayList();

		while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
			if (!StrContains(targetName, "sf2_boss_respawnpoint", false))
			{
				spawnPointList.Push(ent);
			}
		}

		if (spawnPointList.Length > 0)
		{
			ent = spawnPointList.Get(GetRandomInt(0, spawnPointList.Length - 1));
		}

		delete spawnPointList;

		if (!IsValidEntity(ent))
		{
			return false;
		}

		CBaseEntity(ent).GetAbsOrigin(destination);
		return true;
	}

	return false;
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

		if (SF2_ChaserEntity(slender).IsValid())
		{
			SF2_ChaserEntity(slender).UpdateMovementAnimation();
		}
		SetGlowModel(slender, buffer);
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
			if (NPCGetRaidHitbox(npcIndex))
			{
				CopyVector(g_SlenderDetectMins[npcIndex], tempHitboxMins);
				tempHitboxMins[2] = 10.0;
				SetEntPropVector(slender, Prop_Send, "m_vecMins", tempHitboxMins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxs", g_SlenderDetectMaxs[npcIndex]);

				SetEntPropVector(slender, Prop_Send, "m_vecMinsPreScaled", tempHitboxMins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxsPreScaled", g_SlenderDetectMaxs[npcIndex]);
			}
			else
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
	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(bossIndex);
	if (IsValidEntity(controller.EntIndex))
	{
		KillPvEBoss(controller.EntIndex);
	}

	if (SF_IsBoxingMap() && (GetRoundState() == SF2RoundState_Escape) && NPCChaserIsBoxingBoss(bossIndex))
	{
		g_SlenderBoxingBossCount -= 1;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	controller.GetProfile(profile, sizeof(profile));

	if (!controller.IsCopy && MusicActive() && BossHasMusic(profile) && BossMatchesCurrentMusic(profile))
	{
		NPCStopMusic();
	}

	controller.UnSpawn(true);

	// Call our forward.
	Call_StartForward(g_OnBossRemovedFwd);
	Call_PushCell(controller.Index);
	Call_Finish();

	Call_StartForward(g_OnBossRemovedPFwd);
	Call_PushCell(controller);
	Call_Finish();

	// Clean up on the clients.
	for (int i = 1; i <= MaxClients; i++)
	{
		g_SlenderTeleportPlayersRestTime[bossIndex][i] = -1.0;
	}

	g_NpcTeleportType[bossIndex] = -1;
	g_SlenderTeleportTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderProxyTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderTeleportMaxTargetStress[bossIndex] = 9999.0;
	g_SlenderTeleportMaxTargetTime[bossIndex] = -1.0;
	g_SlenderNextTeleportTime[bossIndex] = -1.0;
	g_SlenderTeleportTargetTime[bossIndex] = -1.0;
	g_SlenderTimeUntilKill[bossIndex] = -1.0;

	// Remove all copies associated with me.
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC check = SF2NPC_BaseNPC(i);
		if (check == controller || !check.IsValid())
		{
			continue;
		}

		if (check.CopyMaster == controller)
		{
			LogMessage("Removed boss index %d because it is a copy of boss index %d", check.Index, controller.Index);
			check.Remove();
		}
	}

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_SlenderProxyTeleportMinRange[bossIndex][difficulty] = 0.0;
		g_SlenderProxyTeleportMaxRange[bossIndex][difficulty] = 0.0;
	}

	g_NpcType[bossIndex] = -1;
	g_NpcProfileIndex[bossIndex] = -1;
	g_NpcUniqueProfileIndex[bossIndex] = -1;

	controller.Flags = 0;

	g_NpcFieldOfView[bossIndex] = 0.0;

	controller.SetAddSpeed(0.0);
	controller.SetAddAcceleration(0.0);
	g_NpcStepSize[bossIndex] = 0.0;

	g_NpcHasDiscoMode[bossIndex] = false;
	g_NpcDiscoRadiusMin[bossIndex] = 0.0;
	g_NpcDiscoRadiusMax[bossIndex] = 0.0;

	g_NpcHasFestiveLights[bossIndex] = false;
	g_NpcFestiveLightBrightness[bossIndex] = 0;
	g_NpcFestiveLightDistance[bossIndex] = 0.0;
	g_NpcFestiveLightRadius[bossIndex] = 0.0;

	NPCSetDeathCamEnabled(bossIndex, false);

	controller.CopyMaster = SF2_INVALID_NPC;
	controller.CompanionMaster = SF2_INVALID_NPC;
	g_NpcUniqueID[bossIndex] = -1;
	g_SlenderDeathCamTimer[bossIndex] = null;
	g_SlenderDeathCamTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderThink[bossIndex] = null;
	g_SlenderEntityThink[bossIndex] = null;
	g_SlenderCustomOutroSong[bossIndex] = false;

	g_SlenderFakeTimer[bossIndex] = null;
	g_SlenderModel[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderBoxingBossIsKilled[bossIndex] = false;
	g_SlenderTimeUntilNextProxy[bossIndex] = -1.0;
	g_NpcScareRadius[bossIndex] = 0.0;
	g_NpcHasPlayerScareSpeedBoost[bossIndex] = false;
	g_NpcPlayerSpeedBoostDuration[bossIndex] = 0.0;
	g_NpcHasPlayerScareReaction[bossIndex] = false;
	g_NpcPlayerScareReactionType[bossIndex] = 0;
	g_NpcHasPlayerScareReplenishSprint[bossIndex] = false;
	g_NpcPlayerScareReplenishSprintAmount[bossIndex] = 0.0;
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

	controller.SetProfile("");
}

void SpawnSlender(SF2NPC_BaseNPC npc, const float pos[3])
{
	if (!IsRoundPlaying())
	{
		//return;
	}

	if (SF_IsRenevantMap() && GetRoundState() != SF2RoundState_Escape)
	{
		return; // Stop spawning bosses before all pages are picked up in Renevant.
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	npc.UnSpawn(true);
	npc.GetProfile(profile,sizeof(profile));
	npc.WasKilled = false;

	float truePos[3], trueAng[3];
	trueAng[1] = GetRandomFloat(0.0, 360.0);
	AddVectors(truePos, pos, truePos);

	int bossIndex = npc.Index;

	char buffer[PLATFORM_MAX_PATH];

	GetSlenderModel(bossIndex, _, buffer, sizeof(buffer));

	CBaseCombatCharacter entity;

	switch (NPCGetType(bossIndex))
	{
		case SF2BossType_Statue:
		{
			entity = view_as<CBaseCombatCharacter>(Spawn_Statue(npc, truePos, trueAng));
		}
		case SF2BossType_Chaser:
		{
			entity = view_as<CBaseCombatCharacter>(Spawn_Chaser(npc, truePos, trueAng));
			/*CBaseNPC npcBoss = CBaseNPC();
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

			if (!SF_IsBoxingMap())
			{
				locomotion.SetCallback(LocomotionCallback_IsAbleToJumpAcrossGaps, CanJumpAcrossGaps);
				locomotion.SetCallback(LocomotionCallback_IsAbleToClimb, CanJumpAcrossGaps);
				locomotion.SetCallback(LocomotionCallback_JumpAcrossGap, JumpAcrossGapsCBase);
				locomotion.SetCallback(LocomotionCallback_ClimbUpToLedge, ClimbUpCBase);
			}

			if (NPCGetRaidHitbox(bossIndex))
			{
				npcBoss.SetBodyMins(g_SlenderDetectMins[bossIndex]);
				npcBoss.SetBodyMaxs(g_SlenderDetectMaxs[bossIndex]);

				npcEntity.SetPropVector(Prop_Send, "m_vecMins", g_SlenderDetectMins[bossIndex]);
				npcEntity.SetPropVector(Prop_Send, "m_vecMaxs", g_SlenderDetectMaxs[bossIndex]);

				npcEntity.SetPropVector(Prop_Send, "m_vecMinsPreScaled", g_SlenderDetectMins[bossIndex]);
				npcEntity.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", g_SlenderDetectMaxs[bossIndex]);
			}
			else
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

			//(Experimental)
			if (NPCGetHealthbarState(bossIndex))
			{
				//The boss spawned for the 1st time, block now its teleportation ability to prevent healthbar conflict.
				NPCSetFlags(bossIndex,NPCGetFlags(bossIndex)|SFF_NOTELEPORT);
				UpdateHealthBar(bossIndex);
			}

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
					}
				}
			}
			NPCChaserSetStunInitialHealth(bossIndex, maxHealth);
			int entHealth = RoundToCeil(maxHealth + 1500000000.0);
			npcEntity.SetProp(Prop_Data, "m_iHealth", entHealth);
			npcEntity.SetProp(Prop_Data, "m_iMaxHealth", entHealth);

			entity = npcEntity;*/
		}
	}

	SF2BossProfileData data;
	data = npc.GetProfileData();

	if (g_Enabled)
	{
		if (!data.IsPvEBoss && (npc.Flags & SFF_ATTACKWAITERS) == 0)
		{
			entity.SetProp(Prop_Data, "m_iTeamNum", TFTeam_Blue);
		}
		else
		{
			entity.SetProp(Prop_Data, "m_iTeamNum", TFTeam_Spectator);
		}
	}
	else
	{
		entity.SetProp(Prop_Data, "m_iTeamNum", NPCGetDefaultTeam(bossIndex));
	}

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	if (g_BossPathFollower[bossIndex] == view_as<PathFollower>(0))
	{
		g_BossPathFollower[bossIndex] = PathFollower(_, TraceRayDontHitAnyEntity_Pathing, Path_FilterOnlyActors);
	}

	g_BossPathFollower[bossIndex].SetMinLookAheadDistance(GetBossProfileNodeDistanceLookAhead(profile));

	if (NPCGetModelSkinMax(bossIndex) > 0)
	{
		int randomSkin = GetRandomInt(0, NPCGetModelSkinMax(bossIndex));
		entity.SetProp(Prop_Send, "m_nSkin", randomSkin);
	}
	else
	{
		if (GetBossProfileSkinDifficultyState(profile))
		{
			entity.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(bossIndex, difficulty));
		}
		else
		{
			entity.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkin(bossIndex));
		}
	}
	if (NPCGetModelBodyGroupsMax(bossIndex) > 0)
	{
		int randomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(bossIndex));
		entity.SetProp(Prop_Send, "m_nBody", randomBody);
	}
	else
	{
		if (GetBossProfileBodyGroupsDifficultyState(profile))
		{
			entity.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(bossIndex, difficulty));
		}
		else
		{
			entity.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroups(bossIndex));
		}
	}

	entity.AddFlag(FL_NPC);
	if (g_Enabled)
	{
		if (!data.IsPvEBoss && !SF_IsRaidMap())
		{
			entity.AddFlag(FL_NOTARGET);
		}
	}
	else
	{
		entity.AddFlag(FL_CLIENT);
	}
	//SetEntityTransmitState(entity.index, FL_EDICT_ALWAYS);

	g_SlenderEnt[bossIndex] = EntIndexToEntRef(entity.index);

	if (data.EngineSound[0] != '\0')
	{
		EmitSoundToAll(data.EngineSound, entity.index, SNDCHAN_STATIC, data.EngineSoundLevel,
		_, data.EngineSoundVolume);
	}

	if (data.SpawnEffects != null)
	{
		StringMapSnapshot snapshot = data.SpawnEffects.Snapshot();
		char key[64];
		snapshot.GetKey(GetRandomInt(0, snapshot.Length - 1), key, sizeof(key));
		ArrayList effects;
		data.SpawnEffects.GetValue(key, effects);
		SlenderSpawnEffects(effects, bossIndex, false);
		delete snapshot;
	}

	int master = g_SlenderCopyMaster[bossIndex];
	int flags = NPCGetFlags(bossIndex);

	if (MAX_BOSSES > master >= 0 && NPCGetFakeCopyState(bossIndex, difficulty))
	{
		if (!SF_SpecialRound(SPECIALROUND_DREAMFAKEBOSSES))
		{
			NPCSetFlags(bossIndex, flags | SFF_FAKE);
		}
	}

	ArrayList effects = data.EffectsArray;
	SlenderSpawnEffects(effects, bossIndex);

	if (entity.IsValid())
	{
		SF2BossProfileSoundInfo soundInfo;
		GetBossProfileSpawnLocalSounds(profile, soundInfo);
		soundInfo.EmitSound(_, entity.index);
	}

	// Call our forward.
	Call_StartForward(g_OnBossSpawnFwd);
	Call_PushCell(bossIndex);
	Call_Finish();

	Call_StartForward(g_OnBossSpawnPFwd);
	Call_PushCell(npc);
	Call_Finish();
}

bool ClimbUpCBase(CBaseNPC_Locomotion loco, const float goal[3], const float fwd[3], int entity)
{
	INextBot bot = loco.GetBot();
	SF2_BaseBoss boss = SF2_BaseBoss(bot.GetEntity());
	if (boss.IsValid())
	{
		boss.IsJumping = true;
	}
	return loco.CallBaseFunction(goal, fwd, entity);
}

MRESReturn CBaseAnimating_HandleAnimEvent(int thisInt, DHookParam params)
{
	int bossIndex = NPCGetFromEntIndex(thisInt);
	if (bossIndex == -1)
	{
		bossIndex = g_NpcModelMaster[thisInt];
	}
	int event = params.GetObjectVar(1, 0, ObjectValueType_Int);
	if (event > 0 && IsValidEntity(thisInt) &&
		bossIndex != -1 && NPCGetUniqueID(bossIndex) != -1)
	{
		SlenderCastFootstepAnimEvent(bossIndex, event, thisInt);
		SlenderCastAnimEvent(bossIndex, event, thisInt);
	}
	return MRES_Ignored;
}

void UpdateHealthBar(int bossIndex, int optionalSetPercent = -1)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(NPCGetEntIndex(bossIndex));
	if (!chaser.IsValid())
	{
		return;
	}
	float maxHealth = chaser.MaxHealth;
	float health = float(chaser.GetProp(Prop_Data, "m_iHealth"));
	if (chaser.GetProp(Prop_Data, "m_takedamage") == DAMAGE_EVENTS_ONLY)
	{
		health = chaser.StunHealth;
		maxHealth = chaser.MaxStunHealth;
	}
	if (g_HealthBar == -1)
	{
		return;
	}
	int healthPercent;
	SetEntProp(g_HealthBar, Prop_Send, "m_iBossState", 0);
	healthPercent = RoundToCeil((health / maxHealth) * float(255));
	if (healthPercent > 255)
	{
		healthPercent = 255;
	}
	else if (healthPercent <= 0)
	{
		healthPercent = 0;
	}
	if (optionalSetPercent > -1)
	{
		healthPercent = optionalSetPercent;
	}
	SetEntProp(g_HealthBar, Prop_Send, "m_iBossHealthPercentageByte", healthPercent);
}

void SetHealthBarColor(bool green)
{
	if (g_HealthBar == -1)
	{
		return;
	}
	SetEntProp(g_HealthBar, Prop_Send, "m_iBossState", view_as<int>(green));
}

/*Action Timer_BossBurn(Handle timer, any entref)
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
	//int state = g_SlenderState[bossIndex];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (timer != g_SlenderBurnTimer[bossIndex])
	{
		return Plugin_Stop;
	}
	if (NPCChaserIsStunEnabled(bossIndex))
	{
		if (!NPCIsRaging(bossIndex))
		{
			float burnDamage = -4.0 * GetChaserProfileAfterburnMultiplier(profile);
			NPCChaserAddStunHealth(bossIndex, burnDamage);
			if (NPCChaserGetStunHealth(bossIndex) <= 0.0 && state != STATE_STUN)
			{
				float myPos[3];
				GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);
				//NPCBossTriggerStun(bossIndex, slender, profile, myPos);
				Call_StartForward(g_OnBossStunnedFwd);
				Call_PushCell(bossIndex);
				Call_PushCell(-1);
				Call_Finish();
			}
		}
		if (NPCGetHealthbarState(bossIndex) && state != STATE_STUN && !NPCIsRaging(bossIndex))
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
	//int state = g_SlenderState[bossIndex];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (timer != g_SlenderBleedTimer[bossIndex])
	{
		return Plugin_Stop;
	}
	if (NPCChaserIsStunEnabled(bossIndex))
	{
		if (!NPCIsRaging(bossIndex))
		{
			NPCChaserAddStunHealth(bossIndex, -4.0);
			if (NPCChaserGetStunHealth(bossIndex) <= 0.0 && state != STATE_STUN)
			{
				float myPos[3];
				GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);
				//NPCBossTriggerStun(bossIndex, slender, profile, myPos);
				Call_StartForward(g_OnBossStunnedFwd);
				Call_PushCell(bossIndex);
				Call_PushCell(-1);
				Call_Finish();
			}
		}
		if (NPCGetHealthbarState(bossIndex) && state != STATE_STUN && !NPCIsRaging(bossIndex))
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
}*/

bool SlenderUsesBlink(int bossIndex)
{
	if (NPCGetType(bossIndex) == SF2BossType_Statue)
	{
		return true;
	}
	return false;
}

void SlenderPrintChatMessage(int bossIndex, int player)
{
	if (g_Enabled && GetClientTeam(player) != TFTeam_Red)
	{
		return;
	}

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
			if (buffer[0] != '\0')
			{
				if (StrContains(buffer, "[PLAYER]", true) != -1)
				{
					switch (GetClientTeam(player))
					{
						case TFTeam_Red:
						{
							FormatEx(replacePlayer, sizeof(replacePlayer), "{red}%s{default}", playerName);
						}

						case TFTeam_Blue:
						{
							FormatEx(replacePlayer, sizeof(replacePlayer), "{blue}%s{default}", playerName);
						}
					}

					ReplaceString(buffer, sizeof(buffer), "[PLAYER]", replacePlayer);
				}
				if (StrContains(buffer, "[BOSS]", true) != -1)
				{
					ReplaceString(buffer, sizeof(buffer), "[BOSS]", name);
				}
				if (StrContains(buffer, "[ROUNDTIME]", true) != -1)
				{
					ReplaceString(buffer, sizeof(buffer), "[ROUNDTIME]", time);
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

void SlenderCastFootstepAnimEvent(int bossIndex, int event, int slender)
{
	if (bossIndex == -1)
	{
		return;
	}

	if (!IsValidEntity(slender))
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

	float myPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);

	soundInfo.EmitSound(_, slender);
	SF2ChaserBossProfileData data;
	data = SF2NPC_Chaser(bossIndex).GetProfileData();
	if (data.EarthquakeFootsteps)
	{
		UTIL_ScreenShake(myPos, data.EarthquakeFootstepAmplitude,
		data.EarthquakeFootstepFrequency, data.EarthquakeFootstepDuration,
		data.EarthquakeFootstepRadius, 0, data.EarthquakeFootstepAirShake);
	}
}

void SlenderCastAnimEvent(int bossIndex, int event, int slender)
{
	if (bossIndex == -1)
	{
		return;
	}

	if (!IsValidEntity(slender))
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
	soundInfo.EmitSound(_, slender);
}

// As time passes on, we have to get more aggressive in order to successfully peak the target's
// stress level in the allotted duration we're given. Otherwise we'll be forced to place him
// in a rest period.

// Teleport progressively closer as time passes in attempt to increase the target's stress level.

static Action Timer_SlenderTeleportThink(Handle timer, any id)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC.FromUniqueId(id);
	if (!controller.IsValid())
	{
		return Plugin_Stop;
	}

	int bossIndex = controller.Index;
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

	if (controller.Flags & SFF_NOTELEPORT)
	{
		return Plugin_Continue;
	}

	float gameTime = GetGameTime();

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	// Check to see if anyone's looking at me before doing anything.
	if (PeopleCanSeeSlender(bossIndex, _, false))
	{
		return Plugin_Continue;
	}
	int bossEnt = controller.EntIndex;
	if (bossEnt && bossEnt != INVALID_ENT_REFERENCE)
	{
		SF2_BaseBoss boss = SF2_BaseBoss(bossEnt);
		if (boss.IsKillingSomeone)
		{
			return Plugin_Continue;
		}
	}

	if (!NPCIsTeleportAllowed(bossIndex, difficulty) && (!bossEnt || bossEnt == INVALID_ENT_REFERENCE))
	{
		return Plugin_Continue;
	}

	if (controller.TeleportType == 2)
	{
		if (bossEnt && bossEnt != INVALID_ENT_REFERENCE)
		{
			if (NPCGetType(bossIndex) == SF2BossType_Chaser)
			{
				SF2_ChaserEntity chaser = SF2_ChaserEntity(bossEnt);
				// Check to see if it's a good time to teleport away.
				int state = chaser.State;
				if (state == STATE_IDLE && chaser.IsAllowedToDespawn)
				{
					if (gameTime < g_SlenderTimeUntilKill[bossIndex])
					{
						return Plugin_Continue;
					}
				}
				else
				{
					if (gameTime >= g_SlenderTimeUntilKill[bossIndex])
					{
						g_SlenderTimeUntilKill[bossIndex] = gameTime + NPCGetIdleLifetime(bossIndex, difficulty);
					}
					return Plugin_Continue;
				}
			}
			else if (NPCGetType(bossIndex) == SF2BossType_Statue)
			{
				if (g_SlenderStatueIdleLifeTime[bossIndex] > gameTime)
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
		if (gameTime >= g_SlenderNextTeleportTime[bossIndex])
		{
			if (!NPCIsTeleportAllowed(bossIndex, difficulty) && bossEnt && bossEnt != INVALID_ENT_REFERENCE)
			{
				controller.UnSpawn();
				return Plugin_Continue;
			}
			float teleportTime = GetRandomFloat(NPCGetTeleportTimeMin(bossIndex, difficulty), NPCGetTeleportTimeMax(bossIndex, difficulty));
			g_SlenderNextTeleportTime[bossIndex] = gameTime + teleportTime;
			bool ignoreFuncNavPrefer = g_NpcHasIgnoreNavPrefer[bossIndex];

			int teleportTarget = EntRefToEntIndex(g_SlenderTeleportTarget[bossIndex]);

			if (!IsTargetValidForSlenderEx(CBaseEntity(teleportTarget), bossIndex))
			{
				// We don't have any good targets. Remove myself for now.
				if (SlenderCanRemove(bossIndex))
				{
					controller.UnSpawn();
				}

				g_SlenderTeleportTarget[bossIndex] = INVALID_ENT_REFERENCE;

				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: no good target, removing...", bossIndex);
				#endif
			}
			else
			{
				if (bossEnt && bossEnt != INVALID_ENT_REFERENCE)
				{
					controller.UnSpawn();
					return Plugin_Continue;
				}

				// Let's start the persistency timer here, so that way we won't have infinite looping impossible to spawn bosses
				float targetDuration = controller.GetTeleportPersistencyPeriod(difficulty);
				float deviation = GetRandomFloat(0.92, 1.08);
				targetDuration = Pow(deviation * targetDuration, ((g_RoundDifficultyModifier) / 2.0)) + ((deviation * targetDuration) - 1.0);
				g_SlenderTeleportMaxTargetTime[controller.Index] = gameTime + targetDuration;

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
						if (ignoreFuncNavPrefer && NavHasFuncPrefer(collector.Get(i)))
						{
							continue;
						}

						if (view_as<CTFNavArea>(collector.Get(i)).HasAttributeTF(NO_SPAWNING))
						{
							continue;
						}

						if (collector.Get(i).GetCostSoFar() >= teleportMinRange)
						{
							areaArray.Set(validAreaCount, i);
							validAreaCount++;
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
						/*float cornerPosition[3]; // Will revisit later
						ArrayList corners = new ArrayList();
						for (int i = 0; i < 4; i++)
						{
							corners.Push(view_as<NavCornerType>(i));
						}
						NavCornerType cornerA = view_as<NavCornerType>(GetRandomInt(0, 3));
						NavCornerType invert = cornerA;
						switch (cornerA)
						{
							case NORTH_WEST:
							{
								invert = SOUTH_EAST;
							}
							case NORTH_EAST:
							{
								invert = SOUTH_WEST;
							}
							case SOUTH_EAST:
							{
								invert = NORTH_WEST;
							}
							case SOUTH_WEST:
							{
								invert = NORTH_EAST;
							}
						}
						corners.Erase(corners.FindValue(cornerA));
						corners.Erase(corners.FindValue(invert));
						NavCornerType cornerB = corners.Get(GetRandomInt(0, corners.Length - 1));
						area.GetCorner(cornerA, spawnPos);
						area.GetCorner(cornerB, cornerPosition);
						LerpVectors(spawnPos, cornerPosition, spawnPos, GetRandomFloat(0.3, 0.7));
						area.GetCorner(invert, cornerPosition);
						LerpVectors(spawnPos, cornerPosition, spawnPos, GetRandomFloat(0.3, 0.7));
						delete corners;*/

						float traceMins[3];
						traceMins[0] = g_SlenderDetectMins[bossIndex][0];
						traceMins[1] = g_SlenderDetectMins[bossIndex][1];
						traceMins[2] = 0.0;

						float traceMaxs[3];
						traceMaxs[0] = g_SlenderDetectMaxs[bossIndex][0];
						traceMaxs[1] = g_SlenderDetectMaxs[bossIndex][1];
						traceMaxs[2] = g_SlenderDetectMaxs[bossIndex][2];

						TR_TraceHullFilter(spawnPos, spawnPos, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitEntity);
						if (TR_DidHit())
						{
							area = NULL_AREA;
							validAreaCount--;
							int findValue = areaArray.FindValue(randomCell);
							if (findValue != -1)
							{
								areaArray.Erase(findValue);

								#if defined DEBUG
								SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Area index %d: boss index %d collides with something", findValue, bossIndex);
								#endif
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
										#if defined DEBUG
										SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Area index %d: too close to %N", findValue, i);
										#endif
									}
									canSpawn = false;
									break;
								}
							}

							// Check visibility.
							if (!g_SlenderTeleportIgnoreVis[bossIndex] && IsPointVisibleToAPlayer(spawnPos, !shouldBeBehindObstruction, false, _, true))
							{
								area = NULL_AREA;
								validAreaCount--;
								int findValue = areaArray.FindValue(randomCell);
								if (findValue != -1)
								{
									areaArray.Erase(findValue);
									#if defined DEBUG
									SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Area index %d: is visible to someone", findValue);
									#endif
								}
								canSpawn = false;
							}

							AddVectors(spawnPos, g_SlenderEyePosOffset[bossIndex], spawnPos);

							if (!g_SlenderTeleportIgnoreVis[bossIndex] && IsPointVisibleToAPlayer(spawnPos, !shouldBeBehindObstruction, false, _, true))
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
							if (controller.GetProfileData().CopiesInfo.Enabled[difficulty] && canSpawn)
							{
								float minDistBetweenBosses = GetBossProfileTeleportCopyDistance(profile, difficulty);

								for (int bossCheck = 0; bossCheck < MAX_BOSSES; bossCheck++)
								{
									SF2NPC_BaseNPC check = SF2NPC_BaseNPC(bossCheck);
									if (bossCheck == bossIndex ||
										!check.IsValid())
									{
										continue;
									}

									if (check.CopyMaster != controller && controller.CopyMaster != check && controller.CopyMaster != check.CopyMaster)
									{
										continue;
									}

									int bossEntCheck = check.EntIndex;
									if (!bossEntCheck || bossEntCheck == INVALID_ENT_REFERENCE)
									{
										continue;
									}

									float tempPos[3];
									CBaseEntity(bossEntCheck).GetAbsOrigin(tempPos);

									if (GetVectorSquareMagnitude(spawnPos, tempPos) <= SquareFloat(minDistBetweenBosses))
									{
										area = NULL_AREA;
										validAreaCount--;
										int findValue = areaArray.FindValue(randomCell);
										if (findValue != -1)
										{
											areaArray.Erase(findValue);
											#if defined DEBUG
											SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Area index %d: boss index %d is too close to copy %d", findValue, bossIndex, bossCheck);
											#endif
										}
										canSpawn = false;
										break;
									}
								}
							}

							if (canSpawn)
							{
								controller.Spawn(spawnPos);

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
										if (!IsValidClient(i) || !IsPlayerAlive(i) || g_PlayerEliminated[i] || IsClientInGhostMode(i))
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
							else
							{
								#if defined DEBUG
								SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: can't spawn due to no available areas", bossIndex);
								#endif
							}
						}
					}

					if (validAreaCount <= 0)
					{
						controller.UnSpawn();
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
	else
	{
		float teleportTime = GetRandomFloat(NPCGetTeleportTimeMin(bossIndex, difficulty), NPCGetTeleportTimeMax(bossIndex, difficulty));
		g_SlenderNextTeleportTime[bossIndex] = gameTime + teleportTime;
	}

	return Plugin_Continue;
}

static Action Timer_SlenderRespawnThink(Handle timer, any id)
{
	if (g_Enabled)
	{
		return Plugin_Stop;
	}

	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC.FromUniqueId(id);
	if (!controller.IsValid())
	{
		return Plugin_Stop;
	}

	int bossIndex = controller.Index;
	if (timer != g_SlenderThink[bossIndex])
	{
		return Plugin_Stop;
	}

	float gameTime = GetGameTime();

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	bool cont = false;

	int bossEnt = controller.EntIndex;
	if (bossEnt && bossEnt != INVALID_ENT_REFERENCE && controller.TeleportType == 2)
	{
		cont = true;
	}

	if (!NPCIsTeleportAllowed(bossIndex, difficulty) && (!bossEnt || bossEnt == INVALID_ENT_REFERENCE))
	{
		cont = true;
	}

	if (cont)
	{
		float teleportTime = GetRandomFloat(NPCGetTeleportTimeMin(bossIndex, difficulty), NPCGetTeleportTimeMax(bossIndex, difficulty));
		g_SlenderNextTeleportTime[bossIndex] = gameTime + teleportTime;
		return Plugin_Continue;
	}

	if (gameTime >= g_SlenderNextTeleportTime[bossIndex])
	{
		float teleportTime = GetRandomFloat(NPCGetTeleportTimeMin(bossIndex, difficulty), NPCGetTeleportTimeMax(bossIndex, difficulty));
		g_SlenderNextTeleportTime[bossIndex] = gameTime + teleportTime;

		if (bossEnt && bossEnt != INVALID_ENT_REFERENCE) // For teleport type 0
		{
			controller.UnSpawn();
			return Plugin_Continue;
		}

		ArrayList spawnPoint = new ArrayList();
		float teleportPos[3];
		int ent = -1, spawnTeam = 0;
		while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
		{
			spawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
			if (spawnTeam == NPCGetDefaultTeam(bossIndex))
			{
				spawnPoint.Push(ent);
			}
		}

		ent = -1;
		if (spawnPoint.Length > 0)
		{
			ent = spawnPoint.Get(GetRandomInt(0, spawnPoint.Length - 1));
		}

		delete spawnPoint;

		if (IsValidEntity(ent))
		{
			CBaseEntity(ent).GetAbsOrigin(teleportPos);
			controller.Spawn(teleportPos);
		}
	}

	return Plugin_Continue;
}

bool SlenderMarkAsFake(int bossIndex)
{
	int bossFlags = NPCGetFlags(bossIndex);
	if ((bossFlags & SFF_MARKEDASFAKE) != 0)
	{
		return false;
	}

	int slender = NPCGetEntIndex(bossIndex);
	g_SlenderEnt[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderModel[bossIndex] = INVALID_ENT_REFERENCE;

	NPCSetFlags(bossIndex, bossFlags | SFF_MARKEDASFAKE);

	SF2BossProfileData data;
	data = NPCGetProfileData(bossIndex);

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

		if (data.EngineSound[0] != '\0')
		{
			StopSound(slender, SNDCHAN_STATIC, data.EngineSound);
		}

		SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", 0.0);
		SetEntityRenderFx(slender, RENDERFX_FADE_SLOW);
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

int SpawnSlenderModel(int bossIndex, const float pos[3], bool deathCam = false)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		LogError("Could not spawn boss model: boss does not exist!");
		return -1;
	}

	char buffer[PLATFORM_MAX_PATH], profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	float playbackRate, cycle;
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

	CBaseAnimating slenderModel = CBaseAnimating(CreateEntityByName("prop_dynamic_override"));
	if (slenderModel.IsValid())
	{
		slenderModel.SetModel(buffer);

		slenderModel.Teleport(pos, NULL_VECTOR, NULL_VECTOR);
		slenderModel.Spawn();
		slenderModel.Activate();
		SF2BossProfileMasterAnimationsData animData;
		GetBossProfileAnimationsData(profile, animData);
		if (!deathCam)
		{
			animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Idle], difficulty, buffer, sizeof(buffer), playbackRate, _, cycle);
		}
		else
		{
			bool animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_DeathCam], difficulty, buffer, sizeof(buffer), playbackRate, _, cycle);
			if (!animationFound || strcmp(buffer,"") <= 0)
			{
				animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Idle], difficulty, buffer, sizeof(buffer), playbackRate, _, cycle);
			}
		}
		if (buffer[0] != '\0')
		{
			SetVariantString(buffer);
			slenderModel.AcceptInput("SetDefaultAnimation");
			SetVariantString(buffer);
			slenderModel.AcceptInput("SetAnimation");
			slenderModel.AcceptInput("DisableCollision");
		}

		SetVariantFloat(playbackRate);
		slenderModel.AcceptInput("SetPlaybackRate");
		slenderModel.SetPropFloat(Prop_Data, "m_flCycle", cycle);

		if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
		{
			float scaleModel = modelScale * 0.5;
			slenderModel.SetPropFloat(Prop_Send, "m_flModelScale", scaleModel);
		}
		else
		{
			slenderModel.SetPropFloat(Prop_Send, "m_flModelScale", modelScale);
		}
		if (NPCGetModelSkinMax(bossIndex) > 0)
		{
			int randomSkin = GetRandomInt(0, NPCGetModelSkinMax(bossIndex));
			slenderModel.SetProp(Prop_Send, "m_nSkin", randomSkin);
		}
		else
		{
			if (GetBossProfileSkinDifficultyState(profile))
			{
				slenderModel.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(bossIndex, difficulty));
			}
			else
			{
				slenderModel.SetProp(Prop_Send, "m_nSkin", modelSkin);
			}
		}
		if (NPCGetModelBodyGroupsMax(bossIndex) > 0)
		{
			int randomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(bossIndex));
			slenderModel.SetProp(Prop_Send, "m_nBody", randomBody);
		}
		else
		{
			if (GetBossProfileBodyGroupsDifficultyState(profile))
			{
				slenderModel.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(bossIndex, difficulty));
			}
			else
			{
				slenderModel.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroups(bossIndex));
			}
		}

		slenderModel.SetProp(Prop_Send, "m_nBody", GetBossProfileBodyGroups(profile));

		// Create special effects.
		slenderModel.SetRenderMode(view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
		slenderModel.SetRenderFx(view_as<RenderFx>(g_SlenderRenderFX[bossIndex]));
		slenderModel.SetRenderColor(g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], g_SlenderRenderColor[bossIndex][3]);

		g_NpcModelMaster[slenderModel.index] = bossIndex;
		slenderModel.Hook_HandleAnimEvent(CBaseAnimating_HandleAnimEvent);
	}

	return slenderModel.index;
}

bool PlayerCanSeeSlender(int client, int bossIndex, bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true)
{
	return IsNPCVisibleToPlayer(bossIndex, client, checkFOV, checkBlink, checkEliminated);
}

bool PeopleCanSeeSlender(int bossIndex, bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true)
{
	return IsNPCVisibleToAPlayer(bossIndex, checkFOV, checkBlink, checkEliminated);
}

bool IsNPCVisibleToPlayer(int npcIndex, int client, bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true)
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

bool IsNPCVisibleToAPlayer(int npcIndex, bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true)
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

float NPCGetDistanceFromPoint(int npcIndex, const float point[3])
{
	int npcEnt = NPCGetEntIndex(npcIndex);
	if (npcEnt && npcEnt != INVALID_ENT_REFERENCE)
	{
		float pos[3];
		CBaseEntity(npcEnt).GetAbsOrigin(pos);

		return GetVectorSquareMagnitude(pos, point);
	}

	return -1.0;
}

float NPCGetDistanceFromEntity(int npcIndex, int ent)
{
	if (!IsValidEntity(ent))
	{
		return -1.0;
	}

	float pos[3];
	GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", pos);

	return NPCGetDistanceFromPoint(npcIndex, pos);
}

bool TraceRayBossVisibility(int entity, int mask, any data)
{
	if (entity == data)
	{
		return false;
	}
	if (IsValidClient(entity))
	{
		if (g_PlayerProxy[entity] || IsClientInGhostMode(entity))
		{
			return false;
		}
	}
	if (IsValidEntity(entity) && NPCGetFromEntIndex(entity) != -1)
	{
		return false;
	}
	return true;
}

bool TraceRayDontHitCharacters(int entity, int mask, any data)
{
	if (IsValidClient(entity))
	{
		return false;
	}

	if (IsValidEntity(entity) && NPCGetFromEntIndex(entity) != -1)
	{
		return false;
	}

	return true;
}

bool TraceRayDontHitAnyEntity(int entity, int mask, any data)
{
	if (entity == data)
	{
		return false;
	}
	if (IsValidClient(entity))
	{
		if (g_PlayerProxy[entity] || IsClientInGhostMode(entity))
		{
			return false;
		}
	}
	if (IsValidEntity(entity) && NPCGetFromEntIndex(entity) != -1)
	{
		return false;
	}
	return true;
}

bool TraceRayDontHitAnyEntity_Pathing(int entity, int contentsMask, int desiredcollisiongroup)
{
	if (IsValidClient(entity))
	{
		if (g_PlayerProxy[entity] || IsClientInGhostMode(entity))
		{
			return false;
		}
	}
	if (IsValidEntity(entity) && NPCGetFromEntIndex(entity) != -1)
	{
		return false;
	}
	return true;
}

bool TraceRayDontHitCharactersOrEntity(int entity, int mask, any data)
{
	if (entity == data)
	{
		return false;
	}

	if (IsValidClient(entity))
	{
		return false;
	}

	if (IsValidEntity(entity) && NPCGetFromEntIndex(entity) != -1)
	{
		return false;
	}

	return true;
}

bool TraceRayDontHitAnything(int entity, int mask, any data)
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
					traceHitPos[2] += 5.0;
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
					if (!IsValidClient(teleportClient) ||
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
				float dist = areaArray.Get(i2, 1);
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
			teleportPos[0] = areaArrayClose.Get(arrayIndex, 1);
			teleportPos[1] = areaArrayClose.Get(arrayIndex, 2);
			teleportPos[2] = areaArrayClose.Get(arrayIndex, 3);
		}
		else if (areaArrayAverage.Length)
		{
			arrayIndex = GetRandomInt(0, areaArrayAverage.Length - 1);
			teleportAreaIndex = areaArrayAverage.Get(arrayIndex);
			teleportPos[0] = areaArrayAverage.Get(arrayIndex, 1);
			teleportPos[1] = areaArrayAverage.Get(arrayIndex, 2);
			teleportPos[2] = areaArrayAverage.Get(arrayIndex, 3);
		}
		else if (areaArrayFar.Length)
		{
			arrayIndex = GetRandomInt(0, areaArrayFar.Length - 1);
			teleportAreaIndex = areaArrayFar.Get(arrayIndex);
			teleportPos[0] = areaArrayFar.Get(arrayIndex, 1);
			teleportPos[1] = areaArrayFar.Get(arrayIndex, 2);
			teleportPos[2] = areaArrayFar.Get(arrayIndex, 3);
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

#include "npc/glow.sp"
#include "npc/npc_chaser.sp"
#include "npc/entities/initialize.sp"

static any Native_GetMaxBosses(Handle plugin, int numParams)
{
	return MAX_BOSSES;
}

static any Native_EntIndexToBossIndex(Handle plugin, int numParams)
{
	return NPCGetFromEntIndex(GetNativeCell(1));
}

static any Native_BossIndexToEntIndex(Handle plugin, int numParams)
{
	return EntRefToEntIndex(g_SlenderEnt[GetNativeCell(1)]);
}

static any Native_BossIndexToEntIndexEx(Handle plugin, int numParams)
{
	return NPCGetEntIndex(GetNativeCell(1));
}

static any Native_BossIDToBossIndex(Handle plugin, int numParams)
{
	return NPCGetFromUniqueID(GetNativeCell(1));
}

static any Native_BossIndexToBossID(Handle plugin, int numParams)
{
	return NPCGetUniqueID(GetNativeCell(1));
}

static any Native_AddBoss(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, sizeof(profile));

	int flags = GetNativeCell(2);
	bool spawnCompanions = GetNativeCell(3);
	bool playSpawnSound = GetNativeCell(4);

	return AddProfile(profile, flags, _, spawnCompanions, playSpawnSound);
}

static any Native_RemoveBoss(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
	{
		return 0;
	}

	RemoveProfile(boss.Index);
	return 0;
}

static any Native_GetBossName(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(GetNativeCell(1), profile, sizeof(profile));

	SetNativeString(2, profile, GetNativeCell(3));
	return 0;
}

static any Native_GetBossType(Handle plugin, int numParams)
{
	return NPCGetType(GetNativeCell(1));
}

static any Native_GetBossFlags(Handle plugin, int numParams)
{
	return NPCGetFlags(GetNativeCell(1));
}

static any Native_SetBossFlags(Handle plugin, int numParams)
{
	NPCSetFlags(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

static any Native_SpawnBoss(Handle plugin, int numParams)
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

static any Native_IsBossSpawning(Handle plugin, int numParams)
{
	return false;
}

static any Native_DespawnBoss(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
	{
		return 0;
	}

	boss.UnSpawn();
	return 0;
}

static any Native_GetBossPathFollower(Handle plugin, int numParams)
{
	return g_BossPathFollower[GetNativeCell(1)];
}

static any Native_GetBossMaster(Handle plugin, int numParams)
{
	return g_SlenderCopyMaster[GetNativeCell(1)];
}

static any Native_GetBossIdleLifetime(Handle plugin, int numParams)
{
	return NPCGetIdleLifetime(GetNativeCell(1), GetNativeCell(2));
}

static any Native_GetBossState(Handle plugin, int numParams)
{
	int entity = NPCGetEntIndex(GetNativeCell(1));
	if (!IsValidEntity(entity))
	{
		return 0;
	}

	SF2_BaseBoss boss = SF2_BaseBoss(entity);
	return boss.State;
}

static any Native_SetBossState(Handle plugin, int numParams)
{
	int entity = NPCGetEntIndex(GetNativeCell(1));
	if (!IsValidEntity(entity))
	{
		return 0;
	}

	SF2_BaseBoss boss = SF2_BaseBoss(entity);
	boss.State = GetNativeCell(2);
	return 0;
}

static any Native_GetBossEyePosition(Handle plugin, int numParams)
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

static any Native_GetBossEyePositionOffset(Handle plugin, int numParams)
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

static any Native_GetBossTeleportThinkTimer(Handle plugin, int numParams)
{
	return g_SlenderThink[GetNativeCell(1)];
}

static any Native_SetBossTeleportThinkTimer(Handle plugin, int numParams)
{
	int bossIndex = GetNativeCell(1);
	g_SlenderThink[bossIndex] = GetNativeCell(2);
	return 0;
}

static any Native_GetBossTeleportTarget(Handle plugin, int numParams)
{
	return EntRefToEntIndex(g_SlenderTeleportTarget[GetNativeCell(1)]);
}

static any Native_GetBossGoalPosition(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	if (!controller.Path.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid path for boss index %d", controller.Index);
	}

	float ret[3];
	controller.Path.GetEndPosition(ret);
	SetNativeArray(2, ret, 3);
	return 0;
}

static any Native_Nothing(Handle plugin, int numParams)
{
	return 0;
}

static any Native_GetBossCurrentChaseDuration(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	int entity = controller.EntIndex;
	if (!IsValidEntity(entity))
	{
		return 0;
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	return bossEntity.CurrentChaseDuration;
}

static any Native_SetBossCurrentChaseDuration(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	int entity = controller.EntIndex;
	if (!IsValidEntity(entity))
	{
		return 0;
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	bossEntity.CurrentChaseDuration = GetNativeCell(2);
	return 0;
}

static any Native_GetProfileData(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2BossProfileData data;
	data = controller.GetProfileData();
	SetNativeArray(2, data, sizeof(data));
	return 0;
}

static any Native_GetProfileDataEx(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, sizeof(profile));
	SF2BossProfileData data;
	if (!g_BossProfileData.GetArray(profile, data, sizeof(data)))
	{
		return false;
	}

	SetNativeArray(2, data, sizeof(data));
	return true;
}

static any Native_SpawnBossEffects(Handle plugin, int numParams)
{
	float pos[3], ang[3];
	GetNativeArray(3, pos, 3);
	GetNativeArray(4, ang, 3);
	ArrayList output = GetNativeCellRef(5);
	SlenderSpawnEffects(GetNativeCell(1), GetNativeCell(2), false, pos, ang, output, GetNativeCell(6));
	return 0;
}

static any Native_CanBossBeSeen(Handle plugin, int numParams)
{
	return PeopleCanSeeSlender(GetNativeCell(1), GetNativeCell(2), GetNativeCell(3), GetNativeCell(4));
}