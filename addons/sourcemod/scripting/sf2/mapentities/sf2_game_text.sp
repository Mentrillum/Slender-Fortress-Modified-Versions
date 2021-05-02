// sf2_game_text
// This is a specialized game_text entity that allows maps to show text to only RED
// while utilizing SF2's HudSync object, the same that is used by intro/page/escape messages.

// Normally, game_text entities' messages get immediately replaced in-game due to the
// constant displaying of HUD text by SF2, rendering the text unreadable and useless.

static const char g_sEntityClassname[] = "sf2_game_text";
static const char g_sEntityTranslatedClassname[] = "game_text";

void SF2GameTextEntity_Initialize() 
{
	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2GameTextEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2GameTextEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2GameTextEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2GameTextEntity_OnMapStart);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2GameTextEntity_OnEntityDestroyed);
}

static void SF2GameTextEntity_OnMapStart() 
{
}

static void SF2GameTextEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SDKHook(entity, SDKHook_SpawnPost, SF2GameTextEntity_SpawnPost);
}

static Action SF2GameTextEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	if (strcmp(szInputName, "display", false) == 0)
	{
		int iClients[MAXPLAYERS + 1];
		int iClientsNum;
		
		char sMessage[512];
		GetEntPropString(entity, Prop_Data, "m_iszMessage", sMessage, sizeof(sMessage));

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
}

static void SF2GameTextEntity_SpawnPost(int entity) 
{
	// PrintToServer("Spawned sf2_game_text entity! entity: %i", entity);
}

static Action SF2GameTextEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}