#if defined _sf2_playergroups_included
 #endinput
#endif
#define _sf2_playergroups_included

#pragma semicolon 1

#define SF2_MAX_PLAYER_GROUPS MAXPLAYERS
#define SF2_MAX_PLAYER_GROUP_NAME_LENGTH 32

static int g_PlayerGroupGlobalID = -1;
static int g_PlayerCurrentGroup[MAXPLAYERS + 1] = { -1, ... };
static bool g_PlayerGroupActive[SF2_MAX_PLAYER_GROUPS] = { false, ... };
static int g_PlayerGroupLeader[SF2_MAX_PLAYER_GROUPS] = { -1, ... };
static int g_PlayerGroupID[SF2_MAX_PLAYER_GROUPS] = { -1, ... };
static int g_PlayerGroupQueuePoints[SF2_MAX_PLAYER_GROUPS];
static int g_PlayerGroupPlaying[SF2_MAX_PLAYER_GROUPS] = { false, ... };
static StringMap g_PlayerGroupNames;
static bool g_PlayerGroupInvitedPlayer[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];
static int g_PlayerGroupInvitedPlayerCount[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];
static float g_PlayerGroupInvitedPlayerTime[SF2_MAX_PLAYER_GROUPS][MAXPLAYERS + 1];

void SetupPlayerGroups()
{
	g_PlayerGroupGlobalID = -1;
	g_PlayerGroupNames = new StringMap();
}

stock int GetPlayerGroupFromID(int groupID)
{
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i))
		{
			continue;
		}
		if (GetPlayerGroupID(i) == groupID)
		{
			return i;
		}
	}

	return -1;
}

void SendPlayerGroupInvitation(int client,int groupID,int inviter=-1)
{
	if (!IsValidClient(client) || !IsClientParticipating(client))
	{
		if (IsValidClient(inviter))
		{
			// TODO: Send message to the inviter that the client is invalid!
		}

		return;
	}

	if (!g_PlayerEliminated[client])
	{
		if (IsValidClient(inviter))
		{
			// TODO: Send message to the inviter that the client is currently in-game.
		}

		return;
	}

	int groupIndex = GetPlayerGroupFromID(groupID);
	if (groupIndex == -1)
	{
		return;
	}

	int myGroupIndex = ClientGetPlayerGroup(client);
	if (IsPlayerGroupActive(myGroupIndex))
	{
		if (IsValidClient(inviter))
		{
			if (myGroupIndex == groupIndex)
			{
				CPrintToChat(inviter, "%T", "SF2 Player In Group", inviter);
			}
			else
			{
				CPrintToChat(inviter, "%T", "SF2 Player In Another Group", inviter);
			}
		}

		return;
	}

	if (GetPlayerGroupMemberCount(groupIndex) >= GetMaxPlayersForRound())
	{
		if (IsValidClient(inviter))
		{
			CPrintToChat(inviter, "%T", "SF2 Group Is Full", inviter);
		}

		return;
	}

	if (IsFakeClient(client))
	{
		ClientSetPlayerGroup(client, groupIndex);
		return;
	}

	// Anti-spam.
	char name[MAX_NAME_LENGTH];
	FormatEx(name, sizeof(name), "%N", client);

	if (IsValidClient(inviter))
	{
		float nextInviteTime = GetPlayerGroupInvitedPlayerTime(groupIndex, client) + (20.0 * GetPlayerGroupInvitedPlayerCount(groupIndex, client));
		if (GetGameTime() < nextInviteTime)
		{
			CPrintToChat(inviter, "%T", "SF2 No Group Invite Spam", inviter, RoundFloat(nextInviteTime - GetGameTime()), name);
			return;
		}
	}

	char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	char leaderName[64];
	GetPlayerGroupName(groupIndex, groupName, sizeof(groupName));

	int groupLeader = GetPlayerGroupLeader(groupIndex);
	if (IsValidClient(groupLeader))
	{
		FormatEx(leaderName, sizeof(leaderName), "%N", groupLeader);
	}
	else
	{
		strcopy(leaderName, sizeof(leaderName), "nobody");
	}

	Handle menu = CreateMenu(Menu_GroupInvite);
	SetMenuTitle(menu, "%t%T\n \n", "SF2 Prefix", "SF2 Group Invite Menu Description", client, leaderName, groupName);

	char groupIDString[64];
	FormatEx(groupIDString, sizeof(groupIDString), "%d", groupID);

	char buffer[256];
	FormatEx(buffer, sizeof(buffer), "%T", "Yes", client);
	AddMenuItem(menu, groupIDString, buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "No", client);
	AddMenuItem(menu, "0", buffer);
	DisplayMenu(menu, client, 10);

	SetPlayerGroupInvitedPlayer(groupIndex, client, true);
	SetPlayerGroupInvitedPlayerCount(groupIndex, client, GetPlayerGroupInvitedPlayerCount(groupIndex, client) + 1);
	SetPlayerGroupInvitedPlayerTime(groupIndex, client, GetGameTime());

	if (IsValidClient(inviter))
	{
		CPrintToChat(inviter, "%T", "SF2 Group Invitation Sent", inviter, name);
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
			char groupID[64];
			GetMenuItem(menu, param2, groupID, sizeof(groupID));
			int groupIndex = GetPlayerGroupFromID(StringToInt(groupID));
			if (IsPlayerGroupActive(groupIndex))
			{
				int myGroupIndex = ClientGetPlayerGroup(param1);
				if (IsPlayerGroupActive(myGroupIndex))
				{
					if (myGroupIndex == groupIndex)
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
	return 0;
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

	Handle menu = CreateMenu(Menu_ResetGroupQueuePoints);
	SetMenuTitle(menu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Reset Group Queue Points Menu Title", client, "SF2 Reset Group Queue Points Menu Description", client);

	char buffer[256];
	FormatEx(buffer, sizeof(buffer), "%T", "Yes", client);
	AddMenuItem(menu, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "No", client);
	AddMenuItem(menu, "0", buffer);

	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public int Menu_ResetGroupQueuePoints(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
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
					if (!IsValidClient(i))
					{
						continue;
					}
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
	return 0;
}

void CheckPlayerGroup(int groupIndex)
{
	if (!IsPlayerGroupActive(groupIndex))
	{
		return;
	}

#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START CheckPlayerGroup(%d)", groupIndex);
	}
#endif

	int memberCount = GetPlayerGroupMemberCount(groupIndex);
	if (memberCount <= 0)
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
					if (g_DebugDetailConVar.IntValue > 0) DebugMessage("CheckPlayerGroup(%d): Invalid client detected (%d), removing from group", groupIndex, i);
#endif

					ClientSetPlayerGroup(i, -1);
				}
			}
		}

		memberCount = GetPlayerGroupMemberCount(groupIndex);
		int maxPlayers = GetMaxPlayersForRound();
		int excessMemberCount = (memberCount - maxPlayers);

		if (excessMemberCount > 0)
		{
#if defined DEBUG
			if (g_DebugDetailConVar.IntValue > 0)
			{
				DebugMessage("CheckPlayerGroup(%d): Excess members detected", groupIndex);
			}
#endif

			int groupLeader = GetPlayerGroupLeader(groupIndex);
			if (IsValidClient(groupLeader))
			{
				CPrintToChat(groupLeader, "%T", "SF2 Group Has Too Many Members", groupLeader);
			}

			for (int i = 1, count; i <= MaxClients && count < excessMemberCount; i++)
			{
				if (!IsValidClient(i))
				{
					continue;
				}

				if (ClientGetPlayerGroup(i) == groupIndex)
				{
					if (i == groupLeader)
					{
						continue; // Don't kick off the group leader.
					}

					ClientSetPlayerGroup(i, -1);
					count++;
				}
			}
		}
	}

#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("END CheckPlayerGroup(%d)", groupIndex);
	}
#endif
}

stock int GetPlayerGroupCount()
{
	int count;

	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (IsPlayerGroupActive(i)) count++;
	}

	return count;
}

stock int CreatePlayerGroup()
{
	// Get an inactive group.
	int index = -1;
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i))
		{
			index = i;
			break;
		}
	}

	if (index != -1)
	{
		g_PlayerGroupActive[index] = true;
		g_PlayerGroupGlobalID++;
		SetPlayerGroupID(index, g_PlayerGroupGlobalID);
		ClearPlayerGroupMembers(index);
		SetPlayerGroupQueuePoints(index, 0);
		SetPlayerGroupLeader(index, -1);
		SetPlayerGroupName(index, "");
		SetPlayerGroupPlaying(index, false);

		for (int i = 1; i <= MaxClients; i++)
		{
			SetPlayerGroupInvitedPlayer(index, i, false);
			SetPlayerGroupInvitedPlayerCount(index, i, 0);
			SetPlayerGroupInvitedPlayerTime(index, i, 0.0);
		}
	}

	return index;
}

stock void RemovePlayerGroup(int groupIndex)
{
	if (!IsPlayerGroupActive(groupIndex))
	{
		return;
	}

	ClearPlayerGroupMembers(groupIndex);
	SetPlayerGroupQueuePoints(groupIndex, 0);
	SetPlayerGroupPlaying(groupIndex, false);
	SetPlayerGroupLeader(groupIndex, -1);
	g_PlayerGroupActive[groupIndex] = false;
	SetPlayerGroupID(groupIndex, -1);
}

stock void ClearPlayerGroupMembers(int groupIndex)
{
	if (!IsPlayerGroupValid(groupIndex))
	{
		return;
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (ClientGetPlayerGroup(i) == groupIndex)
		{
			ClientSetPlayerGroup(i, -1);
		}
	}
}

stock bool GetPlayerGroupName(int groupIndex, char[] buffer,int iBufferLen)
{
	char groupIndexString[32];
	FormatEx(groupIndexString, sizeof(groupIndexString), "%d", groupIndex);
	return g_PlayerGroupNames.GetString(groupIndexString, buffer, iBufferLen);
}

stock void SetPlayerGroupName(int groupIndex, const char[] groupName)
{
	char groupIndexString[32];
	FormatEx(groupIndexString, sizeof(groupIndexString), "%d", groupIndex);
	g_PlayerGroupNames.SetString(groupIndexString, groupName);
}

stock int GetPlayerGroupID(int groupIndex)
{
	return g_PlayerGroupID[groupIndex];
}

stock void SetPlayerGroupID(int groupIndex,int iID)
{
	g_PlayerGroupID[groupIndex] = iID;
}

stock bool IsPlayerGroupActive(int groupIndex)
{
	return IsPlayerGroupValid(groupIndex) && g_PlayerGroupActive[groupIndex];
}

stock bool IsPlayerGroupValid(int groupIndex)
{
	return (groupIndex >= 0 && groupIndex < SF2_MAX_PLAYER_GROUPS);
}

stock int GetPlayerGroupMemberCount(int groupIndex)
{
	int count;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		if (ClientGetPlayerGroup(i) == groupIndex)
		{
			count++;
		}
	}

	return count;
}

stock bool IsPlayerGroupPlaying(int groupIndex)
{
	return (IsPlayerGroupActive(groupIndex) && g_PlayerGroupPlaying[groupIndex]);
}

stock void SetPlayerGroupPlaying(int groupIndex, bool toggle)
{
	g_PlayerGroupPlaying[groupIndex] = toggle;
}

stock int GetPlayerGroupLeader(int groupIndex)
{
	return g_PlayerGroupLeader[groupIndex];
}

stock void SetPlayerGroupLeader(int groupIndex,int groupLeader)
{
	g_PlayerGroupLeader[groupIndex] = groupLeader;

	if (IsValidClient(groupLeader))
	{
		char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(groupIndex, groupName, sizeof(groupName));
		CPrintToChat(groupLeader, "%T", "SF2 New Group Leader", groupLeader, groupName);

		char name[MAX_NAME_LENGTH];
		FormatEx(name, sizeof(name), "%N", groupLeader);

		for (int i = 1; i <= MaxClients; i++)
		{
			if (groupLeader == i || !IsValidClient(i))
			{
				continue;
			}
			if (ClientGetPlayerGroup(i) == groupIndex)
			{
				CPrintToChat(i, "%T", "SF2 Player New Group Leader", i, name);
			}
		}
	}
}

int PlayerGroupFindNewLeader(int groupIndex)
{
	if (!IsPlayerGroupActive(groupIndex))
	{
		return -1;
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

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
	return g_PlayerGroupQueuePoints[groupIndex];
}

stock void SetPlayerGroupQueuePoints(int groupIndex,int amount)
{
	g_PlayerGroupQueuePoints[groupIndex] = amount;
}

stock bool HasPlayerGroupInvitedPlayer(int groupIndex,int client)
{
	return g_PlayerGroupInvitedPlayer[groupIndex][client];
}

stock void SetPlayerGroupInvitedPlayer(int groupIndex,int client, bool toggle)
{
	g_PlayerGroupInvitedPlayer[groupIndex][client] = toggle;
}

stock int GetPlayerGroupInvitedPlayerCount(int groupIndex,int client)
{
	return g_PlayerGroupInvitedPlayerCount[groupIndex][client];
}

stock void SetPlayerGroupInvitedPlayerCount(int groupIndex,int client,int amount)
{
	g_PlayerGroupInvitedPlayerCount[groupIndex][client] = amount;
}

stock float GetPlayerGroupInvitedPlayerTime(int groupIndex,int client)
{
	return g_PlayerGroupInvitedPlayerTime[groupIndex][client];
}

stock void SetPlayerGroupInvitedPlayerTime(int groupIndex,int client, float flTime)
{
	g_PlayerGroupInvitedPlayerTime[groupIndex][client] = flTime;
}

stock int ClientGetPlayerGroup(int client)
{
	return g_PlayerCurrentGroup[client];
}

stock void ClientSetPlayerGroup(int client,int groupIndex)
{
	int oldPlayerGroup = ClientGetPlayerGroup(client);
	if (oldPlayerGroup == groupIndex)
	{
		return; // No change.
	}

	g_PlayerCurrentGroup[client] = groupIndex;

	char name[MAX_NAME_LENGTH];
	FormatEx(name, sizeof(name), "%N", client);

	if (IsPlayerGroupActive(oldPlayerGroup))
	{
		SetPlayerGroupInvitedPlayer(oldPlayerGroup, client, false);
		SetPlayerGroupInvitedPlayerCount(oldPlayerGroup, client, 0);
		SetPlayerGroupInvitedPlayerTime(oldPlayerGroup, client, 0.0);

		char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(oldPlayerGroup, groupName, sizeof(groupName));
		CPrintToChat(client, "%T", "SF2 Left Group", client, groupName);

		for (int i = 1; i <= MaxClients; i++)
		{
			if (i == client || !IsValidClient(i))
			{
				continue;
			}
			if (ClientGetPlayerGroup(i) == oldPlayerGroup)
			{
				CPrintToChat(i, "%T", "SF2 Player Left Group", i, name);
			}
		}

		int oldGroupLeader = GetPlayerGroupLeader(oldPlayerGroup);
		if (oldGroupLeader == client)
		{
			int oldGroupNewLeader = PlayerGroupFindNewLeader(oldPlayerGroup);
			if (oldGroupNewLeader == -1)
			{
				// Couldn't find a new leader. This group has no leader!
				SetPlayerGroupLeader(oldPlayerGroup, -1);
			}
		}

		CheckPlayerGroup(oldPlayerGroup);
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

		char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(groupIndex, groupName, sizeof(groupName));
		CPrintToChat(client, "%T", "SF2 Joined Group", client, groupName);

		for (int i = 1; i <= MaxClients; i++)
		{
			if (i == client || !IsValidClient(i))
			{
				continue;
			}
			if (ClientGetPlayerGroup(i) == groupIndex)
			{
				CPrintToChat(i, "%T", "SF2 Player Joined Group", i, name);
			}
		}
	}
}