#if defined _sf2_pvp_menus
 #endinput
#endif

#define _sf2_pvp_menus

#pragma semicolon 1
#pragma newdecls required

void ShowPvPSettings(int client)
{
	char buffer[512];
	Menu menu = new Menu(Menu_SettingsPvP);
	menu.SetTitle("%t %t\n \n", "SF2 Prefix", "SF2 Settings PvP Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t %t", "SF2 Settings PvP Spawn Menu Title",
	g_PlayerPreferences[client].PlayerPreference_PvPAutoSpawn ? "SF2 On" : "SF2 Off");
	menu.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t %t", "SF2 Settings PvP Spawn Protection Title",
	g_PlayerPreferences[client].PlayerPreference_PvPSpawnProtection ? "SF2 On" : "SF2 Off");
	menu.AddItem("0", buffer);
	menu.ExitBackButton = true;
	menu.Display(client, 30);
}

int Menu_SettingsPvP(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_PlayerPreferences[param1].PlayerPreference_PvPAutoSpawn = !g_PlayerPreferences[param1].PlayerPreference_PvPAutoSpawn;
			}
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_PvPSpawnProtection = !g_PlayerPreferences[param1].PlayerPreference_PvPSpawnProtection;
			}
		}
		ShowPvPSettings(param1);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			ShowMainSettings(param1);
		}
	}
	return 0;
}
