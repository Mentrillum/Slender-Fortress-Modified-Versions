#if defined _sf2_playergroups_menus
 #endinput
#endif

#define _sf2_playergroups_menus

void DisplayGroupMainMenuToClient(int client)
{
	Handle hMenu = CreateMenu(Menu_GroupMain);
	SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Group Main Menu Title", client, "SF2 Group Main Menu Description", client);
	
	int iGroupIndex = ClientGetPlayerGroup(client);
	bool bGroupIsActive = IsPlayerGroupActive(iGroupIndex);
	
	char sBuffer[256];
	if (bGroupIsActive && GetPlayerGroupLeader(iGroupIndex) == client)
	{
		Format(sBuffer, sizeof(sBuffer), "%T", "SF2 Admin Group Menu Title", client);
	}
	else
	{
		Format(sBuffer, sizeof(sBuffer), "%T", "SF2 View Current Group Info Menu Title", client);
	}
	
	AddMenuItem(hMenu, "0", sBuffer, bGroupIsActive ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	
	Format(sBuffer, sizeof(sBuffer), "%T", "SF2 Create Group Menu Title", client);
	AddMenuItem(hMenu, "0", sBuffer, bGroupIsActive ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	Format(sBuffer, sizeof(sBuffer), "%T", "SF2 Leave Group Menu Title", client);
	AddMenuItem(hMenu, "0", sBuffer, bGroupIsActive ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
}

public int Menu_GroupMain(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack) DisplayMenu(g_hMenuMain, param1, 30);
	}
	else if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayAdminGroupMenuToClient(param1);
			case 1: DisplayCreateGroupMenuToClient(param1);
			case 2: DisplayLeaveGroupMenuToClient(param1);
		}
	}
}

void DisplayCreateGroupMenuToClient(int client)
{
	int iGroupIndex = ClientGetPlayerGroup(client);
	if (IsPlayerGroupActive(iGroupIndex))
	{
		// He's already in a group. Take him back to the main menu.
		DisplayGroupMainMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 In Group", client);
		return;
	}
	
	Handle hMenu = CreateMenu(Menu_CreateGroup);
	SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Create Group Menu Title", client, "SF2 Create Group Menu Description", client, GetMaxPlayersForRound(), g_iPlayerQueuePoints[client]);
	
	char sBuffer[256];
	Format(sBuffer, sizeof(sBuffer), "%T", "Yes", client);
	AddMenuItem(hMenu, "0", sBuffer);
	Format(sBuffer, sizeof(sBuffer), "%T", "No", client);
	AddMenuItem(hMenu, "0", sBuffer);
	
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
}

public int Menu_CreateGroup(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Select)
	{
		if (param2 == 0)
		{
			int iGroupIndex = ClientGetPlayerGroup(param1);
			if (IsPlayerGroupActive(iGroupIndex))
			{
				CPrintToChat(param1, "%T", "SF2 In Group", param1);
			}
			else
			{
				iGroupIndex = CreatePlayerGroup();
				if (iGroupIndex != -1)
				{
					int iQueuePoints = g_iPlayerQueuePoints[param1];
				
					char sGroupName[64];
					Format(sGroupName, sizeof(sGroupName), "Group %d", iGroupIndex);
					SetPlayerGroupName(iGroupIndex, sGroupName);
					ClientSetPlayerGroup(param1, iGroupIndex);
					SetPlayerGroupLeader(iGroupIndex, param1);
					SetPlayerGroupQueuePoints(iGroupIndex, iQueuePoints);
					
					CPrintToChat(param1, "%T", "SF2 Created Group", param1, sGroupName);
				}
				else
				{
					CPrintToChat(param1, "%T", "SF2 Max Groups Reached", param1);
				}
			}
		}
		
		DisplayGroupMainMenuToClient(param1);
	}
}

void DisplayLeaveGroupMenuToClient(int client)
{
	int iGroupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(iGroupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayGroupMainMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}
	
	char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	GetPlayerGroupName(iGroupIndex, sGroupName, sizeof(sGroupName));
	
	Handle hMenu = CreateMenu(Menu_LeaveGroup);
	SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Leave Group Menu Title", client, "SF2 Leave Group Menu Description", client, sGroupName);
	
	char sBuffer[256];
	Format(sBuffer, sizeof(sBuffer), "%T", "Yes", client);
	AddMenuItem(hMenu, "0", sBuffer);
	Format(sBuffer, sizeof(sBuffer), "%T", "No", client);
	AddMenuItem(hMenu, "0", sBuffer);
	
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
}

public int Menu_LeaveGroup(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Select)
	{
		if (param2 == 0)
		{
			int iGroupIndex = ClientGetPlayerGroup(param1);
			if (!IsPlayerGroupActive(iGroupIndex))
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
}

void DisplayAdminGroupMenuToClient(int client)
{
	int iGroupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(iGroupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayGroupMainMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}
	
	char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	GetPlayerGroupName(iGroupIndex, sGroupName, sizeof(sGroupName));
	
	char sLeaderName[MAX_NAME_LENGTH];
	int iGroupLeader = GetPlayerGroupLeader(iGroupIndex);
	if (IsValidClient(iGroupLeader)) FormatEx(sLeaderName, sizeof(sLeaderName), "%N", iGroupLeader);
	else strcopy(sLeaderName, sizeof(sLeaderName), "---");
	
	int iMemberCount = GetPlayerGroupMemberCount(iGroupIndex);
	int iMaxPlayers = GetMaxPlayersForRound();
	int iQueuePoints = GetPlayerGroupQueuePoints(iGroupIndex);
	
	Handle hMenu = CreateMenu(Menu_AdminGroup);
	SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Admin Group Menu Title", client, "SF2 Admin Group Menu Description", client, sGroupName, sLeaderName, iMemberCount, iMaxPlayers, iQueuePoints);
	
	char sBuffer[256];
	Format(sBuffer, sizeof(sBuffer), "%T", "SF2 View Group Members Menu Title", client);
	AddMenuItem(hMenu, "0", sBuffer);
	Format(sBuffer, sizeof(sBuffer), "%T", "SF2 Set Group Name Menu Title", client);
	AddMenuItem(hMenu, "0", sBuffer, iGroupLeader == client ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	Format(sBuffer, sizeof(sBuffer), "%T", "SF2 Set Group Leader Menu Title", client);
	AddMenuItem(hMenu, "0", sBuffer, iGroupLeader == client ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	Format(sBuffer, sizeof(sBuffer), "%T", "SF2 Invite To Group Menu Title", client);
	AddMenuItem(hMenu, "0", sBuffer, iGroupLeader == client && iMemberCount < iMaxPlayers ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	Format(sBuffer, sizeof(sBuffer), "%T", "SF2 Kick From Group Menu Title", client);
	AddMenuItem(hMenu, "0", sBuffer, iGroupLeader == client && iMemberCount > 1 ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	Format(sBuffer, sizeof(sBuffer), "%T", "SF2 Reset Group Queue Points Menu Title", client);
	AddMenuItem(hMenu, "0", sBuffer, iGroupLeader == client ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
	
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
}

public int Menu_AdminGroup(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack) DisplayGroupMainMenuToClient(param1);
	}
	else if (action == MenuAction_Select)
	{
		int iGroupIndex = ClientGetPlayerGroup(param1);
		if (IsPlayerGroupActive(iGroupIndex))
		{
			switch (param2)
			{
				case 0: DisplayViewGroupMembersMenuToClient(param1);
				case 1: DisplaySetGroupNameMenuToClient(param1);
				case 2: DisplaySetGroupLeaderMenuToClient(param1);
				case 3: DisplayInviteToGroupMenuToClient(param1);
				case 4: DisplayKickFromGroupMenuToClient(param1);
				case 5: DisplayResetGroupQueuePointsMenuToClient(param1);
			}
		}
		else
		{
			DisplayGroupMainMenuToClient(param1);
			CPrintToChat(param1, "%T", "SF2 Group Does Not Exist", param1);
		}
	}
}

void DisplayViewGroupMembersMenuToClient(int client)
{
	int iGroupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(iGroupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}
	
	Handle hPlayers = CreateArray();
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		
		int iTempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(iTempGroup) || iTempGroup != iGroupIndex) continue;
		
		PushArrayCell(hPlayers, i);
	}
	
	int iPlayerCount = GetArraySize(hPlayers);
	if (iPlayerCount)
	{
		Handle hMenu = CreateMenu(Menu_ViewGroupMembers);
		SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 View Group Members Menu Title", client, "SF2 View Group Members Menu Description", client);
		
		char sUserId[32];
		char sName[MAX_NAME_LENGTH];
		
		for (int i = 0; i < iPlayerCount; i++)
		{
			int iClient = GetArrayCell(hPlayers, i);
			FormatEx(sUserId, sizeof(sUserId), "%d", GetClientUserId(iClient));
			FormatEx(sName, sizeof(sName), "%N", iClient);
			AddMenuItem(hMenu, sUserId, sName);
		}
		
		SetMenuExitBackButton(hMenu, true);
		DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players left for the taking!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 No Players Available", client);
	}
	
	delete hPlayers;
}

public int Menu_ViewGroupMembers(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack) DisplayAdminGroupMenuToClient(param1);
	}
	else if (action == MenuAction_Select) DisplayAdminGroupMenuToClient(param1);
}

void DisplaySetGroupLeaderMenuToClient(int client)
{
	int iGroupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(iGroupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}
	
	if (GetPlayerGroupLeader(iGroupIndex) != client)
	{
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Not Group Leader", client);
		return;
	}
	
	Handle hPlayers = CreateArray();
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		
		int iTempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(iTempGroup) || iTempGroup != iGroupIndex) continue;
		if (i == client) continue;
		
		PushArrayCell(hPlayers, i);
	}
	
	int iPlayerCount = GetArraySize(hPlayers);
	if (iPlayerCount)
	{
		Handle hMenu = CreateMenu(Menu_SetGroupLeader);
		SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Set Group Leader Menu Title", client, "SF2 Set Group Leader Menu Description", client);
		
		char sUserId[32];
		char sName[MAX_NAME_LENGTH];
		
		for (int i = 0; i < iPlayerCount; i++)
		{
			int iClient = GetArrayCell(hPlayers, i);
			FormatEx(sUserId, sizeof(sUserId), "%d", GetClientUserId(iClient));
			FormatEx(sName, sizeof(sName), "%N", iClient);
			AddMenuItem(hMenu, sUserId, sName);
		}
		
		SetMenuExitBackButton(hMenu, true);
		DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players left for the taking!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 No Players Available", client);
	}
	
	delete hPlayers;
}

public int Menu_SetGroupLeader(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack) DisplayAdminGroupMenuToClient(param1);
	}
	else if (action == MenuAction_Select)
	{
		int iGroupIndex = ClientGetPlayerGroup(param1);
		if (IsPlayerGroupActive(iGroupIndex) && GetPlayerGroupLeader(iGroupIndex) == param1)
		{
			char sInfo[64];
			GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
			int userid = StringToInt(sInfo);
			int iPlayer = GetClientOfUserId(userid);
			
			if (ClientGetPlayerGroup(iPlayer) == iGroupIndex && IsValidClient(iPlayer))
			{
				char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
				char sName[MAX_NAME_LENGTH];
				GetPlayerGroupName(iGroupIndex, sGroupName, sizeof(sGroupName));
				Format(sName, sizeof(sName), "%N", iPlayer);
				
				SetPlayerGroupLeader(iGroupIndex, iPlayer);
			}
			else
			{
				CPrintToChat(param1, "%T", "SF2 Player Not In Group", param1);
			}
		}
		
		DisplayAdminGroupMenuToClient(param1);
	}
}

void DisplayKickFromGroupMenuToClient(int client)
{
	int iGroupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(iGroupIndex))
	{
		// His group isn't valid anymore. Take him back to the main menu.
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}
	
	if (GetPlayerGroupLeader(iGroupIndex) != client)
	{
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Not Group Leader", client);
		return;
	}
	
	Handle hPlayers = CreateArray();
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		
		int iTempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(iTempGroup) || iTempGroup != iGroupIndex) continue;
		if (i == client) continue;
		
		PushArrayCell(hPlayers, i);
	}
	
	int iPlayerCount = GetArraySize(hPlayers);
	if (iPlayerCount)
	{
		Handle hMenu = CreateMenu(Menu_KickFromGroup);
		SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Kick From Group Menu Title", client, "SF2 Kick From Group Menu Description", client);
		
		char sUserId[32];
		char sName[MAX_NAME_LENGTH];
		
		for (int i = 0; i < iPlayerCount; i++)
		{
			int iClient = GetArrayCell(hPlayers, i);
			FormatEx(sUserId, sizeof(sUserId), "%d", GetClientUserId(iClient));
			FormatEx(sName, sizeof(sName), "%N", iClient);
			AddMenuItem(hMenu, sUserId, sName);
		}
		
		SetMenuExitBackButton(hMenu, true);
		DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players left for the taking!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 No Players Available", client);
	}
	
	delete hPlayers;
}

public int Menu_KickFromGroup(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack) DisplayAdminGroupMenuToClient(param1);
	}
	else if (action == MenuAction_Select)
	{
		int iGroupIndex = ClientGetPlayerGroup(param1);
		if (IsPlayerGroupActive(iGroupIndex) && GetPlayerGroupLeader(iGroupIndex) == param1)
		{
			char sInfo[64];
			GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
			int userid = StringToInt(sInfo);
			int iPlayer = GetClientOfUserId(userid);
			
			if (ClientGetPlayerGroup(iPlayer) == iGroupIndex)
			{
				char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
				char sName[MAX_NAME_LENGTH];
				GetPlayerGroupName(iGroupIndex, sGroupName, sizeof(sGroupName));
				FormatEx(sName, sizeof(sName), "%N", iPlayer);
				
				CPrintToChat(iPlayer, "%T", "SF2 Kicked From Group", iPlayer, sGroupName);
				ClientSetPlayerGroup(iPlayer, -1);
				CPrintToChat(param1, "%T", "SF2 Player Kicked From Group", param1, sName);
			}
			else
			{
				CPrintToChat(param1, "%T", "SF2 Player Not In Group", param1);
			}
		}
		
		DisplayKickFromGroupMenuToClient(param1);
	}
}

void DisplaySetGroupNameMenuToClient(int client)
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
	
	Handle hMenu = CreateMenu(Menu_SetGroupName);
	SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Set Group Name Menu Title", client, "SF2 Set Group Name Menu Description", client);
	
	char sBuffer[256];
	Format(sBuffer, sizeof(sBuffer), "%T", "Back", client);
	AddMenuItem(hMenu, "0", sBuffer);
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
}

public int Menu_SetGroupName(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack) DisplayAdminGroupMenuToClient(param1);
	}
	else if (action == MenuAction_Select) DisplayAdminGroupMenuToClient(param1);
}

void DisplayInviteToGroupMenuToClient(int client)
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
	
	if (GetPlayerGroupMemberCount(iGroupIndex) >= GetMaxPlayersForRound())
	{
		// His group is full!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 Group Is Full", client);
		return;
	}
	
	Handle hPlayers = CreateArray();
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsClientParticipating(i)) continue;
		
		int iTempGroup = ClientGetPlayerGroup(i);
		if (IsPlayerGroupActive(iTempGroup)) continue;
		if (!g_bPlayerEliminated[i]) continue;
		
		PushArrayCell(hPlayers, i);
	}
	
	int iPlayerCount = GetArraySize(hPlayers);
	if (iPlayerCount)
	{
		Handle hMenu = CreateMenu(Menu_InviteToGroup);
		SetMenuTitle(hMenu, "%t%T\n \n%T\n \n", "SF2 Prefix", "SF2 Invite To Group Menu Title", client, "SF2 Invite To Group Menu Description", client);
		
		char sUserId[32];
		char sName[MAX_NAME_LENGTH];
		
		for (int i = 0; i < iPlayerCount; i++)
		{
			int iClient = GetArrayCell(hPlayers, i);
			FormatEx(sUserId, sizeof(sUserId), "%d", GetClientUserId(iClient));
			FormatEx(sName, sizeof(sName), "%N", iClient);
			AddMenuItem(hMenu, sUserId, sName);
		}
		
		SetMenuExitBackButton(hMenu, true);
		DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players left for the taking!
		DisplayAdminGroupMenuToClient(client);
		CPrintToChat(client, "%T", "SF2 No Players Available", client);
	}
	
	delete hPlayers;
}

public int Menu_InviteToGroup(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End) CloseHandle(menu);
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack) DisplayAdminGroupMenuToClient(param1);
	}
	else if (action == MenuAction_Select)
	{
		int iGroupIndex = ClientGetPlayerGroup(param1);
		if (IsPlayerGroupActive(iGroupIndex) && GetPlayerGroupLeader(iGroupIndex) == param1)
		{
			char sInfo[64];
			GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
			int userid = StringToInt(sInfo);
			int iInvitedPlayer = GetClientOfUserId(userid);
			SendPlayerGroupInvitation(iInvitedPlayer, GetPlayerGroupID(iGroupIndex), param1);
		}
		
		DisplayInviteToGroupMenuToClient(param1);
	}
}