enum struct BossData
{
	char Name[64];
	char Profile[64];
	char Pack[64];
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

static ArrayList BossPacks;
static ArrayList BossList;

static int MainMenuPage[MAXPLAYERS+1];
static int PackMenuPage[MAXPLAYERS+1];
static char ViewingPack[MAXPLAYERS+1][64];
static char ViewingBoss[MAXPLAYERS+1][64];

static int PetRef[MAXPLAYERS+1] = {INVALID_ENT_REFERENCE, ...};

void BossPreview_ReloadPack()
{
	if(BossPacks)
		delete BossPacks;

	if(BossList)
		delete BossList;

	BossPacks = new ArrayList(sizeof(PackData));
	BossList = new ArrayList(sizeof(BossData));

	BossData data;
	char pack[64], buffer[PLATFORM_MAX_PATH];
	
	BuildPath(Path_SM, buffer, sizeof(buffer), "data/sf2/profiles");
	strcopy(data.Pack, sizeof(data.Pack), "Core Pack");
	AddSlenderPack(data, "", buffer, true);

	KeyValues kv = new KeyValues("root");

	BuildPath(Path_SM, buffer, sizeof(buffer), "data/sf2/profiles_packs.cfg");
	if(kv.ImportFromFile(buffer))
	{
		kv.JumpToKey("packs");
		kv.GotoFirstSubKey();

		do
		{
			kv.GetString("file", pack, sizeof(pack));
			BuildPath(Path_SM, buffer, sizeof(buffer), "data/sf2/profiles/packs/%s", pack);
			kv.GetString("name", data.Pack, sizeof(data.Pack));

			AddSlenderPack(data, pack, buffer, kv.GetNum("autoload", false) != 0);
		}
		while(kv.GotoNextKey());
	}

	delete kv;
}

Action BossPreview_MainMenu(int client, int args)
{
	if(client)
	{
		if(args)
		{
			char buffer[64];
			GetCmdArgString(buffer, sizeof(buffer));
			StripQuotes(buffer);

			BossData boss;
			int i;
			int length = BossList.Length;
			for(; i<length; i++)
			{
				BossList.GetArray(i, boss);
				if(StrContains(boss.Name, buffer, false) != -1)
				{
					strcopy(ViewingPack[client], sizeof(ViewingPack[]), boss.Pack);
					BossMenu(client, boss.Profile);
					break;
				}
			}

			if(i == length)
				ReplyToCommand(client, "Could not find boss matching \"%s\"", buffer);
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
	
	PackMenuPage[client] = 0;

	Menu menu = new Menu(MainMenuH);

	menu.SetTitle("Boss List:\n ");

	char buffer[64], current[64];
	GetCurrentPack(current, sizeof(current));

	PackData pack;
	int length = BossPacks.Length;
	for (int i; i < length; i++)
	{
		BossPacks.GetArray(i, pack);
		if(!pack.AutoLoad && strcmp(pack.Name, current) == 0)
		{
			Format(buffer, sizeof(buffer), "Current: %s\n ", pack.Name);
			menu.InsertItem(0, pack.Name, buffer);
		}
		else if(pack.AutoLoad)
		{
			Format(buffer, sizeof(buffer), "%s\n ", pack.Name);
			menu.AddItem(pack.Name, buffer);
		}
		else
		{
			menu.AddItem(pack.Name, pack.Name);
		}
	}

	menu.DisplayAt(client, MainMenuPage[client], MENU_TIME_FOREVER);
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
			MainMenuPage[client] = choice / 7 * 7;

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
	
	strcopy(ViewingPack[client], sizeof(ViewingPack[]), pack);

	Menu menu = new Menu(PackMenuH);
	menu.SetTitle("%s\n ", pack);

	PackData packData;
	for (int i = 0; i < BossPacks.Length; i++)
	{
		BossPacks.GetArray(i, packData);
		if (strcmp(packData.Name, pack) == 0)
		{
			break;
		}
	}

	BossData boss;
	int length = BossList.Length;
	for (int i = 0; i < length; i++)
	{
		BossList.GetArray(i, boss);
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
	menu.DisplayAt(client, PackMenuPage[client], MENU_TIME_FOREVER);
}

static int PackMenuH(Menu menu, MenuAction action, int client, int choice)
{
	switch(action)
	{
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_Cancel:
		{
			if(choice == MenuCancel_ExitBack)
				MainMenu(client);
		}
		case MenuAction_Select:
		{
			PackMenuPage[client] = choice / 7 * 7;

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
	int flags = BossList.Length;
	for(int i; i<flags; i++)
	{
		BossList.GetArray(i, boss);
		if(strcmp(boss.Profile, profile) == 0)
			break;
	}

	Menu menu = new Menu(BossMenuH);
	menu.SetTitle("%s\n%s\n ", ViewingPack[client], boss.Name);

	menu.AddItem(boss.Profile, "Preview Boss", IsProfileValid(boss.Profile) ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);

	g_BossPreviewWikiConVar.GetString(boss.Name, sizeof(boss.Name));
	if(boss.Name[0])
		menu.AddItem(boss.Profile, "Open Wiki Page");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

static int BossMenuH(Menu menu, MenuAction action, int client, int option)
{
	switch(action)
	{
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_Cancel:
		{
			if(option == MenuCancel_ExitBack)
				PackMenu(client, ViewingPack[client]);
		}
		case MenuAction_Select:
		{
			char profile[64];
			menu.GetItem(option, profile, sizeof(profile));

			BossData boss;
			int length = BossList.Length;
			for(int i; i<length; i++)
			{
				BossList.GetArray(i, boss);
				if(strcmp(boss.Profile, profile) == 0)
					break;
			}

			switch(option)
			{
				case 0:
				{
					CreatePet(client, boss.Profile);
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
	if(dir)
	{
		FileType type;
		while(dir.GetNext(data.Profile, sizeof(data.Profile), type))
		{
			if(type == FileType_File)
			{
				KeyValues kv = new KeyValues("root");

				FormatEx(data.Filepath, sizeof(data.Filepath), "%s/%s", path, data.Profile);
				if(kv.ImportFromFile(data.Filepath))
				{
					kv.GetSectionName(data.Profile, sizeof(data.Profile));
					kv.GetString("name", data.Name, sizeof(data.Name));

					BossList.PushArray(data);
				}

				delete kv;
			}
		}

		delete dir;

		PackData data3;
		strcopy(data3.Path, sizeof(data3.Path), pack);
		strcopy(data3.Name, sizeof(data3.Name), data.Pack);
		data3.AutoLoad = autoLoad;
		BossPacks.PushArray(data3);
	}
}

static bool GetCurrentPack(char[] buffer, int length)
{
	return view_as<bool>(SF2_GetCurrentBossPack(buffer, length));
}

static void CreatePet(int client, const char[] profile)
{
	BossPreview_Remove(client);

	if (!SF2_IsValidClient(client) || !IsPlayerAlive(client) || !IsProfileValid(profile))
		return;
	
	if (SF2_IsClientInGhostMode(client) || SF2_IsClientProxy(client))
		return;

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
		SDKHook(entity.index, SDKHook_SetTransmit, PetTransmit);

		PetRef[client] = EntIndexToEntRef(entity.index);
		strcopy(ViewingBoss[client], sizeof(ViewingBoss[]), profile);
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
	if (IsValidEntity(PetRef[client]))
	{
		RemoveEntity(PetRef[client]);
		PetRef[client] = INVALID_ENT_REFERENCE;
	}
}

static Action PetTransmit(int entity, int client)
{
	SetEdictFlags(entity, GetEdictFlags(entity) &~ FL_EDICT_ALWAYS);
	
	int owner = GetEntPropEnt(entity, Prop_Data, "m_hEffectEntity");
	if(owner == -1)
	{
		RemoveEntity(entity);
		return Plugin_Continue;
	}

	if(owner == client)
	{
		if(GetClientMenu(client) == MenuSource_None)
			RemoveEntity(entity);
		
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
		return;
	
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
	if(!IsValidEntity(PetRef[client]))
		return;
	
	int entity = EntRefToEntIndex(PetRef[client]);

	SF2BossProfileMasterAnimationsData masterData;
	GetBossProfileAnimationsData(ViewingBoss[client], masterData);
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
		return;
	
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
