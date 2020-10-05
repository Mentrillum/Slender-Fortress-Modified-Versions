#if defined _sf2_playergroups_included
 #endinput
#endif
#define _sf2_playergroups_included

#define SF2_MAX_PLAYER_GROUPS MAXPLAYERS
#define SF2_MAX_PLAYER_GROUP_NAME_LENGTH 32

static int g_iPlayerGroupGlobalID = -1;
static int g_iPlayerCurrentGroup[MAXPLAYERS + 1] = { -1, ... };
static bool g_bPlayerGroupActive[SF2_MAX_PLAYER_GROUPS] = { false, ... };
static int g_iPlayerGroupLeader[SF2_MAX_PLAYER_GROUPS] = { -1, ... };
static int g_iPlayerGroupID[SF2_MAX_PLAYER_GROUPS] = { -1, ... };
static int g_iPlayerGroupQueuePoints[SF2_MAX_PLAYER_GROUPS];
static int g_bPlayerGroupPlaying[SF2_MAX_PLAYER_GROUPS] = { false, ... };
static Handle g_hPlayerGroupNames;
static bool g_bPlayerGroupInvitedPlayer[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];
static int g_iPlayerGroupInvitedPlayerCount[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];
static float g_flPlayerGroupInvitedPlayerTime[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];

void SetupPlayerGroups()
{
	g_iPlayerGroupGlobalID = -1;
	g_hPlayerGroupNames = CreateTrie();
}

stock int GetPlayerGroupFromID(int iGroupID)
{
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i)) continue;
		if (GetPlayerGroupID(i) == iGroupID) return i;
	}
	
	return -1;
}

void SendPlayerGroupInvitation(int client,int iGroupID,int iInviter=-1)
{
	if (!IsValidClient(client) || !IsClientParticipating(client))
	{
		if (IsValidClient(iInviter))
		{
			// TODO: Send message to the inviter that the client is invalid!
		}
		
		return;
	}
	
	if (!g_bPlayerEliminated[client])
	{
		if (IsValidClient(iInviter))
		{
			// TODO: Send message to the inviter that the client is currently in-game.
		}
		
		return;
	}
	
	int iGroupIndex = GetPlayerGroupFromID(iGroupID);
	if (iGroupIndex == -1) return;
	
	int iMyGroupIndex = ClientGetPlayerGroup(client);
	if (IsPlayerGroupActive(iMyGroupIndex))
	{
		if (IsValidClient(iInviter))
		{
			if (iMyGroupIndex == iGroupIndex)
			{
				CPrintToChat(iInviter, "%T", "SF2 Player In Group", iInviter);
			}
			else
			{
				CPrintToChat(iInviter, "%T", "SF2 Player In Another Group", iInviter);
			}
		}
		
		return;
	}
	
	if (GetPlayerGroupMemberCount(iGroupIndex) >= GetMaxPlayersForRound())
	{
		if (IsValidClient(iInviter))
		{
			CPrintToChat(iInviter, "%T", "SF2 Group Is Full", iInviter);
		}
		
		return;
	}
	
	if (IsFakeClient(client))
	{
		ClientSetPlayerGroup(client, iGroupIndex);
		return;
	}
	
	// Anti-spam.
	char sName[MAX_NAME_LENGTH];
	GetClientName(client, sName, sizeof(sName));
	
	if (IsValidClient(iInviter))
	{
		float flNextInviteTime = GetPlayerGroupInvitedPlayerTime(iGroupIndex, client) + (20.0 * GetPlayerGroupInvitedPlayerCount(iGroupIndex, client));
		if (GetGameTime() < flNextInviteTime)
		{
			CPrintToChat(iInviter, "%T", "SF2 No Group Invite Spam", iInviter, RoundFloat(flNextInviteTime - GetGameTime()), sName);
			return;
		}
	}
	
	char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	char sLeaderName[64];
	GetPlayerGroupName(iGroupIndex, sGroupName, sizeof(sGroupName));
	
	int iGroupLeader = GetPlayerGroupLeader(iGroupIndex);
	if (IsValidClient(iGroupLeader)) GetClientName(iGroupLeader, sLeaderName, sizeof(sLeaderName));
	else strcopy(sLeaderName, sizeof(sLeaderName), "nobody");
	
	Handle hMenu = CreateMenu(Menu_GroupInvite);
	SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Group Invite Menu Description", client, sLeaderName, sGroupName);
	
	char sGroupID[64];
	IntToString(iGroupID, sGroupID, sizeof(sGroupID));
	
	char sBuffer[256];
	Format(sBuffer, sizeof(sBuffer), "%T", "Yes", client);
	AddMenuItem(hMenu, sGroupID, sBuffer);
	Format(sBuffer, sizeof(sBuffer), "%T", "No", client);
	AddMenuItem(hMenu, "0", sBuffer);
	DisplayMenu(hMenu, client, 10);
	
	SetPlayerGroupInvitedPlayer(iGroupIndex, client, true);
	SetPlayerGroupInvitedPlayerCount(iGroupIndex, client, GetPlayerGroupInvitedPlayerCount(iGroupIndex, client) + 1);
	SetPlayerGroupInvitedPlayerTime(iGroupIndex, client, GetGameTime());
	
	if (IsValidClient(iInviter))
	{
		CPrintToChat(iInviter, "%T", "SF2 Group Invitation Sent", iInviter, sName);
	}
}

public int Menu_GroupInvite(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) 
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (param2 == 0)
		{
			char sGroupID[64];
			GetMenuItem(menu, param2, sGroupID, sizeof(sGroupID));
			int iGroupIndex = GetPlayerGroupFromID(StringToInt(sGroupID));
			if (IsPlayerGroupActive(iGroupIndex))
			{
				int iMyGroupIndex = ClientGetPlayerGroup(param1);
				if (IsPlayerGroupActive(iMyGroupIndex))
				{
					if (iMyGroupIndex == iGroupIndex)
					{
						CPrintToChat(param1, "%T", "SF2 In Group", param1);
					}
					else
					{
						CPrintToChat(param1, "%T", "SF2 In Another Group", param1);
					}
				}
				else if (GetPlayerGroupMemberCount(iGroupIndex) >= GetMaxPlayersForRound())
				{
					CPrintToChat(param1, "%T", "SF2 Group Is Full", param1);
				}
				else
				{
					ClientSetPlayerGroup(param1, iGroupIndex);
				}
			}
			else
			{
				CPrintToChat(param1, "%T", "SF2 Group Does Not Exist", param1);
			}
		}
	}
}

void DisplayResetGroupQueuePointsMenuToClient(int client)
{
	int iGroupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(iGroupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayGroupMainMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}
	
	if (GetPlayerGroupLeader(iGroupIndex) != client)
	{
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Not Group Leader", client);
		return;
	}
	
	Handle hMenu = CreateMenu(Menu_ResetGroupQueuePoints);
	SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Reset Group Queue Points Menu Title", client, "SF2 Reset Group Queue Points Menu Description", client);
	
	char sBuffer[256];
	Format(sBuffer, sizeof(sBuffer), "%T", "Yes", client);
	AddMenuItem(hMenu, "0", sBuffer);
	Format(sBuffer, sizeof(sBuffer), "%T", "No", client);
	AddMenuItem(hMenu, "0", sBuffer);
	
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
}

public int Menu_ResetGroupQueuePoints(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) delete menu;
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack) DisplayAdminGroupMenuToClient(param1);
	}
	else if (action == MenuAction_Select)
	{
		if (param2 == 0)
		{
			int iGroupIndex = ClientGetPlayerGroup(param1);
			if (IsPlayerGroupActive(iGroupIndex) && GetPlayerGroupLeader(iGroupIndex) == param1)
			{
				SetPlayerGroupQueuePoints(iGroupIndex, 0);
				
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsValidClient(i)) continue;
					if (ClientGetPlayerGroup(i) == iGroupIndex)
					{
						CPrintToChat(i, "%T", "SF2 Group Queue Points Reset", i);
					}
				}
			}
			else
			{
				CPrintToChat(param1, "%T", "SF2 Not Group Leader", param1);
			}
		}
		
		DisplayAdminGroupMenuToClient(param1);
	}
}

void CheckPlayerGroup(int iGroupIndex)
{
	if (!IsPlayerGroupActive(iGroupIndex)) return;
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 0) DebugMessage("START CheckPlayerGroup(%d)", iGroupIndex);
#endif
	
	int iMemberCount = GetPlayerGroupMemberCount(iGroupIndex);
	if (iMemberCount <= 0)
	{
		RemovePlayerGroup(iGroupIndex);
	}
	else
	{
		// Remove any person that isn't participating.
		for (int i = 1; i <= MaxClients; i++)
		{
			if (ClientGetPlayerGroup(i) == iGroupIndex)
			{
				if (!IsValidClient(i) || !IsClientParticipating(i))
				{
#if defined DEBUG
					if (GetConVarInt(g_cvDebugDetail) > 0) DebugMessage("CheckPlayerGroup(%d): Invalid client detected (%d), removing from group", iGroupIndex, i);
#endif
					
					ClientSetPlayerGroup(i, -1);
				}
			}
		}
		
		iMemberCount = GetPlayerGroupMemberCount(iGroupIndex);
		int iMaxPlayers = GetMaxPlayersForRound();
		int iExcessMemberCount = (iMemberCount - iMaxPlayers);
		
		if (iExcessMemberCount > 0)
		{
#if defined DEBUG
			if (GetConVarInt(g_cvDebugDetail) > 0) DebugMessage("CheckPlayerGroup(%d): Excess members detected", iGroupIndex);
#endif

			int iGroupLeader = GetPlayerGroupLeader(iGroupIndex);
			if (IsValidClient(iGroupLeader))
			{
				CPrintToChat(iGroupLeader, "%T", "SF2 Group Has Too Many Members", iGroupLeader);
			}
			
			for (int i = 1, iCount; i <= MaxClients && iCount < iExcessMemberCount; i++)
			{
				if (!IsValidClient(i)) continue;
				
				if (ClientGetPlayerGroup(i) == iGroupIndex)
				{
					if (i == iGroupLeader) continue; // Don't kick off the group leader.
					
					ClientSetPlayerGroup(i, -1);
					iCount++;
				}
			}
		}
	}
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 0) DebugMessage("END CheckPlayerGroup(%d)", iGroupIndex);
#endif
}

stock int GetPlayerGroupCount()
{
	int iCount;
	
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (IsPlayerGroupActive(i)) iCount++;
	}
	
	return iCount;
}

stock int CreatePlayerGroup()
{
	// Get an inactive group.
	int iIndex = -1;
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i))
		{
			iIndex = i;
			break;
		}
	}
	
	if (iIndex != -1)
	{
		g_bPlayerGroupActive[iIndex] = true;
		g_iPlayerGroupGlobalID++;
		SetPlayerGroupID(iIndex, g_iPlayerGroupGlobalID);
		ClearPlayerGroupMembers(iIndex);
		SetPlayerGroupQueuePoints(iIndex, 0);
		SetPlayerGroupLeader(iIndex, -1);
		SetPlayerGroupName(iIndex, "");
		SetPlayerGroupPlaying(iIndex, false);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			SetPlayerGroupInvitedPlayer(iIndex, i, false);
			SetPlayerGroupInvitedPlayerCount(iIndex, i, 0);
			SetPlayerGroupInvitedPlayerTime(iIndex, i, 0.0);
		}
	}
	
	return iIndex;
}

stock void RemovePlayerGroup(int iGroupIndex)
{
	if (!IsPlayerGroupActive(iGroupIndex)) return;
	
	ClearPlayerGroupMembers(iGroupIndex);
	SetPlayerGroupQueuePoints(iGroupIndex, 0);
	SetPlayerGroupPlaying(iGroupIndex, false);
	SetPlayerGroupLeader(iGroupIndex, -1);
	g_bPlayerGroupActive[iGroupIndex] = false;
	SetPlayerGroupID(iGroupIndex, -1);
}

stock void ClearPlayerGroupMembers(int iGroupIndex)
{
	if (!IsPlayerGroupValid(iGroupIndex)) return;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (ClientGetPlayerGroup(i) == iGroupIndex)
		{
			ClientSetPlayerGroup(i, -1);
		}
	}
}

stock bool GetPlayerGroupName(int iGroupIndex, char[] sBuffer,int iBufferLen)
{
	char sGroupIndex[32];
	IntToString(iGroupIndex, sGroupIndex, sizeof(sGroupIndex)); 
	return GetTrieString(g_hPlayerGroupNames, sGroupIndex, sBuffer, iBufferLen);
}

stock void SetPlayerGroupName(int iGroupIndex, const char[] sGroupName)
{
	char sGroupIndex[32];
	IntToString(iGroupIndex, sGroupIndex, sizeof(sGroupIndex)); 
	SetTrieString(g_hPlayerGroupNames, sGroupIndex, sGroupName);
}

stock int GetPlayerGroupID(int iGroupIndex)
{
	return g_iPlayerGroupID[iGroupIndex];
}

stock void SetPlayerGroupID(int iGroupIndex,int iID)
{
	g_iPlayerGroupID[iGroupIndex] = iID;
}

stock bool IsPlayerGroupActive(int iGroupIndex)
{
	return IsPlayerGroupValid(iGroupIndex) && g_bPlayerGroupActive[iGroupIndex];
}

stock bool IsPlayerGroupValid(int iGroupIndex)
{
	return (iGroupIndex >= 0 && iGroupIndex < SF2_MAX_PLAYER_GROUPS);
}

stock int GetPlayerGroupMemberCount(int iGroupIndex)
{
	int iCount;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
	
		if (ClientGetPlayerGroup(i) == iGroupIndex)
		{
			iCount++;
		}
	}
	
	return iCount;
}

stock bool IsPlayerGroupPlaying(int iGroupIndex)
{
	return (IsPlayerGroupActive(iGroupIndex) && g_bPlayerGroupPlaying[iGroupIndex]);
}

stock void SetPlayerGroupPlaying(int iGroupIndex, bool bToggle)
{
	g_bPlayerGroupPlaying[iGroupIndex] = bToggle;
}

stock int GetPlayerGroupLeader(int iGroupIndex)
{
	return g_iPlayerGroupLeader[iGroupIndex];
}

stock void SetPlayerGroupLeader(int iGroupIndex,int iGroupLeader)
{
	g_iPlayerGroupLeader[iGroupIndex] = iGroupLeader;
	
	if (IsValidClient(iGroupLeader))
	{
		char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(iGroupIndex, sGroupName, sizeof(sGroupName));
		CPrintToChat(iGroupLeader, "%T", "SF2 New Group Leader", iGroupLeader, sGroupName);
		
		char sName[MAX_NAME_LENGTH];
		GetClientName(iGroupLeader, sName, sizeof(sName));
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (iGroupLeader == i || !IsValidClient(i)) continue;
			if (ClientGetPlayerGroup(i) == iGroupIndex)
			{
				CPrintToChat(i, "%T", "SF2 Player New Group Leader", i, sName);
			}
		}
	}
}

int PlayerGroupFindNewLeader(int iGroupIndex)
{
	if (!IsPlayerGroupActive(iGroupIndex)) return -1;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		
		if (ClientGetPlayerGroup(i) == iGroupIndex)
		{
			SetPlayerGroupLeader(iGroupIndex, i);
			return i;
		}
	}
	
	return -1;
}

stock int GetPlayerGroupQueuePoints(int iGroupIndex)
{
	return g_iPlayerGroupQueuePoints[iGroupIndex];
}

stock void SetPlayerGroupQueuePoints(int iGroupIndex,int iAmount)
{
	g_iPlayerGroupQueuePoints[iGroupIndex] = iAmount;
}

stock bool HasPlayerGroupInvitedPlayer(int iGroupIndex,int client)
{
	return g_bPlayerGroupInvitedPlayer[iGroupIndex][client];
}

stock void SetPlayerGroupInvitedPlayer(int iGroupIndex,int client, bool bToggle)
{
	g_bPlayerGroupInvitedPlayer[iGroupIndex][client] = bToggle;
}

stock int GetPlayerGroupInvitedPlayerCount(int iGroupIndex,int client)
{
	return g_iPlayerGroupInvitedPlayerCount[iGroupIndex][client];
}

stock int SetPlayerGroupInvitedPlayerCount(int iGroupIndex,int client,int iAmount)
{
	g_iPlayerGroupInvitedPlayerCount[iGroupIndex][client] = iAmount;
}

stock float GetPlayerGroupInvitedPlayerTime(int iGroupIndex,int client)
{
	return g_flPlayerGroupInvitedPlayerTime[iGroupIndex][client];
}

stock void SetPlayerGroupInvitedPlayerTime(int iGroupIndex,int client, float flTime)
{
	g_flPlayerGroupInvitedPlayerTime[iGroupIndex][client] = flTime;
}

stock int ClientGetPlayerGroup(int client)
{
	return g_iPlayerCurrentGroup[client];
}

stock void ClientSetPlayerGroup(int client,int iGroupIndex)
{
	int iOldPlayerGroup = ClientGetPlayerGroup(client);
	if (iOldPlayerGroup == iGroupIndex) return; // No change.
	
	g_iPlayerCurrentGroup[client] = iGroupIndex;
	
	char sName[MAX_NAME_LENGTH];
	GetClientName(client, sName, sizeof(sName));
	
	if (IsPlayerGroupActive(iOldPlayerGroup))
	{
		SetPlayerGroupInvitedPlayer(iOldPlayerGroup, client, false);
		SetPlayerGroupInvitedPlayerCount(iOldPlayerGroup, client, 0);
		SetPlayerGroupInvitedPlayerTime(iOldPlayerGroup, client, 0.0);
		
		char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(iOldPlayerGroup, sGroupName, sizeof(sGroupName));
		CPrintToChat(client, "%T", "SF2 Left Group", client, sGroupName);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (i == client || !IsValidClient(i)) continue;
			if (ClientGetPlayerGroup(i) == iOldPlayerGroup)
			{
				CPrintToChat(i, "%T", "SF2 Player Left Group", i, sName);
			}
		}
	
		int iOldGroupLeader = GetPlayerGroupLeader(iOldPlayerGroup);
		if (iOldGroupLeader == client)
		{
			int iOldGroupNewLeader = PlayerGroupFindNewLeader(iOldPlayerGroup);
			if (iOldGroupNewLeader == -1)
			{
				// Couldn't find a new leader. This group has no leader!
				SetPlayerGroupLeader(iOldPlayerGroup, -1);
			}
		}
		
		CheckPlayerGroup(iOldPlayerGroup);
	}
	
	if (IsPlayerGroupPlaying(iGroupIndex))
	{
		ClientSetQueuePoints(client, 0);
	}
	
	if (IsPlayerGroupActive(iGroupIndex))
	{
		SetPlayerGroupInvitedPlayer(iGroupIndex, client, false);
		SetPlayerGroupInvitedPlayerCount(iGroupIndex, client, 0);
		SetPlayerGroupInvitedPlayerTime(iGroupIndex, client, 0.0);
		
		// Set the player's personal queue points to 0.
		//ClientSetQueuePoints(client, 0);
		
		char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(iGroupIndex, sGroupName, sizeof(sGroupName));
		CPrintToChat(client, "%T", "SF2 Joined Group", client, sGroupName);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (i == client || !IsValidClient(i)) continue;
			if (ClientGetPlayerGroup(i) == iGroupIndex)
			{
				CPrintToChat(i, "%T", "SF2 Player Joined Group", i, sName);
			}
		}
	}
}