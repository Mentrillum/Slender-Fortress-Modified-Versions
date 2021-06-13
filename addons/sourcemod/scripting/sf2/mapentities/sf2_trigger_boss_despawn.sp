// sf2_trigger_boss_despawn

// A trigger that when touched by a boss will despawn the boss from the map.

static const char g_sEntityClassname[] = "sf2_trigger_boss_despawn"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "trigger_multiple"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

/**
 *	Internal data stored for the entity.
 */
enum struct SF2TriggerBossDespawnEntityData
{
	int EntRef;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
	}

	void Destroy()
	{
	}
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2TriggerBossDespawnEntity < SF2TriggerMapEntity
{
	public SF2TriggerBossDespawnEntity(int entIndex) { return view_as<SF2TriggerBossDespawnEntity>(SF2TriggerMapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2TriggerBossDespawnEntityData entData;
		return (SF2TriggerBossDespawnEntityData_Get(this.EntRef, entData) != -1);
	}
}

void SF2TriggerBossDespawnEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2TriggerBossDespawnEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2TriggerBossDespawnEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2TriggerBossDespawnEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2TriggerBossDespawnEntity_OnEntityDestroyed);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2TriggerBossDespawnEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2TriggerBossDespawnEntity_OnEntityKeyValue);
}

static void SF2TriggerBossDespawnEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2TriggerBossDespawnEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2TriggerBossDespawnEntity_SpawnPost);
	SDKHook(entity, SDKHook_StartTouchPost, SF2TriggerBossDespawnEntity_OnStartTouchPost);
}

static Action SF2TriggerBossDespawnEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2TriggerBossDespawnEntity thisEnt = SF2TriggerBossDespawnEntity(entity);

	if (strcmp(szKeyName, "OnDespawn", false) == 0) 
	{
		thisEnt.AddOutput(szKeyName, szValue);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

/*
static Action SF2TriggerBossDespawnEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}
*/

static void SF2TriggerBossDespawnEntity_SpawnPost(int entity) 
{
	int iSpawnFlags = GetEntProp(entity, Prop_Data, "m_spawnflags");
	SetEntProp(entity, Prop_Data, "m_spawnflags", iSpawnFlags | TRIGGER_NPCS);
}

static void SF2TriggerBossDespawnEntity_OnStartTouchPost(int entity, int toucher)
{
	if (!g_bEnabled) return;

	SF2TriggerBossDespawnEntity thisEnt = SF2TriggerBossDespawnEntity(entity);

	if (thisEnt.PassesTriggerFilters(toucher))
	{
		int iBossIndex = NPCGetFromEntIndex(toucher);
		if (iBossIndex != -1) 
		{
			thisEnt.FireOutputNoVariant("OnDespawn", toucher, entity);

			RemoveSlender(iBossIndex);
		}
	}
}

static void SF2TriggerBossDespawnEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2TriggerBossDespawnEntityData entData;
	int iIndex = SF2TriggerBossDespawnEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2TriggerBossDespawnEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2TriggerBossDespawnEntityData_Get(int entIndex, SF2TriggerBossDespawnEntityData entData)
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

/*
static int SF2TriggerBossDespawnEntityData_Update(SF2TriggerBossDespawnEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}
*/
