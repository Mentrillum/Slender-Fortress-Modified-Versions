// sf2_game_text
// This is a specialized game_text entity that allows maps to show text to only RED
// while utilizing SF2's HudSync object, the same that is used by intro/page/escape messages.

// Normally, game_text entities' messages get immediately replaced in-game due to the
// constant displaying of HUD text by SF2, rendering the text unreadable and useless.

static const char g_EntityClassname[] = "sf2_game_text"; // The custom classname of the entity. Should be prefixed with "sf2_"

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2GameTextEntity < CBaseEntity
{
	public SF2GameTextEntity(int entIndex) { return view_as<SF2GameTextEntity>(CBaseEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	public void GetMessage(char[] buffer, int bufferSize)
	{
		this.GetPropString(Prop_Data, "m_iszMessage", buffer, bufferSize);
	}

	public void SetMessage(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "m_iszMessage", buffer);
	}

	public bool ValidateMessageString(char[] buffer, int bufferSize)
	{
		if (StrContains(buffer, "%d") != -1)
		{
			char sName[64];
			this.GetPropString(Prop_Data, "m_iName", sName, sizeof(sName));
			char[] message = new char[bufferSize];
			strcopy(message, bufferSize, buffer);
			ReplaceString(message, bufferSize, "%d", "%%d");
			LogError("sf2_game_text (%s): %%d formatting parameters are NOT ALLOWED! Use the <pageCount> and <maxPages> variables! Please report this to the map creator.\nOffending message: %s", sName, message);
			return false;
		}

		return true;
	}

	public void GetFormattedMessage(char[] buffer, int bufferSize)
	{
		this.GetMessage(buffer, bufferSize);

		if (StrContains(buffer, "<br>") != -1)
		{
			ReplaceString(buffer, bufferSize, "<br>", "\n");
		}

		if (StrContains(buffer, "<maxPages>") != -1)
		{
			char arg[16]; IntToString(g_PageMax, arg, sizeof(arg));
			ReplaceString(buffer, bufferSize, "<maxPages>", arg);
		}

		if (StrContains(buffer, "<pageCount>") != -1)
		{
			char arg[16]; IntToString(g_PageCount, arg, sizeof(arg));
			ReplaceString(buffer, bufferSize, "<pageCount>", arg);
		}

		if (StrContains(buffer, "<pagesLeft>") != -1)
		{
			char arg[16]; IntToString(g_PageMax - g_PageCount, arg, sizeof(arg));
			ReplaceString(buffer, bufferSize, "<pagesLeft>", arg);
		}
	}

	/**
	 * Gets the message formatted as an intro message.
	 */
	public void GetIntroMessage(char[] buffer, int bufferSize)
	{
		this.GetFormattedMessage(buffer, bufferSize);
	}

	/**
	 * Gets the message formatted as an page collection message.
	 */
	public void GetPageMessage(char[] buffer, int bufferSize)
	{
		this.GetFormattedMessage(buffer, bufferSize);
	}

	/**
	 * Gets the message formatted as an escape message.
	 */
	public void GetEscapeMessage(char[] buffer, int bufferSize)
	{
		this.GetPageMessage(buffer, bufferSize);
	}

	property float NextIntroTextDelay
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flNextIntroTextDelay"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flNextIntroTextDelay", value); }
	}

	public void GetNextIntroTextEntityName(char[] buffer, int bufferSize)
	{
		this.GetPropString(Prop_Data, "sf2_szNextIntroText", buffer, bufferSize);
	}

	public void SetNextIntroTextEntityName(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "sf2_szNextIntroText", buffer);
	}

	property SF2GameTextEntity NextIntroTextEntity
	{
		public get()
		{
			char introTextName[64];
			this.GetNextIntroTextEntityName(introTextName, sizeof(introTextName));

			if (introTextName[0] == '\0')
			{
				return SF2GameTextEntity(INVALID_ENT_REFERENCE);
			}

			return SF2GameTextEntity(SF2MapEntity_FindEntityByTargetname(-1, introTextName, -1, -1, -1));
		}
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory(g_EntityClassname, OnCreated, OnRemoved);
	g_EntityFactory.DeriveFromClass("game_text");
	g_EntityFactory.BeginDataMapDesc()
		.DefineFloatField("sf2_flNextIntroTextDelay", _, "nextintrotextdelay")
		.DefineStringField("sf2_szNextIntroText", _, "nextintrotextname")
		.DefineInputFunc("Display", InputFuncValueType_String, InputDisplay)
		.EndDataMapDesc();
	g_EntityFactory.Install();
}

static void OnCreated(int entity)
{
}

static void OnRemoved(int entity)
{
}

static void InputDisplay(int entity, int activator, int caller, const char[] value)
{
	SF2GameTextEntity thisEnt = SF2GameTextEntity(entity);

	int clients[MAXPLAYERS + 1];
	int clientsNum;

	char message[512];
	thisEnt.GetFormattedMessage(message, sizeof(message));

	if (!thisEnt.ValidateMessageString(message, sizeof(message)))
	{
		return;
	}

	if (value[0] != '\0')
	{
		// If a targetname is specified, try to show text to the matched entity.

		int target = -1;
		while ((target = SF2MapEntity_FindEntityByTargetname(target, value, caller, activator, caller)) != -1 && target > 0 && target <= MaxClients)
		{
			clients[clientsNum++] = target;
		}
	}
	else
	{
		int spawnFlags = thisEnt.GetProp(Prop_Data, "m_spawnflags");

		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i))
			{
				continue;
			}

			// If 'All Players' not set, only show message to RED.
			if ((spawnFlags & 1) == 0 && g_PlayerEliminated[i] && !IsClientInGhostMode(i))
			{
				continue;
			}

			clients[clientsNum++] = i;
		}
	}

	ShowHudTextUsingTextEntity(clients, clientsNum, entity, g_HudSync, message);
}