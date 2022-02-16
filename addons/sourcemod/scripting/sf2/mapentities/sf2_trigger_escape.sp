// sf2_trigger_escape

// A trigger that when touched by a player on RED will let the player escape.
// Escaping can only occur during the Escape phase.

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2TriggerEscapeEntity < SF2TriggerMapEntity
{
	public SF2TriggerEscapeEntity(int entIndex) { return view_as<SF2TriggerEscapeEntity>(SF2TriggerMapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
			return false;

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_entityFactory;
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_entityFactory = new CEntityFactory("sf2_trigger_escape", OnCreate);
	g_entityFactory.DeriveFromClass("trigger_multiple");

	//g_entityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_entityFactory.Install();
}

static void OnCreate(int iEntity)
{
	SDKHook(iEntity, SDKHook_SpawnPost, OnSpawn);
	SDKHook(iEntity, SDKHook_StartTouchPost, OnStartTouchPost);
}

static void OnSpawn(int iEntity) 
{
	int iSpawnFlags = GetEntProp(iEntity, Prop_Data, "m_spawnflags");
	SetEntProp(iEntity, Prop_Data, "m_spawnflags", iSpawnFlags | TRIGGER_CLIENTS);
}

static void OnStartTouchPost(int iEntity, int iToucher)
{
	if (!g_bEnabled)
	{
		return;
	}

	SF2TriggerMapEntity trigger = SF2TriggerMapEntity(iEntity);

	if (IsRoundInEscapeObjective() && trigger.PassesTriggerFilters(iToucher))
	{
		if (IsValidClient(iToucher) && IsPlayerAlive(iToucher) && !IsClientInDeathCam(iToucher) && !g_bPlayerEliminated[iToucher] && !DidClientEscape(iToucher))
		{
			ClientEscape(iToucher);
			TeleportClientToEscapePoint(iToucher);
		}
	}
}
