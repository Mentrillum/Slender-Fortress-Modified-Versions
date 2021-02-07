#if defined _sf2_adminmenu_included
 #endinput
#endif
#define _sf2_adminmenu_included

static Handle g_hTopMenu = INVALID_HANDLE;
static int g_iPlayerAdminMenuTargetUserId[MAXPLAYERS + 1] = { -1, ... };

void SetupAdminMenu()
{
	/* Account for late loading */
	Handle hTopMenu = INVALID_HANDLE;
	if (LibraryExists("adminmenu") && ((hTopMenu = GetAdminTopMenu()) != INVALID_HANDLE))
	{
		OnAdminMenuReady(hTopMenu);
	}
}


public void OnAdminMenuReady(Handle hTopMenu)
{
	if (hTopMenu == g_hTopMenu) return;
	
	g_hTopMenu = hTopMenu;
	
	TopMenuObject hServerCommands = FindTopMenuCategory(hTopMenu, ADMINMENU_SERVERCOMMANDS);
	if (hServerCommands != INVALID_TOPMENUOBJECT)
	{
		AddToTopMenu(hTopMenu, "sf2_boss_admin_main", TopMenuObject_Item, AdminTopMenu_BossMain, hServerCommands, "sm_sf2_add_boss", ADMFLAG_SLAY);
	}
	
	TopMenuObject hPlayerCommands = FindTopMenuCategory(hTopMenu, ADMINMENU_PLAYERCOMMANDS);
	if (hPlayerCommands != INVALID_TOPMENUOBJECT)
	{
		AddToTopMenu(hTopMenu, "sf2_player_setplaystate", TopMenuObject_Item, AdminTopMenu_PlayerSetPlayState, hPlayerCommands, "sm_sf2_setplaystate", ADMFLAG_SLAY);
		AddToTopMenu(hTopMenu, "sf2_player_force_proxy", TopMenuObject_Item, AdminTopMenu_PlayerForceProxy, hPlayerCommands, "sm_sf2_force_proxy", ADMFLAG_SLAY);
	}
	delete hTopMenu;
}

static void DisplayPlayerForceProxyAdminMenu(int client)
{
	Handle hMenu = CreateMenu(AdminMenu_PlayerForceProxy);
	SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Force Proxy", client);
	AddTargetsToMenu(hMenu, client);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
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
}

public int AdminMenu_PlayerForceProxy(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack && g_hTopMenu != INVALID_HANDLE)
		{
			DisplayTopMenu(g_hTopMenu, param1, TopMenuPosition_LastCategory);
		}
	}
	else if (action == MenuAction_Select)
	{
		char sUserId[64];
		GetMenuItem(menu, param2, sUserId, sizeof(sUserId));
		
		int client = GetClientOfUserId(StringToInt(sUserId));
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
			DisplayPlayerForceProxyAdminMenu(param1);
		}
		else
		{
			g_iPlayerAdminMenuTargetUserId[param1] = StringToInt(sUserId);
		
			char sName[MAX_NAME_LENGTH];
			FormatEx(sName, sizeof(sName), "%N", client);
			
			Handle hMenu = CreateMenu(AdminMenu_PlayerForceProxyBoss);
			if (!AddBossTargetsToMenu(hMenu))
			{
				CloseHandle(hMenu);
				DisplayTopMenu(g_hTopMenu, param1, TopMenuPosition_LastCategory);
				CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", param1);
			}
			else
			{
				SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Force Proxy Boss", param1, sName);
				SetMenuExitBackButton(hMenu, true);
				DisplayMenu(hMenu, param1, MENU_TIME_FOREVER);
			}
		}
	}
}

public int AdminMenu_PlayerForceProxyBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		int client = GetClientOfUserId(g_iPlayerAdminMenuTargetUserId[param1]);
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
		}
		else
		{
			char sID[64];
			GetMenuItem(menu, param2, sID, sizeof(sID));
			int iIndex = NPCGetFromUniqueID(StringToInt(sID));
			if (iIndex == -1)
			{
				CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
			}
			else
			{
				char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(iIndex, sProfile, sizeof(sProfile));
			
				if (!view_as<bool>(GetProfileNum(sProfile, "proxies", 0)) ||
					g_iSlenderCopyMaster[iIndex] != -1)
				{
					CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Not Allowed To Have Proxies", param1);
				}
				else if (!g_bPlayerEliminated[client])
				{
					CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player In Game", param1);
				}
				else if (g_bPlayerProxy[param1])
				{
					CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Already A Proxy", param1);
				}
				else
				{
					FakeClientCommand(param1, "sm_sf2_force_proxy #%d %d", g_iPlayerAdminMenuTargetUserId[param1], iIndex);
				}
			}
		}
		
		DisplayPlayerForceProxyAdminMenu(param1);
	}
}

static void DisplayPlayerSetPlayStateAdminMenu(int client)
{
	Handle hMenu = CreateMenu(AdminMenu_PlayerSetPlayState);
	SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Set Play State", client);
	AddTargetsToMenu(hMenu, client);
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
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
}

public int AdminMenu_PlayerSetPlayState(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack && g_hTopMenu != INVALID_HANDLE)
		{
			DisplayTopMenu(g_hTopMenu, param1, TopMenuPosition_LastCategory);
		}
	}
	else if (action == MenuAction_Select)
	{
		char sUserId[64];
		GetMenuItem(menu, param2, sUserId, sizeof(sUserId));
		int client = GetClientOfUserId(StringToInt(sUserId));
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
			DisplayPlayerSetPlayStateAdminMenu(param1);
		}
		else
		{
			char sName[MAX_NAME_LENGTH];
			FormatEx(sName, sizeof(sName), "%N", client);
			
			Handle hMenu = CreateMenu(AdminMenu_PlayerSetPlayStateConfirm);
			SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Player Set Play State Confirm", param1, sName);
			char sBuffer[256];
			FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 In", param1);
			AddMenuItem(hMenu, sUserId, sBuffer);
			FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 Out", param1);
			AddMenuItem(hMenu, sUserId, sBuffer);
			SetMenuExitBackButton(hMenu, true);
			DisplayMenu(hMenu, param1, MENU_TIME_FOREVER);
		}
	}
}

public int AdminMenu_PlayerSetPlayStateConfirm(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sUserId[64];
		GetMenuItem(menu, param2, sUserId, sizeof(sUserId));
		int client = GetClientOfUserId(StringToInt(sUserId));
		if (client <= 0)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player Does Not Exist", param1);
		}
		else
		{
			int iUserId = StringToInt(sUserId);
			switch (param2)
			{
				case 0: FakeClientCommand(param1, "sm_sf2_setplaystate #%d 1", iUserId);
				case 1: FakeClientCommand(param1, "sm_sf2_setplaystate #%d 0", iUserId);
			}
		}
		
		DisplayPlayerSetPlayStateAdminMenu(param1);
	}
}

static void DisplayBossMainAdminMenu(int client)
{
	Handle hMenu = CreateMenu(AdminMenu_BossMain);
	SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Main", client);
	
	char sBuffer[512];
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 Admin Menu Add Boss", client);
	AddMenuItem(hMenu, "add_boss", sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 Admin Menu Add Fake Boss", client);
	AddMenuItem(hMenu, "add_boss_fake", sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 Admin Menu Remove Boss", client);
	AddMenuItem(hMenu, "remove_boss", sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 Admin Menu Spawn Boss", client);
	AddMenuItem(hMenu, "spawn_boss", sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 Admin Menu Boss Attack Waiters", client);
	AddMenuItem(hMenu, "boss_attack_waiters", sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 Admin Menu Boss Teleport", client);
	AddMenuItem(hMenu, "boss_no_teleport", sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "SF2 Admin Menu Override Boss", client);
	AddMenuItem(hMenu, "override_boss", sBuffer);
	
	
	SetMenuExitBackButton(hMenu, true);
	DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
}

public int AdminMenu_BossMain(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack && g_hTopMenu != INVALID_HANDLE)
		{
			DisplayTopMenu(g_hTopMenu, param1, TopMenuPosition_LastCategory);
		}
	}
	else if (action == MenuAction_Select)
	{
		char sInfo[64];
		GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
		if (strcmp(sInfo, "add_boss") == 0)
		{
			DisplayAddBossAdminMenu(param1);
		}
		else if (strcmp(sInfo, "add_boss_fake") == 0)
		{
			DisplayAddFakeBossAdminMenu(param1);
		}
		else if (strcmp(sInfo, "remove_boss") == 0)
		{
			DisplayRemoveBossAdminMenu(param1);
		}
		else if (strcmp(sInfo, "spawn_boss") == 0)
		{
			DisplaySpawnBossAdminMenu(param1);
		}
		else if (strcmp(sInfo, "boss_attack_waiters") == 0)
		{
			DisplayBossAttackWaitersAdminMenu(param1);
		}
		else if (strcmp(sInfo, "boss_no_teleport") == 0)
		{
			DisplayBossTeleportAdminMenu(param1);
		}
		else if (strcmp(sInfo, "override_boss") == 0)
		{
			DisplayOverrideBossAdminMenu(param1);
		}
	}
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
}

static bool DisplayAddBossAdminMenu(int client) //Use for view boss list
{
	if (g_hConfig != INVALID_HANDLE)
	{
		KvRewind(g_hConfig);
		if (KvGotoFirstSubKey(g_hConfig))
		{
			Handle hMenu = CreateMenu(AdminMenu_AddBoss);
			SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Add Boss", client);
			
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			char sDisplayName[SF2_MAX_NAME_LENGTH];
			
			do
			{
				KvGetSectionName(g_hConfig, sProfile, sizeof(sProfile));
				KvGetString(g_hConfig, "name", sDisplayName, sizeof(sDisplayName));
				if (!sDisplayName[0]) strcopy(sDisplayName, sizeof(sDisplayName), sProfile);
				AddMenuItem(hMenu, sProfile, sDisplayName);
			}
			while (KvGotoNextKey(g_hConfig));
			
			SetMenuExitBackButton(hMenu, true);
			
			DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
			
			return true;
		}
	}
	
	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_AddBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		GetMenuItem(menu, param2, sProfile, sizeof(sProfile));
		
		FakeClientCommand(param1, "sm_sf2_add_boss %s", sProfile);
		
		DisplayAddBossAdminMenu(param1);
	}
}

static bool DisplayAddFakeBossAdminMenu(int client)
{
	if (g_hConfig != INVALID_HANDLE)
	{
		KvRewind(g_hConfig);
		if (KvGotoFirstSubKey(g_hConfig))
		{
			Handle hMenu = CreateMenu(AdminMenu_AddFakeBoss);
			SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Add Fake Boss", client);
			
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			char sDisplayName[SF2_MAX_NAME_LENGTH];
			
			do
			{
				KvGetSectionName(g_hConfig, sProfile, sizeof(sProfile));
				KvGetString(g_hConfig, "name", sDisplayName, sizeof(sDisplayName));
				if (!sDisplayName[0]) strcopy(sDisplayName, sizeof(sDisplayName), sProfile);
				AddMenuItem(hMenu, sProfile, sDisplayName);
			}
			while (KvGotoNextKey(g_hConfig));
			
			SetMenuExitBackButton(hMenu, true);
			
			DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
			
			return true;
		}
	}
	
	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_AddFakeBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		GetMenuItem(menu, param2, sProfile, sizeof(sProfile));
		
		FakeClientCommand(param1, "sm_sf2_add_boss_fake %s", sProfile);
		
		DisplayAddFakeBossAdminMenu(param1);
	}
}

static int AddBossTargetsToMenu(Handle hMenu)
{
	if (g_hConfig == INVALID_HANDLE) return 0;
	
	KvRewind(g_hConfig);
	if (!KvGotoFirstSubKey(g_hConfig)) return 0;
	
	char sBuffer[512];
	char sDisplay[512], sInfo[64];
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	int iCount;
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		int iUniqueID = NPCGetUniqueID(i);
		if (iUniqueID == -1) continue;
		
		NPCGetProfile(i, sProfile, sizeof(sProfile));
		
		GetProfileString(sProfile, "name", sBuffer, sizeof(sBuffer));
		if (sBuffer[0] == '\0') strcopy(sBuffer, sizeof(sBuffer), sProfile);
		
		FormatEx(sDisplay, sizeof(sDisplay), "%d - %s", i, sBuffer);
		if (g_iSlenderCopyMaster[i] != -1)
		{
			FormatEx(sBuffer, sizeof(sBuffer), " (copy of boss %d)", g_iSlenderCopyMaster[i]);
			StrCat(sDisplay, sizeof(sDisplay), sBuffer);
		}
		
		if (NPCGetFlags(i) & SFF_FAKE)
		{
			StrCat(sDisplay, sizeof(sDisplay), " (fake)");
		}
		
		FormatEx(sInfo, sizeof(sInfo), "%d", iUniqueID);
		
		AddMenuItem(hMenu, sInfo, sDisplay);
		iCount++;
	}
	
	return iCount;
}

static bool DisplayRemoveBossAdminMenu(int client)
{
	if (g_hConfig != INVALID_HANDLE)
	{
		KvRewind(g_hConfig);
		if (KvGotoFirstSubKey(g_hConfig))
		{
			Handle hMenu = CreateMenu(AdminMenu_RemoveBoss);
			if (!AddBossTargetsToMenu(hMenu))
			{
				CloseHandle(hMenu);
				CPrintToChat(client, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
			}
			else
			{
				SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Remove Boss", client);
				SetMenuExitBackButton(hMenu, true);
				DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
				return true;
			}
		}
	}
	
	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_RemoveBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sID[64];
		GetMenuItem(menu, param2, sID, sizeof(sID));
		int iIndex = NPCGetFromUniqueID(StringToInt(sID));
		if (iIndex == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			FakeClientCommand(param1, "sm_sf2_remove_boss %d", iIndex);
		}
		
		DisplayRemoveBossAdminMenu(param1);
	}
}

static bool DisplaySpawnBossAdminMenu(int client)
{
	if (g_hConfig != INVALID_HANDLE)
	{
		KvRewind(g_hConfig);
		if (KvGotoFirstSubKey(g_hConfig))
		{
			Handle hMenu = CreateMenu(AdminMenu_SpawnBoss);
			if (!AddBossTargetsToMenu(hMenu))
			{
				CloseHandle(hMenu);
				CPrintToChat(client, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
			}
			else
			{
				SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Spawn Boss", client);
				SetMenuExitBackButton(hMenu, true);
				DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
				return true;
			}
		}
	}
	
	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_SpawnBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sID[64];
		GetMenuItem(menu, param2, sID, sizeof(sID));
		int iIndex = NPCGetFromUniqueID(StringToInt(sID));
		if (iIndex == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			FakeClientCommand(param1, "sm_sf2_spawn_boss %d", iIndex);
		}
		
		DisplaySpawnBossAdminMenu(param1);
	}
}

static bool DisplayBossAttackWaitersAdminMenu(int client)
{
	if (g_hConfig != INVALID_HANDLE)
	{
		KvRewind(g_hConfig);
		if (KvGotoFirstSubKey(g_hConfig))
		{
			Handle hMenu = CreateMenu(AdminMenu_BossAttackWaiters);
			if (!AddBossTargetsToMenu(hMenu))
			{
				CloseHandle(hMenu);
				CPrintToChat(client, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
			}
			else
			{
				SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Attack Waiters", client);
				SetMenuExitBackButton(hMenu, true);
				DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
				return true;
			}
		}
	}
	
	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_BossAttackWaiters(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sID[64];
		GetMenuItem(menu, param2, sID, sizeof(sID));
		int iIndex = NPCGetFromUniqueID(StringToInt(sID));
		if (iIndex == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
			DisplayBossAttackWaitersAdminMenu(param1);
		}
		else
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iIndex, sProfile, sizeof(sProfile));
		
			char sName[SF2_MAX_NAME_LENGTH];
			GetProfileString(sProfile, "name", sName, sizeof(sName));
			if (!sName[0]) strcopy(sName, sizeof(sName), sProfile);
			
			Handle hMenu = CreateMenu(AdminMenu_BossAttackWaitersConfirm);
			SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Attack Waiters Confirm", param1, sName);
			char sBuffer[256];
			FormatEx(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
			AddMenuItem(hMenu, sID, sBuffer);
			FormatEx(sBuffer, sizeof(sBuffer), "%T", "No", param1);
			AddMenuItem(hMenu, sID, sBuffer);
			SetMenuExitBackButton(hMenu, true);
			DisplayMenu(hMenu, param1, MENU_TIME_FOREVER);
		}
	}
}

public int AdminMenu_BossAttackWaitersConfirm(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sID[64];
		GetMenuItem(menu, param2, sID, sizeof(sID));
		int iIndex = NPCGetFromUniqueID(StringToInt(sID));
		if (iIndex == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			switch (param2)
			{
				case 0: FakeClientCommand(param1, "sm_sf2_boss_attack_waiters %d 1", iIndex);
				case 1: FakeClientCommand(param1, "sm_sf2_boss_attack_waiters %d 0", iIndex);
			}
		}
		
		DisplayBossAttackWaitersAdminMenu(param1);
	}
}

static bool DisplayBossTeleportAdminMenu(int client)
{
	if (g_hConfig != INVALID_HANDLE)
	{
		KvRewind(g_hConfig);
		if (KvGotoFirstSubKey(g_hConfig))
		{
			Handle hMenu = CreateMenu(AdminMenu_BossTeleport);
			if (!AddBossTargetsToMenu(hMenu))
			{
				CloseHandle(hMenu);
				CPrintToChat(client, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 No Active Bosses", client);
			}
			else
			{
				SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Teleport", client);
				SetMenuExitBackButton(hMenu, true);
				DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
				return true;
			}
		}
	}
	
	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_BossTeleport(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sID[64];
		GetMenuItem(menu, param2, sID, sizeof(sID));
		int iIndex = NPCGetFromUniqueID(StringToInt(sID));
		if (iIndex == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
			DisplayBossTeleportAdminMenu(param1);
		}
		else
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iIndex, sProfile, sizeof(sProfile));
		
			char sName[SF2_MAX_NAME_LENGTH];
			GetProfileString(sProfile, "name", sName, sizeof(sName));
			if (!sName[0]) strcopy(sName, sizeof(sName), sProfile);
			
			Handle hMenu = CreateMenu(AdminMenu_BossTeleportConfirm);
			SetMenuTitle(hMenu, "%t%T\n \n", "SF2 Prefix", "SF2 Admin Menu Boss Teleport Confirm", param1, sName);
			char sBuffer[256];
			FormatEx(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
			AddMenuItem(hMenu, sID, sBuffer);
			FormatEx(sBuffer, sizeof(sBuffer), "%T", "No", param1);
			AddMenuItem(hMenu, sID, sBuffer);
			SetMenuExitBackButton(hMenu, true);
			DisplayMenu(hMenu, param1, MENU_TIME_FOREVER);
		}
	}
}

public int AdminMenu_BossTeleportConfirm(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sID[64];
		GetMenuItem(menu, param2, sID, sizeof(sID));
		int iIndex = NPCGetFromUniqueID(StringToInt(sID));
		if (iIndex == -1)
		{
			CPrintToChat(param1, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Does Not Exist", param1);
		}
		else
		{
			switch (param2)
			{
				case 0: FakeClientCommand(param1, "sm_sf2_boss_no_teleport %d 0", iIndex);
				case 1: FakeClientCommand(param1, "sm_sf2_boss_no_teleport %d 1", iIndex);
			}
		}
		
		DisplayBossTeleportAdminMenu(param1);
	}
}

static bool DisplayOverrideBossAdminMenu(int client)
{
	if (g_hConfig != INVALID_HANDLE)
	{
		KvRewind(g_hConfig);
		if (KvGotoFirstSubKey(g_hConfig))
		{
			Handle hMenu = CreateMenu(AdminMenu_OverrideBoss);
			
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			char sDisplayName[SF2_MAX_NAME_LENGTH];
			
			do
			{
				KvGetSectionName(g_hConfig, sProfile, sizeof(sProfile));
				KvGetString(g_hConfig, "name", sDisplayName, sizeof(sDisplayName));
				if (!sDisplayName[0]) strcopy(sDisplayName, sizeof(sDisplayName), sProfile);
				AddMenuItem(hMenu, sProfile, sDisplayName);
			}
			while (KvGotoNextKey(g_hConfig));
			
			SetMenuExitBackButton(hMenu, true);
			
			char sProfileOverride[SF2_MAX_PROFILE_NAME_LENGTH], sProfileDisplayName[SF2_MAX_PROFILE_NAME_LENGTH];
			GetConVarString(g_cvBossProfileOverride, sProfileOverride, sizeof(sProfileOverride));
			
			if (sProfileOverride[0] != '\0' && IsProfileValid(sProfileOverride))
			{
				GetProfileString(sProfileOverride, "name", sProfileDisplayName, sizeof(sProfileDisplayName));
				
				if (sProfileDisplayName[0] == '\0')
					strcopy(sProfileDisplayName, sizeof(sProfileDisplayName), sProfileOverride);
			}
			else
				strcopy(sProfileDisplayName, sizeof(sProfileDisplayName), "---");
			
			SetMenuTitle(hMenu, "%t%T\n%T\n \n", "SF2 Prefix", "SF2 Admin Menu Override Boss", client, "SF2 Admin Menu Current Boss Override", client, sProfileDisplayName);
			
			DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
			
			return true;
		}
	}
	
	DisplayBossMainAdminMenu(client);
	return false;
}

public int AdminMenu_OverrideBoss(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
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
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		GetMenuItem(menu, param2, sProfile, sizeof(sProfile));
		
		FakeClientCommand(param1, "sm_cvar sf2_boss_profile_override %s", sProfile);
		
		DisplayOverrideBossAdminMenu(param1);
	}
}