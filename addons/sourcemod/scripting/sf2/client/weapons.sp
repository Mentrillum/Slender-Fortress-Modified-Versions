#pragma newdecls required
#pragma semicolon 1

static KeyMap g_RestrictedWeapons = null;
static KeyMap g_ModifiedWeapons = null;

// Weapon Handles
static Handle g_WeaponHandles[10][10];

methodmap ModifiedWeaponObject < KeyMap
{
	property KeyMap Super
	{
		public get()
		{
			return view_as<KeyMap>(this);
		}
	}

	property int ItemIndex
	{
		public get()
		{
			return this.GetInt("item_index");
		}
	}

	public void GetItemName(char[] buffer, int bufferSize)
	{
		this.GetString("item_name", buffer, bufferSize);
	}

	property bool BlockTaunts
	{
		public get()
		{
			return this.GetBool("block_taunts");
		}
	}

	property bool ResetHealth
	{
		public get()
		{
			return this.GetBool("reset_health");
		}
	}

	property KeyMap Attributes
	{
		public get()
		{
			return this.GetSection("attributes");
		}
	}

	property KeyMap AttributesThanatophobia
	{
		public get()
		{
			return this.GetSection("attributes_thanatophobia");
		}
	}

	property KeyMap ModifySpeed
	{
		public get()
		{
			return this.GetSection("modify_speed");
		}
	}

	property KeyMap ModifiedIn
	{
		public get()
		{
			return this.GetSection("modified_in");
		}
	}

	property bool CanModifySpeedWhenActive
	{
		public get()
		{
			bool def = false;
			KeyMap obj = this.ModifySpeed;
			if (obj == null)
			{
				return def;
			}

			return obj.GetBool("when_active", def);
		}
	}
}

void SetupPlayerWeapons()
{
	ReloadRestrictedWeapons();
	ReloadModifiedWeapons();
	SetupClassDefaultWeapons();
}

void SF2_RefreshRestrictions()
{
	for(int client = 1; client <= MaxClients; client++)
	{
		if (IsValidClient(client) && (!g_PlayerEliminated[client] || (g_PlayerEliminated[client] && !IsClientInPvP(client) && !IsClientInPvE(client))))
		{
			ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
			g_PlayerPostWeaponsTimer[client] = CreateTimer(1.0, Timer_ClientPostWeapons, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

static void SetupClassDefaultWeapons()
{
	// Scout
	g_WeaponHandles[view_as<TFClassType>(TFClass_Scout)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_scattergun", 13, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Scout)][TFWeaponSlot_Secondary] = PrepareItemHandle("tf_weapon_pistol", 23, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Scout)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_bat", 0, 0, 0, "", true);

	// Sniper
	g_WeaponHandles[view_as<TFClassType>(TFClass_Sniper)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_sniperrifle", 14, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Sniper)][TFWeaponSlot_Secondary] = PrepareItemHandle("tf_weapon_smg", 16, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Sniper)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_club", 3, 0, 0, "", true);

	// Soldier
	g_WeaponHandles[view_as<TFClassType>(TFClass_Soldier)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_rocketlauncher", 18, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Soldier)][TFWeaponSlot_Secondary] = PrepareItemHandle("tf_weapon_shotgun", 10, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Soldier)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_shovel", 6, 0, 0, "", true);

	// Demoman
	g_WeaponHandles[view_as<TFClassType>(TFClass_DemoMan)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_grenadelauncher", 19, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_DemoMan)][TFWeaponSlot_Secondary] = PrepareItemHandle("tf_weapon_pipebomblauncher", 20, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_DemoMan)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_bottle", 1, 0, 0, "", true);

	// Medic
	g_WeaponHandles[view_as<TFClassType>(TFClass_Medic)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_syringegun_medic", 17, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Medic)][TFWeaponSlot_Secondary] = PrepareItemHandle("tf_weapon_medigun", 29, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Medic)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_bonesaw", 8, 0, 0, "", true);

	// Heavy
	g_WeaponHandles[view_as<TFClassType>(TFClass_Heavy)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_minigun", 15, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Heavy)][TFWeaponSlot_Secondary] = PrepareItemHandle("tf_weapon_shotgun", 11, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Heavy)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_fists", 5, 0, 0, "", true);

	// Pyro
	g_WeaponHandles[view_as<TFClassType>(TFClass_Pyro)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_flamethrower", 21, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Pyro)][TFWeaponSlot_Secondary] = PrepareItemHandle("tf_weapon_shotgun", 12, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Pyro)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_fireaxe", 2, 0, 0, "", true);

	// Spy
	g_WeaponHandles[view_as<TFClassType>(TFClass_Spy)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_revolver", 24, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Spy)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_knife", 4, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Spy)][TFWeaponSlot_Building] = PrepareItemHandle("tf_weapon_invis", 297, 0, 0, "", true);

	// Engineer
	g_WeaponHandles[view_as<TFClassType>(TFClass_Engineer)][TFWeaponSlot_Primary] = PrepareItemHandle("tf_weapon_shotgun", 9, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Engineer)][TFWeaponSlot_Secondary] = PrepareItemHandle("tf_weapon_pistol", 22, 0, 0, "", true);
	g_WeaponHandles[view_as<TFClassType>(TFClass_Engineer)][TFWeaponSlot_Melee] = PrepareItemHandle("tf_weapon_wrench", 7, 0, 0, "", true);
}

Handle GetClassStockWeaponHandle(TFClassType tfClass, int slot)
{
	return g_WeaponHandles[tfClass][slot];
}

void ReloadRestrictedWeapons()
{
	if (g_RestrictedWeapons != null)
	{
		CleanupKeyMap(g_RestrictedWeapons);
	}

	char buffer[PLATFORM_MAX_PATH];
	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_RESTRICTEDWEAPONS);
	}
	else
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_RESTRICTEDWEAPONS_DATA);
	}
	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, buffer))
	{
		delete kv;
		LogError("Failed to load restricted weapons list! File not found!");
		return;
	}

	g_RestrictedWeapons = KeyValuesToKeyMap(kv);

	delete kv;
}

void ReloadModifiedWeapons()
{
	if (g_ModifiedWeapons != null)
	{
		CleanupKeyMap(g_ModifiedWeapons);
	}

	char buffer[PLATFORM_MAX_PATH];
	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_MODIFIEDWEAPONS);
	}
	else
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_MODIFIEDWEAPONS_DATA);
	}
	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, buffer))
	{
		delete kv;
		LogError("Failed to load modified weapons list! File not found!");
		return;
	}

	g_ModifiedWeapons = KeyValuesToKeyMap(kv);

	delete kv;
}

KeyMap GetModifiedWeapons()
{
	return g_ModifiedWeapons;
}

ModifiedWeaponObject GetModifiedWeaponFromIndex(int client, int index)
{
	if (g_ModifiedWeapons == null)
	{
		return null;
	}

	TFClassType class = TF2_GetPlayerClass(client);
	ModifiedWeaponObject usedObject = null;
	char name[64];
	TF2_GetClassName(class, name, sizeof(name), true);
	KeyMap classObj = g_ModifiedWeapons.GetSection(name);
	if (classObj == null && class == TFClass_Heavy)
	{
		TF2_GetClassName(class, name, sizeof(name), false);
		classObj = g_ModifiedWeapons.GetSection(name);
	}

	KeyMap allObj = g_ModifiedWeapons.GetSection("all");
	if (allObj == null && classObj == null)
	{
		return null;
	}

	char itemDefString[6];
	IntToString(index, itemDefString, sizeof(itemDefString));
	ModifiedWeaponObject tempObj = null;
	if (classObj != null)
	{
		tempObj = view_as<ModifiedWeaponObject>(classObj.GetSection(itemDefString));
		if (tempObj != null)
		{
			usedObject = tempObj;
		}
	}

	if (usedObject == null && allObj != null)
	{
		tempObj = view_as<ModifiedWeaponObject>(allObj.GetSection(itemDefString));
		if (tempObj != null)
		{
			usedObject = tempObj;
		}
	}

	return usedObject;
}

Action Timer_ClientPostWeapons(Handle timer, any userid)
{
	SF2_BasePlayer client = SF2_BasePlayer(GetClientOfUserId(userid));
	if (!client.IsValid || !client.IsAlive)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerPostWeaponsTimer[client.index])
	{
		return Plugin_Stop;
	}

	g_PlayerHasRegenerationItem[client.index] = false;

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START Timer_ClientPostWeapons(%d)", client.index);
	}

	int oldWeaponItemIndexes[6] = { -1, ... };
	int newWeaponItemIndexes[6] = { -1, ... };

	for (int i = 0; i <= 5; i++)
	{
		int weaponEnt = client.GetWeaponSlot(i);
		if (!IsValidEdict(weaponEnt))
		{
			continue;
		}

		oldWeaponItemIndexes[i] = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
	}
	#endif

	bool removeWeapons = true;
	bool keepUtilityItems = false;
	bool restrictWeapons = true;
	bool useStock = false;
	bool removeWearables = false;
	bool preventAttack = false;

	if (client.IsEliminated)
	{
		removeWeapons = !g_PlayerKeepWeaponsConVar.BoolValue;
		restrictWeapons = true;
		preventAttack = true;
	}

	// pvp
	if (client.IsInPvP || (SF_IsRaidMap() && !client.IsEliminated) || IsClientInWeaponsTrigger(client.index))
	{
		removeWeapons = false;
		restrictWeapons = true;
		keepUtilityItems = false;
		preventAttack = false;
	}

	if (IsRoundInWarmup())
	{
		removeWeapons = false;
		restrictWeapons = false;
		keepUtilityItems = false;
		preventAttack = false;
	}

	if (client.IsInPvE)
	{
		if (IsPvEBoxing())
		{
			removeWeapons = false;
			restrictWeapons = true;
			keepUtilityItems = true;
			preventAttack = false;
		}
		else
		{
			removeWeapons = false;
			restrictWeapons = true;
			keepUtilityItems = false;
			preventAttack = false;
		}
	}

	if (client.IsProxy)
	{
		restrictWeapons = true;
		removeWeapons = true;
		useStock = true;
		removeWearables = true;
		keepUtilityItems = false;
		preventAttack = false;
	}

	if (client.IsInGhostMode)
	{
		removeWeapons = true;
	}

	if (SF_IsBoxingMap() && !client.IsEliminated && !IsRoundEnding())
	{
		removeWeapons = false;
		restrictWeapons = true;
		keepUtilityItems = true;
		preventAttack = false;
	}

	if (IsRoundEnding())
	{
		if (!client.IsEliminated)
		{
			removeWeapons = false;
			restrictWeapons = false;
			preventAttack = false;
		}
	}

	if (removeWeapons && !keepUtilityItems)
	{
		for (int i = 0; i <= 5; i++)
		{
			if (i == TFWeaponSlot_Melee && !client.IsInGhostMode)
			{
				continue;
			}
			TF2_RemoveWeaponSlotAndWearables(client.index, i);
		}

		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_weapon_builder")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(ent);
			}
		}

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_demoshield")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(ent);
			}
		}

		client.SwitchToWeaponSlot(TFWeaponSlot_Melee);
	}

	if (keepUtilityItems)
	{
		for (int i = 0; i <= 5; i++)
		{
			if ((i == TFWeaponSlot_Melee || i == TFWeaponSlot_Secondary) && !client.IsInGhostMode)
			{
				continue;
			}
			TF2_RemoveWeaponSlotAndWearables(client.index, i);
		}

		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_weapon_builder")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(ent);
			}
		}

		int weaponEnt = INVALID_ENT_REFERENCE;
		weaponEnt = client.GetWeaponSlot(TFWeaponSlot_Secondary);

		if (IsValidEdict(weaponEnt))
		{
			int itemIndex = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
			switch (itemIndex)
			{
				case 163, 129, 226, 354, 1001, 131, 406, 1099, 42, 159, 311, 433, 863, 1002, 1190:
				{
					//Do nothing
				}
				default:
				{
					TF2_RemoveWeaponSlotAndWearables(client.index, TFWeaponSlot_Secondary);
				}
			}
		}
	}

	if (removeWearables)
	{
		TF2_StripWearables(client.index);
	}

	TFClassType playerClass = client.Class;
	int classToInt = view_as<int>(playerClass);

	if (restrictWeapons)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable")) != -1)
		{
			int itemIndex = GetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex");

			if (IsWeaponRestricted(client, itemIndex) && GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(ent);
			}
		}

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_razorback")) != -1)
		{
			int itemIndex = GetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex");

			if (IsWeaponRestricted(client, itemIndex) && GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(ent);
			}
		}

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_demoshield")) != -1)
		{
			int itemIndex = GetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex");

			if (IsWeaponRestricted(client, itemIndex) && GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(ent);
			}
		}

		if (g_RestrictedWeapons != null)
		{
			int weaponEnt = INVALID_ENT_REFERENCE;
			for (int slot = TFWeaponSlot_Primary; slot <= 6; slot++)
			{
				weaponEnt = client.GetWeaponSlot(slot);
				if (!IsValidEntity(weaponEnt))
				{
					continue;
				}

				if (useStock || IsWeaponRestricted(client, GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex")))
				{
					TF2_RemoveWeaponSlotAndWearables(client.index, slot);

					if (GetClassStockWeaponHandle(playerClass, slot) != null)
					{
						int newWeapon = TF2Items_GiveNamedItem(client.index, GetClassStockWeaponHandle(playerClass, slot));
						if (IsValidEntity(newWeapon))
						{
							EquipPlayerWeapon(client.index, newWeapon);
						}
					}
				}
				else
				{
					if (!client.HasRegenItem)
					{
						client.HasRegenItem = IsRegenWeapon(weaponEnt);
					}
				}
			}
		}
	}

	// Change stats on some weapons.
	bool resetHealth = false;
	for (int slot = 0; slot <= 5; slot++)
	{
		int weaponEnt = client.GetWeaponSlot(slot);
		Handle weaponHandle = null;
		if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
		{
			continue;
		}

		char name[64];
		TF2_GetClassName(playerClass, name, sizeof(name), true);
		int itemDef = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
		ModifiedWeaponObject usedObject = GetModifiedWeaponFromIndex(client.index, itemDef);

		if (usedObject == null)
		{
			continue;
		}

		KeyMap attributes = usedObject.Attributes;
		if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && usedObject.AttributesThanatophobia != null)
		{
			attributes = usedObject.AttributesThanatophobia;
		}
		if (attributes == null)
		{
			continue;
		}

		bool allowed = !client.IsEliminated;
		KeyMap modified = usedObject.ModifiedIn;
		KeyMap teamModified = null;
		if (modified != null)
		{
			if (!client.IsEliminated && modified.GetBool("red", true))
			{
				teamModified = modified.GetSection("red");
			}
			else
			{
				teamModified = modified.GetSection("blue");
			}

			if (teamModified != null)
			{
				if (client.IsInPvP)
				{
					allowed = modified.GetBool("pvp");
				}
				else if (client.IsInPvE)
				{
					allowed = modified.GetBool("pve");
				}
				else if (client.IsInWeaponsTriggers)
				{
					allowed = modified.GetBool("weapons_trigger");
				}
				else if (!client.IsEliminated && SF_IsBoxingMap())
				{
					allowed = modified.GetBool("boxing", true);
				}
				else if (client.IsEliminated && SF_IsRaidMap())
				{
					allowed = modified.GetBool("raid", true);
				}
				else
				{
					allowed = modified.GetBool("everything_else", !client.IsEliminated);
				}
			}
		}
		if (!allowed)
		{
			continue;
		}

		char itemName[64], attributeList[1024];
		usedObject.GetItemName(itemName, sizeof(itemName));
		for (int i2 = 0; i2 < attributes.KeyLength; i2++)
		{
			if (i2 != 0)
			{
				StrCat(attributeList, sizeof(attributeList), " ; ");
			}
			char key[64], value[64];
			attributes.GetKeyNameFromIndex(i2, key, sizeof(key));
			FloatToString(attributes.GetFloat(key, 0.0), value, sizeof(value));
			StrCat(attributeList, sizeof(attributeList), key);
			StrCat(attributeList, sizeof(attributeList), " ; ");
			StrCat(attributeList, sizeof(attributeList), value);
		}
		weaponHandle = PrepareItemHandle(itemName, itemDef, 0, 0, attributeList);
		if (weaponHandle != null)
		{
			client.RemoveWeaponSlot(slot);
			int entity = TF2Items_GiveNamedItem(client.index, weaponHandle);
			EquipPlayerWeapon(client.index, entity);
			if (usedObject.ResetHealth)
			{
				resetHealth = true;
			}
			delete weaponHandle;
		}
	}
	if (resetHealth && !IsRoundPlaying())
	{
		SetEntityHealth(client.index, client.MaxHealth);
	}

	if (preventAttack)
	{
		int weaponEnt = INVALID_ENT_REFERENCE;
		while ((weaponEnt = FindEntityByClassname(weaponEnt, "tf_wearable_demoshield")) != INVALID_ENT_REFERENCE)
		{
			if (GetEntPropEnt(weaponEnt, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(weaponEnt);
			}
		}

		for (int slot = 0; slot <= 5; slot++)
		{
			if (slot == TFWeaponSlot_Melee)
			{
				continue;
			}

			weaponEnt = client.GetWeaponSlot(slot);
			if (!IsValidEntity(weaponEnt))
			{
				continue;
			}

			int itemDef = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
			switch (itemDef)
			{
				case 30, 212, 59, 60, 297, 947, 1101: // Invis Watch, Base Jumper
				{
					TF2_RemoveWeaponSlotAndWearables(client.index, slot);
				}

				default:
				{
					SetEntPropFloat(weaponEnt, Prop_Send, "m_flNextPrimaryAttack", 99999999.9);
					SetEntPropFloat(weaponEnt, Prop_Send, "m_flNextSecondaryAttack", 99999999.9);
				}
			}
		}
	}

	//Force them to take their melee wep, it prevents the civilian bug.
	client.SwitchToWeaponSlot(TFWeaponSlot_Melee);

	// Remove all hats.
	if (client.IsInGhostMode)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(ent);
			}
		}

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_campaign_item")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client.index)
			{
				RemoveEntity(ent);
			}
		}
	}

	TF2Attrib_RemoveByDefIndex(client.index, 109);
	if (!client.IsEliminated)
	{
		float healthFromPack = 1.0;
		if (!IsClassConfigsValid())
		{
			if (!SF_IsBoxingMap())
			{
				if (client.HasRegenItem)
				{
					healthFromPack = 0.40;
				}
				if (client.Class == TFClass_Medic)
				{
					healthFromPack = 0.0;
				}
			}
		}
		else
		{
			if (!SF_IsBoxingMap())
			{
				healthFromPack = g_ClassHealthPickupMultiplier[classToInt];
				if (client.HasRegenItem)
				{
					healthFromPack -= 0.6;
				}
				if (healthFromPack <= 0.0)
				{
					healthFromPack = 0.0;
				}
			}
		}
		TF2Attrib_SetByDefIndex(client.index, 109, healthFromPack);
	}

	#if defined DEBUG
	int weaponEnt = INVALID_ENT_REFERENCE;

	for (int i = 0; i <= 5; i++)
	{
		weaponEnt = client.GetWeaponSlot(i);
		if (!IsValidEdict(weaponEnt))
		{
			continue;
		}

		newWeaponItemIndexes[i] = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
	}

	if (g_DebugDetailConVar.IntValue > 0)
	{
		for (int i = 0; i <= 5; i++)
		{
			DebugMessage("-> slot %d: %d (old: %d)", i, newWeaponItemIndexes[i], oldWeaponItemIndexes[i]);
		}

		DebugMessage("END Timer_ClientPostWeapons(%d) -> remove = %d, restrict = %d", client.index, removeWeapons, restrictWeapons);
	}
	#endif

	Call_StartForward(g_OnPlayerPostWeaponsPFwd);
	Call_PushCell(client);
	Call_Finish();

	return Plugin_Stop;
}

public Action TF2Items_OnGiveNamedItem(int client, char[] classname, int itemDefinitionIndex, Handle &itemHandle)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	switch (itemDefinitionIndex)
	{
		case 642:
		{
			Handle itemOverride = PrepareItemHandle("tf_wearable", 642, 0, 0, "376 ; 1.0 ; 377 ; 0.2 ; 57 ; 2 ; 412 ; 1.10");

			if (itemOverride != null)
			{
				itemHandle = itemOverride;

				return Plugin_Changed;
			}
			delete itemOverride;
			itemOverride = null;
		}
	}

	return Plugin_Continue;
}

bool IsRegenWeapon(int weaponEnt)
{
	Address attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 1003);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 490);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 190);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 130);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 57);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 220);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	return false;
}

bool IsWeaponRestricted(SF2_BasePlayer client, int itemDefInt)
{
	if (g_RestrictedWeapons == null)
	{
		return false;
	}

	bool returnBool = false;

	char itemDef[32];
	FormatEx(itemDef, sizeof(itemDef), "%d", itemDefInt);

	bool proxyBoss = SF_IsProxyMap();
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(i);
		if (!Npc.IsValid())
		{
			continue;
		}
		if ((Npc.Flags & SFF_PROXIES) != 0)
		{
			proxyBoss = true;
			break;
		}
	}

	char className[32];
	TF2_GetClassName(client.Class, className, sizeof(className));
	KeyMap section = g_RestrictedWeapons.GetSection(className);
	if (section != null)
	{
		char restriction[32];
		section.GetString(itemDef, restriction, sizeof(restriction), "0");
		if (StrContains(restriction, "1") != -1 && !client.IsEliminated)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "2") != -1 && !client.IsEliminated && proxyBoss)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "3") != -1 && client.IsEliminated)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "4") != -1 && client.IsInPvP)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "5") != -1)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "6") != -1 && client.IsInPvE)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "7") != -1 && !client.IsEliminated && SF_IsBoxingMap())
		{
			returnBool = true;
		}

		if (StrContains(restriction, "8") != -1 && !client.IsEliminated && SF_SpecialRound(SPECIALROUND_THANATOPHOBIA))
		{
			returnBool = true;
		}
	}

	section = g_RestrictedWeapons.GetSection("all");
	if (section != null)
	{
		char restriction[32];
		section.GetString(itemDef, restriction, sizeof(restriction), "0");
		if (StrContains(restriction, "1") != -1 && !client.IsEliminated)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "2") != -1 && !client.IsEliminated && proxyBoss)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "3") != -1 && client.IsEliminated)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "4") != -1 && client.IsInPvP)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "5") != -1)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "6") != -1 && client.IsInPvE)
		{
			returnBool = true;
		}

		if (StrContains(restriction, "7") != -1 && !client.IsEliminated && SF_IsBoxingMap())
		{
			returnBool = true;
		}

		if (StrContains(restriction, "8") != -1 && !client.IsEliminated && SF_SpecialRound(SPECIALROUND_THANATOPHOBIA))
		{
			returnBool = true;
		}
	}

	return returnBool;
}
