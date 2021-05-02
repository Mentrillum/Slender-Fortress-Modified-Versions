// sf2_trigger_pvp

static const char g_sEntityClassname[] = "sf2_trigger_pvp"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "trigger_multiple"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

/**
 *	Internal data stored for the entity.
 */
enum struct SF2TriggerPvPEntityData
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
methodmap SF2TriggerPvPEntity < SF2MapEntity
{
	public SF2TriggerPvPEntity(int entIndex) { return view_as<SF2TriggerPvPEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2TriggerPvPEntityData entData;
		return (SF2TriggerPvPEntityData_Get(this.EntRef, entData) != -1);
	}
}

void SF2TriggerPvPEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2TriggerPvPEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2TriggerPvPEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2TriggerPvPEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2TriggerPvPEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2TriggerPvPEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2TriggerPvPEntity_OnEntityKeyValue);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2TriggerPvPEntity_OnLevelInit);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2TriggerPvPEntity_OnMapStart);
}

static void SF2TriggerPvPEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2TriggerPvPEntity_OnMapStart() 
{
}

static void SF2TriggerPvPEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2TriggerPvPEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2TriggerPvPEntity_SpawnPost);
	SDKHook(entity, SDKHook_StartTouchPost, SF2TriggerPvPEntity_OnStartTouchPost);
	SDKHook(entity, SDKHook_EndTouchPost, SF2TriggerPvPEntity_OnEndTouchPost);
}

static Action SF2TriggerPvPEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}

static Action SF2TriggerPvPEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}

static void SF2TriggerPvPEntity_SpawnPost(int entity) 
{
	// Add physics object flag, so we can zap projectiles!
	int flags = GetEntProp(entity, Prop_Data, "m_spawnflags");
	flags |= TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS;
	//flags |= TRIGGER_PHYSICS_OBJECTS;
	flags |= TRIGGER_PHYSICS_DEBRIS;
	SetEntProp(entity, Prop_Data, "m_spawnflags", flags);
}

static void SF2TriggerPvPEntity_OnStartTouchPost(int entity, int toucher)
{
	PvP_OnTriggerStartTouch(entity, toucher);
}

static void SF2TriggerPvPEntity_OnEndTouchPost(int entity, int toucher)
{
	PvP_OnTriggerEndTouch(entity, toucher);
}

static void SF2TriggerPvPEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2TriggerPvPEntityData entData;
	int iIndex = SF2TriggerPvPEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2TriggerPvPEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2TriggerPvPEntityData_Get(int entIndex, SF2TriggerPvPEntityData entData)
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
static int SF2TriggerPvPEntityData_Update(SF2TriggerPvPEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}
*/