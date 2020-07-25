#if defined _sf2_pve_included
 #endinput
#endif
#define _sf2_pve_included

static bool g_bPlayerInPvE[MAXPLAYERS + 1];
static Handle g_hPlayerPvERespawnTimer[MAXPLAYERS + 1];
static bool g_bPlayerInPvETrigger[MAXPLAYERS + 1];

public Action Timer_TeleportPlayerToPvE(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return;
	
	if (g_bPlayerProxy[iClient]) return;
	
	if (timer != g_hPlayerPvERespawnTimer[iClient]) return;
	g_hPlayerPvERespawnTimer[iClient] = INVALID_HANDLE;
	
	Handle hSpawnPointList = CreateArray();
	
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		char sName[32];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (!StrContains(sName, "spawn_boss_alt", false) || !StrContains(sName, "sf2_pve_spawnpoint", false))
		{
			PushArrayCell(hSpawnPointList, ent);
		}
	}
	
	float flMins[3], flMaxs[3];
	GetEntPropVector(iClient, Prop_Send, "m_vecMins", flMins);
	GetEntPropVector(iClient, Prop_Send, "m_vecMaxs", flMaxs);
	
	Handle hClearSpawnPointList = CloneArray(hSpawnPointList);
	for (int i = 0; i < GetArraySize(hSpawnPointList); i++)
	{
		int iEnt = GetArrayCell(hSpawnPointList, i);
		
		float flMyPos[3];
		GetEntPropVector(iEnt, Prop_Data, "m_vecAbsOrigin", flMyPos);
		
		if (IsSpaceOccupiedPlayer(flMyPos, flMins, flMaxs, iClient))
		{
			int iIndex = FindValueInArray(hClearSpawnPointList, iEnt);
			if (iIndex != -1)
			{
				RemoveFromArray(hClearSpawnPointList, iIndex);
			}
		}
	}
	
	int iNum;
	if ((iNum = GetArraySize(hClearSpawnPointList)) > 0)
	{
		ent = GetArrayCell(hClearSpawnPointList, GetRandomInt(0, iNum - 1));
	}
	else if ((iNum = GetArraySize(hSpawnPointList)) > 0)
	{
		ent = GetArrayCell(hSpawnPointList, GetRandomInt(0, iNum - 1));
	}
	
	if (iNum > 0)
	{
		float flPos[3], flAng[3];
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flPos);
		GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", flAng);
		TeleportEntity(iClient, flPos, flAng, view_as<float>({ 0.0, 0.0, 0.0 }));
		
		EmitAmbientSound(SF2_PVP_SPAWN_SOUND, flPos, _, SNDLEVEL_NORMAL, _, 1.0);
		TF2_AddCondition(iClient, TFCond_UberchargedCanteen, 1.5);
	}
	
	CloseHandle(hSpawnPointList);
	CloseHandle(hClearSpawnPointList);
}
