#if defined _sf2_adminmenu_included
 #endinput
#endif
#define _sf2_adminmenu_included

#pragma semicolon 1

static Handle g_TopMenu = null;
static int g_PlayerAdminMenuTargetUserId[MAXTF2PLAYERS] = { -1, ... };
static SF2NPC_Chaser g_SelectedBoss[MAXTF2PLAYERS];

void SetupAdminMenu()
{
	g_OnAdminMenuCreateOptionsPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	/* Account for late loading */
	Handle topMenuHndl = null;
	if (LibraryExists("adminmenu") && ((topMenuHndl = GetAdminTopMenu()) != null))
	{
		TopMenu topMenu = TopMenu.FromHandle(topMenuHndl);

		if (topMenu == g_TopMenu)
		{
			return;
		}

		g_TopMenu = topMenu;

		TopMenuObject commands = topMenu.FindCategory("SF2Commands");
		if (commands == INVALID_TOPMENUOBJECT)
		{
			commands = topMenu.AddCategory("SF2Commands", AdminTopMenu_Main);
		}

		if (commands != INVALID_TOPMENUOBJECT)
		{
			topMenu.AddItem("sf2_boss_admin_main", AdminTopMenu_BossMain, commands, "sm_sf2_add_boss", ADMFLAG_SLAY);
			topMenu.AddItem("sf2_player_setplaystate", AdminTopMenu_PlayerSetPlayState, commands, "sm_sf2_setplaystate", ADMFLAG_SLAY);
			topMenu.AddItem("sf2_player_force_proxy", AdminTopMenu_PlayerForceProxy, commands, "sm_sf2_force_proxy", ADMFLAG_SLAY);
		}
	}
}

static void AdminTopMenu_Main(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	if (action == TopMenuAction_DisplayTitle)
	{
		FormatEx(buffer, maxlength, "%T:", "SF2 Admin Menu Title", param);
	}
	else if (action == TopMenuAction_DisplayOption)
	{
		FormatEx(buffer, maxlength, "%T", "SF2 Admin Menu Title", param);
	}
}

static void DisplayPlayerForceProxyAdminMenu(int client)
{
	Menu menuHandle = new Menu(AdminMenu_PlayerForceProxy);
	menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Force Proxy", client);
	AddTargetsToMenu(menuHandle, client);
	menuHandle.ExitBackButton = true;
	menuHandle.Display(client, MENU_TIME_FOREVER);
}

static int AdminTopMenu_PlayerForceProxy(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	if (action == TopMenuAction_DisplayOption)
	{
		FormatEx(buffer, maxlength, "%t %T", "SF2 Prefix", "SF2 Admin Menu Player Force Proxy", param);
	}
	else if (action == TopMenuAction_SelectOption)
	{
		DisplayPlayerForceProxyAdminMenu(param);
	}
	return 0;
}

static int AdminMenu_PlayerForceProxy(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, userId, sizeof(userId));

		int client = GetClientOfUserId(StringToInt(userId));
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
			DisplayPlayerForceProxyAdminMenu(param1);
		}
		else
		{
			g_PlayerAdminMenuTargetUserId[param1] = StringToInt(userId);

			char name[MAX_NAME_LENGTH];
			FormatEx(name, sizeof(name), "%N", client);

			Menu menuHandle = new Menu(AdminMenu_PlayerForceProxyBoss);
			if (!AddBossTargetsToMenu(menuHandle))
			{
				delete menuHandle;
				DisplayTopMenu(g_TopMenu, param1, TopMenuPosition_LastCategory);
				CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 No Active Bosses", param1);
			}
			else
			{
				menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Force Proxy Boss", param1, name);
				menuHandle.ExitBackButton = true;
				menuHandle.Display(param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}

static int AdminMenu_PlayerForceProxyBoss(Menu menu, MenuAction action, int param1, int param2)
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
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
		}
		else
		{
			char id[64];
			menu.GetItem(param2, id, sizeof(id));
			int index = NPCGetFromUniqueID(StringToInt(id));
			if (index == -1)
			{
				CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
			}
			else
			{
				if (!(NPCGetFlags(index) & SFF_PROXIES) ||
					g_SlenderCopyMaster[index] != -1)
				{
					CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Not Allowed To Have Proxies", param1);
				}
				else if (!g_PlayerEliminated[client])
				{
					CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Player In Game", param1);
				}
				else if (g_PlayerProxy[param1])
				{
					CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Player Already A Proxy", param1);
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
	Menu menuHandle = new Menu(AdminMenu_PlayerSetPlayState);
	menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Set Play State", client);
	AddTargetsToMenu(menuHandle, client);
	menuHandle.ExitBackButton = true;
	menuHandle.Display(client, MENU_TIME_FOREVER);
}

static int AdminTopMenu_PlayerSetPlayState(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	if (action == TopMenuAction_DisplayOption)
	{
		FormatEx(buffer, maxlength, "%t %T", "SF2 Prefix", "SF2 Admin Menu Player Set Play State", param);
	}
	else if (action == TopMenuAction_SelectOption)
	{
		DisplayPlayerSetPlayStateAdminMenu(param);
	}
	return 0;
}

static int AdminMenu_PlayerSetPlayState(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, userId, sizeof(userId));
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

			Menu menuHandle = new Menu(AdminMenu_PlayerSetPlayStateConfirm);
			menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Set Play State Confirm", param1, name);
			char buffer[256];
			FormatEx(buffer, sizeof(buffer), "%T", "SF2 In", param1);
			menuHandle.AddItem(userId, buffer);
			FormatEx(buffer, sizeof(buffer), "%T", "SF2 Out", param1);
			menuHandle.AddItem(userId, buffer);
			menuHandle.ExitBackButton = true;
			menuHandle.Display(param1, MENU_TIME_FOREVER);
		}
	}
	return 0;
}

static int AdminMenu_PlayerSetPlayStateConfirm(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, userId, sizeof(userId));
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
	Menu menuHandle = new Menu(AdminMenu_BossMain);
	menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Main", client);

	char buffer[512];
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Add Boss", client);
	menuHandle.AddItem("add_boss", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Add Fake Boss", client);
	menuHandle.AddItem("add_boss_fake", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Remove Boss", client);
	menuHandle.AddItem("remove_boss", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Spawn Boss", client);
	menuHandle.AddItem("spawn_boss", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Boss Attack Waiters", client);
	menuHandle.AddItem("boss_attack_waiters", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Boss Teleport", client);
	menuHandle.AddItem("boss_no_teleport", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "SF2 Admin Menu Override Boss", client);
	menuHandle.AddItem("override_boss", buffer);
	FormatEx(buffer, sizeof(buffer), "Make a boss wander to aimed position");
	menuHandle.AddItem("force_wander", buffer);
	FormatEx(buffer, sizeof(buffer), "Make a boss alerted to aimed position");
	menuHandle.AddItem("force_alert", buffer);
	FormatEx(buffer, sizeof(buffer), "Make a boss use a attack");
	menuHandle.AddItem("force_attack", buffer);

	menuHandle.ExitBackButton = true;
	menuHandle.Display(client, MENU_TIME_FOREVER);
}

static int AdminMenu_BossMain(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, info, sizeof(info));
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
		else if (strcmp(info, "force_wander") == 0)
		{
			DisplayBossWanderAdminMenu(param1);
		}
		else if (strcmp(info, "force_alert") == 0)
		{
			DisplayBossAlertAdminMenu(param1);
		}
		else if (strcmp(info, "force_attack") == 0)
		{
			DisplayBossAttackAdminMenu(param1);
		}
	}
	return 0;
}

static int AdminTopMenu_BossMain(TopMenu topmenu, TopMenuAction action, TopMenuObject object_id, int param, char[] buffer, int maxlength)
{
	if (action == TopMenuAction_DisplayOption)
	{
		FormatEx(buffer, maxlength, "%t %T", "SF2 Prefix", "SF2 Admin Menu Boss Main", param);
	}
	else if (action == TopMenuAction_SelectOption)
	{
		DisplayBossMainAdminMenu(param);
	}
	return 0;
}

static void AddAllBossesToMenu(Menu menu)
{
	ArrayList bossList = GetBossProfileList();
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
		SF2BossProfileData data;
		g_BossProfileData.GetArray(profile, data, sizeof(data));
		if (data.IsPvEBoss)
		{
			continue;
		}
		menu.AddItem(profile, displayName);
	}
}

static bool DisplayAddBossAdminMenu(int client) //Use for view boss list
{
	ArrayList bossList = GetBossProfileList();
	if (bossList != null)
	{
		Menu menuHandle = new Menu(AdminMenu_AddBoss);
		menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Add Boss", client);

		AddAllBossesToMenu(menuHandle);

		menuHandle.ExitBackButton = true;

		menuHandle.Display(client, MENU_TIME_FOREVER);

		return true;
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_AddBoss(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, profile, sizeof(profile));

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
		Menu menuHandle = new Menu(AdminMenu_AddFakeBoss);
		menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Add Fake Boss", client);

		AddAllBossesToMenu(menuHandle);

		menuHandle.ExitBackButton = true;

		menuHandle.Display(client, MENU_TIME_FOREVER);

		return true;
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_AddFakeBoss(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, profile, sizeof(profile));

		FakeClientCommand(param1, "sm_sf2_add_boss_fake %s", profile);

		DisplayAddFakeBossAdminMenu(param1);
	}
	return 0;
}

static int AddBossTargetsToMenu(Menu menuHandle)
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

		SF2BossProfileData data;
		data = NPCGetProfileData(i);

		if (data.IsPvEBoss)
		{
			continue;
		}

		FormatEx(info, sizeof(info), "%d", uniqueID);

		menuHandle.AddItem(info, display);
		count++;
	}

	return count;
}

static bool DisplayRemoveBossAdminMenu(int client)
{
	if (GetBossProfileList() != null)
	{
		Menu menuHandle = new Menu(AdminMenu_RemoveBoss);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Remove Boss", client);
			menuHandle.ExitBackButton = true;
			menuHandle.Display(client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_RemoveBoss(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
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
		Menu menuHandle = new Menu(AdminMenu_SpawnBoss);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Spawn Boss", client);
			menuHandle.ExitBackButton = true;
			menuHandle.Display(client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_SpawnBoss(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
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
		Menu menuHandle = new Menu(AdminMenu_BossAttackWaiters);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Attack Waiters", client);
			menuHandle.ExitBackButton = true;
			menuHandle.Display(client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_BossAttackWaiters(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
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

			Menu menuHandle = new Menu(AdminMenu_BossAttackWaitersConfirm);
			menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Attack Waiters Confirm", param1, name);
			char buffer[256];
			FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
			menuHandle.AddItem(id, buffer);
			FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
			menuHandle.AddItem(id, buffer);
			menuHandle.ExitBackButton = true;
			menuHandle.Display(param1, MENU_TIME_FOREVER);
		}
	}
	return 0;
}

static int AdminMenu_BossAttackWaitersConfirm(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
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
		Menu menuHandle = new Menu(AdminMenu_BossTeleport);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Teleport", client);
			menuHandle.ExitBackButton = true;
			menuHandle.Display(client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_BossTeleport(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
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

			Menu menuHandle = new Menu(AdminMenu_BossTeleportConfirm);
			menuHandle.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Teleport Confirm", param1, name);
			char buffer[256];
			FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
			menuHandle.AddItem(id, buffer);
			FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
			menuHandle.AddItem(id, buffer);
			menuHandle.ExitBackButton = true;
			menuHandle.Display(param1, MENU_TIME_FOREVER);
		}
	}
	return 0;
}

static int AdminMenu_BossTeleportConfirm(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
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
		Menu menuHandle = new Menu(AdminMenu_OverrideBoss);

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
			SF2BossProfileData data;
			g_BossProfileData.GetArray(profile, data, sizeof(data));
			if (data.IsPvEBoss)
			{
				continue;
			}
			menuHandle.AddItem(profile, displayName);
		}

		menuHandle.ExitBackButton = true;

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

		menuHandle.SetTitle("%t %T\n%T\n \n", "SF2 Prefix", "SF2 Admin Menu Override Boss", client, "SF2 Admin Menu Current Boss Override", client, profileDisplayName);

		menuHandle.Display(client, MENU_TIME_FOREVER);

		return true;
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_OverrideBoss(Menu menu, MenuAction action, int param1, int param2)
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
		char profile[SF2_MAX_PROFILE_NAME_LENGTH], name[SF2_MAX_NAME_LENGTH];
		menu.GetItem(param2, profile, sizeof(profile));

		g_BossProfileOverrideConVar.SetString(profile);

		ArrayList arrayNames;
		arrayNames = GetBossProfileNames(profile);
		arrayNames.GetString(Difficulty_Normal, name, sizeof(name));

		CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next boss to {valve}%s{default}.", "SF2 Prefix", param1, name);

		DisplayOverrideBossAdminMenu(param1);
	}
	return 0;
}

static bool DisplayBossWanderAdminMenu(int client)
{
	if (GetBossProfileList() != null)
	{
		Menu menuHandle = new Menu(AdminMenu_BossWanderToPos);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			menuHandle.SetTitle("%t Make a boss wander to aimed position\n \n", "SF2 Prefix");
			menuHandle.ExitBackButton = true;
			menuHandle.Display(client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_BossWanderToPos(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			int entity = NPCGetEntIndex(index);
			if (!entity || entity == INVALID_ENT_REFERENCE)
			{
				CPrintToChat(param1, "{royalblue}%t {default}That boss is not on the map!", "SF2 Prefix");
			}
			else
			{
				SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(index);
				switch (npc.Type)
				{
					case SF2BossType_Chaser:
					{
						SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
						if (chaser.State != STATE_IDLE)
						{
							CPrintToChat(param1, "{royalblue}%t {default}That boss is not idling!", "SF2 Prefix");
						}
						else
						{
							SF2_BasePlayer admin = SF2_BasePlayer(param1);
							float eyePos[3], eyeAng[3], endPos[3];
							admin.GetEyePosition(eyePos);
							admin.GetEyeAngles(eyeAng);

							Handle trace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, admin.index);
							TR_GetEndPosition(endPos, trace);
							delete trace;

							TE_SetupBeamRingPoint(endPos, 10.0, 375.0, g_ShockwaveBeam, g_ShockwaveHalo, 0, 15, 0.5, 5.0, 0.0, ( { 128, 128, 128, 255 } ), 10, 0);
							TE_SendToClient(admin.index);

							TE_SetupBeamRingPoint(endPos, 10.0, 375.0, g_ShockwaveBeam, g_ShockwaveHalo, 0, 10, 0.6, 10.0, 0.5, ( { 0, 255, 0, 255 } ), 10, 0);
							TE_SendToClient(admin.index);

							EmitSoundToClient(admin.index, g_DebugBeamSound);

							chaser.SetForceWanderPosition(endPos);
							chaser.DebugShouldGoToPos = true;
						}
					}
					case SF2BossType_Statue:
					{

					}
				}
			}
		}

		DisplayBossWanderAdminMenu(param1);
	}
	return 0;
}

static bool DisplayBossAlertAdminMenu(int client)
{
	if (GetBossProfileList() != null)
	{
		Menu menuHandle = new Menu(AdminMenu_BossAlertToPos);
		if (!AddBossTargetsToMenu(menuHandle))
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			menuHandle.SetTitle("%t Make a boss alert to aimed position\n \n", "SF2 Prefix");
			menuHandle.ExitBackButton = true;
			menuHandle.Display(client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_BossAlertToPos(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = NPCGetFromUniqueID(StringToInt(id));
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			int entity = NPCGetEntIndex(index);
			if (!entity || entity == INVALID_ENT_REFERENCE)
			{
				CPrintToChat(param1, "{royalblue}%t {default}That boss is not on the map!", "SF2 Prefix");
			}
			else
			{
				SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(index);
				switch (npc.Type)
				{
					case SF2BossType_Chaser:
					{
						SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
						if (chaser.State != STATE_IDLE && chaser.State != STATE_ALERT)
						{
							CPrintToChat(param1, "{royalblue}%t {default}That boss is busy right now!", "SF2 Prefix");
						}
						else
						{
							SF2_BasePlayer admin = SF2_BasePlayer(param1);
							float eyePos[3], eyeAng[3], endPos[3];
							admin.GetEyePosition(eyePos);
							admin.GetEyeAngles(eyeAng);

							Handle trace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, admin.index);
							TR_GetEndPosition(endPos, trace);
							delete trace;

							TE_SetupBeamRingPoint(endPos, 10.0, 375.0, g_ShockwaveBeam, g_ShockwaveHalo, 0, 15, 0.5, 5.0, 0.0, ( { 128, 128, 128, 255 } ), 10, 0);
							TE_SendToClient(admin.index);

							TE_SetupBeamRingPoint(endPos, 10.0, 375.0, g_ShockwaveBeam, g_ShockwaveHalo, 0, 10, 0.6, 10.0, 0.5, ( { 255, 0, 0, 255 } ), 10, 0);
							TE_SendToClient(admin.index);

							EmitSoundToClient(admin.index, g_DebugBeamSound);

							chaser.SetForceWanderPosition(endPos);
							chaser.InterruptConditions |= COND_DEBUG;
						}
					}
					case SF2BossType_Statue:
					{
						CPrintToChat(param1, "{royalblue}%t {default}That boss is not a chaser!", "SF2 Prefix");
					}
				}
			}
		}

		DisplayBossAlertAdminMenu(param1);
	}
	return 0;
}

static bool DisplayBossAttackAdminMenu(int client)
{
	if (GetBossProfileList() != null)
	{
		Menu menuHandle = new Menu(AdminMenu_BossAttack);
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

			if (NPCGetType(i) != SF2BossType_Chaser)
			{
				continue;
			}
			SF2NPC_Chaser controller = SF2NPC_Chaser(i);

			SF2ChaserBossProfileData chaserData;
			chaserData = controller.GetProfileData();
			if (chaserData.Attacks == null || chaserData.Attacks.Length == 0)
			{
				continue;
			}

			controller.GetProfile(profile, sizeof(profile));
			controller.GetName(buffer, sizeof(buffer));
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

			SF2BossProfileData data;
			data = NPCGetProfileData(i);

			if (data.IsPvEBoss)
			{
				StrCat(display, sizeof(display), " (PvE)");
			}

			FormatEx(info, sizeof(info), "%d", i);

			menuHandle.AddItem(info, display);
			count++;
		}

		if (count <= 0)
		{
			delete menuHandle;
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
		}
		else
		{
			menuHandle.SetTitle("%t Make a boss use a attack\n \n", "SF2 Prefix");
			menuHandle.ExitBackButton = true;
			menuHandle.Display(client, MENU_TIME_FOREVER);
			return true;
		}
	}

	DisplayBossMainAdminMenu(client);
	return false;
}

static int AdminMenu_BossAttack(Menu menu, MenuAction action, int param1, int param2)
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
		menu.GetItem(param2, id, sizeof(id));
		int index = StringToInt(id);
		if (index == -1)
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			int entity = NPCGetEntIndex(index);
			if (!entity || entity == INVALID_ENT_REFERENCE)
			{
				CPrintToChat(param1, "{royalblue}%t {default}That boss is not on the map!", "SF2 Prefix");
			}
			else
			{
				SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
				if (chaser.State != STATE_IDLE && chaser.State != STATE_ALERT && chaser.State != STATE_CHASE)
				{
					CPrintToChat(param1, "{royalblue}%t {default}That boss is busy right now!", "SF2 Prefix");
				}
				else
				{
					g_SelectedBoss[param1] = SF2NPC_Chaser(index);
					DisplayBossAttackListAdminMenu(param1);
					return 0;
				}
			}
		}

		DisplayBossAttackAdminMenu(param1);
	}
	return 0;
}

static bool DisplayBossAttackListAdminMenu(int client)
{
	if (!g_SelectedBoss[client].IsValid())
	{
		CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", client);
		DisplayBossMainAdminMenu(client);
		return false;
	}

	SF2ChaserBossProfileData data;
	data = g_SelectedBoss[client].GetProfileData();
	Menu menuHandle = new Menu(AdminMenu_BossAttackList);
	for (int i = 0; i < data.Attacks.Length; i++)
	{
		SF2ChaserBossProfileAttackData attackData;
		data.GetAttackFromIndex(i, attackData);
		menuHandle.AddItem(attackData.Name, attackData.Name);
	}

	menuHandle.SetTitle("%t Make a boss use a attack\n \n", "SF2 Prefix");
	menuHandle.ExitBackButton = true;
	menuHandle.Display(client, MENU_TIME_FOREVER);
	return true;
}

static int AdminMenu_BossAttackList(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayBossAttackAdminMenu(param1);
		}
	}
	else if (action == MenuAction_Select)
	{
		char id[64];
		menu.GetItem(param2, id, sizeof(id));
		SF2NPC_Chaser npc = g_SelectedBoss[param1];
		if (!npc.IsValid())
		{
			CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			int entity = npc.EntIndex;
			if (!entity || entity == INVALID_ENT_REFERENCE)
			{
				CPrintToChat(param1, "{royalblue}%t {default}That boss is not on the map!", "SF2 Prefix");
			}
			else
			{
				SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
				if (chaser.State != STATE_IDLE && chaser.State != STATE_ALERT && chaser.State != STATE_CHASE)
				{
					CPrintToChat(param1, "{royalblue}%t {default}That boss is busy right now!", "SF2 Prefix");
				}
				else
				{
					char formatter[128];
					FormatEx(formatter, sizeof(formatter), "debug attack %s", id);
					chaser.MyNextBotPointer().GetIntentionInterface().OnCommandString(formatter);
				}
				DisplayBossAttackListAdminMenu(param1);
				return 0;
			}
		}

		DisplayBossAttackAdminMenu(param1);
	}
	return 0;
}
