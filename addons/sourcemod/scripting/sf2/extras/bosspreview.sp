enum struct BossData
{
	char Name[64];
	char Profile[64];
	char Pack[64];
	char Type[32];
	char Description[128];
	char WalkSpeed[32];
	char RunSpeed[32];
	char Filepath[PLATFORM_MAX_PATH];
}

enum struct PackData
{
	char Name[64];
	char Path[64];
	bool AutoLoad;
}

enum struct EquipData
{
	char Profile[64];
	int Flags;
}

static ArrayList g_BossPacks;
static ArrayList g_BossList;

static int g_MainMenuPage[MAXPLAYERS + 1];
static int g_PackMenuPage[MAXPLAYERS + 1];
static char g_ViewingPack[MAXPLAYERS + 1][64];
static char g_ViewingBoss[MAXPLAYERS + 1][64];

static int g_PreviewRef[MAXPLAYERS + 1] = {INVALID_ENT_REFERENCE, ...};

void BossPreview_ReloadPack()
{
	if (g_BossPacks)
	{
		delete g_BossPacks;
	}

	if (g_BossList)
	{
		delete g_BossList;
	}

	g_BossPacks = new ArrayList(sizeof(PackData));
	g_BossList = new ArrayList(sizeof(BossData));

	BossData data;
	char pack[64], buffer[PLATFORM_MAX_PATH];

	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_PROFILES_DIR);
	}
	else
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_PROFILES_DIR_DATA);
	}
	strcopy(data.Pack, sizeof(data.Pack), "Core Pack");
	AddSlenderPack(data, "", buffer, true);

	KeyValues kv = new KeyValues("root");

	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_PROFILES_PACKS);
	}
	else
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_PROFILES_PACKS_DATA);
	}
	if (kv.ImportFromFile(buffer))
	{
		kv.JumpToKey("packs");
		kv.GotoFirstSubKey();

		do
		{
			kv.GetString("file", pack, sizeof(pack));
			BuildPath(Path_SM, buffer, sizeof(buffer), "%s/%s", !g_UseAlternateConfigDirectoryConVar.BoolValue ? FILE_PROFILES_PACKS_DIR : FILE_PROFILES_PACKS_DIR_DATA, pack);
			kv.GetString("name", data.Pack, sizeof(data.Pack));

			AddSlenderPack(data, pack, buffer, kv.GetNum("autoload", false) != 0);
		}
		while (kv.GotoNextKey());
	}

	delete kv;
}

Action BossPreview_MainMenu(int client, int args)
{
	if (client)
	{
		if (args)
		{
			char buffer[64];
			GetCmdArgString(buffer, sizeof(buffer));
			StripQuotes(buffer);

			BossData boss;
			int i;
			int length = g_BossList.Length;
			for (;i < length; i++)
			{
				g_BossList.GetArray(i, boss);
				if (StrContains(boss.Name, buffer, false) != -1)
				{
					strcopy(g_ViewingPack[client], sizeof(g_ViewingPack[]), boss.Pack);
					BossMenu(client, boss.Profile);
					break;
				}
			}

			if (i == length)
			{
				ReplyToCommand(client, "Could not find boss matching \"%s\"", buffer);
			}
		}
		else
		{
			MainMenu(client);
		}
	}
	return Plugin_Handled;
}

static void MainMenu(int client)
{
	BossPreview_Remove(client);

	g_PackMenuPage[client] = 0;

	Menu menu = new Menu(MainMenuH);

	menu.SetTitle("Boss List:\n ");

	char buffer[64], current[64];
	GetCurrentBossPack(current, sizeof(current));

	PackData pack;
	int length = g_BossPacks.Length;
	for (int i; i < length; i++)
	{
		g_BossPacks.GetArray(i, pack);
		if (!pack.AutoLoad && strcmp(pack.Name, current) == 0)
		{
			Format(buffer, sizeof(buffer), "Current: %s\n ", pack.Name);
			menu.InsertItem(0, pack.Name, buffer);
		}
		else if (pack.AutoLoad)
		{
			Format(buffer, sizeof(buffer), "%s\n ", pack.Name);
			menu.AddItem(pack.Name, buffer);
		}
		else
		{
			menu.AddItem(pack.Name, pack.Name);
		}
	}

	menu.DisplayAt(client, g_MainMenuPage[client], MENU_TIME_FOREVER);
}

static int MainMenuH(Menu menu, MenuAction action, int client, int choice)
{
	switch(action)
	{
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_Select:
		{
			g_MainMenuPage[client] = choice / 7 * 7;

			char buffer[64];
			menu.GetItem(choice, buffer, sizeof(buffer));
			PackMenu(client, buffer);
		}
	}
	return 0;
}

static void PackMenu(int client, const char[] pack)
{
	BossPreview_Remove(client);

	strcopy(g_ViewingPack[client], sizeof(g_ViewingPack[]), pack);

	Menu menu = new Menu(PackMenuH);
	menu.SetTitle("%s\n ", pack);

	PackData packData;
	for (int i = 0; i < g_BossPacks.Length; i++)
	{
		g_BossPacks.GetArray(i, packData);
		if (strcmp(packData.Name, pack) == 0)
		{
			break;
		}
	}

	BossData boss;
	int length = g_BossList.Length;
	for (int i = 0; i < length; i++)
	{
		g_BossList.GetArray(i, boss);
		if (strcmp(boss.Pack, pack) == 0)
		{
			menu.AddItem(boss.Profile, boss.Name);
		}
	}

	if (menu.ItemCount == 0)
	{
		PrintToChat(client, "Boss pack %s is not available to view right now.", pack);
		MainMenu(client);
		return;
	}

	menu.ExitBackButton = true;
	menu.DisplayAt(client, g_PackMenuPage[client], MENU_TIME_FOREVER);
}

static int PackMenuH(Menu menu, MenuAction action, int client, int choice)
{
	switch (action)
	{
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_Cancel:
		{
			if(choice == MenuCancel_ExitBack)
			{
				MainMenu(client);
			}
		}
		case MenuAction_Select:
		{
			g_PackMenuPage[client] = choice / 7 * 7;

			char buffer[64];
			menu.GetItem(choice, buffer, sizeof(buffer));
			BossMenu(client, buffer);
		}
	}
	return 0;
}

static void BossMenu(int client, const char[] profile)
{
	BossData boss;
	int flags = g_BossList.Length;
	for (int i; i < flags; i++)
	{
		g_BossList.GetArray(i, boss);
		if (strcmp(boss.Profile, profile) == 0)
		{
			break;
		}
	}

	Menu menu = new Menu(BossMenuH);
	char buffer[256], buffer2[128];
	FormatEx(buffer, sizeof(buffer), "%s\n \n%s\n", g_ViewingPack[client], boss.Name);
	FormatEx(buffer2, sizeof(buffer2), "Type: %s\n \n", boss.Type);
	StrCat(buffer, sizeof(buffer), buffer2);
	FormatEx(buffer2, sizeof(buffer2), "Walk speed: %s\n", boss.WalkSpeed);
	StrCat(buffer, sizeof(buffer), buffer2);
	FormatEx(buffer2, sizeof(buffer2), "Run speed: %s\n", boss.RunSpeed);
	StrCat(buffer, sizeof(buffer), buffer2);
	FormatEx(buffer2, sizeof(buffer2), "%s", boss.Description);
	ReplaceString(buffer2, sizeof(buffer2), "\\n", "\n");
	StrCat(buffer, sizeof(buffer), buffer2);
	FormatEx(buffer2, sizeof(buffer2), "\n ");
	StrCat(buffer, sizeof(buffer), buffer2);

	menu.SetTitle(buffer);

	menu.AddItem(boss.Profile, "Preview Boss", IsProfileValid(boss.Profile) ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

	g_BossPreviewWikiConVar.GetString(boss.Name, sizeof(boss.Name));
	if (boss.Name[0] != '\0')
	{
		menu.AddItem(boss.Profile, "Open Wiki Page");
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

static int BossMenuH(Menu menu, MenuAction action, int client, int option)
{
	switch (action)
	{
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_Cancel:
		{
			if(option == MenuCancel_ExitBack)
			{
				PackMenu(client, g_ViewingPack[client]);
			}
		}
		case MenuAction_Select:
		{
			char profile[64];
			menu.GetItem(option, profile, sizeof(profile));

			BossData boss;
			int length = g_BossList.Length;
			for (int i; i < length; i++)
			{
				g_BossList.GetArray(i, boss);
				if (strcmp(boss.Profile, profile) == 0)
				{
					break;
				}
			}

			switch (option)
			{
				case 0:
				{
					CreatePreview(client, boss.Profile);
				}
				case 1:
				{
					char buffer[PLATFORM_MAX_PATH];
					g_BossPreviewWikiConVar.GetString(buffer, sizeof(buffer));
					Format(buffer, sizeof(buffer), buffer, boss.Name);
					PrintToChat(client, "%s", buffer);

					KeyValues kv = new KeyValues("data");

					kv.SetString("title", "Wiki Page (cl_disablehtmlmotd)");
					kv.SetNum("type", MOTDPANEL_TYPE_URL);
					kv.SetString("msg", buffer);

					ShowVGUIPanel(client, "info", kv, true);
					delete kv;
				}
			}

			BossMenu(client, profile);
		}
	}
	return 0;
}

static void AddSlenderPack(BossData data, const char[] pack, const char[] path, bool autoLoad)
{
	DirectoryListing dir = OpenDirectory(path);
	if (dir != null)
	{
		FileType type;
		while (dir.GetNext(data.Profile, sizeof(data.Profile), type))
		{
			if (type == FileType_File)
			{
				KeyValues kv = new KeyValues("root");

				FormatEx(data.Filepath, sizeof(data.Filepath), "%s/%s", path, data.Profile);
				if (kv.ImportFromFile(data.Filepath))
				{
					kv.GetSectionName(data.Profile, sizeof(data.Profile));
					kv.GetString("name", data.Name, sizeof(data.Name));
					data.Description = "No description provided.";
					int bossType = kv.GetNum("type", SF2BossType_Chaser);
					switch (bossType)
					{
						case SF2BossType_Chaser:
						{
							data.Type = "Chaser";
						}

						case SF2BossType_Statue:
						{
							data.Type = "Statue";
						}
					}
					ConvertWalkSpeedToDescription(kv.GetFloat("walkspeed", 100.0), data.WalkSpeed, sizeof(data.WalkSpeed));
					ConvertRunSpeedToDescription(kv.GetFloat("speed", 300.0), data.RunSpeed, sizeof(data.RunSpeed));

					if (kv.JumpToKey("description"))
					{
						if (kv.GetNum("hidden", false) != 0)
						{
							delete kv;
							continue;
						}
						kv.GetString("type", data.Type, sizeof(data.Type), data.Type);
						kv.GetString("description", data.Description, sizeof(data.Description), data.Description);
					}

					g_BossList.PushArray(data);
				}

				delete kv;
			}
		}

		delete dir;

		PackData data3;
		strcopy(data3.Path, sizeof(data3.Path), pack);
		strcopy(data3.Name, sizeof(data3.Name), data.Pack);
		data3.AutoLoad = autoLoad;
		g_BossPacks.PushArray(data3);
	}
}

static void CreatePreview(int client, const char[] profile)
{
	BossPreview_Remove(client);

	if (!IsValidClient(client) || !IsPlayerAlive(client) || !IsProfileValid(profile))
	{
		return;
	}

	if (IsClientInGhostMode(client) || g_PlayerProxy[client])
	{
		return;
	}

	ArrayList modelsArray = GetBossProfileModels(profile);

	char model[PLATFORM_MAX_PATH];
	modelsArray.GetString(1, model, sizeof(model));

	CBaseAnimating entity = CBaseAnimating(CreateEntityByName("prop_dynamic"));
	if (entity.IsValid())
	{
		entity.SetModel(model);
		entity.KeyValue("solid", "0");
		entity.SetProp(Prop_Send, "m_nBody", GetBossProfileBodyGroups(profile));
		entity.SetProp(Prop_Send, "m_nSkin", GetBossProfileSkin(profile));
		entity.SetPropFloat(Prop_Send, "m_flModelScale", GetBossProfileModelScale(profile));

		entity.SetPropEnt(Prop_Data, "m_hEffectEntity", client);
		SDKHook(entity.index, SDKHook_SetTransmit, PreviewTransmit);

		g_PreviewRef[client] = EntIndexToEntRef(entity.index);
		strcopy(g_ViewingBoss[client], sizeof(g_ViewingBoss[]), profile);
		SetDefaultAnimation(entity.index, profile);

		static float pos[3], ang[3];
		GetClientAbsOrigin(client, pos);
		GetClientEyeAngles(client, ang);
		ang[0] = 0.0;
		entity.Teleport(pos, ang, NULL_VECTOR);

		entity.Spawn();

		int move = entity.LookupPoseParameter("move_x");
		if (move > 0)
		{
			entity.SetPoseParameter(move, 1.0);
		}
		move = entity.LookupPoseParameter("move_scale");
		if (move > 0)
		{
			entity.SetPoseParameter(move, 1.0);
		}
	}
}

void BossPreview_Remove(int client)
{
	if (IsValidEntity(g_PreviewRef[client]))
	{
		RemoveEntity(g_PreviewRef[client]);
		g_PreviewRef[client] = INVALID_ENT_REFERENCE;
	}
}

static Action PreviewTransmit(int entity, int client)
{
	SetEdictFlags(entity, GetEdictFlags(entity) &~ FL_EDICT_ALWAYS);

	int owner = GetEntPropEnt(entity, Prop_Data, "m_hEffectEntity");
	if (owner == -1)
	{
		RemoveEntity(entity);
		return Plugin_Continue;
	}

	if(owner == client)
	{
		if (GetClientMenu(client) == MenuSource_None)
		{
			RemoveEntity(entity);
		}

		return Plugin_Continue;
	}

	return Plugin_Stop;
}

static void SetDefaultAnimation(int entity, const char[] profile)
{
	SF2BossProfileMasterAnimationsData masterData;
	GetBossProfileAnimationsData(profile, masterData);
	char animation[64];
	masterData.GetAnimation("idle", Difficulty_Normal, animation, sizeof(animation));

	ArrayList animations, validAnimations;
	validAnimations = new ArrayList();
	masterData.Animations.GetValue("idle", animations);
	for (int i = 0; i < animations.Length; i++)
	{
		validAnimations.Push(i);
	}
	if (validAnimations.Length <= 0)
	{
		return;
	}

	float playback;
	int randomIndex = validAnimations.Get(GetRandomInt(0, validAnimations.Length - 1));
	masterData.GetAnimation("idle", Difficulty_Normal, animation, sizeof(animation), playback, _, _, _, _, randomIndex);

	CBaseAnimating animator = CBaseAnimating(entity);

	SetVariantString(animation);
	animator.AcceptInput("SetDefaultAnimation");

	SetVariantString(animation);
	animator.AcceptInput("SetAnimation");

	animator.SetPropFloat(Prop_Data, "m_flCycle", 0.0);
	animator.SetPropFloat(Prop_Send, "m_flPlaybackRate", playback);

	delete validAnimations;
}

void BossPreview_OnClientAttack(int client)
{
	if (!IsValidEntity(g_PreviewRef[client]))
	{
		return;
	}

	int entity = EntRefToEntIndex(g_PreviewRef[client]);

	SF2BossProfileMasterAnimationsData masterData;
	GetBossProfileAnimationsData(g_ViewingBoss[client], masterData);
	char animation[64];
	masterData.GetAnimation("attack", Difficulty_Normal, animation, sizeof(animation));

	ArrayList animations, validAnimations;
	validAnimations = new ArrayList();
	masterData.Animations.GetValue("attack", animations);
	for (int i = 0; i < animations.Length; i++)
	{
		validAnimations.Push(i);
	}
	if (validAnimations.Length <= 0)
	{
		return;
	}

	float playback;
	int randomIndex = validAnimations.Get(GetRandomInt(0, validAnimations.Length - 1));
	masterData.GetAnimation("attack", Difficulty_Normal, animation, sizeof(animation), playback, _, _, _, _, randomIndex);

	CBaseAnimating animator = CBaseAnimating(entity);

	SetVariantString(animation);
	animator.AcceptInput("SetAnimation");

	animator.SetPropFloat(Prop_Data, "m_flCycle", 0.0);
	animator.SetPropFloat(Prop_Send, "m_flPlaybackRate", playback);

	delete validAnimations;
}

static void ConvertWalkSpeedToDescription(float speed, char[] buffer, int bufferLen)
{
	char val[128];
	val = "None";
	if (speed > 0.0 && speed <= 45.0)
	{
		val = "Very slow";
	}
	else if (speed > 45.0 && speed <= 65.0)
	{
		val = "Slow";
	}
	else if (speed > 65.0 && speed <= 85.0)
	{
		val = "Moderate";
	}
	else if (speed > 85.0 && speed <= 120.0)
	{
		val = "Average";
	}
	else if (speed > 120.0 && speed <= 150.0)
	{
		val = "Fast";
	}
	else
	{
		val = "Very fast";
	}

	strcopy(buffer, bufferLen, val);
}

static void ConvertRunSpeedToDescription(float speed, char[] buffer, int bufferLen)
{
	char val[128];
	val = "None";
	if (speed > 0.0 && speed <= 75.0)
	{
		val = "Very slow";
	}
	else if (speed > 75.0 && speed <= 150.0)
	{
		val = "Slow";
	}
	else if (speed > 150.0 && speed <= 275.0)
	{
		val = "Moderate";
	}
	else if (speed > 275.0 && speed <= 325.0)
	{
		val = "Average";
	}
	else if (speed > 325.0 && speed <= 375.0)
	{
		val = "Fast";
	}
	else
	{
		val = "Very fast";
	}

	strcopy(buffer, bufferLen, val);
}
