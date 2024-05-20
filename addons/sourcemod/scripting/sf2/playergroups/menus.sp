#if defined _sf2_playergroups_menus
 #endinput
#endif

#define _sf2_playergroups_menus

#pragma semicolon 1

void DisplayGroupMainMenuToClient(int client)
{
	Menu menu = new Menu(Menu_GroupMain);
	menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Group Main Menu Title", client, "SF2 Group Main Menu Description", client);

	int groupIndex = ClientGetPlayerGroup(client);
	bool groupIsActive = IsPlayerGroupActive(groupIndex);

	char buffer[256];
	if (groupIsActive && GetPlayerGroupLeader(groupIndex) == client)
	{
		Format(buffer, sizeof(buffer), "%T", "SF2 Admin Group Menu Title", client);
	}
	else
	{
		Format(buffer, sizeof(buffer), "%T", "SF2 View Current Group Info Menu Title", client);
	}

	menu.AddItem("0", buffer, groupIsActive ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

	Format(buffer, sizeof(buffer), "%T", "SF2 Create Group Menu Title", client);
	menu.AddItem("0", buffer, groupIsActive ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	Format(buffer, sizeof(buffer), "%T", "SF2 Leave Group Menu Title", client);
	menu.AddItem("0", buffer, groupIsActive ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

static int Menu_GroupMain(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			g_MenuMain.Display(param1, 30);
		}
	}
	else if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayAdminGroupMenuToClient(param1);
			}
			case 1:
			{
				DisplayCreateGroupMenuToClient(param1);
			}
			case 2:
			{
				DisplayLeaveGroupMenuToClient(param1);
			}
		}
	}
	return 0;
}

void DisplayCreateGroupMenuToClient(int client)
{
	int groupIndex = ClientGetPlayerGroup(client);
	if (IsPlayerGroupActive(groupIndex))
	{
		// He's already in a group. Take him back to the main menu.
		DisplayGroupMainMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 In Group", client);
		return;
	}

	Menu menu = new Menu(Menu_CreateGroup);
	menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Create Group Menu Title", client, "SF2 Create Group Menu Description", client, GetMaxPlayersForRound(), g_PlayerQueuePoints[client]);

	char buffer[256];
	Format(buffer, sizeof(buffer), "%T", "Yes", client);
	menu.AddItem("0", buffer);
	Format(buffer, sizeof(buffer), "%T", "No", client);
	menu.AddItem("0", buffer);

	menu.Display(client, MENU_TIME_FOREVER);
}

static int Menu_CreateGroup(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (param2 == 0)
		{
			int groupIndex = ClientGetPlayerGroup(param1);
			if (IsPlayerGroupActive(groupIndex))
			{
				CPrintToChat(param1, "%T", "SF2 In Group", param1);
			}
			else
			{
				groupIndex = CreatePlayerGroup();
				if (groupIndex != -1)
				{
					int queuePoints = g_PlayerQueuePoints[param1];

					char groupName[64];
					Format(groupName, sizeof(groupName), "Group %d", groupIndex);
					SetPlayerGroupName(groupIndex, groupName);
					ClientSetPlayerGroup(param1, groupIndex);
					SetPlayerGroupLeader(groupIndex, param1);
					SetPlayerGroupQueuePoints(groupIndex, queuePoints);

					CPrintToChat(param1, "%T", "SF2 Created Group", param1, groupName);
				}
				else
				{
					CPrintToChat(param1, "%T", "SF2 Max Groups Reached", param1);
				}
			}
		}

		DisplayGroupMainMenuToClient(param1);
	}
	return 0;
}

void DisplayLeaveGroupMenuToClient(int client)
{
	int groupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(groupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayGroupMainMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}

	char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	GetPlayerGroupName(groupIndex, groupName, sizeof(groupName));

	Menu menu = new Menu(Menu_LeaveGroup);
	menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Leave Group Menu Title", client, "SF2 Leave Group Menu Description", client, groupName);

	char buffer[256];
	Format(buffer, sizeof(buffer), "%T", "Yes", client);
	menu.AddItem("0", buffer);
	Format(buffer, sizeof(buffer), "%T", "No", client);
	menu.AddItem("0", buffer);

	menu.Display(client, MENU_TIME_FOREVER);
}

static int Menu_LeaveGroup(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		if (param2 == 0)
		{
			int groupIndex = ClientGetPlayerGroup(param1);
			if (!IsPlayerGroupActive(groupIndex))
			{
				CPrintToChat(param1, "%T", "SF2 Group Does Not Exist", param1);
			}
			else
			{
				ClientSetPlayerGroup(param1, -1);
			}
		}

		DisplayGroupMainMenuToClient(param1);
	}
	return 0;
}

void DisplayAdminGroupMenuToClient(int client)
{
	int groupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(groupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayGroupMainMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}

	char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	GetPlayerGroupName(groupIndex, groupName, sizeof(groupName));

	char leaderName[MAX_NAME_LENGTH];
	int groupLeader = GetPlayerGroupLeader(groupIndex);
	if (IsValidClient(groupLeader)) FormatEx(leaderName, sizeof(leaderName), "%N", groupLeader);
	else strcopy(leaderName, sizeof(leaderName), "---");

	int memberCount = GetPlayerGroupMemberCount(groupIndex);
	int maxPlayers = GetMaxPlayersForRound();
	int queuePoints = GetPlayerGroupQueuePoints(groupIndex);

	Menu menu = new Menu(Menu_AdminGroup);
	menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Admin Group Menu Title", client, "SF2 Admin Group Menu Description", client, groupName, leaderName, memberCount, maxPlayers, queuePoints);

	char buffer[256];
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 View Group Members Menu Title", client);
	menu.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Set Group Name Menu Title", client);
	menu.AddItem("0", buffer, groupLeader == client ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Set Group Leader Menu Title", client);
	menu.AddItem("0", buffer, groupLeader == client ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Invite To Group Menu Title", client);
	menu.AddItem("0", buffer, groupLeader == client && memberCount < maxPlayers ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Kick From Group Menu Title", client);
	menu.AddItem("0", buffer, groupLeader == client && memberCount > 1 ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Reset Group Queue Points Menu Title", client);
	menu.AddItem("0", buffer, groupLeader == client ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	FormatEx(buffer, sizeof(buffer), "Opt in for Nightmare + Apollyon voting");
	menu.AddItem("0", buffer, groupLeader == client ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

static int Menu_AdminGroup(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayGroupMainMenuToClient(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		int groupIndex = ClientGetPlayerGroup(param1);
		if (IsPlayerGroupActive(groupIndex))
		{
			switch (param2)
			{
				case 0:
				{
					DisplayViewGroupMembersMenuToClient(param1);
				}
				case 1:
				{
					DisplaySetGroupNameMenuToClient(param1);
				}
				case 2:
				{
					DisplaySetGroupLeaderMenuToClient(param1);
				}
				case 3:
				{
					DisplayInviteToGroupMenuToClient(param1);
				}
				case 4:
				{
					DisplayKickFromGroupMenuToClient(param1);
				}
				case 5:
				{
					DisplayResetGroupQueuePointsMenuToClient(param1);
				}
				case 6:
				{
					DisplayOptInHardDifficultiesToClient(param1);
				}
			}
		}
		else
		{
			DisplayGroupMainMenuToClient(param1);
			CPrintToChat(param1, "%T", "SF2 Group Does Not Exist", param1);
		}
	}
	return 0;
}

void DisplayViewGroupMembersMenuToClient(int client)
{
	int groupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(groupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}

	ArrayList playersHandle = new ArrayList();
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		int tempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(tempGroup) || tempGroup != groupIndex)
		{
			continue;
		}

		playersHandle.Push(i);
	}

	int playerCount = playersHandle.Length;
	if (playerCount)
	{
		Menu menu = new Menu(Menu_ViewGroupMembers);
		menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 View Group Members Menu Title", client, "SF2 View Group Members Menu Description", client);

		char userId[32];
		char name[MAX_NAME_LENGTH];

		for (int i = 0; i < playerCount; i++)
		{
			int clientArray = playersHandle.Get(i);
			FormatEx(userId, sizeof(userId), "%d", GetClientUserId(clientArray));
			FormatEx(name, sizeof(name), "%N", clientArray);
			menu.AddItem(userId, name);
		}

		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players left for the taking!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 No Players Available", client);
	}

	delete playersHandle;
}

static int Menu_ViewGroupMembers(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayAdminGroupMenuToClient(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		DisplayAdminGroupMenuToClient(param1);
	}
	return 0;
}

void DisplaySetGroupLeaderMenuToClient(int client)
{
	int groupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(groupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}

	if (GetPlayerGroupLeader(groupIndex) != client)
	{
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Not Group Leader", client);
		return;
	}

	ArrayList playersHandle = new ArrayList();
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		int tempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(tempGroup) || tempGroup != groupIndex)
		{
			continue;
		}
		if (i == client)
		{
			continue;
		}

		playersHandle.Push(i);
	}

	int playerCount = playersHandle.Length;
	if (playerCount)
	{
		Menu menu = new Menu(Menu_SetGroupLeader);
		menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Set Group Leader Menu Title", client, "SF2 Set Group Leader Menu Description", client);

		char userId[32];
		char name[MAX_NAME_LENGTH];

		for (int i = 0; i < playerCount; i++)
		{
			int clientArray = playersHandle.Get(i);
			FormatEx(userId, sizeof(userId), "%d", GetClientUserId(clientArray));
			FormatEx(name, sizeof(name), "%N", clientArray);
			menu.AddItem(userId, name);
		}

		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players left for the taking!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 No Players Available", client);
	}

	delete playersHandle;
}

static int Menu_SetGroupLeader(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayAdminGroupMenuToClient(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		int groupIndex = ClientGetPlayerGroup(param1);
		if (IsPlayerGroupActive(groupIndex) && GetPlayerGroupLeader(groupIndex) == param1)
		{
			char info[64];
			menu.GetItem(param2, info, sizeof(info));
			int userid = StringToInt(info);
			int player = GetClientOfUserId(userid);

			if (ClientGetPlayerGroup(player) == groupIndex && IsValidClient(player))
			{
				char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
				char name[MAX_NAME_LENGTH];
				GetPlayerGroupName(groupIndex, groupName, sizeof(groupName));
				Format(name, sizeof(name), "%N", player);

				SetPlayerGroupLeader(groupIndex, player);
			}
			else
			{
				CPrintToChat(param1, "%T", "SF2 Player Not In Group", param1);
			}
		}

		DisplayAdminGroupMenuToClient(param1);
	}
	return 0;
}

void DisplayKickFromGroupMenuToClient(int client)
{
	int groupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(groupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}

	if (GetPlayerGroupLeader(groupIndex) != client)
	{
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Not Group Leader", client);
		return;
	}

	ArrayList playersHandle = new ArrayList();
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		int tempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(tempGroup) || tempGroup != groupIndex)
		{
			continue;
		}
		if (i == client)
		{
			continue;
		}

		playersHandle.Push(i);
	}

	int playerCount = playersHandle.Length;
	if (playerCount)
	{
		Menu menu = new Menu(Menu_KickFromGroup);
		menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Kick From Group Menu Title", client, "SF2 Kick From Group Menu Description", client);

		char userId[32];
		char name[MAX_NAME_LENGTH];

		for (int i = 0; i < playerCount; i++)
		{
			int clientArray = playersHandle.Get(i);
			FormatEx(userId, sizeof(userId), "%d", GetClientUserId(clientArray));
			FormatEx(name, sizeof(name), "%N", clientArray);
			menu.AddItem(userId, name);
		}

		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players left for the taking!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 No Players Available", client);
	}

	delete playersHandle;
}

static int Menu_KickFromGroup(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayAdminGroupMenuToClient(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		int groupIndex = ClientGetPlayerGroup(param1);
		if (IsPlayerGroupActive(groupIndex) && GetPlayerGroupLeader(groupIndex) == param1)
		{
			char info[64];
			menu.GetItem(param2, info, sizeof(info));
			int userid = StringToInt(info);
			int player = GetClientOfUserId(userid);

			if (ClientGetPlayerGroup(player) == groupIndex)
			{
				char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
				char name[MAX_NAME_LENGTH];
				GetPlayerGroupName(groupIndex, groupName, sizeof(groupName));
				FormatEx(name, sizeof(name), "%N", player);

				CPrintToChat(player, "%T", "SF2 Kicked From Group", player, groupName);
				ClientSetPlayerGroup(player, -1);
				CPrintToChat(param1, "%T", "SF2 Player Kicked From Group", param1, name);
			}
			else
			{
				CPrintToChat(param1, "%T", "SF2 Player Not In Group", param1);
			}
		}

		DisplayKickFromGroupMenuToClient(param1);
	}
	return 0;
}

void DisplaySetGroupNameMenuToClient(int client)
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

	Menu menu = new Menu(Menu_SetGroupName);
	menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Set Group Name Menu Title", client, "SF2 Set Group Name Menu Description", client);

	char buffer[256];
	Format(buffer, sizeof(buffer), "%T", "Back", client);
	menu.AddItem("0", buffer);
	menu.Display(client, MENU_TIME_FOREVER);
}

static int Menu_SetGroupName(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayAdminGroupMenuToClient(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		DisplayAdminGroupMenuToClient(param1);
	}
	return 0;
}

void DisplayInviteToGroupMenuToClient(int client)
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

	if (GetPlayerGroupMemberCount(groupIndex) >= GetMaxPlayersForRound())
	{
		// His group is full!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Is Full", client);
		return;
	}

	ArrayList playersHandle = new ArrayList();
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsClientParticipating(i))
		{
			continue;
		}

		int tempGroup = ClientGetPlayerGroup(i);
		if (IsPlayerGroupActive(tempGroup))
		{
			continue;
		}
		if (!g_PlayerEliminated[i])
		{
			continue;
		}

		playersHandle.Push(i);
	}

	int playerCount = playersHandle.Length;
	if (playerCount)
	{
		Menu menu = new Menu(Menu_InviteToGroup);
		menu.SetTitle("%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Invite To Group Menu Title", client, "SF2 Invite To Group Menu Description", client);

		char userId[32];
		char name[MAX_NAME_LENGTH];

		for (int i = 0; i < playerCount; i++)
		{
			int clientArray = playersHandle.Get(i);
			FormatEx(userId, sizeof(userId), "%d", GetClientUserId(clientArray));
			FormatEx(name, sizeof(name), "%N", clientArray);
			menu.AddItem(userId, name);
		}

		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players left for the taking!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 No Players Available", client);
	}

	delete playersHandle;
}

static int Menu_InviteToGroup(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayAdminGroupMenuToClient(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		int groupIndex = ClientGetPlayerGroup(param1);
		if (IsPlayerGroupActive(groupIndex) && GetPlayerGroupLeader(groupIndex) == param1)
		{
			char info[64];
			menu.GetItem(param2, info, sizeof(info));
			int userid = StringToInt(info);
			int invitedPlayer = GetClientOfUserId(userid);
			SendPlayerGroupInvitation(invitedPlayer, GetPlayerGroupID(groupIndex), param1);
		}

		DisplayInviteToGroupMenuToClient(param1);
	}
	return 0;
}