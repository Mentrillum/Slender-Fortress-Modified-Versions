#if defined _sf2_pvp_menus
 #endinput
#endif

#define _sf2_pvp_menus

Handle g_hMenuSettingsPvP;

public int Menu_SettingsPvP(Handle menu, MenuAction action,int  param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				char sBuffer[512];
				Format(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings PvP Spawn Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
				DrawPanelItem(hPanel, sBuffer);
				Format(sBuffer, sizeof(sBuffer), "%T", "No", param1);
				DrawPanelItem(hPanel, sBuffer);
				
				SendPanelToClient(hPanel, param1, Panel_SettingsPvPSpawn, 30);
				delete hPanel;
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_hMenuSettings, param1, 30);
		}
	}
}

public int Panel_SettingsPvPSpawn(Handle menu, MenuAction action,int  param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_iPlayerPreferences[param1].PlayerPreference_PvPAutoSpawn = true;
				CPrintToChat(param1, "%T", "SF2 PvP Spawn Accept", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_PvPAutoSpawn = false;
				CPrintToChat(param1, "%T", "SF2 PvP Spawn Decline", param1);
			}
		}
		
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}