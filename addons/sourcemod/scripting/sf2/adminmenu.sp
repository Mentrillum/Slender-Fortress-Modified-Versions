#if defined _sf2_adminmenu_included
 #endinput
#endif
#define _sf2_adminmenu_included

#pragma semicolon 1

static Handle g_TopMenu = null;
static int g_PlayerAdminMenuTargetUserId[MAXPLAYERS + 1] = { -1, ... };

void SetupAdminMenu()
{
	/* Account for late loading */
	Handle topMenu = null;
	if (LibraryExists("adminmenu") && ((topMenu = GetAdminTopMenu()) != null))
	{
		OnAdminMenuReady(topMenu);
	}
}

public void OnAdminMenuReady(Handle topMenu)
{
	if (topMenu == g_TopMenu)
	{
		return;
	}

	g_TopMenu = topMenu;

	TopMenuObject hServerCommands = FindTopMenuCategory(topMenu, ADMINMENU_SERVERCOMMANDS);
	if (hServerCommands != INVALID_TOPMENUOBJECT)
	{
		AddToTopMenu(topMenu, "sf2_boss_admin_main", TopMenuObject_Item, AdminTopMenu_BossMain, hServerCommands, "sm_sf2_add_boss", ADMFLAG_SLAY);
	}

	TopMenuObject hPlayerCommands = FindTopMenuCategory(topMenu, ADMINMENU_PLAYERCOMMANDS);
	if (hPlayerCommands != INVALID_TOPMENUOBJECT)
	{
		AddToTopMenu(topMenu, "sf2_player_setplaystate", TopMenuObject_Item, AdminTopMenu_PlayerSetPlayState, hPlayerCommands, "sm_sf2_setplaystate", ADMFLAG_SLAY);
		AddToTopMenu(topMenu, "sf2_player_force_proxy", TopMenuObject_Item, AdminTopMenu_PlayerForceProxy, hPlayerCommands, "sm_sf2_force_proxy", ADMFLAG_SLAY);
	}
	delete topMenu;
}

static void DisplayPlayerForceProxyAdminMenu(int client)
{
	Handle menuHandle = CreateMenu(AdminMenu_PlayerForceProxy);
	SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Force Proxy", client);
	AddTargetsToMenu(menuHandle, client);
	SetMenuExitBackButton(menuHandle, true);
	DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);
}

public int AdminTopMenu_PlayerForceProxy(Handle topmenu, TopMenuAction action, TopMenuObject object_id,int param, char[] buffer,int maxlength)
{
	if (action == TopMenuAction_DisplayOption)
	{
		FormatEx(buffer, maxlength, "%t%T", "SF2 Prefix", "SF2 Admin Menu Player Force Proxy", param);
	}
	else if (action == TopMenuAction_SelectOption)
	{
		DisplayPlayerForceProxyAdminMenu(param);
	}
	return 0;
}

public int AdminMenu_PlayerForceProxy(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack && g_TopMenu != null)
		{
			DisplayTopMenu(g_TopMenu, param1, TopMenuPosition_LastCategory);
		}
	}
	else if (action == MenuAction_Select)
	{
		char userId[64];
		GetMenuItem(menu, param2, userId, sizeof(userId));

		int client = GetClientOfUserId(StringToInt(userId));
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
			DisplayPlayerForceProxyAdminMenu(param1);
		}
		else
		{
			g_PlayerAdminMenuTargetUserId[param1] = StringToInt(userId);

			char name[MAX_NAME_LENGTH];
			FormatEx(name, sizeof(name), "%N", client);

			Handle menuHandle = CreateMenu(AdminMenu_PlayerForceProxyBoss);
			if (!AddBossTargetsToMenu(menuHandle))
			{
				delete menuHandle;
				DisplayTopMenu(g_TopMenu, param1, TopMenuPosition_LastCategory);
				CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", param1);
			}
			else
			{
				SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Force Proxy Boss", param1, name);
				SetMenuExitBackButton(menuHandle, true);
				DisplayMenu(menuHandle, param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}

public int AdminMenu_PlayerForceProxyBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayPlayerForceProxyAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		int client = GetClientOfUserId(g_PlayerAdminMenuTargetUserId[param1]);
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
		}
		else
		{
			char id[64];
			GetMenuItem(menu, param2, id, sizeof(id));
			int index = NPCGetFromUniqueID(StringToInt(id));
			if (index == -1)
			{
				CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
			}
			else
			{
				if (!(NPCGetFlags(index) & SFF_PROXIES) ||
					g_SlenderCopyMaster[index] != -1)
				{
					CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Not Allowed To Have Proxies", param1);
				}
				else if (!g_PlayerEliminated[client])
				{
					CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player In Game", param1);
				}
				else if (g_PlayerProxy[param1])
				{
					CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Already A Proxy", param1);
				}
				else
				{
					FakeClientCommand(param1, "sm_sf2_force_proxy #%d %d", g_PlayerAdminMenuTargetUserId[param1], index);
				}
			}
		}

		DisplayPlayerForceProxyAdminMenu(param1);
	}
	return 0;
}

static void DisplayPlayerSetPlayStateAdminMenu(int client)
{
	Handle menuHandle = CreateMenu(AdminMenu_PlayerSetPlayState);
	SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Set Play State", client);
	AddTargetsToMenu(menuHandle, client);
	SetMenuExitBackButton(menuHandle, true);
	DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);
}

public int AdminTopMenu_PlayerSetPlayState(Handle topmenu, TopMenuAction action, TopMenuObject object_id,int param, char[] buffer,int maxlength)
{
	if (action == TopMenuAction_DisplayOption)
	{
		FormatEx(buffer, maxlength, "%t%T", "SF2 Prefix", "SF2 Admin Menu Player Set Play State", param);
	}
	else if (action == TopMenuAction_SelectOption)
	{
		DisplayPlayerSetPlayStateAdminMenu(param);
	}
	return 0;
}

public int AdminMenu_PlayerSetPlayState(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack && g_TopMenu != null)
		{
			DisplayTopMenu(g_TopMenu, param1, TopMenuPosition_LastCategory);
		}
	}
	else if (action == MenuAction_Select)
	{
		char userId[64];
		GetMenuItem(menu, param2, userId, sizeof(userId));
		int client = GetClientOfUserId(StringToInt(userId));
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
			DisplayPlayerSetPlayStateAdminMenu(param1);
		}
		else
		{
			char name[MAX_NAME_LENGTH];
			FormatEx(name, sizeof(name), "%N", client);

			Handle menuHandle = CreateMenu(AdminMenu_PlayerSetPlayStateConfirm);
			SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Set Play State Confirm", param1, name);
			char buffer[256];
			FormatEx(buffer, sizeof(buffer), "%T", "SF2 In", param1);
			AddMenuItem(menuHandle, userId, buffer);
			FormatEx(buffer, sizeof(buffer), "%T", "SF2 Out", param1);
			AddMenuItem(menuHandle, userId, buffer);
			SetMenuExitBackButton(menuHandle, true);
			DisplayMenu(menuHandle, param1, MENU_TIME_FOREVER);
		}
	}
	return 0;
}

public int AdminMenu_PlayerSetPlayStateConfirm(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayPlayerSetPlayStateAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char userId[64];
		GetMenuItem(menu, param2, userId, sizeof(userId));
		int client = GetClientOfUserId(StringToInt(userId));
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
		}
		else
		{
			int userIdInt = StringToInt(userId);
			switch (param2)
			{
				case 0:
				{
					FakeClientCommand(param1, "sm_sf2_setplaystate #%d 1", userIdInt);
				}
				case 1:
				{
					FakeClientCommand(param1, "sm_sf2_setplaystate #%d 0", userIdInt);
				}
			}
		}

		DisplayPlayerSetPlayStateAdminMenu(param1);
	}
	return 0;
}

static void DisplayBossMainAdminMenu(int client)
{
	Handle menuHandle = CreateMenu(AdminMenu_BossMain);
	SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Main", client);

	char buffer[512];
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Add Boss", client);
	AddMenuItem(menuHandle, "add_boss", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Add Fake Boss", client);
	AddMenuItem(menuHandle, "add_boss_fake", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Remove Boss", client);
	AddMenuItem(menuHandle, "remove_boss", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Spawn Boss", client);
	AddMenuItem(menuHandle, "spawn_boss", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Boss Attack Waiters", client);
	AddMenuItem(menuHandle, "boss_attack_waiters", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Boss Teleport", client);
	AddMenuItem(menuHandle, "boss_no_teleport", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Override Boss", client);
	AddMenuItem(menuHandle, "override_boss", buffer);

	SetMenuExitBackButton(menuHandle, true);
	DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);
}

public int AdminMenu_BossMain(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack && g_TopMenu != null)
		{
			DisplayTopMenu(g_TopMenu, param1, TopMenuPosition_LastCategory);
		}
	}
	else if (action == MenuAction_Select)
	{
		char info[64];
		GetMenuItem(menu, param2, info, sizeof(info));
		if (strcmp(info, "add_boss") == 0)
		{
			DisplayAddBossAdminMenu(param1);
		}
		else if (strcmp(info, "add_boss_fake") == 0)
		{
			DisplayAddFakeBossAdminMenu(param1);
		}
		else if (strcmp(info, "remove_boss") == 0)
		{
			DisplayRemoveBossAdminMenu(param1);
		}
		else if (strcmp(info, "spawn_boss") == 0)
		{
			DisplaySpawnBossAdminMenu(param1);
		}
		else if (strcmp(info, "boss_attack_waiters") == 0)
		{
			DisplayBossAttackWaitersAdminMenu(param1);
		}
		else if (strcmp(info, "boss_no_teleport") == 0)
		{
			DisplayBossTeleportAdminMenu(param1);
		}
		else if (strcmp(info, "override_boss") == 0)
		{
			DisplayOverrideBossAdminMenu(param1);
		}
	}
	return 0;
}

public int AdminTopMenu_BossMain(Handle topmenu, TopMenuAction action, TopMenuObject object_id,int param, char[] buffer,int maxlength)
{
	if (action == TopMenuAction_DisplayOption)
	{
		FormatEx(buffer, maxlength, "%t%T", "SF2 Prefix", "SF2 Admin Menu Boss Main", param);
	}
	else if (action == TopMenuAction_SelectOption)
	{
		DisplayBossMainAdminMenu(param);
	}
	return 0;
}

static bool DisplayAddBossAdminMenu(int client) //Use for view boss list
{
	ArrayList bossList = GetBossProfileList();
	if (bossList != null)
	{
		Handle menuHandle = CreateMenu(AdminMenu_AddBoss);
		SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Add Boss", client);

		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		char displayName[SF2_MAX_NAME_LENGTH];

		for (int i = 0; i < bossList.Length; i++)
		{
			bossList.GetString(i, profile, sizeof(profile));
			NPCGetBossName(_, displayName, sizeof(displayName), profile);
			if (displayName[0] == '\0')
			{
				strcopy(displayName, sizeof(displayName), profile);
			}
			AddMenuItem(menuHandle, profile, displayName);
		}
		SetMenuExitBackButton(menuHandle, true);

		DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);

		return true;
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_AddBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossMainAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		GetMenuItem(menu, param2, profile, sizeof(profile));

		FakeClientCommand(param1, "sm_sf2_add_boss %s", profile);

		DisplayAddBossAdminMenu(param1);
	}
	return 0;
}

static bool DisplayAddFakeBossAdminMenu(int client)
{
	ArrayList bossList = GetBossProfileList();
	if (bossList != null)
	{
		Handle menuHandle = CreateMenu(AdminMenu_AddFakeBoss);
		SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Add Fake Boss", client);

		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		char displayName[SF2_MAX_NAME_LENGTH];

		for (int i = 0; i < bossList.Length; i++)
		{
			bossList.GetString(i, profile, sizeof(profile));
			NPCGetBossName(_, displayName, sizeof(displayName), profile);
			if (displayName[0] == '\0')
			{
				strcopy(displayName, sizeof(displayName), profile);
			}
			AddMenuItem(menuHandle, profile, displayName);
		}

		SetMenuExitBackButton(menuHandle, true);

		DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);

		return true;
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_AddFakeBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossMainAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		GetMenuItem(menu, param2, profile, sizeof(profile));

		FakeClientCommand(param1, "sm_sf2_add_boss_fake %s", profile);

		DisplayAddFakeBossAdminMenu(param1);
	}
	return 0;
}

static int AddBossTargetsToMenu(Handle menuHandle)
{
	char buffer[512];
	char display[512], info[64];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	int count;

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		int uniqueID = NPCGetUniqueID(i);
		if (uniqueID == -1)
		{
			continue;
		}

		NPCGetProfile(i, profile, sizeof(profile));

		NPCGetBossName(_, buffer, sizeof(buffer), profile);
		if (buffer[0] == '\0')
		{
			strcopy(buffer, sizeof(buffer), profile);
		}

		FormatEx(display, sizeof(display), "%d - %s", i, buffer);
		if (g_SlenderCopyMaster[i] != -1)
		{
			FormatEx(buffer, sizeof(buffer), " (copy of boss %d)", g_SlenderCopyMaster[i]);
			StrCat(display, sizeof(display), buffer);
		}

		if (NPCGetFlags(i) & SFF_FAKE)
		{
			StrCat(display, sizeof(display), " (fake)");
		}

		FormatEx(info, sizeof(info), "%d", uniqueID);

		AddMenuItem(menuHandle, info, display);
		count++;
	}

	return count;
}

static bool DisplayRemoveBossAdminMenu(int client)
{
	if (GetBossProfileList() != null)
	{
		Handle menuHandle = CreateMenu(AdminMenu_RemoveBoss);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Remove Boss", client);
			SetMenuExitBackButton(menuHandle, true);
			DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_RemoveBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossMainAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char id[64];
		GetMenuItem(menu, param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			FakeClientCommand(param1, "sm_sf2_remove_boss %d", index);
		}

		DisplayRemoveBossAdminMenu(param1);
	}
	return 0;
}

static bool DisplaySpawnBossAdminMenu(int client)
{
	if (GetBossProfileList() != null)
	{
		Handle menuHandle = CreateMenu(AdminMenu_SpawnBoss);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Spawn Boss", client);
			SetMenuExitBackButton(menuHandle, true);
			DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_SpawnBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossMainAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char id[64];
		GetMenuItem(menu, param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			FakeClientCommand(param1, "sm_sf2_spawn_boss %d", index);
		}

		DisplaySpawnBossAdminMenu(param1);
	}
	return 0;
}

static bool DisplayBossAttackWaitersAdminMenu(int client)
{
	if (GetBossProfileList() != null)
	{
		Handle menuHandle = CreateMenu(AdminMenu_BossAttackWaiters);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Attack Waiters", client);
			SetMenuExitBackButton(menuHandle, true);
			DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_BossAttackWaiters(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossMainAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char id[64];
		GetMenuItem(menu, param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
			DisplayBossAttackWaitersAdminMenu(param1);
		}
		else
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(index, profile, sizeof(profile));

			char name[SF2_MAX_NAME_LENGTH];
			NPCGetBossName(_, name, sizeof(name), profile);
			if (name[0] == '\0')
			{
				strcopy(name, sizeof(name), profile);
			}

			Handle menuHandle = CreateMenu(AdminMenu_BossAttackWaitersConfirm);
			SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Attack Waiters Confirm", param1, name);
			char buffer[256];
			FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
			AddMenuItem(menuHandle, id, buffer);
			FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
			AddMenuItem(menuHandle, id, buffer);
			SetMenuExitBackButton(menuHandle, true);
			DisplayMenu(menuHandle, param1, MENU_TIME_FOREVER);
		}
	}
	return 0;
}

public int AdminMenu_BossAttackWaitersConfirm(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossAttackWaitersAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char id[64];
		GetMenuItem(menu, param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			switch (param2)
			{
				case 0:
				{
					FakeClientCommand(param1, "sm_sf2_boss_attack_waiters %d 1", index);
				}
				case 1:
				{
					FakeClientCommand(param1, "sm_sf2_boss_attack_waiters %d 0", index);
				}
			}
		}

		DisplayBossAttackWaitersAdminMenu(param1);
	}
	return 0;
}

static bool DisplayBossTeleportAdminMenu(int client)
{
	if (GetBossProfileList() != null)
	{
		Handle menuHandle = CreateMenu(AdminMenu_BossTeleport);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Teleport", client);
			SetMenuExitBackButton(menuHandle, true);
			DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_BossTeleport(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossMainAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char id[64];
		GetMenuItem(menu, param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
			DisplayBossTeleportAdminMenu(param1);
		}
		else
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(index, profile, sizeof(profile));

			char name[SF2_MAX_NAME_LENGTH];
			NPCGetBossName(_, name, sizeof(name), profile);
			if (name[0] == '\0')
			{
				strcopy(name, sizeof(name), profile);
			}

			Handle menuHandle = CreateMenu(AdminMenu_BossTeleportConfirm);
			SetMenuTitle(menuHandle, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Teleport Confirm", param1, name);
			char buffer[256];
			FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
			AddMenuItem(menuHandle, id, buffer);
			FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
			AddMenuItem(menuHandle, id, buffer);
			SetMenuExitBackButton(menuHandle, true);
			DisplayMenu(menuHandle, param1, MENU_TIME_FOREVER);
		}
	}
	return 0;
}

public int AdminMenu_BossTeleportConfirm(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossTeleportAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char id[64];
		GetMenuItem(menu, param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			switch (param2)
			{
				case 0:
				{
					FakeClientCommand(param1, "sm_sf2_boss_no_teleport %d 0", index);
				}
				case 1:
				{
					FakeClientCommand(param1, "sm_sf2_boss_no_teleport %d 1", index);
				}
			}
		}

		DisplayBossTeleportAdminMenu(param1);
	}
	return 0;
}

static bool DisplayOverrideBossAdminMenu(int client)
{
	ArrayList bossList = GetBossProfileList();
	if (bossList != null)
	{
		Handle menuHandle = CreateMenu(AdminMenu_OverrideBoss);

		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		char displayName[SF2_MAX_NAME_LENGTH];

		for (int i = 0; i < bossList.Length; i++)
		{
			bossList.GetString(i, profile, sizeof(profile));
			NPCGetBossName(_, displayName, sizeof(displayName), profile);
			if (displayName[0] == '\0')
			{
				strcopy(displayName, sizeof(displayName), profile);
			}
			AddMenuItem(menuHandle, profile, displayName);
		}

		SetMenuExitBackButton(menuHandle, true);

		char profileOverride[SF2_MAX_PROFILE_NAME_LENGTH], profileDisplayName[SF2_MAX_PROFILE_NAME_LENGTH];
		g_BossProfileOverrideConVar.GetString(profileOverride, sizeof(profileOverride));

		if (profileOverride[0] != '\0' && IsProfileValid(profileOverride))
		{
			NPCGetBossName(_, profileDisplayName, sizeof(profileDisplayName), profileOverride);

			if (profileDisplayName[0] == '\0')
			{
				strcopy(profileDisplayName, sizeof(profileDisplayName), profileOverride);
			}
		}
		else
		{
			strcopy(profileDisplayName, sizeof(profileDisplayName), "---");
		}

		SetMenuTitle(menuHandle, "%t%T\n%T\n \n", "SF2 Prefix", "SF2 Admin Menu Override Boss", client, "SF2 Admin Menu Current Boss Override", client, profileDisplayName);

		DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);

		return true;
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_OverrideBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossMainAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		GetMenuItem(menu, param2, profile, sizeof(profile));

		FakeClientCommand(param1, "sm_cvar sf2_boss_profile_override %s", profile);

		DisplayOverrideBossAdminMenu(param1);
	}
	return 0;
}