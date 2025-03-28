#if defined _sf2_traps_included
 #endinput
#endif
#define _sf2_traps_included

#pragma semicolon 1
#pragma newdecls required

#include "traps/base.sp"
#include "traps/beartrap.sp"
#include "traps/sentry.sp"

methodmap BossProfileTrapData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", difficulty, true);
	}

	public float GetSpawnCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("spawn_cooldown", difficulty, 8.0);
	}

	public bool CanPlaceOnState(int difficulty, int state)
	{
		char states[128];
		this.GetDifficultyString("place_on_states", difficulty, states, sizeof(states), "idle alert");
		if (state == STATE_IDLE && StrContains(states, "idle") != -1)
		{
			return true;
		}

		if (state == STATE_ALERT && StrContains(states, "alert") != -1)
		{
			return true;
		}

		if (state == STATE_CHASE && StrContains(states, "chase") != -1)
		{
			return true;
		}
		return false;
	}

	public ProfileObject GetTrapTypes()
	{
		return this.GetSection("types");
	}

	public BossProfileBaseTrap GetTrapFromName(const char[] name)
	{
		ProfileObject obj = this.GetTrapTypes();
		if (obj == null)
		{
			return null;
		}
		return view_as<BossProfileBaseTrap>(obj.GetSection(name));
	}

	public void Precache()
	{
		for (int i = 0; i < this.GetTrapTypes().SectionLength; i++)
		{
			char name[64];
			this.GetTrapTypes().GetSectionNameFromIndex(i, name, sizeof(name));
			BossProfileBaseTrap trap = this.GetTrapFromName(name);
			if (trap == null)
			{
				continue;
			}
			trap.Precache();
		}
	}
}

void SetupTraps()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerJumpPFwd.AddFunction(null, OnJump);
	SF2_BaseTrap.Initialize();
	SF2_BearTrap.Initialize();
	SF2_SentryTrap.Initialize();
}

static void OnPutInServer(SF2_BasePlayer client)
{
	SDKHook(client.index, SDKHook_PreThink, ClientPreThink);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (client.IsTrapped)
	{
		TF2Attrib_RemoveByName(client.index, "increased jump height");
		TF2Attrib_RemoveByName(client.index, "move speed bonus");
		client.UpdateSpeed();
	}
	client.IsTrapped = false;
	client.TrapCount = 0;
}

static void OnJump(SF2_BasePlayer client)
{
	if (!client.IsTrapped)
	{
		return;
	}

	client.TrapCount -= 1;
	if (client.TrapCount <= 0)
	{
		client.IsTrapped = false;
		client.TrapCount = 0;
		TF2Attrib_RemoveByName(client.index, "increased jump height");
		TF2Attrib_RemoveByName(client.index, "move speed bonus");
		client.UpdateSpeed();
	}
}

static void ClientPreThink(int entity)
{
	SF2_BasePlayer client = SF2_BasePlayer(entity);
	if ((client.IsTrapped || client.IsLatched) && !client.IsInGhostMode)
	{
		if (client.InCondition(TFCond_Taunting))
		{
			client.ChangeCondition(TFCond_Taunting, true);
		}
	}
}

void Trap_SpawnTrap(float position[3], float direction[3], SF2NPC_Chaser controller)
{
	if (g_TrapEntityCount > MAX_TRAPS)
	{
		return;
	}

	int slender = controller.EntIndex;
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}
	SF2_ChaserEntity chaser = SF2_ChaserEntity(slender);
	float newPos[3], zPos[3], newAngles[3], tempAngles[3], product1[3], product2[3], cross[3];
	CopyVector(position, zPos);
	zPos[2] -= 99999.9;
	Handle trace = TR_TraceRayFilterEx(position, zPos, MASK_PLAYERSOLID | CONTENTS_MONSTERCLIP, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, slender);
	TR_GetEndPosition(newPos, trace);
	TR_GetPlaneNormal(trace, direction);
	delete trace;

	CopyVector(direction, tempAngles);
	NegateVector(tempAngles);
	GetVectorAngles(tempAngles, newAngles);
	newAngles[0] -= 90.0;

	GetAngleVectors(direction, product1, NULL_VECTOR, NULL_VECTOR);
	GetAngleVectors(newAngles, product2, NULL_VECTOR, NULL_VECTOR);
	GetVectorCrossProduct(product1, tempAngles, cross);
	float yaw = GetAngleBetweenVectors(product2, cross, tempAngles);
	RotateYaw(newAngles, yaw - 90.0);

	ChaserBossProfile data = controller.GetProfileData();
	int difficulty = controller.Difficulty;
	BossProfileTrapData trapData = data.GetTrapData();
	char name[64];
	trapData.GetTrapTypes().GetSectionNameFromIndex(GetRandomInt(0, trapData.GetTrapTypes().SectionLength - 1), name, sizeof(name));
	BossProfileBaseTrap baseTrap = trapData.GetTrapFromName(name);
	char buffer[PLATFORM_MAX_PATH];

	switch (baseTrap.GetTrapType())
	{
		case SF2BossTrap_BearTrap:
		{
			SF2_BearTrap trap = SF2_BearTrap(CreateEntityByName("sf2_trap_bear_trap"));
			trap.Teleport(newPos, newAngles);
			baseTrap.GetModel(difficulty, buffer, sizeof(buffer));
			trap.SetModel(buffer);
			trap.Controller = controller;
			trap.SetName(name);
			trap.TimeUntilRemove = baseTrap.GetTimeUntilRemoved(difficulty) + GetGameTime();
			trap.Spawn();
			trap.Activate();

			baseTrap.GetSpawnSounds().EmitSound(.entity = trap.index);
		}

		case SF2BossTrap_Sentry:
		{
			SF2_SentryTrap trap = SF2_SentryTrap(CreateEntityByName("sf2_trap_sentry"));
			BossProfileSentryTrap sentry = view_as<BossProfileSentryTrap>(baseTrap);
			chaser.GetAbsAngles(newAngles);
			trap.Teleport(newPos, newAngles);
			trap.Controller = controller;
			trap.SetName(name);
			trap.TimeUntilRemove = baseTrap.GetTimeUntilRemoved(difficulty) + GetGameTime();
			int desiredTeam = chaser.Team;
			if (desiredTeam <= TFTeam_Spectator)
			{
				desiredTeam = GetRandomInt(TFTeam_Red, TFTeam_Blue);
			}
			if (desiredTeam >= 4)
			{
				desiredTeam = TFTeam_Blue;
			}
			SetVariantInt(desiredTeam);
			trap.AcceptInput("SetTeam");

			int level = sentry.GetLevel(difficulty);
			if (level == 0)
			{
				trap.SetProp(Prop_Send, "m_bMiniBuilding", 1);
				trap.SetProp(Prop_Send, "m_iUpgradeLevel", 1);
				trap.SetProp(Prop_Send, "m_iHighestUpgradeLevel", 1);
				trap.SetProp(Prop_Send, "m_nSkin", desiredTeam);
			}
			else
			{
				trap.SetProp(Prop_Send, "m_iUpgradeLevel", level);
				trap.SetProp(Prop_Send, "m_iHighestUpgradeLevel", level);
				trap.SetProp(Prop_Send, "m_nSkin", desiredTeam - 2);
			}
			trap.SetProp(Prop_Send, "m_bBuilding", 1);

			trap.Spawn();
			trap.Activate();
			trap.SetProp(Prop_Send, "m_nSkin", level == 0 ? desiredTeam : desiredTeam - 2);

			SetVariantInt(sentry.GetHealth(difficulty));
			trap.AcceptInput("SetHealth");
			trap.Health = sentry.GetHealth(difficulty);

			float minsMini[3] = {-15.0, -15.0, 0.0}, maxsMini[3] = {15.0, 15.0, 49.5};
			if (level == 0)
			{
				trap.SetPropFloat(Prop_Send, "m_flModelScale", 0.75);
				trap.SetPropVector(Prop_Send, "m_vecMins", minsMini);
				trap.SetPropVector(Prop_Send, "m_vecMaxs", maxsMini);
			}

			baseTrap.GetSpawnSounds().EmitSound(.entity = trap.index);
		}
	}
}
