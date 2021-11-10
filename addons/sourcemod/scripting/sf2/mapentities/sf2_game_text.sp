// sf2_game_text
// This is a specialized game_text entity that allows maps to show text to only RED
// while utilizing SF2's HudSync object, the same that is used by intro/page/escape messages.

// Normally, game_text entities' messages get immediately replaced in-game due to the
// constant displaying of HUD text by SF2, rendering the text unreadable and useless.

static const char g_sEntityClassname[] = "sf2_game_text";
static const char g_sEntityTranslatedClassname[] = "game_text";

static ArrayList g_EntityData;

/**
 *	Internal data stored for the entity.
 */
enum struct SF2GameTextEntityData
{
	int EntRef;
	char NextIntroTextEntityName[64];
	float NextIntroTextDelay;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		this.NextIntroTextEntityName[0] = '\0';
		this.NextIntroTextDelay = 0.0;
	}

	void Destroy()
	{
	}

	void SetNextIntroTextEntityName(const char[] sName) 
	{
		strcopy(this.NextIntroTextEntityName, 64, sName);
	}
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2GameTextEntity < SF2MapEntity
{
	public SF2GameTextEntity(int entIndex) { return view_as<SF2GameTextEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2GameTextEntityData entData;
		return (SF2GameTextEntityData_Get(this.EntRef, entData) != -1);
	}

	public void GetMessage(char[] sBuffer, int iBufferSize)
	{
		GetEntPropString(this.EntRef, Prop_Data, "m_iszMessage", sBuffer, iBufferSize);
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
		public get() { SF2GameTextEntityData entData; SF2GameTextEntityData_Get(this.EntRef, entData); return entData.NextIntroTextDelay; }
	}

	property SF2GameTextEntity NextIntroTextEntity
	{
		public get() 
		{  
			SF2GameTextEntityData entData;
			SF2GameTextEntityData_Get(this.EntRef, entData);

			if (entData.NextIntroTextEntityName[0] == '\0')
				return SF2GameTextEntity(INVALID_ENT_REFERENCE);

			return SF2GameTextEntity(SF2MapEntity_FindEntityByTargetname(-1, entData.NextIntroTextEntityName, -1, -1, -1));
		}
	}

	public bool ValidateMessageString(char[] sBuffer, int iBufferSize)
	{
		if (StrContains(sBuffer, "%d") != -1)
		{
			char sName[64];
			GetEntPropString(this.EntRef, Prop_Data, "m_iName", sName, sizeof(sName));
			char[] sMessage = new char[iBufferSize];
			strcopy(sMessage, iBufferSize, sBuffer);
			ReplaceString(sMessage, iBufferSize, "%d", "%%d");
			LogError("sf2_game_text (%s): %%d formatting parameters are NOT ALLOWED! Use the <pageCount> and <maxPages> variables! Please report this to the map creator.\nOffending message: %s", sName, sMessage);
			return false;
		}

		return true;
	}
}

void SF2GameTextEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2GameTextEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2GameTextEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2GameTextEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2GameTextEntity_OnEntityKeyValue);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2GameTextEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2GameTextEntity_OnEntityDestroyed);
}

static void SF2GameTextEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2GameTextEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));
}

static Action SF2GameTextEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2GameTextEntityData entData;
	if (SF2GameTextEntityData_Get(entity, entData) == -1)
		return Plugin_Continue;

	if (strcmp(szKeyName, "nextintrotextname", false) == 0) 
	{
		entData.SetNextIntroTextEntityName(szValue);
		SF2GameTextEntityData_Update(entData);
		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "nextintrotextdelay", false) == 0)
	{
		float flDelay = StringToFloat(szValue);
		if (flDelay < 0.0)
			flDelay = 0.0;

		entData.NextIntroTextDelay = flDelay;
		SF2GameTextEntityData_Update(entData);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action SF2GameTextEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2GameTextEntity thisEnt = SF2GameTextEntity(entity);

	if (strcmp(szInputName, "display", false) == 0)
	{
		int iClients[MAXPLAYERS + 1];
		int iClientsNum;
		
		char sMessage[512];
		thisEnt.GetFormattedMessage(sMessage, sizeof(sMessage));

		if (!thisEnt.ValidateMessageString(sMessage, sizeof(sMessage))) return Plugin_Handled;

		char sVariant[PLATFORM_MAX_PATH];
		SF2MapEntity_GetVariantString(sVariant, sizeof(sVariant));

		if (sVariant[0] != '\0')
		{
			// If a targetname is specified, try to show text to the matched entity.

			int target = -1;
			while ((target = SF2MapEntity_FindEntityByTargetname(target, sVariant, caller, activator, caller)) != -1)
			{
				if (IsValidClient(target))
				{
					iClients[iClientsNum++] = target;
				}
			}
		}
		else 
		{
			int iSpawnFlags = GetEntProp(entity, Prop_Data, "m_spawnflags");

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

		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

static void SF2GameTextEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2GameTextEntityData entData;
	int iIndex = SF2GameTextEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2GameTextEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2GameTextEntityData_Get(int entIndex, SF2GameTextEntityData entData)
{
	entData.EntRef = EnsureEntRef(entIndex);
	if (entData.EntRef == INVALID_ENT_REFERENCE)
		return -1;

	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return -1;
	
	g_EntityData.GetArray(iIndex, entData, sizeof(entData));
	return iIndex;
}

static int SF2GameTextEntityData_Update(SF2GameTextEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}