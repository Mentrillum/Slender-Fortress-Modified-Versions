// sf2_trigger_escape

// A trigger that when touched by a player on RED will let the player escape.
// Escaping can only occur during the Escape phase.

static const char g_sEntityClassname[] = "sf2_trigger_escape"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "trigger_multiple"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

void SF2TriggerEscapeEntity_Initialize() 
{
	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2TriggerEscapeEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2TriggerEscapeEntity_InitializeEntity);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2TriggerEscapeEntity_OnAcceptEntityInput);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2TriggerEscapeEntity_OnEntityKeyValue);
}

static void SF2TriggerEscapeEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SDKHook(entity, SDKHook_SpawnPost, SF2TriggerEscapeEntity_SpawnPost);
	SDKHook(entity, SDKHook_StartTouchPost, SF2TriggerEscapeEntity_OnStartTouchPost);
}

/*
static Action SF2TriggerEscapeEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}

static Action SF2TriggerEscapeEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}
*/

static void SF2TriggerEscapeEntity_SpawnPost(int entity) 
{
	int iSpawnFlags = GetEntProp(entity, Prop_Data, "m_spawnflags");
	SetEntProp(entity, Prop_Data, "m_spawnflags", iSpawnFlags | TRIGGER_CLIENTS);
}

static void SF2TriggerEscapeEntity_OnStartTouchPost(int entity, int toucher)
{
	if (!g_bEnabled) return;

	SF2TriggerMapEntity trigger = SF2TriggerMapEntity(entity);

	if (IsRoundInEscapeObjective() && trigger.PassesTriggerFilters(toucher))
	{
		if (IsValidClient(toucher) && IsPlayerAlive(toucher) && !IsClientInDeathCam(toucher) && !g_bPlayerEliminated[toucher] && !DidClientEscape(toucher))
		{
			ClientEscape(toucher);
			TeleportClientToEscapePoint(toucher);
		}
	}
}

static Action SF2TriggerEscapeEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}
