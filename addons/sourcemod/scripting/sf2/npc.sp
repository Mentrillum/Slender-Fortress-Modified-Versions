#if defined _sf2_npc_included
 #endinput
#endif
#define _sf2_npc_included

#pragma semicolon 1
#pragma newdecls required

#define SF2_BOSS_PAGE_CALCULATION 512.0

static int g_NpcGlobalUniqueID = 0;

static int g_NpcUniqueID[MAX_BOSSES] = { -1, ... };
static char g_SlenderProfile[MAX_BOSSES][SF2_MAX_PROFILE_NAME_LENGTH];
static int g_NpcFlags[MAX_BOSSES] = { 0, ... };
static int g_NpcTeleporters[MAX_BOSSES][MAX_NPCTELEPORTER];
static int g_NpcModelMaster[2049];
static float g_NpcHighestPagePercent[MAX_BOSSES] = { -1.0, ... };

int g_SlenderEnt[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };

static float g_NpcAddSpeed[MAX_BOSSES];
static float g_NpcAddSpeedPersistent[MAX_BOSSES];
static float g_NpcAddWalkSpeedPersistent[MAX_BOSSES];
static float g_NpcAddAcceleration[MAX_BOSSES];
static float g_NpcAddAccelerationPersistent[MAX_BOSSES];

static bool g_NpcShouldBeAffectedBySight[MAX_BOSSES];

static int g_NpcDefaultTeam[MAX_BOSSES];

static bool g_NpcWasKilled[MAX_BOSSES];

void NPCInitialize()
{
	g_OnEntityDestroyedPFwd.AddFunction(null, EntityDestroyed);
	g_OnEntityTeleportedPFwd.AddFunction(null, EntityTeleported);
	g_OnPlayerLookAtBossPFwd.AddFunction(null, OnPlayerLookAtBoss);
	g_OnPageCountChangedPFwd.AddFunction(null, OnPageCountChanged);

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

	SetupNPCEffectsAPI();
}

static void EntityDestroyed(CBaseEntity ent, const char[] classname)
{
	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC.FromEntity(ent.index);
	if (controller.IsValid())
	{
		NPCOnDespawn(controller, view_as<CBaseCombatCharacter>(ent));
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
			int index = teleporters.FindValue(EntIndexToEntRef(teleporter.index));
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
					boss.Teleporters.Push(EntIndexToEntRef(teleporter.index));
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

				if (controller.GetProfileData().Type == SF2BossType_Chaser)
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
	switch (boss.GetProfileData().Type)
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

static void OnPageCountChanged(int pageCount, int oldPageCount)
{
	ArrayList indexes = null;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(i);
		if (!controller.IsValid())
		{
			continue;
		}

		int difficulty = controller.Difficulty;
		BaseBossProfile profileData = controller.GetProfileData();
		if (profileData.IsPvEBoss)
		{
			continue;
		}

		float old = g_NpcHighestPagePercent[controller.Index];
		float newValue = -1.0;
		BossOnPageCountChangedData pageChangeData = profileData.GetPageCountChagedData(pageCount, old, newValue);
		if (pageChangeData == null)
		{
			continue;
		}

		int entity = NPCGetEntIndex(i);
		if (entity && entity != INVALID_ENT_REFERENCE && pageChangeData.GetLocalSounds() != null)
		{
			pageChangeData.GetLocalSounds().EmitSound(_, entity);
		}
		if (pageChangeData.GetGlobalSounds() != null)
		{
			if (indexes == null)
			{
				indexes = new ArrayList();
			}
			indexes.Push(NPCGetUniqueID(i));
		}
		else
		{
			g_NpcHighestPagePercent[controller.Index] = newValue;
		}

		controller.SetPersistentAddSpeed(pageChangeData.GetAddSpeed(difficulty));
		controller.SetPersistentAddWalkSpeed(pageChangeData.GetAddWalkSpeed(difficulty));
		controller.SetPersistentAddAcceleration(pageChangeData.GetAddAcceleration(difficulty));
	}

	if (indexes != null)
	{
		indexes.Sort(Sort_Random, Sort_Integer);
		SF2NPC_BaseNPC controller = SF2_INVALID_NPC;
		int index = 0;
		while (!controller.IsValid())
		{
			controller = SF2NPC_BaseNPC(NPCGetFromUniqueID(indexes.Get(index)));
			index++;
		}

		BaseBossProfile profileData = controller.GetProfileData();
		BossOnPageCountChangedData pageChangeData = profileData.GetPageCountChagedData(pageCount, g_NpcHighestPagePercent[controller.Index], g_NpcHighestPagePercent[controller.Index]);
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!player.IsValid)
			{
				continue;
			}

			if (player.IsEliminated && !player.IsInGhostMode && !player.IsProxy)
			{
				continue;
			}

			if (!player.IsEliminated && player.HasEscaped)
			{
				continue;
			}

			pageChangeData.GetGlobalSounds().EmitSound(true, i);
		}
		delete indexes;
	}
}

void NPCOnDespawn(SF2NPC_BaseNPC controller, CBaseCombatCharacter entity)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	controller.GetProfile(profile, sizeof(profile));
	int bossIndex = controller.Index;
	BaseBossProfile data = controller.GetProfileData();
	Call_StartForward(g_OnBossDespawnFwd);
	Call_PushCell(bossIndex);
	Call_Finish();

	//Turn off all slender's effects in order to prevent some bugs.
	SlenderRemoveEffects(bossIndex, true);

	if (data.Type == SF2BossType_Statue)
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

	if (data.GetDespawnEffects() != null)
	{
		ProfileObject obj = view_as<ProfileObject>(data.GetDespawnEffects().GetSection(GetRandomInt(0, data.GetDespawnEffects().Length - 1)));
		if (obj != null)
		{
			if (data.GetBool("__was_killed") && obj.GetBool("hide_on_death", false))
			{
				// Do nothing
			}
			else
			{
				obj = obj.GetSection("effects");
				if (obj != null)
				{
					float pos[3], ang[3];
					CBaseEntity(NPCGetEntIndex(bossIndex)).GetAbsOrigin(pos);
					CBaseEntity(NPCGetEntIndex(bossIndex)).GetAbsAngles(ang);
					SlenderSpawnEffects(view_as<ProfileEffectMaster>(obj), bossIndex, false, pos, ang, _, _, true);
				}
			}
		}
	}

	if (data.GetDespawnInputs() != null)
	{
		data.GetDespawnInputs().AcceptInputs(entity);
	}

	char sound[PLATFORM_MAX_PATH];
	data.GetConstantSound(sound, sizeof(sound));
	if (sound[0] != '\0')
	{
		StopSound(entity.index, SNDCHAN_STATIC, sound);
	}

	if (NPCGetFlags(bossIndex) & SFF_HASSTATICLOOPLOCALSOUND)
	{
		char loopSound[PLATFORM_MAX_PATH];
		data.GetStaticLocalLoopSound(loopSound, sizeof(loopSound));

		if (loopSound[0] != '\0')
		{
			StopSound(entity.index, SNDCHAN_STATIC, loopSound);
		}
	}
	if (SF_IsRaidMap() || SF_BossesChaseEndlessly() || view_as<ChaserBossProfile>(data).Healthbar)
	{
		controller.Flags = controller.Flags & ~SFF_NOTELEPORT;
	}

	g_SlenderEnt[bossIndex] = INVALID_ENT_REFERENCE;
	if (view_as<ChaserBossProfile>(data).Healthbar && g_HealthBar != -1)
	{
		int npcIndex = 0;
		for (npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{
			if (NPCGetUniqueID(npcIndex) == -1)
			{
				continue;
			}
			data = SF2NPC_BaseNPC(npcIndex).GetProfileData();
			if (view_as<ChaserBossProfile>(data).Healthbar)
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

	data.SetBool("__was_killed", false);
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

bool NPCGetProfile(int npcIndex, char[] buffer, int bufferLen)
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

void NPCRemoveAll()
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		NPCRemove(i);
	}
}

int NPCGetFlags(int npcIndex)
{
	return g_NpcFlags[npcIndex];
}

void NPCSetFlags(int npcIndex,int flags)
{
	g_NpcFlags[npcIndex] = flags;
}

void NPCSetAddSpeed(int npcIndex, float amount)
{
	g_NpcAddSpeed[npcIndex] += amount;
}

void NPCSetPersistentAddSpeed(int npcIndex, float amount)
{
	g_NpcAddSpeedPersistent[npcIndex] += amount;
}

void NPCSetPersistentAddWalkSpeed(int npcIndex, float amount)
{
	g_NpcAddWalkSpeedPersistent[npcIndex] += amount;
}

void NPCSetAddAcceleration(int npcIndex, float amount)
{
	g_NpcAddAcceleration[npcIndex] += amount;
}

void NPCSetPersistentAddAcceleration(int npcIndex, float amount)
{
	g_NpcAddAccelerationPersistent[npcIndex] += amount;
}

float NPCGetAddSpeed(int npcIndex)
{
	return g_NpcAddSpeed[npcIndex];
}

float NPCGetPersistentAddSpeed(int npcIndex)
{
	return g_NpcAddSpeedPersistent[npcIndex];
}

float NPCGetPersistentAddWalkSpeed(int npcIndex)
{
	return g_NpcAddWalkSpeedPersistent[npcIndex];
}

float NPCGetAddAcceleration(int npcIndex)
{
	return g_NpcAddAcceleration[npcIndex];
}

float NPCGetPersistentAddAcceleration(int npcIndex)
{
	return g_NpcAddAccelerationPersistent[npcIndex];
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

	if (SF2NPC_BaseNPC(npcIndex).GetProfileData().Type == SF2BossType_Statue)
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
	SF2NPC_BaseNPC(npcIndex).GetProfileData().GetEyes().GetOffsetPos(eyePosOffset);

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

	BossProfileAttributes attributesInfo = GetBossProfile(profile).GetAttributes();
	if (attributesInfo == null)
	{
		return false;
	}

	bool returnValue = false;
	if (attributesInfo.GetValue(attribute) >= 0.0)
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

	BossProfileAttributes attributesInfo = GetBossProfile(profile).GetAttributes();

	if (attributesInfo == null)
	{
		return 0.0;
	}

	return attributesInfo.GetValue(attribute);
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
	BaseBossProfile profileData = GetBossProfile(profile);

	int teleportType = profileData.TeleportType;

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
					if (GetVectorSquareMagnitude(buffer, slenderPos) <= SquareFloat(profileData.GetStaticRadius(difficulty)))
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

	BaseBossProfile profileData = GetBossProfile(profile);

	int bossType = profileData.Type;

	g_NpcUniqueID[npc.Index] = g_NpcGlobalUniqueID++;

	if (SF_IsSlaughterRunMap())
	{
		NPCSetFlags(npc.Index, profileData.Flags | additionalBossFlags | SFF_NOTELEPORT);
	}
	else
	{
		NPCSetFlags(npc.Index, profileData.Flags | additionalBossFlags);
	}

	npc.CopyMaster = SF2_INVALID_NPC;
	npc.CompanionMaster = SF2_INVALID_NPC;

	g_NpcShouldBeAffectedBySight[npc.Index] = false;

	g_NpcDefaultTeam[npc.Index] = g_DefaultBossTeamConVar.IntValue;

	g_NpcHighestPagePercent[npc.Index] = -1.0;

	g_NpcAddSpeed[npc.Index] = 0.0;
	g_NpcAddSpeedPersistent[npc.Index] = 0.0;
	g_NpcAddWalkSpeedPersistent[npc.Index] = 0.0;
	g_NpcAddAcceleration[npc.Index] = 0.0;
	g_NpcAddAccelerationPersistent[npc.Index] = 0.0;

	g_SlenderFakeTimer[npc.Index] = null;
	g_SlenderEntityThink[npc.Index] = null;
	g_SlenderDeathCamTimer[npc.Index] = null;
	g_SlenderDeathCamTarget[npc.Index] = INVALID_ENT_REFERENCE;
	g_SlenderNextTeleportTime[npc.Index] = 0.0;
	g_SlenderTimeUntilKill[npc.Index] = -1.0;
	g_SlenderNextJumpScare[npc.Index] = -1.0;
	g_SlenderTimeUntilNextProxy[npc.Index] = -1.0;

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
		BossProfilePvEData pveData = profileData.GetPvEData();
		if (pveData.IsEnabled && showPvEMessage && pveData.GetSpawnMessages() != null && pveData.GetSpawnMessages().KeyLength > 0)
		{
			char prefix[PLATFORM_MAX_PATH], message[PLATFORM_MAX_PATH], name[SF2_MAX_NAME_LENGTH], keyName[64];
			pveData.GetSpawnMessagePrefix(prefix, sizeof(prefix));
			if (prefix[0] == '\0')
			{
				prefix = "[SF2]";
			}
			int messageIndex = GetRandomInt(0, pveData.GetSpawnMessages().KeyLength - 1);
			pveData.GetSpawnMessages().GetKeyNameFromIndex(messageIndex, keyName, sizeof(keyName));
			pveData.GetSpawnMessages().GetString(keyName, message, sizeof(message));
			if (StrContains(message, "[BOSS]", true) != -1)
			{
				profileData.GetName(1, name, sizeof(name));
				ReplaceString(message, sizeof(message), "[BOSS]", name);
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
			ProfileSound soundInfo = profileData.GetIntroSounds();
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
		if (spawnCompanions)
		{
			char compProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			BossProfileCompanions companions = profileData.GetCompanions();
			if (companions != null)
			{
				char spawnType[64];
				companions.GetSpawnType(spawnType, sizeof(spawnType));
				if (spawnType[0] == '\0') // No random companions
				{
					/*SF2BossProfileCompanionsInfo companionInfo;
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
					}*/
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

		if (profileData.GetRedCameraOverlays() != null)
		{
			char value[PLATFORM_MAX_PATH];
			profileData.GetRedCameraOverlays().GetString(GetRandomInt(0, profileData.GetRedCameraOverlays().Length - 1), value, sizeof(value));
			profileData.SetActiveRedCameraOverlay(value);
		}
	}

	Call_StartForward(g_OnBossAddedFwd);
	Call_PushCell(npc.Index);
	Call_Finish();

	Call_StartForward(g_OnBossAddedPFwd);
	Call_PushCell(npc);
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
	BossProfileCompanions companions = npc.GetProfileData().GetCompanions();
	if (companions == null)
	{
		return;
	}

	ArrayList companionsToAdd = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	char compProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	float maxWeight = 0.0;
	for (int i = 0; i < companions.SectionLength; i++)
	{
		maxWeight += companions.GetWeightFromGroupEx(i, npc.Difficulty);
	}
	float randomWeight = GetRandomFloat(0.0, maxWeight);

	for (int i = 0; i < companions.SectionLength; i++)
	{
		if (companions.GetBossesFromGroupEx(i) == null)
		{
			continue;
		}

		float weight = companions.GetWeightFromGroupEx(i, npc.Difficulty);
		if (weight <= 0.0)
		{
			continue;
		}

		randomWeight -= weight;
		if (randomWeight >= 0.0)
		{
			continue;
		}

		for (int i2 = 0; i2 < companions.GetBossesFromGroupEx(i).KeyLength; i2++)
		{
			char key[64];
			companions.GetBossesFromGroupEx(i).GetKeyNameFromIndex(i2, key, sizeof(key));
			companions.GetBossesFromGroupEx(i).GetString(key, compProfile, sizeof(compProfile));
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
	BaseBossProfile profileData = GetBossProfile(profile);
	switch (modelState)
	{
		case 0:
		{
			switch (difficulty)
			{
				case Difficulty_Normal:
				{
					profileData.GetModel(Difficulty_Normal, buffer, bufferLen);
				}
				case Difficulty_Hard:
				{
					profileData.GetModel(Difficulty_Hard, buffer, bufferLen);
				}
				case Difficulty_Insane:
				{
					profileData.GetModel(Difficulty_Insane, buffer, bufferLen);
				}
				case Difficulty_Nightmare:
				{
					profileData.GetModel(Difficulty_Nightmare, buffer, bufferLen);
				}
				case Difficulty_Apollyon:
				{
					profileData.GetModel(Difficulty_Apollyon, buffer, bufferLen);
				}
			}
		}
	}
	return true;
}

bool NPCFindUnstuckPosition(SF2_BaseBoss boss, float lastPos[3], float destination[3])
{
	SF2NPC_BaseNPC controller = boss.Controller;
	BaseBossProfile data = controller.GetProfileData();
	PathFollower path = controller.Path;
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(boss.index);
	CNavArea area = TheNavMesh.GetNearestNavArea(lastPos, _, _, _, false);
	area.GetCenter(destination);
	float tempMaxs[3];
	npc.GetBodyMaxs(tempMaxs);
	float traceMins[3];
	data.GetHullMins(traceMins);
	traceMins[0] -= 5.0;
	traceMins[1] -= 5.0;
	traceMins[2] = 0.0;

	float traceMaxs[3];
	data.GetHullMaxs(traceMaxs);
	traceMaxs[0] += 5.0;
	traceMaxs[1] += 5.0;
	traceMaxs[2] = tempMaxs[2];
	Handle trace = TR_TraceHullFilterEx(destination, destination, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntityEx);
	bool hit = TR_DidHit(trace);
	delete trace;
	if (GetVectorSquareMagnitude(destination, lastPos) <= SquareFloat(16.0) || hit)
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

			trace = TR_TraceHullFilterEx(destination, destination, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntityEx);
			hit = TR_DidHit(trace);
			delete trace;
			if (hit)
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

	int ent = -1;
	char targetName[64];
	if (controller.GetProfileData().IsPvEBoss)
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
		BaseBossProfile data = GetBossProfile(profile);
		GetSlenderModel(npcIndex, _, buffer, sizeof(buffer));
		SetEntityModel(slender, buffer);

		if (SF2_ChaserEntity(slender).IsValid())
		{
			SF2_ChaserEntity(slender).UpdateMovementAnimation();
		}
		SetGlowModel(slender, buffer);
		if (data.SkinMax > 0)
		{
			int randomSkin = GetRandomInt(0, data.SkinMax);
			SetEntProp(slender, Prop_Send, "m_nSkin", randomSkin);
		}
		else
		{
			SetEntProp(slender, Prop_Send, "m_nSkin", data.GetSkin(difficulty));
		}
		if (data.BodyMax > 0)
		{
			int randomBody = GetRandomInt(0, data.BodyMax);
			SetEntProp(slender, Prop_Send, "m_nBody", randomBody);
		}
		else
		{
			SetEntProp(slender, Prop_Send, "m_nBody", data.GetBodyGroup(difficulty));
		}
		if (data.Type == SF2BossType_Chaser)
		{
			float mins[3], maxs[3];
			if (data.RaidHitbox)
			{
				data.GetHullMins(mins);
				data.GetHullMaxs(maxs);
				mins[2] = 10.0;
				SetEntPropVector(slender, Prop_Send, "m_vecMins", mins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxs", maxs);

				SetEntPropVector(slender, Prop_Send, "m_vecMinsPreScaled", mins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxsPreScaled", maxs);
			}
			else
			{
				CopyVector(HULL_HUMAN_MINS, mins);
				mins[2] = 10.0;
				SetEntPropVector(slender, Prop_Send, "m_vecMins", mins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);

				SetEntPropVector(slender, Prop_Send, "m_vecMinsPreScaled", mins);
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

	if (SF_IsBoxingMap() && (GetRoundState() == SF2RoundState_Escape) && view_as<SF2NPC_Chaser>(controller).GetProfileData().BoxingBoss)
	{
		g_SlenderBoxingBossCount -= 1;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	controller.GetProfile(profile, sizeof(profile));

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

	controller.Flags = 0;

	controller.SetAddSpeed(0.0);
	controller.SetAddAcceleration(0.0);

	controller.CopyMaster = SF2_INVALID_NPC;
	controller.CompanionMaster = SF2_INVALID_NPC;
	g_NpcUniqueID[bossIndex] = -1;
	g_SlenderDeathCamTimer[bossIndex] = null;
	g_SlenderDeathCamTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderThink[bossIndex] = null;
	g_SlenderEntityThink[bossIndex] = null;

	g_SlenderFakeTimer[bossIndex] = null;
	g_SlenderModel[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderBoxingBossIsKilled[bossIndex] = false;
	g_SlenderTimeUntilNextProxy[bossIndex] = -1.0;

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
	npc.GetProfile(profile, sizeof(profile));
	npc.WasKilled = false;
	BaseBossProfile data = npc.GetProfileData();

	float truePos[3], trueAng[3];
	trueAng[1] = GetRandomFloat(0.0, 360.0);
	AddVectors(truePos, pos, truePos);

	int bossIndex = npc.Index;

	CBaseCombatCharacter entity;

	switch (data.Type)
	{
		case SF2BossType_Statue:
		{
			entity = view_as<CBaseCombatCharacter>(Spawn_Statue(npc, truePos, trueAng));
		}
		case SF2BossType_Chaser:
		{
			entity = view_as<CBaseCombatCharacter>(Spawn_Chaser(npc, truePos, trueAng));
		}
	}

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

	g_BossPathFollower[bossIndex].SetMinLookAheadDistance(data.NodeDistanceLookAhead);

	if (data.SkinMax > 0)
	{
		int randomSkin = GetRandomInt(0, data.SkinMax);
		entity.SetProp(Prop_Send, "m_nSkin", randomSkin);
	}
	else
	{
		entity.SetProp(Prop_Send, "m_nSkin", data.GetSkin(difficulty));
	}
	if (data.BodyMax > 0)
	{
		int randomBody = GetRandomInt(0, data.BodyMax);
		entity.SetProp(Prop_Send, "m_nBody", randomBody);
	}
	else
	{
		entity.SetProp(Prop_Send, "m_nBody", data.GetBodyGroup(difficulty));
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

	char buffer[PLATFORM_MAX_PATH];
	data.GetConstantSound(buffer, sizeof(buffer));
	if (buffer[0] != '\0')
	{
		EmitSoundToAll(buffer, entity.index, SNDCHAN_STATIC, data.ConstantSoundLevel,
		_, data.ConstantSoundVolume);
	}

	if (data.GetSpawnEffects() != null)
	{
		ProfileObject obj = view_as<ProfileObject>(data.GetSpawnEffects().GetSection(GetRandomInt(0, data.GetSpawnEffects().Length - 1)));
		obj = obj != null ? obj.GetSection("effects") : null;
		if (obj != null)
		{
			SlenderSpawnEffects(view_as<ProfileEffectMaster>(obj), bossIndex, false);
		}
	}

	if (data.GetOutputs() != null)
	{
		data.GetOutputs().AddOutputs(entity);
	}

	if (data.GetSpawnInputs() != null)
	{
		data.GetSpawnInputs().AcceptInputs(entity);
	}

	int master = g_SlenderCopyMaster[bossIndex];
	int flags = NPCGetFlags(bossIndex);

	if (MAX_BOSSES > master >= 0 && data.GetCopies().GetFakes(difficulty))
	{
		if (!SF_SpecialRound(SPECIALROUND_DREAMFAKEBOSSES))
		{
			NPCSetFlags(bossIndex, flags | SFF_FAKE);
		}
	}

	SlenderSpawnEffects(view_as<ProfileEffectMaster>(data.GetSection("effects")), bossIndex);

	if (entity.IsValid())
	{
		data.GetLocalSpawnSounds().EmitSound(_, entity.index);
	}

	float teleportTime = GetRandomFloat(data.GetMinTeleportTime(difficulty), data.GetMaxTeleportTime(difficulty));
	g_SlenderNextTeleportTime[bossIndex] = GetGameTime() + teleportTime;

	// Call our forward.
	Call_StartForward(g_OnBossSpawnFwd);
	Call_PushCell(bossIndex);
	Call_Finish();

	Call_StartForward(g_OnBossSpawnPFwd);
	Call_PushCell(npc);
	Call_Finish();
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
		SlenderCastAnimEvent(bossIndex, event, thisInt);
	}
	return MRES_Ignored;
}

void UpdateHealthBar(int bossIndex, int optionalSetPercent = -1)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(NPCGetEntIndex(bossIndex));
	if (!chaser.IsValid())
	{
		if (g_HealthBar != -1)
		{
			SetEntProp(g_HealthBar, Prop_Send, "m_iBossHealthPercentageByte", 0);
		}
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
	if (SF2NPC_BaseNPC(bossIndex).GetProfileData().Type == SF2BossType_Statue)
	{
		return true;
	}
	return false;
}

void SlenderPrintChatMessage(int bossIndex, int player)
{
	if (g_Enabled && GetClientTeam(player) != TFTeam_Red)
	{
		//return;
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

	BaseBossProfile profileData = GetBossProfile(profile);
	ProfileObject deathMessages = profileData.GetSection("chat_message_upon_death");
	if (deathMessages == null || deathMessages.Size <= 0)
	{
		return;
	}

	int difficultyIndex = profileData.GetInt("chat_message_upon_death_difficulty_indexes", 123456);

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
			char buffer[PLATFORM_MAX_PATH], prefix[PLATFORM_MAX_PATH], name[SF2_MAX_NAME_LENGTH], time[PLATFORM_MAX_PATH], keyName[64];
			int roundTime = RoundToNearest(g_RoundTimeMessage);
			int randomMessage = GetRandomInt(0, deathMessages.KeyLength - 1);
			profileData.GetString("chat_message_upon_death_prefix", prefix, sizeof(prefix), "[SF2]");
			deathMessages.GetKeyNameFromIndex(randomMessage, keyName, sizeof(keyName));
			deathMessages.GetString(keyName, buffer, sizeof(buffer));
			profileData.GetName(GetLocalGlobalDifficulty(bossIndex), name, sizeof(name));
			FormatEx(time, sizeof(time), "%d", roundTime);
			char playerName[32], replacePlayer[64];
			FormatEx(playerName, sizeof(playerName), "%N", player);
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
					if (prefix[0] == '\0')
					{
						CPrintToChatAll("%s", buffer);
					}
					else
					{
						CPrintToChatAll("{royalblue}%s {default}%s", prefix, buffer);
					}
				}
			}
		}
	}
}

void SlenderCastAnimEvent(int bossIndex, int index, int slender)
{
	if (bossIndex == -1 || !IsValidEntity(slender))
	{
		return;
	}

	ChaserBossProfile data = SF2NPC_Chaser(bossIndex).GetProfileData();

	BossProfileEventData event = data.GetEvents(index);
	if (event == null)
	{
		return;
	}

	float myPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);

	if (event.GetSounds() != null)
	{
		event.GetSounds().EmitSound(.entity = slender);
	}

	if (event.GetEffects() != null)
	{
		SlenderSpawnEffects(event.GetEffects(), bossIndex, false);
	}

	if (event.IsFootsteps && data.EarthquakeFootsteps)
	{
		UTIL_ScreenShake(myPos, data.EarthquakeFootstepAmplitude,
		data.EarthquakeFootstepFrequency, data.EarthquakeFootstepDuration,
		data.EarthquakeFootstepRadius, 0, data.EarthquakeFootstepAirShake);
	}
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
	BaseBossProfile data = controller.GetProfileData();

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

	if (!data.IsTeleportAllowed(difficulty) && (!bossEnt || bossEnt == INVALID_ENT_REFERENCE))
	{
		return Plugin_Continue;
	}

	if (data.TeleportType == 2)
	{
		if (bossEnt && bossEnt != INVALID_ENT_REFERENCE)
		{
			if (data.Type == SF2BossType_Chaser)
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
						g_SlenderTimeUntilKill[bossIndex] = gameTime + data.GetIdleLifeTime(difficulty);
					}
					return Plugin_Continue;
				}
			}
			else if (data.Type == SF2BossType_Statue)
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
			if (!data.IsTeleportAllowed(difficulty) && bossEnt && bossEnt != INVALID_ENT_REFERENCE)
			{
				controller.UnSpawn();
				return Plugin_Continue;
			}
			float teleportTime = GetRandomFloat(data.GetMinTeleportTime(difficulty), data.GetMaxTeleportTime(difficulty));
			g_SlenderNextTeleportTime[bossIndex] = gameTime + teleportTime;
			bool ignoreFuncNavPrefer = data.IgnoreNavPrefer;

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
				float targetDuration = data.GetTeleportPersistencyPeriod(difficulty);
				float deviation = GetRandomFloat(0.92, 1.08);
				targetDuration = Pow(deviation * targetDuration, ((g_RoundDifficultyModifier) / 2.0)) + ((deviation * targetDuration) - 1.0);
				g_SlenderTeleportMaxTargetTime[controller.Index] = gameTime + targetDuration;

				float teleportMinRange = data.GetMinTeleportRange(difficulty);
				bool shouldBeBehindObstruction = false;
				if (data.TeleportType == 2)
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
					SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(area, data.GetMaxTeleportRange(difficulty));
					int areaCount = collector.Count();
					ArrayList areaArray = new ArrayList(1, areaCount);
					int validAreaCount = 0;
					for (int i = 0; i < areaCount; i++)
					{
						if (ignoreFuncNavPrefer && NavHasFuncPrefer(collector.Get(i)))
						{
							continue;
						}

						if (area.HasAttributes(NAV_MESH_NO_HOSTAGES) || view_as<CTFNavArea>(area).HasAttributeTF(NO_SPAWNING))
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
						float cornerPosition[3];
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
						LerpVectors(spawnPos, cornerPosition, spawnPos, GetRandomFloat(0.35, 0.65));
						area.GetCorner(invert, cornerPosition);
						LerpVectors(spawnPos, cornerPosition, spawnPos, GetRandomFloat(0.35, 0.65));
						delete corners;

						float traceMins[3];
						data.GetHullMins(traceMins);
						traceMins[2] = 0.0;

						float traceMaxs[3];
						data.GetHullMaxs(traceMaxs);

						Handle trace = TR_TraceHullFilterEx(spawnPos, spawnPos, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitEntity);
						bool hit = TR_DidHit(trace);
						delete trace;
						if (hit)
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
							if (!data.TeleportIgnoreVis && IsPointVisibleToAPlayer(spawnPos, !shouldBeBehindObstruction, false, _, true))
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

							float offset[3];
							data.GetEyes().GetOffsetPos(offset);
							AddVectors(spawnPos, offset, spawnPos);

							if (!data.TeleportIgnoreVis && IsPointVisibleToAPlayer(spawnPos, !shouldBeBehindObstruction, false, _, true))
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

							SubtractVectors(spawnPos, offset, spawnPos);

							// Look for copies
							if (controller.GetProfileData().GetCopies().IsEnabled(difficulty) && canSpawn)
							{
								float minDistBetweenBosses = data.GetCopies().GetTeleportDistanceSpacing(difficulty);

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
											if ((NPCGetDistanceFromEntity(bossIndex, i) <= SquareFloat(data.GetJumpscareDistance(difficulty)) && GetGameTime() >= g_SlenderNextJumpScare[bossIndex]) ||
											(PlayerCanSeeSlender(i, bossIndex) && !data.JumpscareNoSight))
											{
												didJumpScare = true;

												ClientDoJumpScare(i, bossIndex, data.GetJumpscareDuration(difficulty));
											}
										}
									}

									if (didJumpScare)
									{
										g_SlenderNextJumpScare[bossIndex] = GetGameTime() + data.GetJumpscareCooldown(difficulty);
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
		float teleportTime = GetRandomFloat(data.GetMinTeleportTime(difficulty), data.GetMaxTeleportTime(difficulty));
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
	BaseBossProfile data = controller.GetProfileData();

	bool cont = false;

	int bossEnt = controller.EntIndex;
	if (bossEnt && bossEnt != INVALID_ENT_REFERENCE && data.TeleportType == 2)
	{
		cont = true;
	}

	if (!data.IsTeleportAllowed(difficulty) && (!bossEnt || bossEnt == INVALID_ENT_REFERENCE))
	{
		cont = true;
	}

	if (cont)
	{
		float teleportTime = GetRandomFloat(data.GetMinTeleportTime(difficulty), data.GetMaxTeleportTime(difficulty));
		g_SlenderNextTeleportTime[bossIndex] = gameTime + teleportTime;
		return Plugin_Continue;
	}

	if (gameTime >= g_SlenderNextTeleportTime[bossIndex])
	{
		float teleportTime = GetRandomFloat(data.GetMinTeleportTime(difficulty), data.GetMaxTeleportTime(difficulty));
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

	BaseBossProfile data = SF2NPC_BaseNPC(bossIndex).GetProfileData();

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

		char sound[PLATFORM_MAX_PATH];
		data.GetConstantSound(sound, sizeof(sound));
		if (sound[0] != '\0')
		{
			StopSound(slender, SNDCHAN_STATIC, sound);
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

	BaseBossProfile profileData = GetBossProfile(profile);

	float playbackRate, cycle;
	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	GetSlenderModel(bossIndex, _, buffer, sizeof(buffer));
	if (buffer[0] == '\0')
	{
		LogError("Could not spawn boss model: model is invalid!");
		return -1;
	}
	float modelScale = profileData.ModelScale;
	if (modelScale <= 0.0)
	{
		LogError("Could not spawn boss model: model scale is less than or equal to 0.0!");
		return -1;
	}
	int modelSkin = profileData.GetSkin(difficulty);
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
		ProfileMasterAnimations animData = profileData.GetAnimations();
		ProfileAnimation animSection = null;
		if (!deathCam)
		{
			animSection = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Idle]);
			if (animSection != null)
			{
				animSection.GetAnimationName(difficulty, buffer, sizeof(buffer));
				playbackRate = animSection.GetAnimationPlaybackRate(difficulty);
				cycle = animSection.GetAnimationCycle(difficulty);
			}
		}
		else
		{
			animSection = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_DeathCam]);
			if (animSection == null)
			{
				animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Idle]);
			}
			if (animSection != null)
			{
				playbackRate = animSection.GetAnimationPlaybackRate(difficulty);
				cycle = animSection.GetAnimationCycle(difficulty);
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
		if (profileData.SkinMax > 0)
		{
			int randomSkin = GetRandomInt(0, profileData.SkinMax);
			slenderModel.SetProp(Prop_Send, "m_nSkin", randomSkin);
		}
		else
		{
			slenderModel.SetProp(Prop_Send, "m_nSkin", modelSkin);
		}
		if (profileData.BodyMax > 0)
		{
			int randomBody = GetRandomInt(0, profileData.BodyMax);
			slenderModel.SetProp(Prop_Send, "m_nBody", randomBody);
		}
		else
		{
			slenderModel.SetProp(Prop_Send, "m_nBody", profileData.GetBodyGroup(difficulty));
		}

		// Create special effects.
		slenderModel.SetRenderMode(profileData.GetRenderMode(difficulty));
		slenderModel.SetRenderFx(profileData.GetRenderFx(difficulty));
		int color[4];
		profileData.GetRenderColor(difficulty, color);
		slenderModel.SetRenderColor(color[0], color[1], color[2], color[3]);

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

		return GetVectorDistance(pos, point, true);
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
	CBaseEntity(ent).GetAbsOrigin(pos);

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
	if (SF2_ChaserEntity(entity).IsValid() || SF2_StatueEntity(entity).IsValid())
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

	if (SF2_ChaserEntity(entity).IsValid() || SF2_StatueEntity(entity).IsValid())
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
	if (SF2_ChaserEntity(entity).IsValid() || SF2_StatueEntity(entity).IsValid())
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
	if (SF2_ChaserEntity(entity).IsValid() || SF2_StatueEntity(entity).IsValid())
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

	if (SF2_ChaserEntity(entity).IsValid() || SF2_StatueEntity(entity).IsValid())
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
				CNavArea area = collector.Get(areaIndex);

				// Check flags.
				if (area.HasAttributes(NAV_MESH_NO_HOSTAGES) || view_as<CTFNavArea>(area).HasAttributeTF(NO_SPAWNING))
				{
					// Don't spawn/teleport at areas marked with the "NO HOSTAGES" flag.
					continue;
				}

				int index = areaArray.Push(area);
				areaArray.Set(index, area.GetCostSoFar(), 1);
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
	return SF2NPC_BaseNPC(GetNativeCell(1)).GetProfileData().Type;
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
	return SF2NPC_BaseNPC(GetNativeCell(1)).GetProfileData().GetIdleLifeTime(GetNativeCell(2));
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
	boss.GetProfileData().GetEyes().GetOffsetPos(eyePos);

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

	return controller.GetProfileData();
}

static any Native_GetProfileDataEx(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, sizeof(profile));
	return GetBossProfile(profile);
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