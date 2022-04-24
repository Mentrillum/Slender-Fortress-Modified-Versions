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
static StringMap g_hPlayerGroupNames;
static bool g_bPlayerGroupInvitedPlayer[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];
static int g_iPlayerGroupInvitedPlayerCount[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];
static float g_flPlayerGroupInvitedPlayerTime[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];

void SetupPlayerGroups()
{
	g_iPlayerGroupGlobalID = -1;
	g_hPlayerGroupNames = new StringMap();
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
	
	int groupIndex = GetPlayerGroupFromID(iGroupID);
	if (groupIndex == -1) return;
	
	int iMyGroupIndex = ClientGetPlayerGroup(client);
	if (IsPlayerGroupActive(iMyGroupIndex))
	{
		if (IsValidClient(iInviter))
		{
			if (iMyGroupIndex == groupIndex)
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
	
	if (GetPlayerGroupMemberCount(groupIndex) >= GetMaxPlayersForRound())
	{
		if (IsValidClient(iInviter))
		{
			CPrintToChat(iInviter, "%T", "SF2 Group Is Full", iInviter);
		}
		
		return;
	}
	
	if (IsFakeClient(client))
	{
		ClientSetPlayerGroup(client, groupIndex);
		return;
	}
	
	// Anti-spam.
	char sName[MAX_NAME_LENGTH];
	FormatEx(sName, sizeof(sName), "%N", client);
	
	if (IsValidClient(iInviter))
	{
		float flNextInviteTime = GetPlayerGroupInvitedPlayerTime(groupIndex, client) + (20.0 * GetPlayerGroupInvitedPlayerCount(groupIndex, client));
		if (GetGameTime() < flNextInviteTime)
		{
			CPrintToChat(iInviter, "%T", "SF2 No Group Invite Spam", iInviter, RoundFloat(flNextInviteTime - GetGameTime()), sName);
			return;
		}
	}
	
	char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	char sLeaderName[64];
	GetPlayerGroupName(groupIndex, sGroupName, sizeof(sGroupName));
	
	int iGroupLeader = GetPlayerGroupLeader(groupIndex);
	if (IsValidClient(iGroupLeader)) FormatEx(sLeaderName, sizeof(sLeaderName), "%N", iGroupLeader);
	else strcopy(sLeaderName, sizeof(sLeaderName), "nobody");
	
	Handle hMenu = CreateMenu(Menu_GroupInvite);
	SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Group Invite Menu Description", client, sLeaderName, sGroupName);
	
	char sGroupID[64];
	FormatEx(sGroupID, sizeof(sGroupID), "%d", iGroupID);
	
	char sBuffer[256];
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "Yes", client);
	AddMenuItem(hMenu, sGroupID, sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "No", client);
	AddMenuItem(hMenu, "0", sBuffer);
	DisplayMenu(hMenu, client, 10);
	
	SetPlayerGroupInvitedPlayer(groupIndex, client, true);
	SetPlayerGroupInvitedPlayerCount(groupIndex, client, GetPlayerGroupInvitedPlayerCount(groupIndex, client) + 1);
	SetPlayerGroupInvitedPlayerTime(groupIndex, client, GetGameTime());
	
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
			int groupIndex = GetPlayerGroupFromID(StringToInt(sGroupID));
			if (IsPlayerGroupActive(groupIndex))
			{
				int iMyGroupIndex = ClientGetPlayerGroup(param1);
				if (IsPlayerGroupActive(iMyGroupIndex))
				{
					if (iMyGroupIndex == groupIndex)
					{
						CPrintToChat(param1, "%T", "SF2 In Group", param1);
					}
					else
					{
						CPrintToChat(param1, "%T", "SF2 In Another Group", param1);
					}
				}
				else if (GetPlayerGroupMemberCount(groupIndex) >= GetMaxPlayersForRound())
				{
					CPrintToChat(param1, "%T", "SF2 Group Is Full", param1);
				}
				else
				{
					ClientSetPlayerGroup(param1, groupIndex);
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
	int groupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(groupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayGroupMainMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}
	
	if (GetPlayerGroupLeader(groupIndex) != client)
	{
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Not Group Leader", client);
		return;
	}
	
	Handle hMenu = CreateMenu(Menu_ResetGroupQueuePoints);
	SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Reset Group Queue Points Menu Title", client, "SF2 Reset Group Queue Points Menu Description", client);
	
	char sBuffer[256];
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "Yes", client);
	AddMenuItem(hMenu, "0", sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "No", client);
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
			int groupIndex = ClientGetPlayerGroup(param1);
			if (IsPlayerGroupActive(groupIndex) && GetPlayerGroupLeader(groupIndex) == param1)
			{
				SetPlayerGroupQueuePoints(groupIndex, 0);
				
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsValidClient(i)) continue;
					if (ClientGetPlayerGroup(i) == groupIndex)
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

void CheckPlayerGroup(int groupIndex)
{
	if (!IsPlayerGroupActive(groupIndex)) return;
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("START CheckPlayerGroup(%d)", groupIndex);
#endif
	
	int iMemberCount = GetPlayerGroupMemberCount(groupIndex);
	if (iMemberCount <= 0)
	{
		RemovePlayerGroup(groupIndex);
	}
	else
	{
		// Remove any person that isn't participating.
		for (int i = 1; i <= MaxClients; i++)
		{
			if (ClientGetPlayerGroup(i) == groupIndex)
			{
				if (!IsValidClient(i) || !IsClientParticipating(i))
				{
#if defined DEBUG
					if (g_cvDebugDetail.IntValue > 0) DebugMessage("CheckPlayerGroup(%d): Invalid client detected (%d), removing from group", groupIndex, i);
#endif
					
					ClientSetPlayerGroup(i, -1);
				}
			}
		}
		
		iMemberCount = GetPlayerGroupMemberCount(groupIndex);
		int iMaxPlayers = GetMaxPlayersForRound();
		int iExcessMemberCount = (iMemberCount - iMaxPlayers);
		
		if (iExcessMemberCount > 0)
		{
#if defined DEBUG
			if (g_cvDebugDetail.IntValue > 0) DebugMessage("CheckPlayerGroup(%d): Excess members detected", groupIndex);
#endif

			int iGroupLeader = GetPlayerGroupLeader(groupIndex);
			if (IsValidClient(iGroupLeader))
			{
				CPrintToChat(iGroupLeader, "%T", "SF2 Group Has Too Many Members", iGroupLeader);
			}
			
			for (int i = 1, iCount; i <= MaxClients && iCount < iExcessMemberCount; i++)
			{
				if (!IsValidClient(i)) continue;
				
				if (ClientGetPlayerGroup(i) == groupIndex)
				{
					if (i == iGroupLeader) continue; // Don't kick off the group leader.
					
					ClientSetPlayerGroup(i, -1);
					iCount++;
				}
			}
		}
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("END CheckPlayerGroup(%d)", groupIndex);
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

stock void RemovePlayerGroup(int groupIndex)
{
	if (!IsPlayerGroupActive(groupIndex)) return;
	
	ClearPlayerGroupMembers(groupIndex);
	SetPlayerGroupQueuePoints(groupIndex, 0);
	SetPlayerGroupPlaying(groupIndex, false);
	SetPlayerGroupLeader(groupIndex, -1);
	g_bPlayerGroupActive[groupIndex] = false;
	SetPlayerGroupID(groupIndex, -1);
}

stock void ClearPlayerGroupMembers(int groupIndex)
{
	if (!IsPlayerGroupValid(groupIndex)) return;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (ClientGetPlayerGroup(i) == groupIndex)
		{
			ClientSetPlayerGroup(i, -1);
		}
	}
}

stock bool GetPlayerGroupName(int groupIndex, char[] sBuffer,int iBufferLen)
{
	char sGroupIndex[32];
	FormatEx(sGroupIndex, sizeof(sGroupIndex), "%d", groupIndex);
	return g_hPlayerGroupNames.GetString(sGroupIndex, sBuffer, iBufferLen);
}

stock void SetPlayerGroupName(int groupIndex, const char[] sGroupName)
{
	char sGroupIndex[32];
	FormatEx(sGroupIndex, sizeof(sGroupIndex), "%d", groupIndex);
	g_hPlayerGroupNames.SetString(sGroupIndex, sGroupName);
}

stock int GetPlayerGroupID(int groupIndex)
{
	return g_iPlayerGroupID[groupIndex];
}

stock void SetPlayerGroupID(int groupIndex,int iID)
{
	g_iPlayerGroupID[groupIndex] = iID;
}

stock bool IsPlayerGroupActive(int groupIndex)
{
	return IsPlayerGroupValid(groupIndex) && g_bPlayerGroupActive[groupIndex];
}

stock bool IsPlayerGroupValid(int groupIndex)
{
	return (groupIndex >= 0 && groupIndex < SF2_MAX_PLAYER_GROUPS);
}

stock int GetPlayerGroupMemberCount(int groupIndex)
{
	int iCount;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
	
		if (ClientGetPlayerGroup(i) == groupIndex)
		{
			iCount++;
		}
	}
	
	return iCount;
}

stock bool IsPlayerGroupPlaying(int groupIndex)
{
	return (IsPlayerGroupActive(groupIndex) && g_bPlayerGroupPlaying[groupIndex]);
}

stock void SetPlayerGroupPlaying(int groupIndex, bool bToggle)
{
	g_bPlayerGroupPlaying[groupIndex] = bToggle;
}

stock int GetPlayerGroupLeader(int groupIndex)
{
	return g_iPlayerGroupLeader[groupIndex];
}

stock void SetPlayerGroupLeader(int groupIndex,int iGroupLeader)
{
	g_iPlayerGroupLeader[groupIndex] = iGroupLeader;
	
	if (IsValidClient(iGroupLeader))
	{
		char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(groupIndex, sGroupName, sizeof(sGroupName));
		CPrintToChat(iGroupLeader, "%T", "SF2 New Group Leader", iGroupLeader, sGroupName);
		
		char sName[MAX_NAME_LENGTH];
		FormatEx(sName, sizeof(sName), "%N", iGroupLeader);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (iGroupLeader == i || !IsValidClient(i)) continue;
			if (ClientGetPlayerGroup(i) == groupIndex)
			{
				CPrintToChat(i, "%T", "SF2 Player New Group Leader", i, sName);
			}
		}
	}
}

int PlayerGroupFindNewLeader(int groupIndex)
{
	if (!IsPlayerGroupActive(groupIndex)) return -1;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		
		if (ClientGetPlayerGroup(i) == groupIndex)
		{
			SetPlayerGroupLeader(groupIndex, i);
			return i;
		}
	}
	
	return -1;
}

stock int GetPlayerGroupQueuePoints(int groupIndex)
{
	return g_iPlayerGroupQueuePoints[groupIndex];
}

stock void SetPlayerGroupQueuePoints(int groupIndex,int iAmount)
{
	g_iPlayerGroupQueuePoints[groupIndex] = iAmount;
}

stock bool HasPlayerGroupInvitedPlayer(int groupIndex,int client)
{
	return g_bPlayerGroupInvitedPlayer[groupIndex][client];
}

stock void SetPlayerGroupInvitedPlayer(int groupIndex,int client, bool bToggle)
{
	g_bPlayerGroupInvitedPlayer[groupIndex][client] = bToggle;
}

stock int GetPlayerGroupInvitedPlayerCount(int groupIndex,int client)
{
	return g_iPlayerGroupInvitedPlayerCount[groupIndex][client];
}

stock int SetPlayerGroupInvitedPlayerCount(int groupIndex,int client,int iAmount)
{
	g_iPlayerGroupInvitedPlayerCount[groupIndex][client] = iAmount;
}

stock float GetPlayerGroupInvitedPlayerTime(int groupIndex,int client)
{
	return g_flPlayerGroupInvitedPlayerTime[groupIndex][client];
}

stock void SetPlayerGroupInvitedPlayerTime(int groupIndex,int client, float flTime)
{
	g_flPlayerGroupInvitedPlayerTime[groupIndex][client] = flTime;
}

stock int ClientGetPlayerGroup(int client)
{
	return g_iPlayerCurrentGroup[client];
}

stock void ClientSetPlayerGroup(int client,int groupIndex)
{
	int iOldPlayerGroup = ClientGetPlayerGroup(client);
	if (iOldPlayerGroup == groupIndex) return; // No change.
	
	g_iPlayerCurrentGroup[client] = groupIndex;
	
	char sName[MAX_NAME_LENGTH];
	FormatEx(sName, sizeof(sName), "%N", client);
	
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
	
	if (IsPlayerGroupPlaying(groupIndex))
	{
		ClientSetQueuePoints(client, 0);
	}
	
	if (IsPlayerGroupActive(groupIndex))
	{
		SetPlayerGroupInvitedPlayer(groupIndex, client, false);
		SetPlayerGroupInvitedPlayerCount(groupIndex, client, 0);
		SetPlayerGroupInvitedPlayerTime(groupIndex, client, 0.0);
		
		// Set the player's personal queue points to 0.
		//ClientSetQueuePoints(client, 0);
		
		char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(groupIndex, sGroupName, sizeof(sGroupName));
		CPrintToChat(client, "%T", "SF2 Joined Group", client, sGroupName);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (i == client || !IsValidClient(i)) continue;
			if (ClientGetPlayerGroup(i) == groupIndex)
			{
				CPrintToChat(i, "%T", "SF2 Player Joined Group", i, sName);
			}
		}
	}
}