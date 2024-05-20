#pragma semicolon 1

static Menu g_ChangelogUpdate;
static KeyValues g_ChangelogConfig;

#define FILE_CHANGELOG "configs/sf2/changelog.cfg"
#define FILE_CHANGELOG_DATA "data/sf2/changelog.cfg"

static bool g_SeeUpdateMenu[MAXTF2PLAYERS] = { false, ... };

void InitializeChangelog()
{
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnGamemodeStartPFwd.AddFunction(null, OnGamemodeStart);

	RegConsoleCmd("sm_slupdate", Command_Update);
	RegAdminCmd("sm_sf2_reloadchangelog", Command_ReloadChangelog, ADMFLAG_SLAY);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	if (client.Team > 1 && !g_SeeUpdateMenu[client.index])
	{
		g_SeeUpdateMenu[client.index] = true;
		g_ChangelogUpdate.Display(client.index, 30);
	}
}

static void OnDisconnected(SF2_BasePlayer client)
{
	g_SeeUpdateMenu[client.index] = false;
}

static void OnGamemodeStart()
{
	CreateChangelog();
}

static Action Command_Update(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	g_ChangelogUpdate.Display(client, 30);
	return Plugin_Handled;
}

static Action Command_ReloadChangelog(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	CreateChangelog();
	PrintToChat(client, "Reloaded the changelog.");
	return Plugin_Handled;
}

static void CreateChangelog()
{
	if (g_ChangelogConfig != null)
	{
		delete g_ChangelogConfig;
	}

	char buffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, buffer, sizeof(buffer), g_UseAlternateConfigDirectoryConVar.BoolValue ? FILE_CHANGELOG_DATA : FILE_CHANGELOG);
	g_ChangelogConfig = new KeyValues("root");
	if (!g_ChangelogConfig.ImportFromFile(buffer))
	{
		LogSF2Message("Failed to load changelog! File not found!");
		delete g_ChangelogConfig;
		return;
	}

	char list[1024];
	g_ChangelogUpdate = new Menu(Menu_Update);
	FormatEx(list, sizeof(list), "%tSlender Fortress\n \n", "SF2 Prefix");
	StrCat(list, sizeof(list), "Coders: KitRifty, Kenzzer, Mentrillum, The Gaben\n");
	StrCat(list, sizeof(list), "Version: ");
	StrCat(list, sizeof(list), PLUGIN_VERSION);
	StrCat(list, sizeof(list), "\n \n");
	Format(list, sizeof(list), "%s%t\n", list, "SF2 Recent Changes");
	StrCat(list, sizeof(list), "\n \n");

	g_ChangelogUpdate.SetTitle(list);
	g_ChangelogConfig.Rewind();
	char section[5], name[64], message[64];
	if (g_ChangelogConfig.GotoFirstSubKey())
	{
		do
		{
			g_ChangelogConfig.GetString("name", name, sizeof(name));
			FormatEx(message, sizeof(message), " ----- %s ----- ", name);
			g_ChangelogUpdate.AddItem("", message, ITEMDRAW_DISABLED);

			int count = 1;
			for (int i = 1;; i++)
			{
				FormatEx(section, sizeof(section), "%d", i);
				g_ChangelogConfig.GetString(section, message, sizeof(message));
				if (message[0] == '\0')
				{
					break;
				}

				g_ChangelogUpdate.AddItem("", message, ITEMDRAW_DISABLED);
				count++;
			}
			while (count % 7 != 0)
			{
				g_ChangelogUpdate.AddItem("", " ", ITEMDRAW_SPACER);
				count++;
			}
		}
		while (g_ChangelogConfig.GotoNextKey());

		g_ChangelogUpdate.AddItem("", " ", ITEMDRAW_SPACER);
		g_ChangelogUpdate.AddItem("0", "Display Main Menu");
	}
}

static int Menu_Update(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select && param2 == 0)
	{
		g_MenuMain.Display(param1, 30);
	}
	return 0;
}