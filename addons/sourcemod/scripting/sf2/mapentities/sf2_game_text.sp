// sf2_game_text
// This is a specialized game_text entity that allows maps to show text to only RED
// while utilizing SF2's HudSync object, the same that is used by intro/page/escape messages.

// Normally, game_text entities' messages get immediately replaced in-game due to the
// constant displaying of HUD text by SF2, rendering the text unreadable and useless.

static const char g_sEntityClassname[] = "sf2_game_text"; // The custom classname of the entity. Should be prefixed with "sf2_"

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2GameTextEntity < CBaseEntity
{
	public SF2GameTextEntity(int entIndex) { return view_as<SF2GameTextEntity>(CBaseEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
			return false;

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_entityFactory;
	}

	public void GetMessage(char[] sBuffer, int iBufferSize)
	{
		this.GetPropString(Prop_Data, "m_iszMessage", sBuffer, iBufferSize);
	}

	public void SetMessage(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "m_iszMessage", sBuffer);
	}

	public bool ValidateMessageString(char[] sBuffer, int iBufferSize)
	{
		if (StrContains(sBuffer, "%d") != -1)
		{
			char sName[64];
			this.GetPropString(Prop_Data, "m_iName", sName, sizeof(sName));
			char[] sMessage = new char[iBufferSize];
			strcopy(sMessage, iBufferSize, sBuffer);
			ReplaceString(sMessage, iBufferSize, "%d", "%%d");
			LogError("sf2_game_text (%s): %%d formatting parameters are NOT ALLOWED! Use the <pageCount> and <maxPages> variables! Please report this to the map creator.\nOffending message: %s", sName, sMessage);
			return false;
		}

		return true;
	}

	public void GetFormattedMessage(char[] sBuffer, int iBufferSize)
	{
		this.GetMessage(sBuffer, iBufferSize);

		if (StrContains(sBuffer, "<br>") != -1)
		{
			ReplaceString(sBuffer, iBufferSize, "<br>", "\n");
		}

		if (StrContains(sBuffer, "<maxPages>") != -1)
		{
			char sArg[16]; IntToString(g_iPageMax, sArg, sizeof(sArg));
			ReplaceString(sBuffer, iBufferSize, "<maxPages>", sArg);
		}

		if (StrContains(sBuffer, "<pageCount>") != -1)
		{
			char sArg[16]; IntToString(g_iPageCount, sArg, sizeof(sArg));
			ReplaceString(sBuffer, iBufferSize, "<pageCount>", sArg);
		}

		if (StrContains(sBuffer, "<pagesLeft>") != -1)
		{
			char sArg[16]; IntToString(g_iPageMax - g_iPageCount, sArg, sizeof(sArg));
			ReplaceString(sBuffer, iBufferSize, "<pagesLeft>", sArg);
		}
	}

	/**
	 * Gets the message formatted as an intro message.
	 */
	public void GetIntroMessage(char[] sBuffer, int iBufferSize)
	{
		this.GetFormattedMessage(sBuffer, iBufferSize);
	}

	/**
	 * Gets the message formatted as an page collection message.
	 */
	public void GetPageMessage(char[] sBuffer, int iBufferSize)
	{
		this.GetFormattedMessage(sBuffer, iBufferSize);
	}

	/**
	 * Gets the message formatted as an escape message.
	 */
	public void GetEscapeMessage(char[] sBuffer, int iBufferSize)
	{
		this.GetPageMessage(sBuffer, iBufferSize);
	}

	property float NextIntroTextDelay
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flNextIntroTextDelay"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flNextIntroTextDelay", value); }
	}

	public void GetNextIntroTextEntityName(char[] sBuffer, int iBufferSize)
	{
		this.GetPropString(Prop_Data, "sf2_szNextIntroText", sBuffer, iBufferSize);
	}

	public void SetNextIntroTextEntityName(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szNextIntroText", sBuffer);
	}

	property SF2GameTextEntity NextIntroTextEntity
	{
		public get() 
		{  
			char sIntroTextName[64];
			this.GetNextIntroTextEntityName(sIntroTextName, sizeof(sIntroTextName));

			if (sIntroTextName[0] == '\0')
				return SF2GameTextEntity(INVALID_ENT_REFERENCE);

			return SF2GameTextEntity(SF2MapEntity_FindEntityByTargetname(-1, sIntroTextName, -1, -1, -1));
		}
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize() 
{
	g_entityFactory = new CEntityFactory(g_sEntityClassname, OnCreated, OnRemoved);
	g_entityFactory.DeriveFromClass("game_text");
	g_entityFactory.BeginDataMapDesc()
		.DefineFloatField("sf2_flNextIntroTextDelay", _, "nextintrotextdelay")
		.DefineStringField("sf2_szNextIntroText", _, "nextintrotextname")
		.DefineInputFunc("Display", InputFuncValueType_String, InputDisplay)
		.EndDataMapDesc();
	g_entityFactory.Install();
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

	int iClients[MAXPLAYERS + 1];
	int iClientsNum;
	
	char sMessage[512];
	thisEnt.GetFormattedMessage(sMessage, sizeof(sMessage));

	if (!thisEnt.ValidateMessageString(sMessage, sizeof(sMessage)))
		return;

	if (value[0] != '\0')
	{
		// If a targetname is specified, try to show text to the matched entity.

		int target = -1;
		while ((target = SF2MapEntity_FindEntityByTargetname(target, value, caller, activator, caller)) != -1 && target > 0 && target <= MaxClients)
		{
			iClients[iClientsNum++] = target;
		}
	}
	else 
	{
		int iSpawnFlags = thisEnt.GetProp(Prop_Data, "m_spawnflags");

		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i)) continue;
			
			// If 'All Players' not set, only show message to RED.
			if ((iSpawnFlags & 1) == 0 && g_bPlayerEliminated[i] && !IsClientInGhostMode(i))
				continue;

			iClients[iClientsNum++] = i;
		}
	}

	ShowHudTextUsingTextEntity(iClients, iClientsNum, entity, g_hHudSync, sMessage);
}