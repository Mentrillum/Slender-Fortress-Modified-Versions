#if defined _sf2_pvp_menus
 #endinput
#endif

#define _sf2_pvp_menus

#pragma semicolon 1

Handle g_MenuSettingsPvP;

public int Menu_SettingsPvP(Handle menu, MenuAction action,int  param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				char buffer[512];
				Format(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings PvP Spawn Menu Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				Format(buffer, sizeof(buffer), "%T", "Yes", param1);
				DrawPanelItem(panel, buffer);
				Format(buffer, sizeof(buffer), "%T", "No", param1);
				DrawPanelItem(panel, buffer);

				SendPanelToClient(panel, param1, Panel_SettingsPvPSpawn, 30);
				delete panel;
			}
			case 1:
			{
				char buffer[512];
				Format(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings PvP Spawn Protection Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				DrawPanelItem(panel, "On");
				DrawPanelItem(panel, "Off");

				SendPanelToClient(panel, param1, Panel_SettingsPvPProtection, 30);
				delete panel;
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_MenuSettings, param1, 30);
		}
	}
	return 0;
}

public int Panel_SettingsPvPSpawn(Handle menu, MenuAction action,int  param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_PvPAutoSpawn = true;
				CPrintToChat(param1, "%T", "SF2 PvP Spawn Accept", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_PvPAutoSpawn = false;
				CPrintToChat(param1, "%T", "SF2 PvP Spawn Decline", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsPvPProtection(Handle menu, MenuAction action,int  param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_PvPSpawnProtection = true;
				CPrintToChat(param1, "%T", "SF2 PvP Protection On", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_PvPSpawnProtection = false;
				CPrintToChat(param1, "%T", "SF2 PvP Protection Off", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}