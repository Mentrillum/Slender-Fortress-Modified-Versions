#if defined _sf2_npc_chaser_included
#endinput
#endif
#define _sf2_npc_chaser_included

#pragma semicolon 1

static SF2ChaserBossProfileData g_NpcChaserProfileData[MAX_BOSSES];

static float g_NpcStunAddHealth[MAX_BOSSES];

static float g_NpcDeathInitialHealth[MAX_BOSSES][Difficulty_Max];
static float g_NpcDeathHealth[MAX_BOSSES][Difficulty_Max];

static float g_NpcAlertGracetime[MAX_BOSSES][Difficulty_Max];
static float g_NpcAlertDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcChaseDuration[MAX_BOSSES][Difficulty_Max];

ArrayList g_NpcChaseOnLookTarget[MAX_BOSSES] = { null, ... };

static float g_NpcSearchWanderRangeMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcSearchWanderRangeMax[MAX_BOSSES][Difficulty_Max];

bool g_NpcCopyAlerted[MAX_BOSSES];

static bool g_NpcHasIsBoxingBoss[MAX_BOSSES] = { false, ... };

bool g_NpcStealingLife[MAX_BOSSES];
Handle g_NpcLifeStealTimer[MAX_BOSSES];

static Handle g_NpcInstantKillThink[MAX_BOSSES];

//Boxing stuff
static int g_NpcBoxingCurrentDifficulty[MAX_BOSSES];
static int g_NpcBoxingRagePhase[MAX_BOSSES];

static bool g_ClientShouldBeForceChased[MAX_BOSSES][2049];
static bool g_IsTargetMarked[MAX_BOSSES][2049];

GlobalForward g_OnChaserBossStartAttackFwd;
GlobalForward g_OnChaserBossEndAttackFwd;

/*#include "sf2/npc/npc_chaser_mind.sp"
#include "sf2/npc/npc_chaser_attacks.sp"
#include "sf2/npc/npc_chaser_pathing.sp"
#include "sf2/npc/npc_chaser_projectiles.sp"*/
#include "npc_creeper.sp"

void NPCChaserInitialize()
{
	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		NPCChaserResetValues(npcIndex);
	}

	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnBossRemovedPFwd.AddFunction(null, OnBossRemoved);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	ResetClientNPCStates(client);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ResetClientNPCStates(client);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		ResetClientNPCStates(client);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ResetClientNPCStates(client);
}

static void OnBossRemoved(SF2NPC_BaseNPC npc)
{
	if (npc.Type == SF2BossType_Chaser)
	{
		NPCChaserOnRemoveProfile(npc.Index);
	}
}

SF2ChaserBossProfileData NPCChaserGetProfileData(int npcIndex)
{
	return g_NpcChaserProfileData[npcIndex];
}

void NPCChaserSetProfileData(int npcIndex, SF2ChaserBossProfileData value)
{
	g_NpcChaserProfileData[npcIndex] = value;
}

float NPCChaserGetAddStunHealth(int npcIndex)
{
	return g_NpcStunAddHealth[npcIndex];
}

void NPCChaserSetAddStunHealth(int npcIndex, float amount)
{
	g_NpcStunAddHealth[npcIndex] += amount;
}

float NPCChaserGetDeathInitialHealth(int npcIndex, int difficulty)
{
	return g_NpcDeathInitialHealth[npcIndex][difficulty];
}

float NPCChaserGetDeathHealth(int npcIndex, int difficulty)
{
	return g_NpcDeathHealth[npcIndex][difficulty];
}

void NPCChaserSetDeathHealth(int npcIndex, int difficulty, float amount)
{
	g_NpcDeathHealth[npcIndex][difficulty] = amount;
}

bool NPCChaserIsBoxingBoss(int npcIndex)
{
	return g_NpcHasIsBoxingBoss[npcIndex];
}

int NPCChaserGetBoxingDifficulty(int npcIndex)
{
	return g_NpcBoxingCurrentDifficulty[npcIndex];
}

void NPCChaserSetBoxingDifficulty(int npcIndex, int value)
{
	g_NpcBoxingCurrentDifficulty[npcIndex] = value;
}

bool ShouldClientBeForceChased(SF2NPC_BaseNPC controller, CBaseEntity client)
{
	return g_ClientShouldBeForceChased[controller.Index][client.index];
}

void SetClientForceChaseState(SF2NPC_BaseNPC controller, CBaseEntity client, bool value)
{
	g_ClientShouldBeForceChased[controller.Index][client.index] = value;
}

bool IsTargetMarked(SF2NPC_BaseNPC controller, CBaseEntity entity)
{
	return g_IsTargetMarked[controller.Index][entity.index];
}

void SetTargetMarkState(SF2NPC_BaseNPC controller, CBaseEntity entity, bool value)
{
	g_IsTargetMarked[controller.Index][entity.index] = value;
}

ArrayList NPCChaserGetAutoChaseTargets(int npcIndex)
{
	return g_NpcChaseOnLookTarget[npcIndex];
}

void ResetClientNPCStates(CBaseEntity client)
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_ClientShouldBeForceChased[i][client.index] = false;
	}
}

void NPCChaserOnSelectProfile(int npcIndex)
{
	SF2NPC_Chaser chaser = SF2NPC_Chaser(npcIndex);
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(npcIndex, profile, sizeof(profile));
	SF2ChaserBossProfileData profileData;
	g_ChaserBossProfileData.GetArray(profile, profileData, sizeof(profileData));
	g_NpcChaserProfileData[npcIndex] = profileData;

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcDeathInitialHealth[npcIndex][difficulty] = GetChaserProfileDeathHealth(profile, difficulty);
		g_NpcDeathHealth[npcIndex][difficulty] = g_NpcDeathInitialHealth[npcIndex][difficulty];
	}

	if (g_NpcChaseOnLookTarget[npcIndex] == null)
	{
		g_NpcChaseOnLookTarget[npcIndex] = new ArrayList();
	}

	chaser.SetAddSpeed(-chaser.GetAddSpeed());
	chaser.SetAddAcceleration(-chaser.GetAddAcceleration());
	chaser.StunHealthAdd = -chaser.StunHealthAdd;

	g_NpcHasIsBoxingBoss[npcIndex] = GetChaserProfileBoxingState(profile);

	g_NpcStealingLife[npcIndex] = false;
	g_NpcLifeStealTimer[npcIndex] = null;

	g_NpcBoxingCurrentDifficulty[npcIndex] = 1;
	g_NpcBoxingRagePhase[npcIndex] = 0;

	g_NpcCopyAlerted[npcIndex] = false;

	if (chaser.HasAttribute(SF2Attribute_ReducedSpeedOnLook) || chaser.HasAttribute(SF2Attribute_ReducedWalkSpeedOnLook) || chaser.HasAttribute(SF2Attribute_ReducedAccelerationOnLook))
	{
		chaser.SetAffectedBySight(true);
	}
}

void NPCChaserOnRemoveProfile(int npcIndex)
{
	NPCChaserResetValues(npcIndex);
}

/**
 *	Resets all global variables on a specified NPC. Usually this should be done last upon removing a boss from the game.
 */
static void NPCChaserResetValues(int npcIndex)
{
	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcAlertGracetime[npcIndex][difficulty] = 0.0;
		g_NpcAlertDuration[npcIndex][difficulty] = 0.0;
		g_NpcChaseDuration[npcIndex][difficulty] = 0.0;

		g_NpcSearchWanderRangeMin[npcIndex][difficulty] = 0.0;
		g_NpcSearchWanderRangeMax[npcIndex][difficulty] = 0.0;

		g_NpcDeathInitialHealth[npcIndex][difficulty] = 0.0;
		NPCChaserSetDeathHealth(npcIndex, difficulty, 0.0);
	}

	g_NpcHasIsBoxingBoss[npcIndex] = false;

	g_NpcStunAddHealth[npcIndex] = 0.0;

	g_NpcStealingLife[npcIndex] = false;
	g_NpcLifeStealTimer[npcIndex] = null;
	if (g_NpcChaseOnLookTarget[npcIndex] != null)
	{
		delete g_NpcChaseOnLookTarget[npcIndex];
		g_NpcChaseOnLookTarget[npcIndex] = null;
	}

	NPCSetAddSpeed(npcIndex, -NPCGetAddSpeed(npcIndex));
	NPCSetAddAcceleration(npcIndex, -NPCGetAddAcceleration(npcIndex));
	NPCChaserSetAddStunHealth(npcIndex, -NPCChaserGetAddStunHealth(npcIndex));

	g_NpcBoxingCurrentDifficulty[npcIndex] = 0;
	g_NpcBoxingRagePhase[npcIndex] = 0;

	g_NpcCopyAlerted[npcIndex] = false;
}

SF2_ChaserEntity Spawn_Chaser(SF2NPC_BaseNPC controller, const float pos[3], const float ang[3])
{
	int bossIndex = controller.Index;

	NPCSetAddSpeed(bossIndex, -NPCGetAddSpeed(bossIndex));
	NPCSetAddAcceleration(bossIndex, -NPCGetAddAcceleration(bossIndex));
	NPCChaserSetAddStunHealth(bossIndex, -NPCChaserGetAddStunHealth(bossIndex));
	/*char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	g_LastStuckTime[bossIndex] = 0.0;
	g_SlenderOldState[bossIndex] = STATE_IDLE;
	g_NpcCopyAlerted[bossIndex] = false;
	g_NpcNextDecloakTime[bossIndex] = -1.0;
	g_NpcIsCrawling[bossIndex] = false;
	g_NpcChangeToCrawl[bossIndex] = false;
	g_SlenderSoundPositionSetCooldown[bossIndex] = 0.0;

	//g_NpcInstantKillThink[bossIndex] = CreateTimer(0.0, Timer_InstantKillThink, bossIndex, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_SlenderNextWanderPos[bossIndex][difficulty] = GetGameTime() +
			GetRandomFloat(GetChaserProfileWanderEnterTimeMin(profile, difficulty), GetChaserProfileWanderEnterTimeMax(profile, difficulty));
	}*/

	return SF2_ChaserEntity.Create(controller, pos, ang);
}

void Despawn_Chaser(int bossIndex)
{
	g_NpcInstantKillThink[bossIndex] = null;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		SF2_BasePlayer player = SF2_BasePlayer(i);
		player.SetForceChaseState(SF2NPC_BaseNPC(bossIndex), false);
	}
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

bool IsTargetValidForSlender(SF2_BaseBoss boss, CBaseEntity target, bool includeEliminated = false)
{
	if (!target.IsValid())
	{
		return false;
	}

	if (target.index <= 0)
	{
		return false;
	}

	SF2_BasePlayer player = SF2_BasePlayer(target.index);
	if (player.IsValid && (!player.IsAlive ||
		player.IsInDeathCam ||
		player.IsInGhostMode ||
		player.HasEscaped ||
		player.InCondition(view_as<TFCond>(130)) ||
		player.Team == TFTeam_Spectator))
	{
		return false;
	}

	if (!g_Enabled)
	{
		if (target.GetProp(Prop_Data, "m_iTeamNum") == boss.Team)
		{
			return false;
		}
	}
	else
	{
		if (!includeEliminated && player.IsValid && player.IsEliminated)
		{
			return false;
		}

		if (target.GetProp(Prop_Data, "m_iTeamNum") == boss.Team)
		{
			return false;
		}
	}

	return true;
}

bool IsTargetValidForSlenderEx(CBaseEntity target, int bossIndex, bool includeEliminated = false)
{
	if (!target.IsValid())
	{
		return false;
	}

	if (target.index <= 0)
	{
		return false;
	}

	SF2_BasePlayer player = SF2_BasePlayer(target.index);
	if (player.IsValid && (!player.IsAlive ||
		player.IsInDeathCam ||
		player.IsInGhostMode ||
		player.HasEscaped ||
		player.InCondition(view_as<TFCond>(130)) ||
		player.Team == TFTeam_Spectator))
	{
		return false;
	}

	if (g_Enabled)
	{
		if (!includeEliminated && player.IsValid && player.IsEliminated)
		{
			return false;
		}

		if (!g_SlenderTeleportIgnoreChases[bossIndex])
		{
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				SF2NPC_Chaser npc = SF2NPC_Chaser(i);
				if (!npc.IsValid())
				{
					continue;
				}

				SF2_ChaserEntity chaser = SF2_ChaserEntity(npc.EntIndex);
				if (!chaser.IsValid())
				{
					continue;
				}

				SF2BossProfileData data;
				data = view_as<SF2NPC_BaseNPC>(npc).GetProfileData();

				int state = chaser.State;
				if (!data.IsPvEBoss && (state == STATE_CHASE || state == STATE_ATTACK || state == STATE_STUN))
				{
					return false;
				}
			}
		}
	}

	return true;
}

bool IsPvETargetValid(CBaseEntity target)
{
	if (!target.IsValid())
	{
		return false;
	}

	SF2_BasePlayer player = SF2_BasePlayer(target.index);

	if (player.IsValid && (!player.IsAlive || !player.IsInPvE || player.IsInGhostMode))
	{
		return false;
	}

	if (g_Buildings.FindValue(EntIndexToEntRef(target.index)) != -1)
	{
		int owner = target.GetPropEnt(Prop_Send, "m_hBuilder");
		if (IsValidClient(owner) && !IsClientInPvE(owner))
		{
			return false;
		}
	}

	return true;
}

void NPC_DropKey(int bossIndex, const char[] model, const char[] trigger)
{
	char buffer[PLATFORM_MAX_PATH];
	float myPos[3], vel[3];
	int boss = NPCGetEntIndex(bossIndex);
	GetEntPropVector(boss, Prop_Data, "m_vecAbsOrigin", myPos);
	FormatEx(buffer, sizeof(buffer), "sf2_key_%s", trigger);

	int touchBox = CreateEntityByName("tf_halloween_pickup");
	DispatchKeyValue(touchBox, "targetname", buffer);
	DispatchKeyValue(touchBox, "powerup_model", model);
	DispatchKeyValue(touchBox, "modelscale", "2.0");
	DispatchKeyValue(touchBox, "pickup_sound", "ui/itemcrate_smash_ultrarare_short.wav");
	DispatchKeyValue(touchBox, "pickup_particle", "utaunt_firework_teamcolor_red");
	DispatchKeyValue(touchBox, "TeamNum", "0");
	TeleportEntity(touchBox, myPos, NULL_VECTOR, NULL_VECTOR);
	SetEntityModel(touchBox, model);
	SetEntProp(touchBox, Prop_Data, "m_iEFlags", 12845056);
	DispatchSpawn(touchBox);
	ActivateEntity(touchBox);
	SetEntityModel(touchBox, model);

	int key = CreateEntityByName("tf_halloween_pickup");
	DispatchKeyValue(key, "targetname", buffer);
	DispatchKeyValue(key, "powerup_model", PAGE_MODEL);
	DispatchKeyValue(key, "modelscale", "2.0");
	DispatchKeyValue(key, "pickup_sound", "ui/itemcrate_smash_ultrarare_short.wav");
	DispatchKeyValue(key, "pickup_particle", "utaunt_firework_teamcolor_red");
	DispatchKeyValue(key, "TeamNum", "0");
	TeleportEntity(key, myPos, NULL_VECTOR, NULL_VECTOR);
	SetEntityModel(key, PAGE_MODEL);
	SetEntProp(key, Prop_Data, "m_iEFlags", 12845056);
	DispatchSpawn(key);
	ActivateEntity(key);

	SetEntityRenderMode(key, RENDER_TRANSCOLOR);
	SetEntityRenderColor(key, 0, 0, 0, 1);

	int glow = CreateEntityByName("tf_taunt_prop");
	DispatchKeyValue(glow, "targetname", buffer);
	DispatchKeyValue(glow, "powerup_model", model);
	TeleportEntity(glow, myPos, NULL_VECTOR, NULL_VECTOR);
	DispatchSpawn(glow);
	ActivateEntity(glow);
	SetEntityModel(glow, model);

	SetEntProp(glow, Prop_Send, "m_bGlowEnabled", 1);
	SetEntPropFloat(glow, Prop_Send, "m_flModelScale", 2.0);
	SetEntityRenderMode(glow, RENDER_TRANSCOLOR);
	SetEntityRenderColor(glow, 0, 0, 0, 1);

	SetVariantString("!activator");
	AcceptEntityInput(touchBox, "SetParent", key);

	SetVariantString("!activator");
	AcceptEntityInput(glow, "SetParent", key);

	SetEntityModel(key, PAGE_MODEL);
	SetEntityMoveType(key, MOVETYPE_FLYGRAVITY);

	HookSingleEntityOutput(touchBox, "OnRedPickup", KeyTrigger);

	vel[0] = GetRandomFloat(-300.0, 300.0);
	vel[1] = GetRandomFloat(-300.0, 300.0);
	vel[2] = GetRandomFloat(700.0, 900.0);

	SetEntProp(key, Prop_Data, "m_iEFlags", 12845056);

	TeleportEntity(key, myPos, NULL_VECTOR, vel);
	SetEntPropFloat(key, Prop_Send, "m_flModelScale", 2.0);
	SetEntProp(key, Prop_Data, "m_iEFlags", 12845056);
	SetEntProp(key, Prop_Data, "m_MoveCollide", 1);

	SDKHook(key, SDKHook_SetTransmit, Hook_KeySetTransmit);
	SDKHook(glow, SDKHook_SetTransmit, Hook_KeySetTransmit);
	SDKHook(touchBox, SDKHook_SetTransmit, Hook_KeySetTransmit);

	//The key can be stuck somewhere to prevent that, make an auto collect.
	float timeLeft = float(g_RoundTime);
	if (timeLeft > 60.0)
	{
		timeLeft = 30.0;
	}
	else
	{
		timeLeft = timeLeft - 20.0;
	}
	CreateTimer(timeLeft, CollectKey, EntIndexToEntRef(touchBox), TIMER_FLAG_NO_MAPCHANGE);
}

static void KeyTrigger(const char[] output, int caller, int activator, float delay)
{
	TriggerKey(caller);
}

static Action Hook_KeySetTransmit(int entity, int other)
{
	if (!IsValidClient(other))
	{
		return Plugin_Continue;
	}

	if (g_PlayerEliminated[other] && IsClientInGhostMode(other))
	{
		return Plugin_Continue;
	}

	if (!g_PlayerEliminated[other])
	{
		return Plugin_Continue;
	}

	return Plugin_Handled;
}

static Action CollectKey(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (ent == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	char class[64];
	GetEntityNetClass(ent, class, sizeof(class));
	if (strcmp(class, "CHalloweenPickup") != 0)
	{
		return Plugin_Stop;
	}

	TriggerKey(ent);
	return Plugin_Stop;
}

static void TriggerKey(int caller)
{
	char targetName[PLATFORM_MAX_PATH];
	GetEntPropString(caller, Prop_Data, "m_iName", targetName, sizeof(targetName));

	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "tf_halloween_pickup")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "KillHierarchy");
		}
	}

	ReplaceString(targetName, sizeof(targetName), "sf2_key_", "", false);
	float myPos[3];
	GetEntPropVector(caller, Prop_Data, "m_vecAbsOrigin", myPos);
	TE_Particle(g_Particles[FireworksRED], myPos, myPos);
	TE_SendToAll();
	TE_Particle(g_Particles[FireworksBLU], myPos, myPos);
	TE_SendToAll();
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Trigger");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_door")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Open");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_multiple")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Enable");
		}
	}
	RemoveEntity(caller);
	EmitSoundToAll("ui/itemcrate_smash_ultrarare_short.wav", caller, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
}

void NPCChaser_InitializeAPI()
{
	CreateNative("SF2_GetBossCurrentAttackIndex", Native_GetBossCurrentAttackIndex);
	CreateNative("SF2_GetBossAttackIndexType", Native_GetBossAttackIndexType);
	CreateNative("SF2_GetBossAttackIndexDamage", Native_GetBossAttackIndexDamage);
	CreateNative("SF2_UpdateBossAnimation", Native_UpdateBossAnimation);
	CreateNative("SF2_GetBossAttackIndexDamageType", Native_GetBossAttackIndexDamageType);

	CreateNative("SF2_PerformBossVoice", Native_PerformVoice);
	CreateNative("SF2_CreateBossSoundHint", Native_CreateBossSoundHint);

	CreateNative("SF2_GetChaserProfileFromBossIndex", Native_GetProfileData);
	CreateNative("SF2_GetChaserProfileFromName", Native_GetProfileDataEx);
	CreateNative("SF2_SetEntityForceChaseState", Native_SetForceChaseState);

	g_OnChaserBossStartAttackFwd = new GlobalForward("SF2_OnChaserBossStartAttack", ET_Ignore, Param_Cell, Param_String);
	g_OnChaserBossEndAttackFwd = new GlobalForward("SF2_OnChaserBossEndAttack", ET_Ignore, Param_Cell, Param_String);

	SF2_ChaserEntity.SetupAPI();
}

static any Native_GetBossCurrentAttackIndex(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return 0;
	}

	return chaser.AttackIndex;
}

static any Native_PerformVoice(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return 0;
	}

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttackFromIndex(GetNativeCell(3), attackData);

	return chaser.PerformVoice(GetNativeCell(2), attackData.Name);
}

static any Native_CreateBossSoundHint(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return 0;
	}

	float position[3];
	GetNativeArray(3, position, 3);

	chaser.UpdateAlertTriggerCountEx(position);

	return 0;
}

static any Native_GetBossAttackIndexType(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return 0;
	}

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttackFromIndex(GetNativeCell(2), attackData);

	return attackData.Type;
}

static any Native_GetBossAttackIndexDamage(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return 0;
	}

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttackFromIndex(GetNativeCell(2), attackData);

	return attackData.Damage[GetNativeCell(3)];
}

static any Native_UpdateBossAnimation(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return 0;
	}

	char value[64];
	bool spawn = GetNativeCell(4);
	switch (GetNativeCell(3))
	{
		case STATE_IDLE, STATE_ALERT, STATE_CHASE:
		{
			if (!chaser.IsInChaseInitial && !spawn)
			{
				chaser.UpdateMovementAnimation();
				return 0;
			}
			else
			{
				strcopy(value, sizeof(value), g_SlenderAnimationsList[SF2BossAnimation_ChaseInitial]);
			}
		}

		case STATE_ATTACK:
		{
			strcopy(value, sizeof(value), g_SlenderAnimationsList[SF2BossAnimation_Attack]);
		}

		case STATE_STUN:
		{
			strcopy(value, sizeof(value), g_SlenderAnimationsList[SF2BossAnimation_Stun]);
		}

		case STATE_DEATHCAM:
		{
			strcopy(value, sizeof(value), g_SlenderAnimationsList[SF2BossAnimation_DeathCam]);
		}

		case STATE_DEATH:
		{
			strcopy(value, sizeof(value), g_SlenderAnimationsList[SF2BossAnimation_Death]);
		}
	}

	if (spawn)
	{
		strcopy(value, sizeof(value), g_SlenderAnimationsList[SF2BossAnimation_Spawn]);
	}

	chaser.ResetProfileAnimation(value, _, chaser.GetAttackName());

	return 0;
}

static any Native_GetBossAttackIndexDamageType(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return 0;
	}

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttackFromIndex(GetNativeCell(2), attackData);

	return attackData.DamageType[1];
}

static any Native_GetProfileData(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SetNativeArray(2, data, sizeof(data));
	return 0;
}

static any Native_GetProfileDataEx(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, sizeof(profile));
	SF2ChaserBossProfileData data;
	if (!g_ChaserBossProfileData.GetArray(profile, data, sizeof(data)))
	{
		return false;
	}

	SetNativeArray(2, data, sizeof(data));
	return true;
}

static any Native_SetForceChaseState(Handle plugin, int numParams)
{
	SF2NPC_Chaser controller = SF2NPC_Chaser(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	CBaseEntity target = CBaseEntity(GetNativeCell(2));
	if (!target.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", controller.Index);
	}

	SetClientForceChaseState(controller, target, GetNativeCell(3));
	return 0;
}