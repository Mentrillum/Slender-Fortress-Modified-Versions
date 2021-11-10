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
Handle g_hMenuSettingsFlashlightTemp1;
Handle g_hMenuCredits;
Handle g_hMenuCredits1;
Handle g_hMenuCredits2;
Handle g_hMenuCredits3;
Handle g_hMenuCredits4;
Handle g_hMenuCredits5;
Handle g_hMenuUpdate;

#include "sf2/playergroups/menus.sp"
#include "sf2/pvp/menus.sp"

void SetupMenus()
{
	char buffer[512];
	
	// Create menus.
	g_hMenuMain = CreateMenu(Menu_Main);
	SetMenuTitle(g_hMenuMain, "%t%t\n \n", "SF2 Prefix", "SF2 Main Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t (!slhelp)", "SF2 Help Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slnext)", "SF2 Queue Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slgroup)", "SF2 Group Main Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slghost)", "SF2 Ghost Mode Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slpack)", "SF2 Boss Pack Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slnextpack)", "SF2 Boss Next Pack Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slsettings)", "SF2 Settings Menu Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	strcopy(buffer, sizeof(buffer), "Credits (!slcredits)");
	AddMenuItem(g_hMenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slbosslist)", "SF2 Boss View On List Title");
	AddMenuItem(g_hMenuMain, "0", buffer);
	
	g_hMenuVoteDifficulty = CreateMenu(Menu_VoteDifficulty);
	SetMenuTitle(g_hMenuVoteDifficulty, "%t%t\n \n", "SF2 Prefix", "SF2 Difficulty Vote Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
	AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
	AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
	AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
	
	g_hMenuHelp = CreateMenu(Menu_Help);
	SetMenuTitle(g_hMenuHelp, "%t%t\n \n", "SF2 Prefix", "SF2 Help Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Objective Menu Title");
	AddMenuItem(g_hMenuHelp, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Commands Menu Title");
	AddMenuItem(g_hMenuHelp, "1", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Class Info Menu Title");
	AddMenuItem(g_hMenuHelp, "2", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Ghost Mode Menu Title");
	AddMenuItem(g_hMenuHelp, "3", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Sprinting And Stamina Menu Title");
	AddMenuItem(g_hMenuHelp, "4", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Controls Menu Title");
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
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Scout Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Scout", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Sniper Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Sniper", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Soldier Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Soldier", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Demoman Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Demoman", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Heavy Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Heavy", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Medic Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Medic", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Pyro Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Pyro", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Spy Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Spy", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Engineer Class Info Menu Title");
	AddMenuItem(g_hMenuHelpClassInfo, "Engineer", buffer);
	SetMenuExitBackButton(g_hMenuHelpClassInfo, true);

	g_hMenuSettings = CreateMenu(Menu_Settings);
	SetMenuTitle(g_hMenuSettings, "%t%t\n \n", "SF2 Prefix", "SF2 Settings Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings PvP Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Hints Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Mute Mode Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Film Grain Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Proxy Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Flashlight Temperature Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Ghost Mode Teleport Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Ghost Mode Toggle State Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Proxy Ask Menu Title");
	AddMenuItem(g_hMenuSettings, "0", buffer);
	SetMenuExitBackButton(g_hMenuSettings, true);
	
	g_hMenuSettingsFlashlightTemp1 = CreateMenu(Menu_Settings_Flashlighttemp1);
	SetMenuTitle(g_hMenuSettingsFlashlightTemp1, buffer);
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "0", "1000 Kelvin");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "1", "2000 Kelvin");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "2", "3000 Kelvin");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "3", "4000 Kelvin");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "4", "5000 Kelvin");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "5", "6000 Kelvin (Default)");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "6", "7000 Kelvin");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "7", "8000 Kelvin");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "8", "9000 Kelvin");
	AddMenuItem(g_hMenuSettingsFlashlightTemp1, "9", "10000 Kelvin");
	SetMenuExitBackButton(g_hMenuSettingsFlashlightTemp1, true);

	g_hMenuCredits = CreateMenu(Menu_Credits);
	
	FormatEx(buffer, sizeof(buffer), "Credits\n");
	StrCat(buffer, sizeof(buffer), "Coders: KitRifty, Kenzzer, Mentrillum, The Gaben\n");
	StrCat(buffer, sizeof(buffer), "Mark J. Hadley - The creator of the Slender game\n");
	StrCat(buffer, sizeof(buffer), "Mark Steen - Compositing the intro music\n");
	StrCat(buffer, sizeof(buffer), "Toby Fox - Compositing The World Revolving\n");
	StrCat(buffer, sizeof(buffer), "Mammoth Mogul - For being a GREAT test subject\n");
	StrCat(buffer, sizeof(buffer), "Egosins - For offering to host this publicly\n");
	
	SetMenuTitle(g_hMenuCredits, buffer);
	AddMenuItem(g_hMenuCredits, "0", "Next");
	AddMenuItem(g_hMenuCredits, "1", "Back");

	g_hMenuCredits1 = CreateMenu(Menu_Credits1);
	
	FormatEx(buffer, sizeof(buffer), "Credits\n");
	StrCat(buffer, sizeof(buffer), "Glubbable - For working on a ton of maps\n");
	StrCat(buffer, sizeof(buffer), "Somberguy - Suggestions and support\n");
	StrCat(buffer, sizeof(buffer), "Omi-Box - Materials, maps, current Slender Man model, and more\n");
	StrCat(buffer, sizeof(buffer), "Narry Gewman - Imported first Slender Man model\n");
	StrCat(buffer, sizeof(buffer), "Simply Delicious - For the awesome camera overlay\n");
	StrCat(buffer, sizeof(buffer), "Jason278 -Page models");
	StrCat(buffer, sizeof(buffer), "Hydra X9K Music - Triple Bosses Music composer (Never Let Up Remix)\n");
	StrCat(buffer, sizeof(buffer), "Dj-Rec0il - Running In the 90s Remix composer\n");
	
	SetMenuTitle(g_hMenuCredits1, buffer);
	AddMenuItem(g_hMenuCredits1, "0", "Next");
	AddMenuItem(g_hMenuCredits1, "1", "Back");
	
	g_hMenuCredits2 = CreateMenu(Menu_Credits2);
	
	FormatEx(buffer, sizeof(buffer), "%tCredits\n \n", "SF2 Prefix");
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
	
	FormatEx(buffer, sizeof(buffer), "%tCredits\n \n", "SF2 Prefix");
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
	
	FormatEx(buffer, sizeof(buffer), "%tCredits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "Major special thanks to all official Modified server owners!\n \n");
	StrCat(buffer, sizeof(buffer), "Demon Hamster Eating My Wafflez\n");
	StrCat(buffer, sizeof(buffer), "Munt\n");
	StrCat(buffer, sizeof(buffer), "KanP\n");
	StrCat(buffer, sizeof(buffer), "SAXY GIBUS MAN\n");
	StrCat(buffer, sizeof(buffer), "Fire\n");
	StrCat(buffer, sizeof(buffer), "[NxN]Nameless\n");
	StrCat(buffer, sizeof(buffer), "Diviously\n");
	StrCat(buffer, sizeof(buffer), "Astolfo Alter\n");
	StrCat(buffer, sizeof(buffer), "Nekomata\n");
	
	SetMenuTitle(g_hMenuCredits4, buffer);
	AddMenuItem(g_hMenuCredits4, "0", "Next");
	AddMenuItem(g_hMenuCredits4, "1", "Back");

	g_hMenuCredits5 = CreateMenu(Menu_Credits5);
	
	FormatEx(buffer, sizeof(buffer), "%tCredits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "And finally to all of these people that helped out this version one way or another!\n \n");
	StrCat(buffer, sizeof(buffer), "Dookster\n");
	StrCat(buffer, sizeof(buffer), "Astolfo Alter\n");
	StrCat(buffer, sizeof(buffer), "Spook\n");
	StrCat(buffer, sizeof(buffer), "Rorek\n");
	StrCat(buffer, sizeof(buffer), "Chillax\n");
	StrCat(buffer, sizeof(buffer), "Staff from Disc-FF (EllieDear, Arrow Skye, tocks, and Pasta Stalin)\n");
	StrCat(buffer, sizeof(buffer), "Basically everyone at District: Zen\n");
	StrCat(buffer, sizeof(buffer), "And you for playing this new way of SF2!\n \n");

	SetMenuTitle(g_hMenuCredits5, buffer);
	AddMenuItem(g_hMenuCredits5, "0", "Back");
	
	g_hMenuUpdate = CreateMenu(Menu_Update);
	FormatEx(buffer, sizeof(buffer), "%tSlender Fortress\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "Coders: KitRifty, Kenzzer, Mentrillum, The Gaben\n");
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
	
	if (g_hMenuVoteDifficulty != null) delete g_hMenuVoteDifficulty;
	
	g_hMenuVoteDifficulty = CreateMenu(Menu_VoteDifficulty);
	SetMenuTitle(g_hMenuVoteDifficulty, "%t%t\n \n", "SF2 Prefix", "SF2 Difficulty Vote Menu Title");
	
	switch (GetRandomInt(1,6))//There's probably a better way to do this but I was tired.
	{
		case 1:
		{
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
		}
		case 2:
		{
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
		}
		case 3:
		{
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
		}
		case 4:
		{
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
		}
		case 5:
		{
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "1", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
		}
		case 6:
		{
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "3", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
			AddMenuItem(g_hMenuVoteDifficulty, "2", buffer);
			FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
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
			case 5: FakeClientCommand(param1, "sm_slnextpack");
			case 6: DisplayMenu(g_hMenuSettings, param1, 30);
			case 7: DisplayMenu(g_hMenuCredits, param1, MENU_TIME_FOREVER);
			case 8: DisplayBossList(param1);
		}
	}
}

public int Menu_VoteDifficulty(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_VoteEnd && !SF_SpecialRound(SPECIALROUND_MODBOSSES) && !g_cvRestartSession.BoolValue)
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
		
		char sInfo[64], sDisplay[256], sColor[32], sNightmareDisplay[256];
		GetMenuItem(menu, param1, sInfo, sizeof(sInfo), _, sDisplay, sizeof(sDisplay));
		
		if (IsSpecialRoundRunning() && (SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) || SF_SpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS) || SF_SpecialRound(SPECIALROUND_2DOUBLE) || SF_SpecialRound(SPECIALROUND_DEBUGMODE) || SF_SpecialRound(SPECIALROUND_ESCAPETICKETS)))
		{
			g_cvDifficulty.SetInt(Difficulty_Insane);
		}
		else if (!SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) && !SF_SpecialRound(SPECIALROUND_2DOOM) && !SF_SpecialRound(SPECIALROUND_2DOUBLE) && !SF_SpecialRound(SPECIALROUND_ESCAPETICKETS) && !SF_SpecialRound(SPECIALROUND_NOGRACE) && !SF_SpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS) && !SF_SpecialRound(SPECIALROUND_DEBUGMODE) && !SF_SpecialRound(SPECIALROUND_MODBOSSES) && (GetRandomInt(1, 200) <= 2 || bPlayersCalledForNightmare))
		{
			if (GetRandomInt(1, 20) <= 1)
			{
				g_cvDifficulty.SetInt(Difficulty_Apollyon);
			}
			else
			{
				g_cvDifficulty.SetInt(Difficulty_Nightmare);
			}
		}
		else if (IsSpecialRoundRunning() && (SF_SpecialRound(SPECIALROUND_NOGRACE) || SF_SpecialRound(SPECIALROUND_2DOOM) || SF_SpecialRound(SPECIALROUND_DEBUGMODE)))
		{
			g_cvDifficulty.SetInt(Difficulty_Hard);
		}
		else
		{
			g_cvDifficulty.SetString(sInfo);
		}
		
		int iDifficulty = g_cvDifficulty.IntValue;
		switch (iDifficulty)
		{
			case Difficulty_Easy:
			{
				FormatEx(sDisplay, sizeof(sDisplay), "%t", "SF2 Easy Difficulty");
				strcopy(sColor, sizeof(sColor), "{green}");
			}
			case Difficulty_Hard:
			{
				FormatEx(sDisplay, sizeof(sDisplay), "%t", "SF2 Hard Difficulty");
				strcopy(sColor, sizeof(sColor), "{orange}");
			}
			case Difficulty_Insane:
			{
				FormatEx(sDisplay, sizeof(sDisplay), "%t", "SF2 Insane Difficulty");
				strcopy(sColor, sizeof(sColor), "{red}");
			}
			case Difficulty_Nightmare:
			{
				FormatEx(sDisplay, sizeof(sDisplay), "%t!", "SF2 Nightmare Difficulty");
				FormatEx(sNightmareDisplay, sizeof(sNightmareDisplay), "%t mode!", "SF2 Nightmare Difficulty");
				strcopy(sColor, sizeof(sColor), "{valve}");
				for (int i = 0; i < sizeof(g_strSoundNightmareMode)-1; i++)
					EmitSoundToAll(g_strSoundNightmareMode[i]);
				SpecialRoundGameText(sNightmareDisplay, "leaderboard_streak");
			}
			case Difficulty_Apollyon:
			{
				FormatEx(sDisplay, sizeof(sDisplay), "%t!", "SF2 Apollyon Difficulty");
				FormatEx(sNightmareDisplay, sizeof(sNightmareDisplay), "%t mode!", "SF2 Apollyon Difficulty");
				strcopy(sColor, sizeof(sColor), "{darkgray}");
				for (int i = 0; i < sizeof(g_strSoundNightmareMode)-1; i++)
					EmitSoundToAll(g_strSoundNightmareMode[i]);
				SpecialRoundGameText(sNightmareDisplay, "leaderboard_streak");
				int iRandomQuote = GetRandomInt(1, 8);
				switch (iRandomQuote)
				{
					case 1:
					{
						EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_1);
						CPrintToChatAll("{purple}Snatcher{default}: Oh no! You're not slipping out of your contract THAT easily.");
					}
					case 2:
					{
						EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_2);
						CPrintToChatAll("{purple}Snatcher{default}: You ready to die some more? Great!");
					}
					case 3:
					{
						EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_3);
						CPrintToChatAll("{purple}Snatcher{default}: Live fast, die young, and leave behind a pretty corpse, huh? At least you got two out of three right.");
					}
					case 4:
					{
						EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_4);
						CPrintToChatAll("{purple}Snatcher{default}: I love the smell of DEATH in the morning.");
					}
					case 5:
					{
						EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_5);
						CPrintToChatAll("{purple}Snatcher{default}: Oh ho ho! I hope you don't think one measely death gets you out of your contract. We're only getting started.");
					}
					case 6:
					{
						EmitSoundToAll(SNATCHER_APOLLYON_1);
						CPrintToChatAll("{purple}Snatcher{default}: Ah! It gets better every time!");
					}
					case 7:
					{
						EmitSoundToAll(SNATCHER_APOLLYON_2);
						CPrintToChatAll("{purple}Snatcher{default}: Hope you enjoyed that one kiddo, because theres a lot more where that came from!");
					}
					case 8:
					{
						EmitSoundToAll(SNATCHER_APOLLYON_3);
						CPrintToChatAll("{purple}Snatcher{default}: Killing you is hard work, but it pays off. HA HA HA HA HA HA HA HA HA HA");
					}
				}
			}
			default:
			{
				FormatEx(sDisplay, sizeof(sDisplay), "%t", "SF2 Normal Difficulty");
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
						
						CPrintToChat(param1, "{dodgerblue}%T", "SF2 Ghost Mode Enabled", param1);
					}
				}
				case 1:
				{
					if (!IsClientInGhostMode(param1)) CPrintToChat(param1, "{red}%T", "SF2 Ghost Mode Disabled Already", param1);
					else
					{
						ClientSetGhostModeState(param1, false);
						TF2_RespawnPlayer(param1);
						
						CPrintToChat(param1, "{dodgerblue}%T", "SF2 Ghost Mode Disabled", param1);
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
			case 0: DisplayMenu(g_hMenuCredits1, param1, MENU_TIME_FOREVER);
			case 1: DisplayMenu(g_hMenuMain, param1, 30);
		}
	}
}

public int Menu_Credits1(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuCredits2, param1, MENU_TIME_FOREVER);
			case 1: DisplayMenu(g_hMenuCredits, param1, MENU_TIME_FOREVER);
		}
	}
}

public int Menu_ClassInfo(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_hMenuHelp, param1, 30);
		}
	}
	else if (action == MenuAction_Select)
	{
		char sInfo[64];
		GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
		
		Handle hMenu = CreateMenu(Menu_ClassInfoBackOnly);
		
		char sTitle[64], sDescription[64];
		FormatEx(sTitle, sizeof(sTitle), "SF2 Help %s Class Info Menu Title", sInfo);
		FormatEx(sDescription, sizeof(sDescription), "SF2 Help %s Class Info Description", sInfo);
		
		SetMenuTitle(hMenu, "%t%t\n \n%t\n \n", "SF2 Prefix", sTitle, sDescription);
		AddMenuItem(hMenu, "0", "Back");
		DisplayMenu(hMenu, param1, 30);
	}
}

public int Menu_ClassInfoBackOnly(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
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
				FormatEx(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Hints Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				FormatEx(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
				DrawPanelItem(hPanel, sBuffer);
				FormatEx(sBuffer, sizeof(sBuffer), "%T", "No", param1);
				DrawPanelItem(hPanel, sBuffer);
				
				SendPanelToClient(hPanel, param1, Panel_SettingsHints, 30);
				delete hPanel;
			}
			case 2:
			{
				char sBuffer[512];
				FormatEx(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Mute Mode Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				DrawPanelItem(hPanel, "Normal");
				DrawPanelItem(hPanel, "Mute opposing team");
				DrawPanelItem(hPanel, "Mute opposing team except when I'm a proxy");
				
				SendPanelToClient(hPanel, param1, Panel_SettingsMuteMode, 30);
				delete hPanel;
			}
			case 3:
			{
				char sBuffer[512];
				FormatEx(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Film Grain Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				FormatEx(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
				DrawPanelItem(hPanel, sBuffer);
				FormatEx(sBuffer, sizeof(sBuffer), "%T", "No", param1);
				DrawPanelItem(hPanel, sBuffer);
				
				SendPanelToClient(hPanel, param1, Panel_SettingsFilmGrain, 30);
				delete hPanel;
			}
			case 4:
			{
				char sBuffer[512];
				FormatEx(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Proxy Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				FormatEx(sBuffer, sizeof(sBuffer), "%T", "Yes", param1);
				DrawPanelItem(hPanel, sBuffer);
				FormatEx(sBuffer, sizeof(sBuffer), "%T", "No", param1);
				DrawPanelItem(hPanel, sBuffer);
				
				SendPanelToClient(hPanel, param1, Panel_SettingsProxy, 30);
				delete hPanel;
			}
			case 5: DisplayMenu(g_hMenuSettingsFlashlightTemp1, param1, 30);
			case 6:
			{
				char sBuffer[512];
				FormatEx(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Ghost Mode Teleport Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				DrawPanelItem(hPanel, "Teleport to only players");
				DrawPanelItem(hPanel, "Teleport to only bosses");
				
				SendPanelToClient(hPanel, param1, Panel_SettingsGhostModeTeleport, 30);
				delete hPanel;
			}
			case 7:
			{
				char sBuffer[512];
				FormatEx(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Ghost Mode Toggle State Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				DrawPanelItem(hPanel, "Default state");
				DrawPanelItem(hPanel, "Enable ghost mode upon grace period ends");
				DrawPanelItem(hPanel, "Enable ghost mode upon death on RED");
				
				SendPanelToClient(hPanel, param1, Panel_SettingsGhostModeToggleState, 30);
				delete hPanel;
			}
			case 8:
			{
				char sBuffer[512];
				FormatEx(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Settings Proxy Menu Title", param1);
				
				Handle hPanel = CreatePanel();
				SetPanelTitle(hPanel, sBuffer);
				
				DrawPanelItem(hPanel, "Enable Ask Message");
				DrawPanelItem(hPanel, "Disable Ask Message");
				
				SendPanelToClient(hPanel, param1, Panel_SettingsProxyAskMenu, 30);
				delete hPanel;
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

public int Menu_Settings_Flashlighttemp1(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 1;
				ClientSaveCookies(param1);
			}
			case 1:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 2;
				ClientSaveCookies(param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 3;
				ClientSaveCookies(param1);
			}
			case 3:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 4;
				ClientSaveCookies(param1);
			}
			case 4:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 5;
				ClientSaveCookies(param1);
			}
			case 5:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 6;
				ClientSaveCookies(param1);
			}
			case 6:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 7;
				ClientSaveCookies(param1);
			}
			case 7:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 8;
				ClientSaveCookies(param1);
			}
			case 8:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 9;
				ClientSaveCookies(param1);
			}
			case 9:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 10;
				ClientSaveCookies(param1);
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
				g_iPlayerPreferences[param1].PlayerPreference_FilmGrain = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Film Grain", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_FilmGrain = false;
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
				g_iPlayerPreferences[param1].PlayerPreference_ShowHints = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Hints", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_ShowHints = false;
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
				g_iPlayerPreferences[param1].PlayerPreference_EnableProxySelection = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Proxy", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_EnableProxySelection = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Proxy", param1);
			}
		}
		
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}

public int Panel_SettingsProxyAskMenu(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_iPlayerPreferences[param1].PlayerPreference_ProxyShowMessage = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Ask Message Proxy", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_ProxyShowMessage = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Ask Message Proxy", param1);
			}
		}
		
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
				g_iPlayerPreferences[param1].PlayerPreference_MuteMode = 0;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Normal", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_MuteMode = 1;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Opposing", param1);
			}
			case 3:
			{
				g_iPlayerPreferences[param1].PlayerPreference_MuteMode = 2;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Proxy", param1);
			}
		}
		
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}

public int Panel_SettingsGhostModeTeleport(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_iPlayerPreferences[param1].PlayerPreference_GhostModeTeleportState = 0;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Teleport Ghost Players", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_GhostModeTeleportState = 1;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Teleport Ghost Bosses", param1);
			}
		}
		
		DisplayMenu(g_hMenuSettings, param1, 30);
	}
}

public int Panel_SettingsGhostModeToggleState(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_iPlayerPreferences[param1].PlayerPreference_GhostModeToggleState = 0;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Toggle Ghost Default", param1);
			}
			case 2:
			{
				g_iPlayerPreferences[param1].PlayerPreference_GhostModeToggleState = 1;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Toggle Ghost On Grace", param1);
			}
			case 3:
			{
				g_iPlayerPreferences[param1].PlayerPreference_GhostModeToggleState = 2;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Toggle Ghost On Death", param1);
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
			case 1: DisplayMenu(g_hMenuCredits1, param1, MENU_TIME_FOREVER);
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
			case 0: DisplayMenu(g_hMenuCredits5, param1, MENU_TIME_FOREVER);
			case 1: DisplayMenu(g_hMenuCredits3, param1, MENU_TIME_FOREVER);
		}
	}
}
public int Menu_Credits5(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0: DisplayMenu(g_hMenuCredits4, param1, MENU_TIME_FOREVER);
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
	ArrayList hQueueList = GetQueueList();
	
	char sBuffer[256];
	
	if (hQueueList.Length)
	{
		FormatEx(sBuffer, sizeof(sBuffer), "%T\n \n", "SF2 Reset Queue Points Option", client, g_iPlayerQueuePoints[client]);
		AddMenuItem(menu, "ponyponypony", sBuffer);
		
		int iIndex;
		char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		char sInfo[256];
		
		for (int i = 0, iSize = hQueueList.Length; i < iSize; i++)
		{
			if (!hQueueList.Get(i, 2))
			{
				iIndex = hQueueList.Get(i);
				
				FormatEx(sBuffer, sizeof(sBuffer), "%N - %d", iIndex, g_iPlayerQueuePoints[iIndex]);
				FormatEx(sInfo, sizeof(sInfo), "player_%d", GetClientUserId(iIndex));
				AddMenuItem(menu, sInfo, sBuffer, g_bPlayerPlaying[iIndex] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
			}
			else
			{
				iIndex = hQueueList.Get(i);
				if (GetPlayerGroupMemberCount(iIndex) > 1)
				{
					GetPlayerGroupName(iIndex, sGroupName, sizeof(sGroupName));
					
					FormatEx(sBuffer, sizeof(sBuffer), "[GROUP] %s - %d", sGroupName, GetPlayerGroupQueuePoints(iIndex));
					FormatEx(sInfo, sizeof(sInfo), "group_%d", iIndex);
					AddMenuItem(menu, sInfo, sBuffer, IsPlayerGroupPlaying(iIndex) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
				}
				else
				{
					for (int iClient = 1; iClient <= MaxClients; iClient++)
					{
						if (!IsValidClient(iClient)) continue;
						if (ClientGetPlayerGroup(iClient) == iIndex)
						{
							FormatEx(sBuffer, sizeof(sBuffer), "%N - %d", iClient, g_iPlayerQueuePoints[iClient]);
							FormatEx(sInfo, sizeof(sInfo), "player_%d", GetClientUserId(iClient));
							AddMenuItem(menu, "player", sBuffer, g_bPlayerPlaying[iClient] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
							break;
						}
					}
				}
			}
		}
	}
	
	delete hQueueList;
	
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
	
	ArrayList hPlayers = new ArrayList();
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hPlayers in DisplayViewGroupMembersQueueMenu.", hPlayers);
	#endif
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		
		int iTempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(iTempGroup) || iTempGroup != iGroupIndex) continue;
		
		hPlayers.Push(i);
	}
	
	int iPlayerCount = hPlayers.Length;
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
			int iClient = hPlayers.Get(i);
			FormatEx(sUserId, sizeof(sUserId), "%d", GetClientUserId(iClient));
			FormatEx(sName, sizeof(sName), "%N", iClient);
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
	
	delete hPlayers;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hPlayers in DisplayViewGroupMembersQueueMenu.", hPlayers);
	#endif
}

public int Menu_ViewGroupMembersQueue(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
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
	FormatEx(buffer, sizeof(buffer), "%T", "Yes", client);
	AddMenuItem(menu, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "No", client);
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
			
			if (strcmp(sInfo, "ponyponypony", false) == 0) DisplayResetQueuePointsMenu(param1);
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
		case MenuAction_End: delete menu;
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
					CPrintToChat(param1, "{dodgerblue}%T", "SF2 Queue Points Reset", param1);
					
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
		
		case MenuAction_End: delete menu;
	}
}

void DisplayBossList(int client)
{
	Handle menu = CreateMenu(Menu_BossList);
	
	if (g_hConfig != null)
	{
		g_hConfig.Rewind();
		if (g_hConfig.GotoFirstSubKey())
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			char sDisplayName[SF2_MAX_NAME_LENGTH];
			
			do
			{
				g_hConfig.GetSectionName(sProfile, sizeof(sProfile));
				NPCGetBossName(_, sDisplayName, sizeof(sDisplayName), sProfile);
				if (sDisplayName[0] == '\0') strcopy(sDisplayName, sizeof(sDisplayName), sProfile);
				AddMenuItem(menu, sProfile, sDisplayName);
			}
			while (g_hConfig.GotoNextKey());
		}
	}
	SetMenuTitle(menu, "%t%T\n \n", "SF2 Prefix", "SF2 Boss List Menu Title", client);
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public int Menu_BossList(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				DisplayMenu(g_hMenuMain, param1, 30);
			}
		}
		case MenuAction_End: delete menu;
	}
}
