#if defined _sf2_menus
 #endinput
#endif

#define _sf2_menus

#pragma semicolon 1

Menu g_MenuMain;
Menu g_MenuVoteDifficulty;
Menu g_MenuHelp;
Menu g_MenuHelpObjective;
Menu g_MenuHelpObjective2;
Menu g_MenuHelpCommands;
Menu g_MenuHelpSprinting;
Menu g_MenuHelpControls;
Menu g_MenuHelpClassInfo;
Menu g_MenuHelpGhostMode;
Menu g_MenuSettings;
Menu g_MenuSettingsFlashlightTemp1;
Menu g_MenuCredits;
Menu g_MenuCredits1;
Menu g_MenuCredits2;
Menu g_MenuCredits3;
Menu g_MenuCredits4;
Menu g_MenuCredits5;

static ArrayList g_Voters;
static bool g_IsRunOff;

#include "sf2/playergroups/menus.sp"
#include "sf2/pvp/menus.sp"
#include "sf2/changelog.sp"

void SetupMenus()
{
	char buffer[512];

	// Create menus.
	g_MenuMain = new Menu(Menu_Main);
	g_MenuMain.SetTitle("%t %t\n \n", "SF2 Prefix", "SF2 Main Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t (!slhelp)", "SF2 Help Menu Title");
	g_MenuMain.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slnext)", "SF2 Queue Menu Title");
	g_MenuMain.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slgroup)", "SF2 Group Main Menu Title");
	g_MenuMain.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slghost)", "SF2 Ghost Mode Menu Title");
	g_MenuMain.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slpack)", "SF2 Boss Pack Menu Title");
	g_MenuMain.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slnextpack)", "SF2 Boss Next Pack Menu Title");
	g_MenuMain.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slsettings)", "SF2 Settings Menu Title");
	g_MenuMain.AddItem("0", buffer);
	strcopy(buffer, sizeof(buffer), "Credits (!slcredits)");
	g_MenuMain.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t (!slbosslist)", "SF2 Boss View On List Title");
	g_MenuMain.AddItem("0", buffer);

	g_MenuHelp = new Menu(Menu_Help);
	g_MenuHelp.SetTitle("%t %t\n \n", "SF2 Prefix", "SF2 Help Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Objective Menu Title");
	g_MenuHelp.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Commands Menu Title");
	g_MenuHelp.AddItem("1", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Class Info Menu Title");
	g_MenuHelp.AddItem("2", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Ghost Mode Menu Title");
	g_MenuHelp.AddItem("3", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Sprinting And Stamina Menu Title");
	g_MenuHelp.AddItem("4", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Controls Menu Title");
	g_MenuHelp.AddItem("5", buffer);
	g_MenuHelp.ExitBackButton = true;

	g_MenuHelpObjective = new Menu(Menu_HelpObjective);
	g_MenuHelpObjective.SetTitle("%t %t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Objective Menu Title", "SF2 Help Objective Description");
	g_MenuHelpObjective.AddItem("0", "Next");
	g_MenuHelpObjective.AddItem("1", "Back");

	g_MenuHelpObjective2 = new Menu(Menu_HelpObjective2);
	g_MenuHelpObjective2.SetTitle("%t %t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Objective Menu Title", "SF2 Help Objective Description 2");
	g_MenuHelpObjective2.AddItem("0", "Back");

	g_MenuHelpCommands = new Menu(Menu_BackButtonOnly);
	g_MenuHelpCommands.SetTitle("%t %t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Commands Menu Title", "SF2 Help Commands Description");
	g_MenuHelpCommands.AddItem("0", "Back");

	g_MenuHelpGhostMode = new Menu(Menu_BackButtonOnly);
	g_MenuHelpGhostMode.SetTitle("%t %t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Ghost Mode Menu Title", "SF2 Help Ghost Mode Description");
	g_MenuHelpGhostMode.AddItem("0", "Back");

	g_MenuHelpSprinting = new Menu(Menu_BackButtonOnly);
	g_MenuHelpSprinting.SetTitle("%t %t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Sprinting And Stamina Menu Title", "SF2 Help Sprinting And Stamina Description");
	g_MenuHelpSprinting.AddItem("0", "Back");

	g_MenuHelpControls = new Menu(Menu_BackButtonOnly);
	g_MenuHelpControls.SetTitle("%t %t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Controls Menu Title", "SF2 Help Controls Description");
	g_MenuHelpControls.AddItem("0", "Back");

	g_MenuHelpClassInfo = new Menu(Menu_ClassInfo);
	g_MenuHelpClassInfo.SetTitle("%t %t\n \n%t\n \n", "SF2 Prefix", "SF2 Help Class Info Menu Title", "SF2 Help Class Info Description");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Scout Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Scout", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Sniper Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Sniper", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Soldier Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Soldier", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Demoman Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Demoman", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Heavy Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Heavy", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Medic Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Medic", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Pyro Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Pyro", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Spy Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Spy", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Help Engineer Class Info Menu Title");
	g_MenuHelpClassInfo.AddItem("Engineer", buffer);
	g_MenuHelpClassInfo.ExitBackButton = true;

	g_MenuSettings = new Menu(Menu_Settings);
	g_MenuSettings.SetTitle("%t %t\n \n", "SF2 Prefix", "SF2 Settings Menu Title");
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings PvP Menu Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Hints Menu Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Mute Mode Menu Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Film Grain Menu Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings View Bobbing Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Hud Version Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Proxy Menu Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Music Volume Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Flashlight Temperature Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Ghost Mode Teleport Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Ghost Mode Toggle State Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Proxy Ask Menu Title");
	g_MenuSettings.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings PvE Menu Title");
	g_MenuSettings.AddItem("0", buffer);
	g_MenuSettings.ExitBackButton = true;

	g_MenuSettingsFlashlightTemp1 = new Menu(Menu_Settings_Flashlighttemp1);
	FormatEx(buffer, sizeof(buffer), "%t", "SF2 Settings Flashlight Temperature Title");
	g_MenuSettingsFlashlightTemp1.SetTitle(buffer);
	g_MenuSettingsFlashlightTemp1.AddItem("0", "1k Kelvin");
	g_MenuSettingsFlashlightTemp1.AddItem("1", "2k Kelvin");
	g_MenuSettingsFlashlightTemp1.AddItem("2", "3k Kelvin");
	g_MenuSettingsFlashlightTemp1.AddItem("3", "4k Kelvin");
	g_MenuSettingsFlashlightTemp1.AddItem("4", "5k Kelvin");
	g_MenuSettingsFlashlightTemp1.AddItem("5", "6k Kelvin (Default)");
	g_MenuSettingsFlashlightTemp1.AddItem("6", "7k Kelvin");
	g_MenuSettingsFlashlightTemp1.AddItem("7", "8k Kelvin");
	g_MenuSettingsFlashlightTemp1.AddItem("8", "9k Kelvin");
	g_MenuSettingsFlashlightTemp1.AddItem("9", "10k Kelvin");
	g_MenuSettingsFlashlightTemp1.ExitBackButton = true;

	g_MenuCredits = new Menu(Menu_Credits);

	FormatEx(buffer, sizeof(buffer), "%t Credits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "Coders: KitRifty, Kenzzer, Mentrillum, The Gaben\n");
	StrCat(buffer, sizeof(buffer), "Mark J. Hadley - The creator of the Slender game\n");
	StrCat(buffer, sizeof(buffer), "Mark Steen - Compositing the intro music\n");
	StrCat(buffer, sizeof(buffer), "Toby Fox - Compositing The World Revolving\n");
	StrCat(buffer, sizeof(buffer), "Mammoth Mogul - For being a GREAT test subject\n");
	StrCat(buffer, sizeof(buffer), "Egosins - For offering to host this publicly\n");

	g_MenuCredits.SetTitle(buffer);
	g_MenuCredits.AddItem("0", "Next");
	g_MenuCredits.AddItem("1", "Back");

	g_MenuCredits1 = new Menu(Menu_Credits1);

	FormatEx(buffer, sizeof(buffer), "%t Credits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "Glubbable - For working on a ton of maps\n");
	StrCat(buffer, sizeof(buffer), "Somberguy - Suggestions and support\n");
	StrCat(buffer, sizeof(buffer), "Omi-Box - Materials, maps, current Slender Man model, and more\n");
	StrCat(buffer, sizeof(buffer), "Narry Gewman - Imported first Slender Man model\n");
	StrCat(buffer, sizeof(buffer), "Simply Delicious - For the awesome camera overlay\n");
	StrCat(buffer, sizeof(buffer), "Jason278 - Page models");
	StrCat(buffer, sizeof(buffer), "Dj-Rec0il - Running In the 90s Remix composer\n");

	g_MenuCredits1.SetTitle(buffer);
	g_MenuCredits1.AddItem("0", "Next");
	g_MenuCredits1.AddItem("1", "Back");

	g_MenuCredits2 = new Menu(Menu_Credits2);

	FormatEx(buffer, sizeof(buffer), "%t Credits\n \n", "SF2 Prefix");
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

	g_MenuCredits2.SetTitle(buffer);
	g_MenuCredits2.AddItem("0", "Next");
	g_MenuCredits2.AddItem("1", "Back");

	g_MenuCredits3 = new Menu(Menu_Credits3);

	FormatEx(buffer, sizeof(buffer), "%t Credits\n \n", "SF2 Prefix");
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

	g_MenuCredits3.SetTitle(buffer);
	g_MenuCredits3.AddItem("0", "Next");
	g_MenuCredits3.AddItem("1", "Back");

	g_MenuCredits4 = new Menu(Menu_Credits4);

	FormatEx(buffer, sizeof(buffer), "%t Credits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "Major special thanks to all official Modified server owners!\n \n");
	StrCat(buffer, sizeof(buffer), "Demon Hamster Eating My Wafflez\n");
	StrCat(buffer, sizeof(buffer), "Munt\n");
	StrCat(buffer, sizeof(buffer), "KanP\n");
	StrCat(buffer, sizeof(buffer), "SAXY GIBUS MAN\n");
	StrCat(buffer, sizeof(buffer), "Fire\n");

	g_MenuCredits4.SetTitle(buffer);
	g_MenuCredits4.AddItem("0", "Next");
	g_MenuCredits4.AddItem("1", "Back");

	g_MenuCredits5 = new Menu(Menu_Credits5);

	FormatEx(buffer, sizeof(buffer), "%t Credits\n \n", "SF2 Prefix");
	StrCat(buffer, sizeof(buffer), "And finally to all of these people that helped out this version one way or another!\n \n");
	StrCat(buffer, sizeof(buffer), "KitRifty\n");
	StrCat(buffer, sizeof(buffer), "Spook\n");
	StrCat(buffer, sizeof(buffer), "Rorek\n");
	StrCat(buffer, sizeof(buffer), "Chillax\n");
	StrCat(buffer, sizeof(buffer), "Staff from Disc-FF (EllieDear, Arrow Skye, tocks, Pasta Stalin, etc)\n");
	StrCat(buffer, sizeof(buffer), "Basically everyone at Disc-FF\n");
	StrCat(buffer, sizeof(buffer), "And you for playing this new way of SF2!\n \n");

	g_MenuCredits5.SetTitle(buffer);
	g_MenuCredits5.AddItem("0", "Back");

	PvP_SetupMenus();
	PvE_SetupMenus();
}

void RandomizeVoteMenu(bool excludeHigh = false)
{
	char buffer[512];

	if (g_MenuVoteDifficulty != null)
	{
		delete g_MenuVoteDifficulty;
	}

	if (g_Voters != null)
	{
		delete g_Voters;
	}

	g_Voters = new ArrayList(2);
	g_IsRunOff = false;

	g_MenuVoteDifficulty = new Menu((g_DifficultyVoteRevoteConVar.FloatValue > 0.0) ? Menu_VoteNoneDifficulty : Menu_VoteDifficulty);
	g_MenuVoteDifficulty.SetTitle("%t %t\n \n", "SF2 Prefix", "SF2 Difficulty Vote Menu Title");

	g_DifficultyVoteOptionsConVar.GetString(buffer, sizeof(buffer));

	bool normal = StrContains(buffer, "1") != -1;
	bool hard = StrContains(buffer, "2") != -1;
	bool insane = StrContains(buffer, "3") != -1;
	bool nightmare = StrContains(buffer, "4") != -1;
	bool apollyon = StrContains(buffer, "5") != -1;
	bool random = StrContains(buffer, "6") != -1;

	if (excludeHigh)
	{
		nightmare = false;
		apollyon = false;
	}

	// WHOA there is a better way, and I'm not tired
	ArrayList options = new ArrayList(ByteCountToCells(64));
	ArrayList indicies = new ArrayList();
	int index = 0;
	if (normal)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Normal Difficulty");
		options.PushString(buffer);
		indicies.Push(1);
		index++;
	}

	if (hard)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Hard Difficulty");
		options.PushString(buffer);
		indicies.Push(2);
		index++;
	}

	if (insane)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Insane Difficulty");
		options.PushString(buffer);
		indicies.Push(3);
		index++;
	}

	if (nightmare)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Nightmare Difficulty");
		options.PushString(buffer);
		indicies.Push(4);
		index++;
	}

	if (apollyon)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Apollyon Difficulty");
		options.PushString(buffer);
		indicies.Push(5);
		index++;
	}

	int participating = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsClientParticipating(i) || IsFakeClient(i))
		{
			continue;
		}

		participating++;
	}

	if (!excludeHigh)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsValidClient(i) || g_PlayerEliminated[i])
			{
				continue;
			}

			int group = ClientGetPlayerGroup(i);
			if (!IsPlayerGroupValid(group) || !IsPlayerGroupOptInHarder(group))
			{
				continue;
			}

			if (GetPlayerGroupMemberCount(group) < participating)
			{
				if (GetPlayerGroupMemberCount(group) < GetMaxPlayersForRound())
				{
					continue;
				}
			}

			if (!nightmare)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Nightmare Difficulty");
				options.PushString(buffer);
				indicies.Push(4);
				index++;
			}

			if (!apollyon)
			{
				FormatEx(buffer, sizeof(buffer), "%t", "SF2 Apollyon Difficulty");
				options.PushString(buffer);
				indicies.Push(5);
				index++;
			}
			break;
		}
	}

	if (random)
	{
		FormatEx(buffer, sizeof(buffer), "%t", "SF2 Random Difficulty");
		options.PushString(buffer);
		indicies.Push(6);
		index++;
	}

	// I'm going to say that the random shuffle for the array list sucks, so I'm doing my own
	ArrayList actualOptions = new ArrayList(ByteCountToCells(64));
	ArrayList actualIndicies = new ArrayList();
	for (int i = 0; i < options.Length;)
	{
		int arrayIndex = GetRandomInt(0, options.Length - 1);
		char choice[64];
		options.GetString(arrayIndex, choice, sizeof(choice));
		actualOptions.PushString(choice);
		actualIndicies.Push(indicies.Get(arrayIndex));
		options.Erase(arrayIndex);
		indicies.Erase(arrayIndex);
	}

	for (int i = 0; i < actualOptions.Length; i++)
	{
		int indexToAdd = actualIndicies.Get(i);
		char choice[64], value[2];
		actualOptions.GetString(i, choice, sizeof(choice));
		FormatEx(value, sizeof(value), "%d", indexToAdd);
		g_MenuVoteDifficulty.AddItem(value, choice);
	}

	delete options;
	delete indicies;
	delete actualOptions;
	delete actualIndicies;

	if (g_DifficultyVoteRevoteConVar.FloatValue > 0.0)
	{
		SetVoteResultCallback(g_MenuVoteDifficulty, Menu_VoteRunoffDifficulty);
	}
}

static int Menu_Main(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuHelp.Display(param1, 30);
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
				g_MenuSettings.Display(param1, 30);
			}
			case 7:
			{
				g_MenuCredits.Display(param1, MENU_TIME_FOREVER);
			}
			case 8:
			{
				DisplayBossList(param1);
			}
		}
	}
	return 0;
}

static void Menu_VoteRunoffDifficulty(Menu oldmenu, int votes, int clients, const int[][] clientInfo, int items, const int[][] itemInfo)
{
	if (items > 1)
	{
		float runoff = g_DifficultyVoteRevoteConVar.FloatValue;
		if (runoff)
		{
			if (float(itemInfo[0][VOTEINFO_ITEM_VOTES]) <= (votes * runoff))
			{
				g_IsRunOff = true;
				Menu newmenu = new Menu(Menu_VoteDifficulty);
				newmenu.SetTitle("%t %t\n \n", "SF2 Prefix", "SF2 Difficulty Vote Menu Title");

				ArrayList list = new ArrayList();
				for(int i = 0; i < items; i++)
				{
					if (itemInfo[i][VOTEINFO_ITEM_VOTES] >= itemInfo[1][VOTEINFO_ITEM_VOTES])
					{
						list.Push(itemInfo[i][VOTEINFO_ITEM_INDEX]);
					}
				}

				char data[64], display[64];
				int length = list.Length;
				for (int i = 0; i < length; i++)
				{
					int index = list.Get(i);
					oldmenu.GetItem(index, data, sizeof(data), _, display, sizeof(display));
					newmenu.AddItem(data, display);
				}

				delete list;

				g_VoteTimer = CreateTimer(1.0, Timer_ReVoteDifficulty, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);

				if (GetMenuItemCount(g_MenuVoteDifficulty) > 1)
				{
					Call_StartForward(g_OnDifficultyVoteFinishedFwd);
					Call_PushCell(g_Voters);
					Call_PushCell(false);
					Call_Finish();
				}
				g_Voters.Clear();

				delete g_MenuVoteDifficulty;
				g_MenuVoteDifficulty = newmenu;

				return;
			}
		}
	}

	Menu_VoteDifficulty(oldmenu, MenuAction_VoteEnd, itemInfo[0][VOTEINFO_ITEM_INDEX], 0);
}

static Action Timer_ReVoteDifficulty(Handle timer)
{
	if (timer != g_VoteTimer || IsRoundEnding())
	{
		g_VoteTimer = null;
		return Plugin_Stop;
	}

	if (IsVoteInProgress() || NativeVotes_IsVoteInProgress())
	{
		return Plugin_Continue; // There's another vote in progess. Wait.
	}

	int clients[MAXTF2PLAYERS] = { -1, ... };
	int clientsNum;
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid || player.IsBot || player.IsEliminated)
		{
			continue;
		}

		clients[clientsNum] = player.index;
		clientsNum++;
	}

	if (clientsNum == 0)
	{
		g_VoteTimer = null;
		return Plugin_Stop;
	}

	VoteMenu(g_MenuVoteDifficulty, clients, clientsNum, 7);
	g_VoteTimer = null;
	return Plugin_Stop;
}

static int Menu_VoteNoneDifficulty(Menu menu, MenuAction action,int param1,int param2)
{
	if (action == MenuAction_Select)
	{
		char option[64];
		GetMenuItem(menu, param2, option, sizeof(option));
		int index = g_Voters.Push(param1);
		int value = StringToInt(option);
		g_Voters.Set(index, value, 1);
	}
	return 0;
}

static Action Timer_HighVoteDifficulty(Handle timer)
{
	if (timer != g_VoteTimer || IsRoundEnding())
	{
		return Plugin_Stop;
	}

	if (NativeVotes_IsVoteInProgress() || IsVoteInProgress())
	{
		return Plugin_Continue; // There's another vote in progess. Wait.
	}

	int clients[MAXTF2PLAYERS] = { -1, ... };
	int clientsNum;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || g_PlayerEliminated[i])
		{
			continue;
		}

		clients[clientsNum] = i;
		clientsNum++;
	}

	RandomizeVoteMenu(true);
	VoteMenu(g_MenuVoteDifficulty, clients, clientsNum, 10);
	if (GetMenuItemCount(g_MenuVoteDifficulty) == 1)
	{
		for (int i = 0; i < clientsNum; i++)
		{
			FakeClientCommand(clients[i], "menuselect 1");
		}
	}

	return Plugin_Stop;
}

static int Menu_VoteDifficulty(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char option[64];
		menu.GetItem(param2, option, sizeof(option));
		int index = g_Voters.Push(param1);
		int value = StringToInt(option);
		g_Voters.Set(index, value, 1);
	}

	if (action == MenuAction_VoteEnd && !SF_SpecialRound(SPECIALROUND_MODBOSSES) && !g_RestartSessionConVar.BoolValue)
	{
		int clientInGame = 0, clientCallingForNightmare = 0;
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsValidClient(client) && !g_PlayerEliminated[client])
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
		menu.GetItem(param1, info, sizeof(info), _, display, sizeof(display));

		int difficulty = StringToInt(info);

		bool rng = false, change = false;

		if (info[0] != '\0')
		{
			if (g_HighDifficultyPercentConVar.FloatValue > 0.0 && (strcmp(info, "4") == 0 || strcmp(info, "5") == 0))
			{
				float nrm, hrd, ins, ngt, apl;
				for (int i = 0; i < g_Voters.Length; i++)
				{
					switch (g_Voters.Get(i, 1))
					{
						case Difficulty_Normal:
						{
							nrm += 1.0;
						}
						case Difficulty_Hard:
						{
							hrd += 1.0;
						}
						case Difficulty_Insane:
						{
							ins += 1.0;
						}
						case Difficulty_Nightmare:
						{
							ngt += 1.0;
						}
						case Difficulty_Apollyon:
						{
							apl += 1.0;
						}
					}
				}
				float values = (ngt + apl) / g_Voters.Length;
				if (values < g_HighDifficultyPercentConVar.FloatValue)
				{
					if (values > 0.5)
					{
						CPrintToChatAll("%t", "SF2 Difficulty Vote Finished Unsuccessful Runoff", RoundToFloor(g_HighDifficultyPercentConVar.FloatValue * 100.0));
						g_VoteTimer = CreateTimer(1.0, Timer_HighVoteDifficulty, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
						return 0;
					}
					else
					{
						int winner = Difficulty_Normal;
						if (hrd > ins && hrd > nrm)
						{
							winner = Difficulty_Hard;
						}
						else if (ins > hrd && ins > nrm)
						{
							winner = Difficulty_Insane;
						}
						difficulty = winner;
						change = true;
					}
				}
			}
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
						difficulty = Difficulty_Apollyon;
					}
					case 4:
					{
						if (nightmare)
						{
							difficulty = Difficulty_Nightmare;
						}
						else
						{
							difficulty = Difficulty_Apollyon;
						}
					}
					case 3:
					{
						if (insane)
						{
							difficulty = Difficulty_Insane;
						}
						else if (nightmare)
						{
							difficulty = Difficulty_Nightmare;
						}
						else
						{
							difficulty = Difficulty_Apollyon;
						}
					}
					case 2:
					{
						if (hard)
						{
							difficulty = Difficulty_Hard;
						}
						else if (insane)
						{
							difficulty = Difficulty_Insane;
						}
						else if (nightmare)
						{
							difficulty = Difficulty_Nightmare;
						}
						else
						{
							difficulty = Difficulty_Apollyon;
						}
					}
					case 1:
					{
						if (normal)
						{
							difficulty = Difficulty_Normal;
						}
						else if (hard)
						{
							difficulty = Difficulty_Hard;
						}
						else if (insane)
						{
							difficulty = Difficulty_Insane;
						}
						else if (nightmare)
						{
							difficulty = Difficulty_Nightmare;
						}
						else
						{
							difficulty = Difficulty_Apollyon;
						}
					}
				}
			}
			else
			{
				difficulty = GetRandomInt(Difficulty_Normal, Difficulty_Insane);
			}
		}

		Action fwdAction = Plugin_Continue;
		int difficulty2 = difficulty;

		// This cell ref shit does not work, why?
		Call_StartForward(g_OnDifficultyVoteFinishedPFwd);
		Call_PushCell(difficulty);
		Call_PushCellRef(difficulty2);
		Call_Finish(fwdAction);

		if (fwdAction == Plugin_Changed)
		{
			difficulty = difficulty2;
		}

		if ((SF_SpecialRound(SPECIALROUND_SILENTSLENDER) || SF_SpecialRound(SPECIALROUND_NOGRACE)) && difficulty < Difficulty_Hard)
		{
			difficulty = Difficulty_Hard;
		}

		if ((SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) || SF_SpecialRound(SPECIALROUND_ESCAPETICKETS) || SF_SpecialRound(SPECIALROUND_2DOUBLE) || SF_SpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS) || SF_SpecialRound(SPECIALROUND_WALLHAX)) && difficulty < Difficulty_Insane)
		{
			difficulty = Difficulty_Insane;
		}

		if (GetRandomInt(1, 200) <= 2 || playersCalledForNightmare)
		{
			if (GetRandomInt(1, 20) <= 1)
			{
				rng = true;
				difficulty = Difficulty_Apollyon;
			}
			else
			{
				difficulty = Difficulty_Nightmare;
			}
		}

		switch (difficulty)
		{
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
				PlayNightmareSound();
				SpecialRoundGameText(nightmareDisplay, "leaderboard_streak");
			}
			case Difficulty_Apollyon:
			{
				FormatEx(display, sizeof(display), "%t!", "SF2 Apollyon Difficulty");
				FormatEx(nightmareDisplay, sizeof(nightmareDisplay), "%t mode!", "SF2 Apollyon Difficulty");
				strcopy(color, sizeof(color), "{darkgray}");
				PlayNightmareSound();
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

		g_DifficultyConVar.SetInt(difficulty);

		if (!change)
		{
			CPrintToChatAll("%t %s%s", "SF2 Difficulty Vote Finished", color, display);
		}
		else
		{
			CPrintToChatAll("%t %s%s", "SF2 Difficulty Vote Finished Unsuccessful", RoundToFloor(g_HighDifficultyPercentConVar.FloatValue * 100.0), color, display);
		}
		char checker[64];
		g_DifficultyVoteRandomConVar.GetString(checker, sizeof(checker));
		if (g_MenuVoteDifficulty.ItemCount > 1)
		{
			Call_StartForward(g_OnDifficultyVoteFinishedFwd);
			Call_PushCell(g_Voters);
			Call_PushCell(g_IsRunOff);
			Call_Finish();
		}
	}
	return 0;
}

static int Menu_Help(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuHelpObjective.Display(param1, 30);
			}
			case 1:
			{
				g_MenuHelpCommands.Display(param1, 30);
			}
			case 2:
			{
				g_MenuHelpClassInfo.Display(param1, 30);
			}
			case 3:
			{
				g_MenuHelpGhostMode.Display(param1, 30);
			}
			case 4:
			{
				g_MenuHelpSprinting.Display(param1, 30);
			}
			case 5:
			{
				g_MenuHelpControls.Display(param1, 30);
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			g_MenuMain.Display(param1, 30);
		}
	}
	return 0;
}

static int Menu_HelpObjective(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuHelpObjective2.Display(param1, 30);
			}
			case 1:
			{
				g_MenuHelp.Display(param1, 30);
			}
		}
	}
	return 0;
}

static int Menu_HelpObjective2(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuHelpObjective.Display(param1, 30);
			}
		}
	}
	return 0;
}

static int Menu_BackButtonOnly(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuHelp.Display(param1, 30);
			}
		}
	}
	return 0;
}

static int Menu_Credits(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuCredits1.Display(param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				g_MenuMain.Display(param1, 30);
			}
		}
	}
	return 0;
}

static int Menu_Credits1(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuCredits2.Display(param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				g_MenuCredits.Display(param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}

static int Menu_ClassInfo(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			g_MenuHelp.Display(param1, 30);
		}
	}
	else if (action == MenuAction_Select)
	{
		char info[64];
		menu.GetItem(param2, info, sizeof(info));

		Menu menuHandle = new Menu(Menu_ClassInfoBackOnly);

		char title[64], description[64];
		FormatEx(title, sizeof(title), "SF2 Help %s Class Info Menu Title", info);
		FormatEx(description, sizeof(description), "SF2 Help %s Class Info Description", info);

		menuHandle.SetTitle("%t %t\n \n%t\n \n", "SF2 Prefix", title, description);
		menuHandle.AddItem("0", "Back");
		menuHandle.Display(param1, 30);
	}
	return 0;
}

static int Menu_ClassInfoBackOnly(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		g_MenuHelpClassInfo.Display(param1, 30);
	}
	return 0;
}

static int Menu_Settings(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuSettingsPvP.Display(param1, 30);
			}
			case 1:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Hints Menu Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
				panel.DrawItem(buffer);
				FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
				panel.DrawItem(buffer);

				panel.Send(param1, Panel_SettingsHints, 30);
				delete panel;
			}
			case 2:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Mute Mode Menu Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				panel.DrawItem("Normal");
				panel.DrawItem("Mute opposing team");
				panel.DrawItem("Mute opposing team except when I'm a proxy");

				panel.Send(param1, Panel_SettingsMuteMode, 30);
				delete panel;
			}
			case 3:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Film Grain Menu Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
				panel.DrawItem(buffer);
				FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
				panel.DrawItem(buffer);

				panel.Send(param1, Panel_SettingsFilmGrain, 30);
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

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				panel.DrawItem("Use the new HUD");
				panel.DrawItem("Use the legacy HUD");

				panel.Send(param1, Panel_SettingsHudVersion, 30);
				delete panel;
			}
			case 6:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Proxy Menu Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				FormatEx(buffer, sizeof(buffer), "%T", "Yes", param1);
				panel.DrawItem(buffer);
				FormatEx(buffer, sizeof(buffer), "%T", "No", param1);
				panel.DrawItem(buffer);

				panel.Send(param1, Panel_SettingsProxy, 30);
				delete panel;
			}
			case 7:
			{
				char buffer[512];
				Format(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Music Volume Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				panel.DrawItem("0%");
				panel.DrawItem("25%");
				panel.DrawItem("50%");
				panel.DrawItem("75%");
				panel.DrawItem("100% (Default)");

				panel.Send(param1, Panel_SettingsMusicVolume, 30);
				delete panel;
			}
			case 8:
			{
				g_MenuSettingsFlashlightTemp1.Display(param1, 30);
			}
			case 9:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Ghost Mode Teleport Menu Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				panel.DrawItem("Teleport to only players");
				panel.DrawItem("Teleport to only bosses");

				panel.Send(param1, Panel_SettingsGhostModeTeleport, 30);
				delete panel;
			}
			case 10:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Ghost Mode Toggle State Menu Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				panel.DrawItem("Default state");
				panel.DrawItem("Enable ghost mode upon grace period ends");
				panel.DrawItem("Enable ghost mode upon death on RED");

				panel.Send(param1, Panel_SettingsGhostModeToggleState, 30);
				delete panel;
			}
			case 11:
			{
				char buffer[512];
				FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Proxy Menu Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				panel.DrawItem("Enable Ask Message");
				panel.DrawItem("Disable Ask Message");

				panel.Send(param1, Panel_SettingsProxyAskMenu, 30);
				delete panel;
			}
			case 12:
			{
				GetPvEMenu().Display(param1, 30);
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			g_MenuMain.Display(param1, 30);
		}
	}
	return 0;
}

static int Menu_Settings_Flashlighttemp1(Menu menu, MenuAction action, int param1, int param2)
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
		CPrintToChat(param1, "%t", "SF2 Flashlight Temperature Changed", g_PlayerPreferences[param1].PlayerPreference_FlashlightTemperature);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			g_MenuMain.Display(param1, 30);
		}
	}
	return 0;
}

static int Panel_SettingsFilmGrain(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

static int Panel_SettingsHints(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

static int Panel_SettingsProxy(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

static int Panel_SettingsProxyAskMenu(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

static int Panel_SettingsMuteMode(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

static int Panel_SettingsGhostModeTeleport(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

static int Panel_SettingsGhostModeToggleState(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

static int Panel_SettingsMusicVolume(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		float volume;
		for (int i = 1; i < param2; i++)
		{
			volume += 0.25;
		}
		g_PlayerPreferences[param1].PlayerPreference_MusicVolume = volume;
		CPrintToChat(param1, "%t", "SF2 Music Volum Changed", RoundToNearest(volume * 100.0));
		ClientSaveCookies(param1);

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

int Panel_SettingsHudVersion(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

int Panel_SettingsViewBobbing(Menu menu, MenuAction action, int param1, int param2)
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

		g_MenuSettings.Display(param1, 30);
	}
	return 0;
}

static int Menu_Credits2(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuCredits3.Display(param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				g_MenuCredits1.Display(param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}

static int Menu_Credits3(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuCredits4.Display(param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				g_MenuCredits2.Display(param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}

static int Menu_Credits4(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuCredits5.Display(param1, MENU_TIME_FOREVER);
			}
			case 1:
			{
				g_MenuCredits3.Display(param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}

static int Menu_Credits5(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				g_MenuCredits4.Display(param1, MENU_TIME_FOREVER);
			}
		}
	}
	return 0;
}

void DisplayQueuePointsMenu(int client)
{
	Menu menu = new Menu(Menu_QueuePoints);
	ArrayList queueList = GetQueueList();

	char buffer[256];

	if (queueList.Length)
	{
		FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Reset Queue Points Option", client, g_PlayerQueuePoints[client]);
		menu.AddItem("deathcorridor", buffer);

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
				menu.AddItem(info, buffer, g_PlayerPlaying[index] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
			}
			else
			{
				index = queueList.Get(i);
				if (GetPlayerGroupMemberCount(index) > 1)
				{
					GetPlayerGroupName(index, groupName, sizeof(groupName));

					FormatEx(buffer, sizeof(buffer), "[GROUP] %s - %d", groupName, GetPlayerGroupQueuePoints(index));
					FormatEx(info, sizeof(info), "group_%d", index);
					menu.AddItem(info, buffer, IsPlayerGroupPlaying(index) ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
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
							menu.AddItem("player", buffer, g_PlayerPlaying[i2] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
							break;
						}
					}
				}
			}
		}
	}

	delete queueList;

	menu.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Queue Menu Title", client);
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
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
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		int tempGroup = ClientGetPlayerGroup(i);
		if (!IsPlayerGroupActive(tempGroup) || tempGroup != groupIndex)
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

		Menu menuHandle = new Menu(Menu_ViewGroupMembersQueue);
		menuHandle.SetTitle("%t %T (%s)\n \n", "SF2 Prefix", "SF2 View Group Members Menu Title", client, groupName);

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

			menuHandle.AddItem(userId, name);
		}

		menuHandle.ExitBackButton = true;
		menuHandle.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		// No players!
		DisplayQueuePointsMenu(client);
	}

	delete playersArray;
}

static int Menu_ViewGroupMembersQueue(Menu menu, MenuAction action, int param1, int param2)
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

	Menu menu = new Menu(Menu_ResetQueuePoints);
	FormatEx(buffer, sizeof(buffer), "%T", "Yes", client);
	menu.AddItem("0", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "No", client);
	menu.AddItem("1", buffer);
	menu.SetTitle("%T\n \n", "SF2 Should Reset Queue Points", client);
	menu.Display(client, MENU_TIME_FOREVER);
}

static int Menu_QueuePoints(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			char info[64];
			menu.GetItem(param2, info, sizeof(info));

			if (strcmp(info, "deathcorridor", false) == 0)
			{
				DisplayResetQueuePointsMenu(param1);
			}
			else if (!StrContains(info, "player_"))
			{
				// Do nothing
			}
			else if (!StrContains(info, "group_"))
			{
				char index[64];
				strcopy(index, sizeof(index), info);
				ReplaceString(index, sizeof(index), "group_", "");
				DisplayViewGroupMembersQueueMenu(param1, StringToInt(index));
			}
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				g_MenuMain.Display(param1, 30);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

static int Menu_ResetQueuePoints(Menu menu, MenuAction action, int param1, int param2)
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
	Menu menu = new Menu(Menu_BossList);

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
			SF2BossProfileData data;
			g_BossProfileData.GetArray(profile, data, sizeof(data));
			if (data.Description.Hidden)
			{
				continue;
			}
			if (data.IsPvEBoss)
			{
				StrCat(displayName, sizeof(displayName), " (PvE Boss)");
			}
			menu.AddItem(profile, displayName);
		}
	}
	menu.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 Boss List Menu Title", client);
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

static int Menu_BossList(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				g_MenuMain.Display(param1, 30);
			}
		}

		case MenuAction_Select:
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			menu.GetItem(param2, profile, sizeof(profile));
			SF2BossProfileData data;
			g_BossProfileData.GetArray(profile, data, sizeof(data));
			Menu newMenu = new Menu(Menu_BossDisplay);
			char buffer[256], buffer2[128];
			data.Names.GetString(Difficulty_Normal, buffer2, sizeof(buffer2));
			FormatEx(buffer, sizeof(buffer), "%t %s\n \n", "SF2 Prefix", buffer2);
			FormatEx(buffer2, sizeof(buffer2), "Type: %s\n \n", data.Description.Type);
			StrCat(buffer, sizeof(buffer), buffer2);
			SF2ChaserBossProfileData chaserData;
			if (g_ChaserBossProfileData.GetArray(profile, chaserData, sizeof(chaserData)))
			{
				FormatEx(buffer2, sizeof(buffer2), "Walk speed: %s\n", ConvertWalkSpeedToDescription(chaserData.WalkSpeed[Difficulty_Normal]));
			}
			StrCat(buffer, sizeof(buffer), buffer2);
			float speed = data.RunSpeed[Difficulty_Normal];
			SF2StatueBossProfileData statueData;
			if (g_StatueBossProfileData.GetArray(profile, statueData, sizeof(statueData)))
			{
				speed *= 10.0;
			}
			FormatEx(buffer2, sizeof(buffer2), "Run speed: %s\n \n", ConvertRunSpeedToDescription(speed));
			StrCat(buffer, sizeof(buffer), buffer2);
			FormatEx(buffer2, sizeof(buffer2), "%s", data.Description.Information);
			ReplaceString(buffer2, sizeof(buffer2), "\\n", "\n");
			StrCat(buffer, sizeof(buffer), buffer2);
			newMenu.SetTitle(buffer);
			newMenu.AddItem("", "", ITEMDRAW_SPACER);
			newMenu.ExitBackButton = true;
			newMenu.Display(param1, MENU_TIME_FOREVER);
		}

		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}

static char[] ConvertWalkSpeedToDescription(float speed)
{
	char buffer[128];
	buffer = "None";
	if (speed > 0.0 && speed <= 45.0)
	{
		buffer = "Very slow";
	}
	else if (speed > 45.0 && speed <= 65.0)
	{
		buffer = "Slow";
	}
	else if (speed > 65.0 && speed <= 85.0)
	{
		buffer = "Moderate";
	}
	else if (speed > 85.0 && speed <= 120.0)
	{
		buffer = "Average";
	}
	else if (speed > 120.0 && speed <= 150.0)
	{
		buffer = "Fast";
	}
	else
	{
		buffer = "Very fast";
	}

	return buffer;
}

static char[] ConvertRunSpeedToDescription(float speed)
{
	char buffer[128];
	buffer = "None";
	if (speed > 0.0 && speed <= 50.0)
	{
		buffer = "Very slow";
	}
	else if (speed > 50.0 && speed <= 150.0)
	{
		buffer = "Slow";
	}
	else if (speed > 150.0 && speed <= 250.0)
	{
		buffer = "Moderate";
	}
	else if (speed > 250.0 && speed <= 300.0)
	{
		buffer = "Average";
	}
	else if (speed > 300.0 && speed <= 350.0)
	{
		buffer = "Fast";
	}
	else
	{
		buffer = "Very fast";
	}

	return buffer;
}

static int Menu_BossDisplay(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				DisplayBossList(param1);
			}
		}

		case MenuAction_Select:
		{
			DisplayBossList(param1);
		}

		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 0;
}
