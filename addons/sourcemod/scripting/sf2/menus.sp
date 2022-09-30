#if defined _sf2_menus
 #endinput
#endif

#define _sf2_menus

#pragma semicolon 1

Handle g_MenuMain;
Handle g_MenuVoteDifficulty;
Handle g_MenuHelp;
Handle g_MenuHelpObjective;
Handle g_MenuHelpObjective2;
Handle g_MenuHelpCommands;
Handle g_MenuHelpSprinting;
Handle g_MenuHelpControls;
Handle g_MenuHelpClasinfo;
Handle g_MenuHelpGhostMode;
Handle g_MenuSettings;
Handle g_MenuSettingsFlashlightTemp1;
Handle g_MenuCredits;
Handle g_MenuCredits1;
Handle g_MenuCredits2;
Handle g_MenuCredits3;
Handle g_MenuCredits4;
Handle g_MenuCredits5;
Handle g_MenuUpdate;

#include "sf2/playergroups/menus.sp"
#include "sf2/pvp/menus.sp"

void SetupMenus()
{
	char buffer[512];

	// Create menus.
	g_MenuMain = CreateMenu(Menu_Main);
	SetMenuTitle(g_MenuMain, "%t%t\n \n", "SF2 Prefix", "SF2 Main Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t (!slhelp)", "SF2 Help Menu Title");
	AddMenuItem(g_MenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slnext)", "SF2 Queue Menu Title");
	AddMenuItem(g_MenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slgroup)", "SF2 Group Main Menu Title");
	AddMenuItem(g_MenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slghost)", "SF2 Ghost Mode Menu Title");
	AddMenuItem(g_MenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slpack)", "SF2 Boss Pack Menu Title");
	AddMenuItem(g_MenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slnextpack)", "SF2 Boss Next Pack Menu Title");
	AddMenuItem(g_MenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slsettings)", "SF2 Settings Menu Title");
	AddMenuItem(g_MenuMain, "0", buffer);
	strcopy(buffer, sizeof(buffer), "Credits (!slcredits)");
	AddMenuItem(g_MenuMain, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slbosslist)", "SF2 Boss View On List Title");
	AddMenuItem(g_MenuMain, "0", buffer);

	g_MenuVoteDifficulty = CreateMenu(Menu_VoteDifficulty);
	SetMenuTitle(g_MenuVoteDifficulty, "%t%t\n \n", "SF2 Prefix", "SF2 Difficulty Vote Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
	AddMenuItem(g_MenuVoteDifficulty, "1", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
	AddMenuItem(g_MenuVoteDifficulty, "2", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
	AddMenuItem(g_MenuVoteDifficulty, "3", buffer);

	g_MenuHelp = CreateMenu(Menu_Help);
	SetMenuTitle(g_MenuHelp, "%t%t\n \n", "SF2 Prefix", "SF2 Help Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Objective Menu Title");
	AddMenuItem(g_MenuHelp, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Commands Menu Title");
	AddMenuItem(g_MenuHelp, "1", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Class Info Menu Title");
	AddMenuItem(g_MenuHelp, "2", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Ghost Mode Menu Title");
	AddMenuItem(g_MenuHelp, "3", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Sprinting And Stamina Menu Title");
	AddMenuItem(g_MenuHelp, "4", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Controls Menu Title");
	AddMenuItem(g_MenuHelp, "5", buffer);
	SetMenuExitBackButton(g_MenuHelp, true);

	g_MenuHelpObjective = CreateMenu(Menu_HelpObjective);
	SetMenuTitle(g_MenuHelpObjective, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Objective Menu Title", "SF2 Help Objective Description");
	AddMenuItem(g_MenuHelpObjective, "0", "Next");
	AddMenuItem(g_MenuHelpObjective, "1", "Back");

	g_MenuHelpObjective2 = CreateMenu(Menu_HelpObjective2);
	SetMenuTitle(g_MenuHelpObjective2, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Objective Menu Title", "SF2 Help Objective Description 2");
	AddMenuItem(g_MenuHelpObjective2, "0", "Back");

	g_MenuHelpCommands = CreateMenu(Menu_BackButtonOnly);
	SetMenuTitle(g_MenuHelpCommands, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Commands Menu Title", "SF2 Help Commands Description");
	AddMenuItem(g_MenuHelpCommands, "0", "Back");

	g_MenuHelpGhostMode = CreateMenu(Menu_BackButtonOnly);
	SetMenuTitle(g_MenuHelpGhostMode, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Ghost Mode Menu Title", "SF2 Help Ghost Mode Description");
	AddMenuItem(g_MenuHelpGhostMode, "0", "Back");

	g_MenuHelpSprinting = CreateMenu(Menu_BackButtonOnly);
	SetMenuTitle(g_MenuHelpSprinting, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Sprinting And Stamina Menu Title", "SF2 Help Sprinting And Stamina Description");
	AddMenuItem(g_MenuHelpSprinting, "0", "Back");

	g_MenuHelpControls = CreateMenu(Menu_BackButtonOnly);
	SetMenuTitle(g_MenuHelpControls, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Controls Menu Title", "SF2 Help Controls Description");
	AddMenuItem(g_MenuHelpControls, "0", "Back");

	g_MenuHelpClasinfo = CreateMenu(Menu_ClassInfo);
	SetMenuTitle(g_MenuHelpClasinfo, "%t%t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Class Info Menu Title", "SF2 Help Class Info Description");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Scout Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Scout", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Sniper Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Sniper", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Soldier Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Soldier", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Demoman Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Demoman", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Heavy Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Heavy", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Medic Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Medic", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Pyro Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Pyro", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Spy Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Spy", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Engineer Class Info Menu Title");
	AddMenuItem(g_MenuHelpClasinfo, "Engineer", buffer);
	SetMenuExitBackButton(g_MenuHelpClasinfo, true);

	g_MenuSettings = CreateMenu(Menu_Settings);
	SetMenuTitle(g_MenuSettings, "%t%t\n \n", "SF2 Prefix", "SF2 Settings Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings PvP Menu Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Hints Menu Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Mute Mode Menu Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Film Grain Menu Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "Toggle camera view bobbing");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Hud Version Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Proxy Menu Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Flashlight Temperature Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Ghost Mode Teleport Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Ghost Mode Toggle State Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Proxy Ask Menu Title");
	AddMenuItem(g_MenuSettings, "0", buffer);
	SetMenuExitBackButton(g_MenuSettings, true);

	g_MenuSettingsFlashlightTemp1 = CreateMenu(Menu_Settings_Flashlighttemp1);
	SetMenuTitle(g_MenuSettingsFlashlightTemp1, buffer);
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "0", "1000 Kelvin");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "1", "2000 Kelvin");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "2", "3000 Kelvin");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "3", "4000 Kelvin");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "4", "5000 Kelvin");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "5", "6000 Kelvin (Default)");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "6", "7000 Kelvin");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "7", "8000 Kelvin");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "8", "9000 Kelvin");
	AddMenuItem(g_MenuSettingsFlashlightTemp1, "9", "10000 Kelvin");
	SetMenuExitBackButton(g_MenuSettingsFlashlightTemp1, true);

	g_MenuCredits = CreateMenu(Menu_Credits);

	FormatEx(buffer, sizeof(buffer), "Credits\n");
	StrCat(buffer, sizeof(buffer), "Coders: KitRifty, Kenzzer, Mentrillum, The Gaben\n");
	StrCat(buffer, sizeof(buffer), "Mark J. Hadley - The creator of the Slender game\n");
	StrCat(buffer, sizeof(buffer), "Mark Steen - Compositing the intro music\n");
	StrCat(buffer, sizeof(buffer), "Toby Fox - Compositing The World Revolving\n");
	StrCat(buffer, sizeof(buffer), "Mammoth Mogul - For being a GREAT test subject\n");
	StrCat(buffer, sizeof(buffer), "Egosins - For offering to host this publicly\n");

	SetMenuTitle(g_MenuCredits, buffer);
	AddMenuItem(g_MenuCredits, "0", "Next");
	AddMenuItem(g_MenuCredits, "1", "Back");

	g_MenuCredits1 = CreateMenu(Menu_Credits1);

	FormatEx(buffer, sizeof(buffer), "Credits\n");
	StrCat(buffer, sizeof(buffer), "Glubbable - For working on a ton of maps\n");
	StrCat(buffer, sizeof(buffer), "Somberguy - Suggestions and support\n");
	StrCat(buffer, sizeof(buffer), "Omi-Box - Materials, maps, current Slender Man model, and more\n");
	StrCat(buffer, sizeof(buffer), "Narry Gewman - Imported first Slender Man model\n");
	StrCat(buffer, sizeof(buffer), "Simply Delicious - For the awesome camera overlay\n");
	StrCat(buffer, sizeof(buffer), "Jason278 -Page models");
	StrCat(buffer, sizeof(buffer), "Dj-Rec0il - Running In the 90s Remix composer\n");

	SetMenuTitle(g_MenuCredits1, buffer);
	AddMenuItem(g_MenuCredits1, "0", "Next");
	AddMenuItem(g_MenuCredits1, "1", "Back");

	g_MenuCredits2 = CreateMenu(Menu_Credits2);

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

	SetMenuTitle(g_MenuCredits2, buffer);
	AddMenuItem(g_MenuCredits2, "0", "Next");
	AddMenuItem(g_MenuCredits2, "1", "Back");

	g_MenuCredits3 = CreateMenu(Menu_Credits3);

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

	SetMenuTitle(g_MenuCredits3, buffer);
	AddMenuItem(g_MenuCredits3, "0", "Next");
	AddMenuItem(g_MenuCredits3, "1", "Back");

	g_MenuCredits4 = CreateMenu(Menu_Credits4);

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

	SetMenuTitle(g_MenuCredits4, buffer);
	AddMenuItem(g_MenuCredits4, "0", "Next");
	AddMenuItem(g_MenuCredits4, "1", "Back");

	g_MenuCredits5 = CreateMenu(Menu_Credits5);

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

	SetMenuTitle(g_MenuCredits5, buffer);
	AddMenuItem(g_MenuCredits5, "0", "Back");

	g_MenuUpdate = CreateMenu(Menu_Update);
	FormatEx(buffer, sizeof(buffer), "%tSlender Fortress\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "Coders: KitRifty, Kenzzer, Mentrillum, The Gaben\n");
	StrCat(buffer, sizeof(buffer), "Version: ");
	StrCat(buffer, sizeof(buffer), PLUGIN_VERSION);
	StrCat(buffer, sizeof(buffer), "\n \n");
	Format(buffer, sizeof(buffer), "%s%t\n",buffer,"SF2 Recent Changes");
	Format(buffer, sizeof(buffer), "%s%t\n",buffer,"SF2 Change Log");
	StrCat(buffer, sizeof(buffer), "\n \n");

	SetMenuTitle(g_MenuUpdate, buffer);

	AddMenuItem(g_MenuUpdate, "0", "Display main menu");

	PvP_SetupMenus();
}

void RandomizeVoteMenu()
{
	char buffer[512];

	if (g_MenuVoteDifficulty != null)
	{
		delete g_MenuVoteDifficulty;
	}

	g_MenuVoteDifficulty = CreateMenu(Menu_VoteDifficulty);
	SetMenuTitle(g_MenuVoteDifficulty, "%t%t\n \n", "SF2 Prefix", "SF2 Difficulty Vote Menu Title");

	g_DifficultyVoteOptionsConVar.GetString(buffer, sizeof(buffer));

	bool normal = StrContains(buffer, "1") != -1;
	bool hard = StrContains(buffer, "2") != -1;
	bool insane = StrContains(buffer, "3") != -1;
	bool nightmare = StrContains(buffer, "4") != -1;
	bool apollyon = StrContains(buffer, "5") != -1;
	bool random = StrContains(buffer, "6") != -1;

	switch (GetRandomInt(1,6))//There's probably a better way to do this but I was tired.
	{
		case 1:
		{
			if (normal)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "1", buffer);
			}
			if (hard)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "2", buffer);
			}
			if (insane)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "3", buffer);
			}
		}
		case 2:
		{
			if (hard)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "2", buffer);
			}
			if (normal)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "1", buffer);
			}
			if (insane)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "3", buffer);
			}
		}
		case 3:
		{
			if (hard)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "2", buffer);
			}
			if (insane)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "3", buffer);
			}
			if (normal)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "1", buffer);
			}
		}
		case 4:
		{
			if (normal)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "1", buffer);
			}
			if (insane)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "3", buffer);
			}
			if (hard)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "2", buffer);
			}
		}
		case 5:
		{
			if (insane)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "3", buffer);
			}
			if (normal)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "1", buffer);
			}
			if (hard)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "2", buffer);
			}
		}
		case 6:
		{
			if (insane)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "3", buffer);
			}
			if (hard)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "2", buffer);
			}
			if (normal)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
				AddMenuItem(g_MenuVoteDifficulty, "1", buffer);
			}
		}
	}
	if (nightmare)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Nightmare Difficulty");
		AddMenuItem(g_MenuVoteDifficulty, "4", buffer);
	}
	if(apollyon)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Apollyon Difficulty");
		AddMenuItem(g_MenuVoteDifficulty, "5", buffer);
	}

	if (random)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Random Difficulty");
		AddMenuItem(g_MenuVoteDifficulty, "", buffer);
	}
}

public int Menu_Main(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuHelp, param1, 30);
			}
			case 1:
			{
				DisplayQueuePointsMenu(param1);
			}
			case 2:
			{
				DisplayGroupMainMenuToClient(param1);
			}
			case 3:
			{
				FakeClientCommand(param1, "sm_slghost");
			}
			case 4:
			{
				FakeClientCommand(param1, "sm_slpack");
			}
			case 5:
			{
				FakeClientCommand(param1, "sm_slnextpack");
			}
			case 6:
			{
				DisplayMenu(g_MenuSettings, param1, 30);
			}
			case 7:
			{
				DisplayMenu(g_MenuCredits, param1, MENU_TIME_FOREVER);
			}
			case 8:
			{
				DisplayBossList(param1);
			}
		}
	}
	return 0;
}

public int Menu_VoteDifficulty(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_VoteEnd && !SF_SpecialRound(SPECIALROUND_MODBOSSES) && !g_RestartSessionConVar.BoolValue)
	{
		int clientInGame = 0, clientCallingForNightmare = 0;
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && !g_PlayerEliminated[client])
			{
				clientInGame++;
				if (g_PlayerCalledForNightmare[client])
				{
					clientCallingForNightmare++;
				}
			}
		}
		bool playersCalledForNightmare = (clientInGame == clientCallingForNightmare);

		char info[64], display[256], color[32], nightmareDisplay[256];
		GetMenuItem(menu, param1, info, sizeof(info), _, display, sizeof(display));

		bool rng = false;

		if (IsSpecialRoundRunning() && (SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) || SF_SpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS) || SF_SpecialRound(SPECIALROUND_2DOUBLE) || SF_SpecialRound(SPECIALROUND_WALLHAX) || SF_SpecialRound(SPECIALROUND_ESCAPETICKETS)))
		{
			g_DifficultyConVar.SetInt(Difficulty_Insane);
		}
		else if (!SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) && !SF_SpecialRound(SPECIALROUND_2DOOM) &&
		!SF_SpecialRound(SPECIALROUND_2DOUBLE) && !SF_SpecialRound(SPECIALROUND_ESCAPETICKETS) && !SF_SpecialRound(SPECIALROUND_NOGRACE) &&
		!SF_SpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS) && !SF_SpecialRound(SPECIALROUND_WALLHAX) && !SF_SpecialRound(SPECIALROUND_MODBOSSES) &&
		(GetRandomInt(1, 200) <= 2 || playersCalledForNightmare))
		{
			if (GetRandomInt(1, 20) <= 1)
			{
				rng = true;
				g_DifficultyConVar.SetInt(Difficulty_Apollyon);
			}
			else
			{
				g_DifficultyConVar.SetInt(Difficulty_Nightmare);
			}
		}
		else if (IsSpecialRoundRunning() && (SF_SpecialRound(SPECIALROUND_NOGRACE) || SF_SpecialRound(SPECIALROUND_2DOOM)))
		{
			g_DifficultyConVar.SetInt(Difficulty_Hard);
		}
		else if (info[0] != '\0')
		{
			g_DifficultyConVar.SetString(info);
		}
		else
		{
			g_DifficultyVoteOptionsConVar.GetString(info, sizeof(info));

			if (g_DifficultyVoteRandomConVar.BoolValue)
			{
				bool normal = StrContains(info, "1") != -1;
				bool hard = StrContains(info, "2") != -1;
				bool insane = StrContains(info, "3") != -1;
				bool nightmare = StrContains(info, "4") != -1;
				bool apollyon = StrContains(info, "5") != -1;

				int count = ((normal ? 1 : 0) + (hard ? 1 : 0) + (insane ? 1 : 0) + (nightmare ? 1 : 0) + (apollyon ? 1 : 0));

				int rand = GetRandomInt(1, count);
				switch (rand)
				{
					case 5:
					{
						g_DifficultyConVar.SetInt(Difficulty_Apollyon);
					}
					case 4:
					{
						if (nightmare)
						{
							g_DifficultyConVar.SetInt(Difficulty_Nightmare);
						}
						else
						{
							g_DifficultyConVar.SetInt(Difficulty_Apollyon);
						}
					}
					case 3:
					{
						if (insane)
						{
							g_DifficultyConVar.SetInt(Difficulty_Insane);
						}
						else if (nightmare)
						{
							g_DifficultyConVar.SetInt(Difficulty_Nightmare);
						}
						else
						{
							g_DifficultyConVar.SetInt(Difficulty_Apollyon);
						}
					}
					case 2:
					{
						if (hard)
						{
							g_DifficultyConVar.SetInt(Difficulty_Hard);
						}
						else if (insane)
						{
							g_DifficultyConVar.SetInt(Difficulty_Insane);
						}
						else if (nightmare)
						{
							g_DifficultyConVar.SetInt(Difficulty_Nightmare);
						}
						else
						{
							g_DifficultyConVar.SetInt(Difficulty_Apollyon);
						}
					}
					case 1:
					{
						if (normal)
						{
							g_DifficultyConVar.SetInt(Difficulty_Normal);
						}
						else if (hard)
						{
							g_DifficultyConVar.SetInt(Difficulty_Hard);
						}
						else if (insane)
						{
							g_DifficultyConVar.SetInt(Difficulty_Insane);
						}
						else if (nightmare)
						{
							g_DifficultyConVar.SetInt(Difficulty_Nightmare);
						}
						else
						{
							g_DifficultyConVar.SetInt(Difficulty_Apollyon);
						}
					}
				}
			}
			else
			{
				g_DifficultyConVar.SetInt(GetRandomInt(Difficulty_Normal, Difficulty_Apollyon));
			}
		}

		int difficulty = g_DifficultyConVar.IntValue;
		switch (difficulty)
		{
			case Difficulty_Easy:
			{
				FormatEx(display, sizeof(display), "%t", "SF2 Easy Difficulty");
				strcopy(color, sizeof(color), "{green}");
			}
			case Difficulty_Hard:
			{
				FormatEx(display, sizeof(display), "%t", "SF2 Hard Difficulty");
				strcopy(color, sizeof(color), "{orange}");
			}
			case Difficulty_Insane:
			{
				FormatEx(display, sizeof(display), "%t", "SF2 Insane Difficulty");
				strcopy(color, sizeof(color), "{red}");
			}
			case Difficulty_Nightmare:
			{
				FormatEx(display, sizeof(display), "%t!", "SF2 Nightmare Difficulty");
				FormatEx(nightmareDisplay, sizeof(nightmareDisplay), "%t mode!", "SF2 Nightmare Difficulty");
				strcopy(color, sizeof(color), "{valve}");
				for (int i = 0; i < sizeof(g_SoundNightmareMode)-1; i++)
				{
					EmitSoundToAll(g_SoundNightmareMode[i]);
				}
				SpecialRoundGameText(nightmareDisplay, "leaderboard_streak");
			}
			case Difficulty_Apollyon:
			{
				FormatEx(display, sizeof(display), "%t!", "SF2 Apollyon Difficulty");
				FormatEx(nightmareDisplay, sizeof(nightmareDisplay), "%t mode!", "SF2 Apollyon Difficulty");
				strcopy(color, sizeof(color), "{darkgray}");
				for (int i = 0; i < sizeof(g_SoundNightmareMode)-1; i++)
				{
					EmitSoundToAll(g_SoundNightmareMode[i]);
				}
				SpecialRoundGameText(nightmareDisplay, "leaderboard_streak");
				if (rng)
				{
					int randomQuote = GetRandomInt(1, 8);
					switch (randomQuote)
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
			}
			default:
			{
				FormatEx(display, sizeof(display), "%t", "SF2 Normal Difficulty");
				strcopy(color, sizeof(color), "{yellow}");
			}
		}

		CPrintToChatAll("%t %s%s", "SF2 Difficulty Vote Finished", color, display);
	}
	return 0;
}

public int Menu_GhostMode(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		if (IsRoundEnding() ||
			IsRoundInWarmup() ||
			!g_PlayerEliminated[param1] ||
			!IsClientParticipating(param1) ||
			g_PlayerProxy[param1])
		{
			CPrintToChat(param1, "{red}%T", "SF2 Ghost Mode Not Allowed", param1);
		}
		else
		{
			switch (param2)
			{
				case 0:
				{
					if (IsClientInGhostMode(param1))
					{
						CPrintToChat(param1, "{red}%T", "SF2 Ghost Mode Enabled Already", param1);
					}
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
					if (!IsClientInGhostMode(param1))
					{
						CPrintToChat(param1, "{red}%T", "SF2 Ghost Mode Disabled Already", param1);
					}
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
	return 0;
}

public int Menu_Help(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuHelpObjective, param1, 30);
			}
			case 1:
			{
				DisplayMenu(g_MenuHelpCommands, param1, 30);
			}
			case 2:
			{
				DisplayMenu(g_MenuHelpClasinfo, param1, 30);
			}
			case 3:
			{
				DisplayMenu(g_MenuHelpGhostMode, param1, 30);
			}
			case 4:
			{
				DisplayMenu(g_MenuHelpSprinting, param1, 30);
			}
			case 5:
			{
				DisplayMenu(g_MenuHelpControls, param1, 30);
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_MenuMain, param1, 30);
		}
	}
	return 0;
}

public int Menu_HelpObjective(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuHelpObjective2, param1, 30);
			}
			case 1:
			{
				DisplayMenu(g_MenuHelp, param1, 30);
			}
		}
	}
	return 0;
}

public int Menu_HelpObjective2(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuHelpObjective, param1, 30);
			}
		}
	}
	return 0;
}

public int Menu_BackButtonOnly(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuHelp, param1, 30);
			}
		}
	}
	return 0;
}

public int Menu_Credits(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuCredits1, param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				DisplayMenu(g_MenuMain, param1, 30);
			}
		}
	}
	return 0;
}

public int Menu_Credits1(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuCredits2, param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				DisplayMenu(g_MenuCredits, param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}

public int Menu_ClassInfo(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_MenuHelp, param1, 30);
		}
	}
	else if (action == MenuAction_Select)
	{
		char info[64];
		GetMenuItem(menu, param2, info, sizeof(info));

		Handle menuHandle = CreateMenu(Menu_ClassInfoBackOnly);

		char title[64], description[64];
		FormatEx(title, sizeof(title), "SF2 Help %s Class Info Menu Title", info);
		FormatEx(description, sizeof(description), "SF2 Help %s Class Info Description", info);

		SetMenuTitle(menuHandle, "%t%t\n \n%t\n \n", "SF2 Prefix", title, description);
		AddMenuItem(menuHandle, "0", "Back");
		DisplayMenu(menuHandle, param1, 30);
	}
	return 0;
}

public int Menu_ClassInfoBackOnly(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		DisplayMenu(g_MenuHelpClasinfo, param1, 30);
	}
	return 0;
}

public int Menu_Settings(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuSettingsPvP, param1, 30);
			}
			case 1:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Hints Menu Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
				DrawPanelItem(panel, buffer);
				FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
				DrawPanelItem(panel, buffer);

				SendPanelToClient(panel, param1, Panel_SettingsHints, 30);
				delete panel;
			}
			case 2:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Mute Mode Menu Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				DrawPanelItem(panel, "Normal");
				DrawPanelItem(panel, "Mute opposing team");
				DrawPanelItem(panel, "Mute opposing team except when I'm a proxy");

				SendPanelToClient(panel, param1, Panel_SettingsMuteMode, 30);
				delete panel;
			}
			case 3:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Film Grain Menu Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
				DrawPanelItem(panel, buffer);
				FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
				DrawPanelItem(panel, buffer);

				SendPanelToClient(panel, param1, Panel_SettingsFilmGrain, 30);
				delete panel;
			}
			case 4:
			{
				FakeClientCommand(param1, "sm_slviewbob");
			}
			case 5:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Hud Version Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				DrawPanelItem(panel, "Use the new HUD");
				DrawPanelItem(panel, "Use the legacy HUD");

				SendPanelToClient(panel, param1, Panel_SettingsHudVersion, 30);
				delete panel;
			}
			case 6:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Proxy Menu Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
				DrawPanelItem(panel, buffer);
				FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
				DrawPanelItem(panel, buffer);

				SendPanelToClient(panel, param1, Panel_SettingsProxy, 30);
				delete panel;
			}
			case 7:
			{
				DisplayMenu(g_MenuSettingsFlashlightTemp1, param1, 30);
			}
			case 8:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Ghost Mode Teleport Menu Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				DrawPanelItem(panel, "Teleport to only players");
				DrawPanelItem(panel, "Teleport to only bosses");

				SendPanelToClient(panel, param1, Panel_SettingsGhostModeTeleport, 30);
				delete panel;
			}
			case 9:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Ghost Mode Toggle State Menu Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				DrawPanelItem(panel, "Default state");
				DrawPanelItem(panel, "Enable ghost mode upon grace period ends");
				DrawPanelItem(panel, "Enable ghost mode upon death on RED");

				SendPanelToClient(panel, param1, Panel_SettingsGhostModeToggleState, 30);
				delete panel;
			}
			case 10:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Proxy Menu Title", param1);

				Handle panel = CreatePanel();
				SetPanelTitle(panel, buffer);

				DrawPanelItem(panel, "Enable Ask Message");
				DrawPanelItem(panel, "Disable Ask Message");

				SendPanelToClient(panel, param1, Panel_SettingsProxyAskMenu, 30);
				delete panel;
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_MenuMain, param1, 30);
		}
	}
	return 0;
}

public int Menu_Settings_Flashlighttemp1(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 1;
				ClientSaveCookies(param1);
			}
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 2;
				ClientSaveCookies(param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 3;
				ClientSaveCookies(param1);
			}
			case 3:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 4;
				ClientSaveCookies(param1);
			}
			case 4:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 5;
				ClientSaveCookies(param1);
			}
			case 5:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 6;
				ClientSaveCookies(param1);
			}
			case 6:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 7;
				ClientSaveCookies(param1);
			}
			case 7:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 8;
				ClientSaveCookies(param1);
			}
			case 8:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 9;
				ClientSaveCookies(param1);
			}
			case 9:
			{
				g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature = 10;
				ClientSaveCookies(param1);
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMenu(g_MenuMain, param1, 30);
		}
	}
	return 0;
}

public int Panel_SettingsFilmGrain(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_FilmGrain = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Film Grain", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_FilmGrain = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Film Grain", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsHints(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_ShowHints = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Hints", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_ShowHints = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Hints", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsProxy(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_EnableProxySelection = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Proxy", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_EnableProxySelection = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Proxy", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsProxyAskMenu(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_ProxyShowMessage = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Enabled Ask Message Proxy", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_ProxyShowMessage = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Disabled Ask Message Proxy", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsMuteMode(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_MuteMode = 0;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Normal", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_MuteMode = 1;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Opposing", param1);
			}
			case 3:
			{
				g_PlayerPreferences[param1].PlayerPreference_MuteMode = 2;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Mute Mode Proxy", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsGhostModeTeleport(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_GhostModeTeleportState = 0;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Teleport Ghost Players", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_GhostModeTeleportState = 1;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Teleport Ghost Bosses", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsGhostModeToggleState(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_GhostModeToggleState = 0;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Toggle Ghost Default", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_GhostModeToggleState = 1;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Toggle Ghost On Grace", param1);
			}
			case 3:
			{
				g_PlayerPreferences[param1].PlayerPreference_GhostModeToggleState = 2;
				ClientUpdateListeningFlags(param1);
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Toggle Ghost On Death", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsHudVersion(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_LegacyHud = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 New Hud Use", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_LegacyHud = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Legacy Hud Use", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Panel_SettingsViewBobbing(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				g_PlayerPreferences[param1].PlayerPreference_ViewBobbing = true;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Toggle View Bobbing On", param1);
			}
			case 2:
			{
				g_PlayerPreferences[param1].PlayerPreference_ViewBobbing = false;
				ClientSaveCookies(param1);
				CPrintToChat(param1, "%T", "SF2 Toggle View Bobbing Off", param1);
			}
		}

		DisplayMenu(g_MenuSettings, param1, 30);
	}
	return 0;
}

public int Menu_Credits2(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuCredits3, param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				DisplayMenu(g_MenuCredits1, param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}
public int Menu_Credits3(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuCredits4, param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				DisplayMenu(g_MenuCredits2, param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}
public int Menu_Credits4(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuCredits5, param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				DisplayMenu(g_MenuCredits3, param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}
public int Menu_Credits5(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				DisplayMenu(g_MenuCredits4, param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}
public int Menu_Update(Handle menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 0)
		{
			DisplayMenu(g_MenuMain, param1, 30);
		}
	}
	return 0;
}
void DisplayQueuePointsMenu(int client)
{
	Handle menu = CreateMenu(Menu_QueuePoints);
	ArrayList queueList = GetQueueList();

	char buffer[256];

	if (queueList.Length)
	{
		FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Reset Queue Points Option", client, g_PlayerQueuePoints[client]);
		AddMenuItem(menu, "ponyponypony", buffer);

		int index;
		char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		char info[256];

		for (int i = 0, iSize = queueList.Length; i < iSize; i++)
		{
			if (!queueList.Get(i, 2))
			{
				index = queueList.Get(i);

				FormatEx(buffer, sizeof(buffer), "%N - %d", index, g_PlayerQueuePoints[index]);
				FormatEx(info, sizeof(info), "player_%d", GetClientUserId(index));
				AddMenuItem(menu, info, buffer, g_PlayerPlaying[index] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
			}
			else
			{
				index = queueList.Get(i);
				if (GetPlayerGroupMemberCount(index) > 1)
				{
					GetPlayerGroupName(index, groupName, sizeof(groupName));

					FormatEx(buffer, sizeof(buffer), "[GROUP] %s - %d", groupName, GetPlayerGroupQueuePoints(index));
					FormatEx(info, sizeof(info), "group_%d", index);
					AddMenuItem(menu, info, buffer, IsPlayerGroupPlaying(index) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
				}
				else
				{
					for (int i2 = 1; i2 <= MaxClients; i2++)
					{
						if (!IsValidClient(i2))
						{
							continue;
						}
						if (ClientGetPlayerGroup(i2) == index)
						{
							FormatEx(buffer, sizeof(buffer), "%N - %d", i2, g_PlayerQueuePoints[i2]);
							FormatEx(info, sizeof(info), "player_%d", GetClientUserId(i2));
							AddMenuItem(menu, "player", buffer, g_PlayerPlaying[i2] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
							break;
						}
					}
				}
			}
		}
	}

	delete queueList;

	SetMenuTitle(menu, "%t%T\n \n", "SF2 Prefix", "SF2 Queue Menu Title", client);
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

void DisplayViewGroupMembersQueueMenu(int client,int groupIndex)
{
	if (!IsPlayerGroupActive(groupIndex))
	{
		// The group isn't valid anymore. Take him back to the main menu.
		DisplayQueuePointsMenu(client);
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return;
	}

	ArrayList playersArray = new ArrayList();
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for playersArray in DisplayViewGroupMembersQueueMenu.", playersArray);
	#endif
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		int iTempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(iTempGroup) || iTempGroup != groupIndex)
		{
			continue;
		}

		playersArray.Push(i);
	}

	int playerCount = playersArray.Length;
	if (playerCount)
	{
		char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
		GetPlayerGroupName(groupIndex, groupName, sizeof(groupName));

		Handle menuHandle = CreateMenu(Menu_ViewGroupMembersQueue);
		SetMenuTitle(menuHandle, "%t%T (%s)\n \n", "SF2 Prefix", "SF2 View Group Members Menu Title", client, groupName);

		char userId[32];
		char name[MAX_NAME_LENGTH * 2];

		for (int i = 0; i < playerCount; i++)
		{
			int clientArray = playersArray.Get(i);
			FormatEx(userId, sizeof(userId), "%d", GetClientUserId(clientArray));
			FormatEx(name, sizeof(name), "%N", clientArray);
			if (GetPlayerGroupLeader(groupIndex) == clientArray)
			{
				StrCat(name, sizeof(name), " (LEADER)");
			}

			AddMenuItem(menuHandle, userId, name);
		}

		SetMenuExitBackButton(menuHandle, true);
		DisplayMenu(menuHandle, client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players!
		DisplayQueuePointsMenu(client);
	}

	delete playersArray;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for playersArray in DisplayViewGroupMembersQueueMenu.", playersArray);
	#endif
}

public int Menu_ViewGroupMembersQueue(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_Select:
		{
			DisplayQueuePointsMenu(param1);
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				DisplayQueuePointsMenu(param1);
			}
		}
	}
	return 0;
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
			char info[64];
			GetMenuItem(menu, param2, info, sizeof(info));

			if (strcmp(info, "ponyponypony", false) == 0)
			{
				DisplayResetQueuePointsMenu(param1);
			}
			else if (!StrContains(info, "player_"))
			{
			}
			else if (!StrContains(info, "group_"))
			{
				char sIndex[64];
				strcopy(sIndex, sizeof(sIndex), info);
				ReplaceString(sIndex, sizeof(sIndex), "group_", "");
				DisplayViewGroupMembersQueueMenu(param1, StringToInt(sIndex));
			}
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				DisplayMenu(g_MenuMain, param1, 30);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
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

		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

void DisplayBossList(int client)
{
	Handle menu = CreateMenu(Menu_BossList);

	ArrayList bossList = GetBossProfileList();

	if (bossList != null)
	{
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
			AddMenuItem(menu, profile, displayName);
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
				DisplayMenu(g_MenuMain, param1, 30);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}
