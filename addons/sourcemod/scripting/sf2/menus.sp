#if defined _sf2_menus
 #endinput
#endif

#define _sf2_menus

Handle g_hMenuMain;
Handle g_hMenuVoteDifficulty;
Handle g_hMenuHelp;
Handle g_hMenuHelpObjective;
Handle g_hMenuHelpObjective2;
Handle g_hMenuHelpCommands;
Handle g_hMenuHelpSprinting;
Handle g_hMenuHelpControls;
Handle g_hMenuHelpClassInfo;
Handle g_hMenuHelpGhostMode;
Handle g_hMenuSettings;
Handle g_hMenuCredits;
Handle g_hMenuCredits2;
Handle g_hMenuCredits3;
Handle g_hMenuCredits4;
Handle g_hMenuUpdate;

#include "sf2/playergroups/menus.sp"
#include "sf2/pvp/menus.sp"

void SetupMenus()
{
	char buffer[512];
	
	// Create menus.
	g_hMenuMain = CreateMenu(Menu_Main);
	SetMenuTitle(g_hMenuMain, "%t%t\n \n", "SF2 Prefix", "SF2 Main Menu Title");
	Format(buffer, sizeof(buffer), "%t (!slhelp)", "SF2 Help Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	Format(buffer, sizeof(buffer), "%t (!slnext)", "SF2 Queue Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	Format(buffer, sizeof(buffer), "%t (!slgroup)", "SF2 Group Main Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	Format(buffer, sizeof(buffer), "%t (!slghost)", "SF2 Ghost Mode Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	Format(buffer, sizeof(buffer), "%t (!slpack)", "SF2 Boss Pack Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	Format(buffer, sizeof(buffer), "%t (!slsettings)", "SF2 Settings Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	strcopy(buffer, sizeof(buffer), "Credits (!slcredits)");
	AddMenuItem(g_hMenuMain, "0", buffer);
	
	g_hMenuVoteDifficulty = CreateMenu(Menu_VoteDifficulty);
	SetMenuTitle(g_hMenuVoteDifficulty, "%t%t\n \n", "SF2 Prefix", "SF2 Difficulty Vote Menu Title");
	Format(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
	AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
	AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
	AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
	
	g_hMenuHelp = CreateMenu(Menu_Help);
	SetMenuTitle(g_hMenuHelp, "%t%t\n \n", "SF2 Prefix", "SF2 Help Menu Title");
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Objective Menu Title");
	AddMenuItem(g_hMenuHelp, "0", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Commands Menu Title");
	AddMenuItem(g_hMenuHelp, "1", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Class Info Menu Title");
	AddMenuItem(g_hMenuHelp, "2", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Ghost Mode Menu Title");
	AddMenuItem(g_hMenuHelp, "3", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Sprinting And Stamina Menu Title");
	AddMenuItem(g_hMenuHelp, "4", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Controls Menu Title");
	AddMenuItem(g_hMenuHelp, "5", buffer);
	SetMenuExitBackButton(g_hMenuHelp, true);
	
	g_hMenuHelpObjective = CreateMenu(Menu_HelpObjective);
	SetMenuTitle(g_hMenuHelpObjective, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Objective Menu Title", "SF2 Help Objective Description");
	AddMenuItem(g_hMenuHelpObjective, "0", "Next");
	AddMenuItem(g_hMenuHelpObjective, "1", "Back");
	
	g_hMenuHelpObjective2 = CreateMenu(Menu_HelpObjective2);
	SetMenuTitle(g_hMenuHelpObjective2, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Objective Menu Title", "SF2 Help Objective Description 2");
	AddMenuItem(g_hMenuHelpObjective2, "0", "Back");
	
	g_hMenuHelpCommands = CreateMenu(Menu_BackButtonOnly);
	SetMenuTitle(g_hMenuHelpCommands, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Commands Menu Title", "SF2 Help Commands Description");
	AddMenuItem(g_hMenuHelpCommands, "0", "Back");
	
	g_hMenuHelpGhostMode = CreateMenu(Menu_BackButtonOnly);
	SetMenuTitle(g_hMenuHelpGhostMode, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Ghost Mode Menu Title", "SF2 Help Ghost Mode Description");
	AddMenuItem(g_hMenuHelpGhostMode, "0", "Back");
	
	g_hMenuHelpSprinting = CreateMenu(Menu_BackButtonOnly);
	SetMenuTitle(g_hMenuHelpSprinting, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Sprinting And Stamina Menu Title", "SF2 Help Sprinting And Stamina Description");
	AddMenuItem(g_hMenuHelpSprinting, "0", "Back");
	
	g_hMenuHelpControls = CreateMenu(Menu_BackButtonOnly);
	SetMenuTitle(g_hMenuHelpControls, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Controls Menu Title", "SF2 Help Controls Description");
	AddMenuItem(g_hMenuHelpControls, "0", "Back");
	
	g_hMenuHelpClassInfo = CreateMenu(Menu_ClassInfo);
	SetMenuTitle(g_hMenuHelpClassInfo, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Class Info Menu Title", "SF2 Help Class Info Description");
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Scout Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Scout", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Sniper Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Sniper", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Soldier Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Soldier", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Demoman Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Demoman", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Heavy Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Heavy", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Medic Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Medic", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Pyro Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Pyro", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Spy Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Spy", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Help Engineer Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Engineer", buffer);
	SetMenuExitBackButton(g_hMenuHelpClassInfo, true);
	
	g_hMenuSettings = CreateMenu(Menu_Settings);
	SetMenuTitle(g_hMenuSettings, "%t%t\n \n", "SF2 Prefix", "SF2 Settings Menu Title");
	Format(buffer, sizeof(buffer), "%t", "SF2 Settings PvP Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Settings Hints Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Settings Mute Mode Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Settings Film Grain Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Settings Proxy Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	Format(buffer, sizeof(buffer), "%t", "SF2 Settings Music Volume Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	SetMenuExitBackButton(g_hMenuSettings, true);
	
	g_hMenuCredits = CreateMenu(Menu_Credits);
	
	Format(buffer, sizeof(buffer), "Credits\n");
	StrCat(buffer, sizeof(buffer), "Coders: Kit o' Rifty, Benoist3012, Mentrillum, The Gaben\n");
	StrCat(buffer, sizeof(buffer), "Mark J. Hadley - The creator of the Slender game\n");
	StrCat(buffer, sizeof(buffer), "Mark Steen - Compositing the intro music\n");
	StrCat(buffer, sizeof(buffer), "Dj-Rec0il - Compositing the Running In The 90s cover\n");
	StrCat(buffer, sizeof(buffer), "Mammoth Mogul - For being a GREAT test subject\n");
	StrCat(buffer, sizeof(buffer), "Egosins - For offering to host this publicly\n");
	StrCat(buffer, sizeof(buffer), "Glubbable - For working on a ton of maps\n");
	StrCat(buffer, sizeof(buffer), "Somberguy - Suggestions and support\n");
	StrCat(buffer, sizeof(buffer), "Omi-Box - Materials, maps, current Slender Man model, and more\n");
	StrCat(buffer, sizeof(buffer), "Narry Gewman - Imported first Slender Man model\n");
	StrCat(buffer, sizeof(buffer), "Simply Delicious - For the awesome camera overlay\n");
	StrCat(buffer, sizeof(buffer), "Jason278 -Page models");
	
	SetMenuTitle(g_hMenuCredits, buffer);
	AddMenuItem(g_hMenuCredits, "0", "Next");
	AddMenuItem(g_hMenuCredits, "1", "Back");
	
	g_hMenuCredits2 = CreateMenu(Menu_Credits2);
	
	Format(buffer, sizeof(buffer), "%tCredits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "To all the peeps who alpha-tested this thing!\n \n");
	StrCat(buffer, sizeof(buffer), "Tofu\n");
	StrCat(buffer, sizeof(buffer), "Ace-Dashie\n");
	StrCat(buffer, sizeof(buffer), "Hobbes\n");
	StrCat(buffer, sizeof(buffer), "Diskein\n");
	StrCat(buffer, sizeof(buffer), "111112oo\n");
	StrCat(buffer, sizeof(buffer), "Incoheriant Chipmunk\n");
	StrCat(buffer, sizeof(buffer), "Shrow\n");
	StrCat(buffer, sizeof(buffer), "Liquid Vita\n");
	StrCat(buffer, sizeof(buffer), "Pinkle D Lies\n");
	StrCat(buffer, sizeof(buffer), "Ultimatefry\n \n");
	
	SetMenuTitle(g_hMenuCredits2, buffer);
	AddMenuItem(g_hMenuCredits2, "0", "Next");
	AddMenuItem(g_hMenuCredits2, "1", "Back");
	
	g_hMenuCredits3 = CreateMenu(Menu_Credits3);
	
	Format(buffer, sizeof(buffer), "%tCredits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "Credits to all peeps who gave special round suggestions!\n \n");
	StrCat(buffer, sizeof(buffer), "TehPlayer14\n");
	StrCat(buffer, sizeof(buffer), "SirAnthony\n");
	StrCat(buffer, sizeof(buffer), "DelcsXCritical\n");
	StrCat(buffer, sizeof(buffer), "Gardevoid\n");
	StrCat(buffer, sizeof(buffer), "Eile Mizer\n");
	StrCat(buffer, sizeof(buffer), "DeadlyCreature\n");
	StrCat(buffer, sizeof(buffer), "Average\n");
	StrCat(buffer, sizeof(buffer), "FireHue\n");
	StrCat(buffer, sizeof(buffer), "Spooky Pyro\n");
	StrCat(buffer, sizeof(buffer), "Firedudeet\n \n");
	
	SetMenuTitle(g_hMenuCredits3, buffer);
	AddMenuItem(g_hMenuCredits3, "0", "Next");
	AddMenuItem(g_hMenuCredits3, "1", "Back");
	
	g_hMenuCredits4 = CreateMenu(Menu_Credits4);
	
	Format(buffer, sizeof(buffer), "%tCredits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "And major special thanks for keeping this plugin going!\n \n");
	StrCat(buffer, sizeof(buffer), "Demon Hamster Eating My Wafflez\n");
	StrCat(buffer, sizeof(buffer), "Dookster\n");
	StrCat(buffer, sizeof(buffer), "Glacetomic\n");
	StrCat(buffer, sizeof(buffer), "Phantasmo\n");
	StrCat(buffer, sizeof(buffer), "Geo\n");
	StrCat(buffer, sizeof(buffer), "[NxN]Nameless\n");
	StrCat(buffer, sizeof(buffer), "_Painkiller76_\n");
	StrCat(buffer, sizeof(buffer), "Odie\n");
	StrCat(buffer, sizeof(buffer), "Tons of members from the Russian SF2 server\n");
	StrCat(buffer, sizeof(buffer), "And you for playing this new way of SF2!\n \n");
	
	SetMenuTitle(g_hMenuCredits4, buffer);
	AddMenuItem(g_hMenuCredits4, "0", "Back");
	
	g_hMenuUpdate = CreateMenu(Menu_Update);
	Format(buffer, sizeof(buffer), "%tSlender Fortress\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "Coders: Kit o' Rifty, Benoist3012, Mentrillum, The Gaben\n");
	StrCat(buffer, sizeof(buffer), "Version: ");
	StrCat(buffer, sizeof(buffer), PLUGIN_VERSION);
	StrCat(buffer, sizeof(buffer), "\n \n");
	Format(buffer, sizeof(buffer), "%s%t\n",buffer,"SF2 Recent Changes");
	Format(buffer, sizeof(buffer), "%s%t\n",buffer,"SF2 Change Log");
	StrCat(buffer, sizeof(buffer), "\n \n");
	
	SetMenuTitle(g_hMenuUpdate, buffer);
	
	AddMenuItem(g_hMenuUpdate, "0", "Display main menu");
	
	PvP_SetupMenus();
}

void RandomizeVoteMenu()
{
	char buffer[512];
	
	if (g_hMenuVoteDifficulty != INVALID_HANDLE) delete g_hMenuVoteDifficulty;
	
	g_hMenuVoteDifficulty = CreateMenu(Menu_VoteDifficulty);
	SetMenuTitle(g_hMenuVoteDifficulty, "%t%t\n \n", "SF2 Prefix", "SF2 Difficulty Vote Menu Title");
	
	switch (GetRandomInt(1,6))//There's probably a better way to do this but I was tired.
	{
		case 1:
		{
			Format(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
		}
		case 2:
		{
			Format(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
		}
		case 3:
		{
			Format(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
		}
		case 4:
		{
			Format(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
		}
		case 5:
		{
			Format(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
		}
		case 6:
		{
			Format(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
			Format(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
		}
	}
}

public int Menu_Main(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuHelp, param1, 30);
			case 1: DisplayQueuePointsMenu(param1);
			case 2:	DisplayGroupMainMenuToClient(param1);
			case 3: FakeClientCommand(param1, "sm_slghost");
			case 4: FakeClientCommand(param1, "sm_slpack");
			case 5: DisplayMenu(g_hMenuSettings, param1, 30);
			case 6: DisplayMenu(g_hMenuCredits, param1, MENU_TIME_FOREVER);
		}
	}
}

public int Menu_VoteDifficulty(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_VoteEnd)
	{
		int iClientInGame = 0, iClientCallingForNightmare = 0;
		for (int iClient = 1; iClient <= MaxClients; iClient++)
		{
			if (IsClientInGame(iClient) && !g_bPlayerEliminated[iClient])
			{
				iClientInGame++;
				if (g_bPlayerCalledForNightmare[iClient]) iClientCallingForNightmare++;
			}
		}
		bool bPlayersCalledForNightmare = (iClientInGame == iClientCallingForNightmare);
		
		char sInfo[64], sDisplay[256], sColor[32];
		GetMenuItem(menu, param1, sInfo, sizeof(sInfo), _, sDisplay, sizeof(sDisplay));
		
		if (IsSpecialRoundRunning() && (SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) || SF_SpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS) || SF_SpecialRound(SPECIALROUND_2DOUBLE) || SF_SpecialRound(SPECIALROUND_WALLHAX)))
		{
			SetConVarInt(g_cvDifficulty, Difficulty_Insane);
		}
		else if ((!SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) && GetRandomInt(1, 200) <= 2) || bPlayersCalledForNightmare) 
			SetConVarInt(g_cvDifficulty, Difficulty_Nightmare);
		else if (IsSpecialRoundRunning() && SF_SpecialRound(SPECIALROUND_NOGRACE) || SF_SpecialRound(SPECIALROUND_2DOOM))
		{
			SetConVarInt(g_cvDifficulty, Difficulty_Hard);
		}
		else
		{
			SetConVarString(g_cvDifficulty, sInfo);
		}
		
		int iDifficulty = GetConVarInt(g_cvDifficulty);
		switch (iDifficulty)
		{
			case Difficulty_Easy:
			{
				Format(sDisplay, sizeof(sDisplay), "%t", "SF2 Easy Difficulty");
				strcopy(sColor, sizeof(sColor), "{green}");
			}
			case Difficulty_Hard:
			{
				Format(sDisplay, sizeof(sDisplay), "%t", "SF2 Hard Difficulty");
				strcopy(sColor, sizeof(sColor), "{orange}");
			}
			case Difficulty_Insane:
			{
				Format(sDisplay, sizeof(sDisplay), "%t", "SF2 Insane Difficulty");
				strcopy(sColor, sizeof(sColor), "{red}");
			}
			case Difficulty_Nightmare:
			{
				Format(sDisplay, sizeof(sDisplay), "Nightmare!");
				strcopy(sColor, sizeof(sColor), "{valve}");
				for (int i = 0; i < sizeof(g_strSoundNightmareMode)-1; i++)
					EmitSoundToAll(g_strSoundNightmareMode[i]);
				SpecialRoundGameText("Nightmare mode!", "leaderboard_streak");
				if (SF_SpecialRound(SPECIALROUND_HYPERSNATCHER))
				{
					int iRandomQuote = GetRandomInt(1, 5);
					switch (iRandomQuote)
					{
						case 1:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_1);
							CPrintToChatAll("{ghostwhite}Hyper Snatcher {default}:  Oh no! You're not slipping out of your contract THAT easily.");
						}
						case 2:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_2);
							CPrintToChatAll("{ghostwhite}Hyper Snatcher {default}:  You ready to die some more? Great!");
						}
						case 3:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_3);
							CPrintToChatAll("{ghostwhite}Hyper Snatcher {default}:  Live fast, die young, and leave behind a pretty corpse, huh? At least you got two out of three right.");
						}
						case 4:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_4);
							CPrintToChatAll("{ghostwhite}Hyper Snatcher {default}:  I love the smell of DEATH in the morning.");
						}
						case 5:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_5);
							CPrintToChatAll("{ghostwhite}Hyper Snatcher {default}:  Oh ho ho! I hope you don't think one measely death gets you out of your contract. We're only getting started.");
						}
					}
				}
			}
			default:
			{
				Format(sDisplay, sizeof(sDisplay), "%t", "SF2 Normal Difficulty");
				strcopy(sColor, sizeof(sColor), "{yellow}");
			}
		}
		
		CPrintToChatAll("%t %s%s", "SF2 Difficulty Vote Finished", sColor, sDisplay);
	}
}

public int Menu_GhostMode(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		if (IsRoundEnding() ||
			IsRoundInWarmup() ||
			!g_bPlayerEliminated[param1] ||
			!IsClientParticipating(param1) ||
			g_bPlayerProxy[param1])
		{
			CPrintToChat(param1, "{red}%T", "SF2 Ghost Mode Not Allowed", param1);
		}
		else
		{
			switch (param2)
			{
				case 0:
				{
					if (IsClientInGhostMode(param1)) CPrintToChat(param1, "{red}%T", "SF2 Ghost Mode Enabled Already", param1);
					else
					{
						TF2_RespawnPlayer(param1);
						ClientSetGhostModeState(param1, true);
						HandlePlayerHUD(param1);
						
						CPrintToChat(param1, "{olive}%T", "SF2 Ghost Mode Enabled", param1);
					}
				}
				case 1:
				{
					if (!IsClientInGhostMode(param1)) CPrintToChat(param1, "{red}%T", "SF2 Ghost Mode Disabled Already", param1);
					else
					{
						ClientSetGhostModeState(param1, false);
						TF2_RespawnPlayer(param1);
						
						CPrintToChat(param1, "{olive}%T", "SF2 Ghost Mode Disabled", param1);
					}
				}
			}
		}
	}
}

public int Menu_Help(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuHelpObjective, param1, 30);
			case 1: DisplayMenu(g_hMenuHelpCommands, param1, 30);
			case 2: DisplayMenu(g_hMenuHelpClassInfo, param1, 30);
			case 3: DisplayMenu(g_hMenuHelpGhostMode, param1, 30);
			case 4: DisplayMenu(g_hMenuHelpSprinting, param1, 30);
			case 5: DisplayMenu(g_hMenuHelpControls, param1, 30);
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_hMenuMain, param1, 30);
		}
	}
}

public int Menu_HelpObjective(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuHelpObjective2, param1, 30);
			case 1: DisplayMenu(g_hMenuHelp, param1, 30);
		}
	}
}

public int Menu_HelpObjective2(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuHelpObjective, param1, 30);
		}
	}
}

public int Menu_BackButtonOnly(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuHelp, param1, 30);
		}
	}
}

public int Menu_Credits(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuCredits2, param1, MENU_TIME_FOREVER);
			case 1: DisplayMenu(g_hMenuMain, param1, 30);
		}
	}
}

public int Menu_ClassInfo(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_hMenuMain, param1, 30);
		}
	}
	else if (action == MenuAction_Select)
	{
		char sInfo[64];
		GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
		
		Handle hMenu = CreateMenu(Menu_ClassInfoBackOnly);
		
		char sTitle[64], sDescription[64];
		Format(sTitle, sizeof(sTitle), "SF2 Help %s Class Info Menu Title", sInfo);
		Format(sDescription, sizeof(sDescription), "SF2 Help %s Class Info Description", sInfo);
		
		SetMenuTitle(hMenu, "%t%t\n \n%t\n \n", "SF2 Prefix", sTitle, sDescription);
		AddMenuItem(hMenu, "0", "Back");
		DisplayMenu(hMenu, param1, 30);
	}
}

public int Menu_ClassInfoBackOnly(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		DisplayMenu(g_hMenuHelpClassInfo, param1, 30);
	}
}

public int Menu_Settings(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuSettingsPvP, param1, 30);
			case 1:
			{
				char sBuffer[512];
				Format(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Hints Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
				DrawPanelItem(hPanel, sBuffer);
				Format(sBuffer, sizeof(sBuffer), "%T", "No", param1);
				DrawPanelItem(hPanel, sBuffer);
				
				SendPanelToClient(hPanel, param1, Panel_SettingsHints, 30);
				CloseHandle(hPanel);
			}
			case 2:
			{
				char sBuffer[512];
				Format(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Mute Mode Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				DrawPanelItem(hPanel, "Normal");
				DrawPanelItem(hPanel, "Mute opposing team");
				DrawPanelItem(hPanel, "Mute opposing team except when I'm a proxy");
				
				SendPanelToClient(hPanel, param1, Panel_SettingsMuteMode, 30);
				CloseHandle(hPanel);
			}
			case 3:
			{
				char sBuffer[512];
				Format(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Film Grain Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
				DrawPanelItem(hPanel, sBuffer);
				Format(sBuffer, sizeof(sBuffer), "%T", "No", param1);
				DrawPanelItem(hPanel, sBuffer);
				
				SendPanelToClient(hPanel, param1, Panel_SettingsFilmGrain, 30);
				CloseHandle(hPanel);
			}
			case 4:
			{
				char sBuffer[512];
				Format(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Proxy Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
				DrawPanelItem(hPanel, sBuffer);
				Format(sBuffer, sizeof(sBuffer), "%T", "No", param1);
				DrawPanelItem(hPanel, sBuffer);
				
				SendPanelToClient(hPanel, param1, Panel_SettingsProxy, 30);
				CloseHandle(hPanel);
			}
			case 5:
			{
				char sBuffer[512];
				Format(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Music Volume Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				DrawPanelItem(hPanel, "0%");
				DrawPanelItem(hPanel, "25%");
				DrawPanelItem(hPanel, "50%");
				DrawPanelItem(hPanel, "75%");
				DrawPanelItem(hPanel, "100% (Default)");
				
				SendPanelToClient(hPanel, param1, Panel_SettingsMusicVolume, 30);
				CloseHandle(hPanel);
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_hMenuMain, param1, 30);
		}
	}
}

public int Panel_SettingsFilmGrain(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_iPlayerPreferences[param1][PlayerPreference_FilmGrain] = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Film Grain", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1][PlayerPreference_FilmGrain] = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Film Grain", param1);
			}
		}
		
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}

public int Panel_SettingsHints(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_iPlayerPreferences[param1][PlayerPreference_ShowHints] = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Hints", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1][PlayerPreference_ShowHints] = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Hints", param1);
			}
		}
		
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}

public int Panel_SettingsProxy(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_iPlayerPreferences[param1][PlayerPreference_EnableProxySelection] = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Proxy", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1][PlayerPreference_EnableProxySelection] = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Proxy", param1);
			}
		}
		
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}

public int Panel_SettingsMusicVolume(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		float flDesiredVolume = 0.0;
		for (int i = 1; i < param2; i++)
			flDesiredVolume += 0.25;
		g_iPlayerPreferences[param1][PlayerPreference_MusicVolume] = flDesiredVolume;
		CPrintToChat(param1, "%t", "SF2 Music Volum Changed", RoundToNearest(flDesiredVolume*100.0));
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}

public int Panel_SettingsMuteMode(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_iPlayerPreferences[param1][PlayerPreference_MuteMode] = MuteMode_Normal;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Normal", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1][PlayerPreference_MuteMode] = MuteMode_DontHearOtherTeam;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Opposing", param1);
			}
			case 3:
			{
				g_iPlayerPreferences[param1][PlayerPreference_MuteMode] = MuteMode_DontHearOtherTeamIfNotProxy;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Proxy", param1);
			}
		}
		
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}

public int Menu_Credits2(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuCredits3, param1, MENU_TIME_FOREVER);
			case 1: DisplayMenu(g_hMenuCredits, param1, MENU_TIME_FOREVER);
		}
	}
}
public int Menu_Credits3(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuCredits4, param1, MENU_TIME_FOREVER);
			case 1: DisplayMenu(g_hMenuCredits2, param1, MENU_TIME_FOREVER);
		}
	}
}
public int Menu_Credits4(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuCredits3, param1, MENU_TIME_FOREVER);
		}
	}
}
public int Menu_Update(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		if( param2 == 0 )
			DisplayMenu(g_hMenuMain, param1, 30);
	}
	return;
}
void DisplayQueuePointsMenu(int client)
{
	Handle menu = CreateMenu(Menu_QueuePoints);
	Handle hQueueList = GetQueueList();
	
	char sBuffer[256];
	
	if (GetArraySize(hQueueList))
	{
		Format(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Reset Queue Points Option", client, g_iPlayerQueuePoints[client]);
		AddMenuItem(menu, "ponyponypony", sBuffer);
		
		int iIndex;
		char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		char sInfo[256];
		
		for (int i = 0, iSize = GetArraySize(hQueueList); i < iSize; i++)
		{
			if (!GetArrayCell(hQueueList, i, 2))
			{
				iIndex = GetArrayCell(hQueueList, i);
				
				Format(sBuffer, sizeof(sBuffer), "%N - %d", iIndex, g_iPlayerQueuePoints[iIndex]);
				Format(sInfo, sizeof(sInfo), "player_%d", GetClientUserId(iIndex));
				AddMenuItem(menu, sInfo, sBuffer, g_bPlayerPlaying[iIndex] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
			}
			else
			{
				iIndex = GetArrayCell(hQueueList, i);
				if (GetPlayerGroupMemberCount(iIndex) > 1)
				{
					GetPlayerGroupName(iIndex, sGroupName, sizeof(sGroupName));
					
					Format(sBuffer, sizeof(sBuffer), "[GROUP] %s - %d", sGroupName, GetPlayerGroupQueuePoints(iIndex));
					Format(sInfo, sizeof(sInfo), "group_%d", iIndex);
					AddMenuItem(menu, sInfo, sBuffer, IsPlayerGroupPlaying(iIndex) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
				}
				else
				{
					for (int iClient = 1; iClient <= MaxClients; iClient++)
					{
						if (!IsValidClient(iClient)) continue;
						if (ClientGetPlayerGroup(iClient) == iIndex)
						{
							Format(sBuffer, sizeof(sBuffer), "%N - %d", iClient, g_iPlayerQueuePoints[iClient]);
							Format(sInfo, sizeof(sInfo), "player_%d", GetClientUserId(iClient));
							AddMenuItem(menu, "player", sBuffer, g_bPlayerPlaying[iClient] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
							break;
						}
					}
				}
			}
		}
	}
	
	CloseHandle(hQueueList);
	
	SetMenuTitle(menu, "%t%T\n \n", "SF2 Prefix", "SF2 Queue Menu Title", client);
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

void DisplayViewGroupMembersQueueMenu(int client,int iGroupIndex)
{
	if (!IsPlayerGroupActive(iGroupIndex))
	{
		// The group isn't valid anymore. Take him back to the main menu.
		DisplayQueuePointsMenu(client);
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
		char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(iGroupIndex, sGroupName, sizeof(sGroupName));
		
		Handle hMenu = CreateMenu(Menu_ViewGroupMembersQueue);
		SetMenuTitle(hMenu, "%t%T (%s)\n \n", "SF2 Prefix", "SF2 View Group Members Menu Title", client, sGroupName);
		
		char sUserId[32];
		char sName[MAX_NAME_LENGTH * 2];
		
		for (int i = 0; i < iPlayerCount; i++)
		{
			int iClient = GetArrayCell(hPlayers, i);
			IntToString(GetClientUserId(iClient), sUserId, sizeof(sUserId));
			GetClientName(iClient, sName, sizeof(sName));
			if (GetPlayerGroupLeader(iGroupIndex) == iClient) StrCat(sName, sizeof(sName), " (LEADER)");
			
			AddMenuItem(hMenu, sUserId, sName);
		}
		
		SetMenuExitBackButton(hMenu, true);
		DisplayMenu(hMenu, client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players!
		DisplayQueuePointsMenu(client);
	}
	
	CloseHandle(hPlayers);
}

public int Menu_ViewGroupMembersQueue(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_End: CloseHandle(menu);
		case MenuAction_Select: DisplayQueuePointsMenu(param1);
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack) DisplayQueuePointsMenu(param1);
		}
	}
}

void DisplayResetQueuePointsMenu(int client)
{
	char buffer[256];

	Handle menu = CreateMenu(Menu_ResetQueuePoints);
	Format(buffer, sizeof(buffer), "%T", "Yes", client);
	AddMenuItem(menu, "0", buffer);
	Format(buffer, sizeof(buffer), "%T", "No", client);
	AddMenuItem(menu, "1", buffer);
	SetMenuTitle(menu, "%T\n \n", "SF2 Should Reset Queue Points", client);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public int Menu_QueuePoints(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			char sInfo[64];
			GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
			
			if (StrEqual(sInfo, "ponyponypony")) DisplayResetQueuePointsMenu(param1);
			else if (!StrContains(sInfo, "player_"))
			{
			}
			else if (!StrContains(sInfo, "group_"))
			{
				char sIndex[64];
				strcopy(sIndex, sizeof(sIndex), sInfo);
				ReplaceString(sIndex, sizeof(sIndex), "group_", "");
				DisplayViewGroupMembersQueueMenu(param1, StringToInt(sIndex));
			}
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				DisplayMenu(g_hMenuMain, param1, 30);
			}
		}
		case MenuAction_End: CloseHandle(menu);
	}
}

public int Menu_ResetQueuePoints(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			switch (param2)
			{
				case 0:
				{
					ClientSetQueuePoints(param1, 0);
					CPrintToChat(param1, "{olive}%T", "SF2 Queue Points Reset", param1);
					
					// Special round.
					if (IsSpecialRoundRunning()) 
					{
						SetClientPlaySpecialRoundState(param1, true);
					}
					
					/*// new boss round
					if (IsNewBossRoundRunning()) 
					{
						// If the player resets the queue points ignore them when checking for players that haven't played the new boss yet, if applicable.
						SetClientPlayNewBossRoundState(param1, true);
					}*/
				}
			}
			
			DisplayQueuePointsMenu(param1);
		}
		
		case MenuAction_End: CloseHandle(menu);
	}
}