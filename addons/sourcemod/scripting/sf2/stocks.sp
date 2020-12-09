#if defined _sf2_stocks_included
 #endinput
#endif
#define _sf2_stocks_included

#define VALID_MINIMUM_MEMORY_ADDRESS 0x10000

#define SF2_FLASHLIGHT_WIDTH 512.0 // How wide the player's Flashlight should be in world units.
#define SF2_FLASHLIGHT_LENGTH 1024.0 // How far the player's Flashlight can reach in world units.
#define SF2_FLASHLIGHT_BRIGHTNESS 0 // Intensity of the players' Flashlight.
#define SF2_FLASHLIGHT_DRAIN_RATE 0.65 // How long (in seconds) each bar on the player's Flashlight meter lasts.
#define SF2_FLASHLIGHT_RECHARGE_RATE 0.68 // How long (in seconds) it takes each bar on the player's Flashlight meter to recharge.
#define SF2_FLASHLIGHT_FLICKERAT 0.25 // The percentage of the Flashlight battery where the Flashlight will start to blink.
#define SF2_FLASHLIGHT_ENABLEAT 0.3 // The percentage of the Flashlight battery where the Flashlight will be able to be used again (if the player shortens out the Flashlight from excessive use).
#define SF2_FLASHLIGHT_COOLDOWN 0.4 // How much time players have to wait before being able to switch their flashlight on again after turning it off.

// Hud Element hiding flags (possibly outdated)
#define	HIDEHUD_WEAPONSELECTION		( 1<<0 )	// Hide ammo count & weapon selection
#define	HIDEHUD_FLASHLIGHT			( 1<<1 )
#define	HIDEHUD_ALL					( 1<<2 )
#define HIDEHUD_HEALTH				( 1<<3 )	// Hide health & armor / suit battery
#define HIDEHUD_PLAYERDEAD			( 1<<4 )	// Hide when local player's dead
#define HIDEHUD_NEEDSUIT			( 1<<5 )	// Hide when the local player doesn't have the HEV suit
#define HIDEHUD_MISCSTATUS			( 1<<6 )	// Hide miscellaneous status elements (trains, pickup history, death notices, etc)
#define HIDEHUD_CHAT				( 1<<7 )	// Hide all communication elements (saytext, voice icon, etc)
#define	HIDEHUD_CROSSHAIR			( 1<<8 )	// Hide crosshairs
#define	HIDEHUD_VEHICLE_CROSSHAIR	( 1<<9 )	// Hide vehicle crosshair
#define HIDEHUD_INVEHICLE			( 1<<10 )
#define HIDEHUD_BONUS_PROGRESS		( 1<<11 )	// Hide bonus progress display (for bonus map challenges)

#define FFADE_IN            0x0001        // Just here so we don't pass 0 into the function
#define FFADE_OUT           0x0002        // Fade out (not in)
#define FFADE_MODULATE      0x0004        // Modulate (don't blend)
#define FFADE_STAYOUT       0x0008        // ignores the duration, stays faded out until new ScreenFade message received
#define FFADE_PURGE         0x0010        // Purges all other fades, replacing them with this one

#define SF_FADE_IN				0x0001		// Fade in, not out
#define SF_FADE_MODULATE		0x0002		// Modulate, don't blend
#define SF_FADE_ONLYONE			0x0004
#define SF_FADE_STAYOUT			0x0008

#define TRIGGER_CLIENTS 						(1 << 0)
#define TRIGGER_NPCS 							(1 << 1)
#define TRIGGER_PUSHABLES 						(1 << 2)
#define TRIGGER_PHYSICS_OBJECTS 				(1 << 3)
#define TRIGGER_ONLY_ALLY_NPCS 					(1 << 4)
#define TRIGGER_ONLY_CLIENTS_IN_VEHICLES 		(1 << 5)
#define TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS 	(1 << 6)
#define TRIGGER_ONLY_CLIENTS_NOT_IN_VEHICLES 	(1 << 7)
#define TRIGGER_PHYSICS_DEBRIS 					(1 << 8)
#define TRIGGER_ONLY_NPCS_IN_VEHICLES 			(1 << 9)
#define TRIGGER_DISSALOW_BOTS 					(1 << 10)

#define MAX_BUTTONS 26

#define SOLID_NONE			0	// no solid model
#define SOLID_BSP			1	// a BSP tree
#define SOLID_BBOX			2	// an AABB
#define SOLID_OBB			3	// an OBB (not implemented yet)
#define SOLID_OBB_YAW		4	// an OBB, constrained so that it can only yaw
#define SOLID_CUSTOM		5	// Always call into the entity for tests
#define SOLID_VPHYSICS		6	// solid vphysics object, get vcollide from the model and collide with that
#define SOLID_LAST			7

#define COLLISION_GROUP_DEBRIS 1
#define COLLISION_GROUP_DEBRIS_TRIGGER 2
#define COLLISION_GROUP_PLAYER 5

#define EFL_FORCE_CHECK_TRANSMIT (1 << 7)

#define vec3_origin { 0.0, 0.0, 0.0 }

#define TF_WEAPON_PHLOGISTINATOR 594

// m_nSolidType
#define SOLID_NONE 0 // no solid model
#define SOLID_BSP 1 // a BSP tree
#define SOLID_BBOX 2 // an AABB
#define SOLID_OBB 3 // an OBB (not implemented yet)
#define SOLID_OBB_YAW 4 // an OBB, constrained so that it can only yaw
#define SOLID_CUSTOM 5 // Always call into the entity for tests
#define SOLID_VPHYSICS 6 // solid vphysics object, get vcollide from the model and collide with that
// m_usSolidFlags
#define FSOLID_CUSTOMRAYTEST 0x0001 // Ignore solid type + always call into the entity for ray tests
#define FSOLID_CUSTOMBOXTEST 0x0002 // Ignore solid type + always call into the entity for swept box tests
#define FSOLID_NOT_SOLID 0x0004 // Are we currently not solid?
#define FSOLID_TRIGGER 0x0008 // This is something may be collideable but fires touch functions
							// even when it's not collideable (when the FSOLID_NOT_SOLID flag is set)
#define FSOLID_NOT_STANDABLE 0x0010 // You can't stand on this
#define FSOLID_VOLUME_CONTENTS 0x0020 // Contains volumetric contents (like water)
#define FSOLID_FORCE_WORLD_ALIGNED 0x0040 // Forces the collision rep to be world-aligned even if it's SOLID_BSP or SOLID_VPHYSICS
#define FSOLID_USE_TRIGGER_BOUNDS 0x0080 // Uses a special trigger bounds separate from the normal OBB
#define FSOLID_ROOT_PARENT_ALIGNED 0x0100 // Collisions are defined in root parent's local coordinate space
#define FSOLID_TRIGGER_TOUCH_DEBRIS 0x0200 // This trigger will touch debris objects

#define	DAMAGE_NO				0
#define DAMAGE_EVENTS_ONLY		1
#define	DAMAGE_YES				2
#define	DAMAGE_AIM				3

#define EF_BONEMERGE			0x001 	// Performs bone merge on client side
#define	EF_BRIGHTLIGHT 			0x002	// DLIGHT centered at entity origin
#define	EF_DIMLIGHT 			0x004	// player flashlight
#define	EF_NOINTERP				0x008	// don't interpolate the next frame
#define	EF_NOSHADOW				0x010	// Don't cast no shadow
#define	EF_NODRAW				0x020	// don't draw entity
#define	EF_NORECEIVESHADOW		0x040	// Don't receive no shadow
#define	EF_BONEMERGE_FASTCULL	0x080	// For use with EF_BONEMERGE. If this is set, then it places this ent's origin at its
										// parent and uses the parent's bbox + the max extents of the aiment.
										// Otherwise, it sets up the parent's bones every frame to figure out where to place
										// the aiment, which is inefficient because it'll setup the parent's bones even if
										// the parent is not in the PVS.
#define	EF_ITEM_BLINK			0x100	// blink an item so that the user notices it.
#define	EF_PARENT_ANIMATES		0x200	// always assume that the parent entity is animating

// hull defines, mostly used for space checking.
float HULL_HUMAN_MINS[3] = { -13.0, -13.0, 0.0 };
float HULL_HUMAN_MAXS[3] = { 13.0, 13.0, 72.0 };

float HULL_TF2PLAYER_MINS[3] = { -24.5, -24.5, 0.0 };
float HULL_TF2PLAYER_MAXS[3] = { 24.5,  24.5, 83.0 };

static bool g_bClientAndEntityNetwork[2049][MAXPLAYERS+1];

//  ==========================================================
//	Map Functions
//  ==========================================================

stock bool SF_IsSurvivalMap()
{
	return view_as<bool>(g_bIsSurvivalMap || (GetConVarInt(g_cvSurvivalMap) == 1));
}

stock bool SF_IsRaidMap()
{
	return view_as<bool>(g_bIsRaidMap || (GetConVarInt(g_cvRaidMap) == 1));
}

stock bool SF_IsProxyMap()
{
	return view_as<bool>(g_bIsProxyMap || (GetConVarInt(g_cvProxyMap) == 1));
}

stock bool SF_BossesChaseEndlessly()
{
	return view_as<bool>(g_bBossesChaseEndlessly || (GetConVarInt(g_cvBossChaseEndlessly) == 1));
}

stock bool SF_IsBoxingMap()
{
	return view_as<bool>(g_bIsBoxingMap || (GetConVarInt(g_cvBoxingMap) == 1));
}

stock bool SF_IsRenevantMap()
{
	return view_as<bool>(g_bIsRenevantMap || (GetConVarInt(g_cvRenevantMap) == 1));
}
/*
int SDK_StartTouch(int iEntity, int iOther)
{
	if(g_hSDKStartTouch != INVALID_HANDLE)
	{
		return SDKCall(g_hSDKStartTouch, iEntity, iOther);
	}
	return -1;
}

int SDK_EndTouch(int iEntity, int iOther)
{
	if(g_hSDKEndTouch != INVALID_HANDLE)
	{
		return SDKCall(g_hSDKEndTouch, iEntity, iOther);
	}
	return -1;
}
*/
bool SDK_PointIsWithin(int iFunc, float flPos[3])
{
	if(g_hSDKPointIsWithin != INVALID_HANDLE)
	{
		return view_as<bool>(SDKCall(g_hSDKPointIsWithin, iFunc, flPos));
	}

	return false;
}

//	==========================================================
//	ENTITY & ENTITY NETWORK FUNCTIONS
//	==========================================================

stock void Network_HookEntity(int iEnt)
{
	Network_ResetEntity(iEnt);
	SDKHook(iEnt, SDKHook_SetTransmit, NetworkHook_EntityTransmission);
}

public Action NetworkHook_EntityTransmission(int iEntity, int iClient)
{
	if (!Network_ClientHasSeenEntity(iClient, iEntity))
	{
		DataPack networkData = new DataPack();
		networkData.WriteCell(EntIndexToEntRef(iEntity));
		networkData.WriteCell(GetClientUserId(iClient));
		RequestFrame(Frame_UpdateClientEntityInfo, networkData);
	}
	return Plugin_Continue;
}

public void Frame_UpdateClientEntityInfo(DataPack networkData)
{
	networkData.Reset(); 
	int iRef = networkData.ReadCell();
	int userid = networkData.ReadCell();
	delete networkData;
	int iEntity = EntRefToEntIndex(iRef);
	int iClient = GetClientOfUserId(userid);
	
	if (iEntity > 0 && iClient > 0)
		g_bClientAndEntityNetwork[iEntity][iClient] = true;
}

stock void Network_ResetClient(int iClient)
{
	for (int i = 0; i < 2049; i++)
	{
		g_bClientAndEntityNetwork[i][iClient] = false;
	}
}

stock void Network_ResetEntity(int iEnt)
{
	for (int i = 0; i <= MaxClients; i++)
	{
		g_bClientAndEntityNetwork[iEnt][i] = false;
	}
}

stock bool Network_ClientHasSeenEntity(int iClient, int iEnt)
{
	return g_bClientAndEntityNetwork[iEnt][iClient];
}

stock bool IsEntityClassname(int iEnt, const char[] classname, bool bCaseSensitive=true)
{
	if (!IsValidEntity(iEnt)) return false;
	
	char sBuffer[256];
	GetEntityClassname(iEnt, sBuffer, sizeof(sBuffer));
	
	return StrEqual(sBuffer, classname, bCaseSensitive);
}

stock int FindEntityByTargetname(const char[] targetName, const char[] className, bool caseSensitive=true)
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, className)) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (StrEqual(sName, targetName, caseSensitive))
		{
			return ent;
		}
	}
	
	return INVALID_ENT_REFERENCE;
}

stock float EntityDistanceFromEntity(int ent1,int ent2, bool bSquared=false)
{
	if (!IsValidEntity(ent1) || !IsValidEntity(ent2)) return -1.0;
	
	float flMyPos[3],flHisPos[3];
	GetEntPropVector(ent1, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(ent2, Prop_Data, "m_vecAbsOrigin", flHisPos);
	return GetVectorDistance(flMyPos, flHisPos, bSquared);
}

stock void GetEntityOBBCenterPosition(int ent, float flBuffer)
{
	float flPos[3], flMins[3], flMaxs[3];
	GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flPos);
	GetEntPropVector(ent, Prop_Send, "m_vecMins", flMins);
	GetEntPropVector(ent, Prop_Send, "m_vecMaxs", flMaxs);
	
	for (new i = 0; i < 3; i++) flBuffer[i] = flPos[i] + ((flMins[i] + flMaxs[i]) / 2.0);
}

stock bool IsSpaceOccupied(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle hTrace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_VISIBLE, TraceRayDontHitEntity, entity);
	bool bHit = TR_DidHit(hTrace);
	ref = TR_GetEntityIndex(hTrace);
	delete hTrace;
	return bHit;
}

stock bool IsSpaceOccupiedIgnorePlayers(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle hTrace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_VISIBLE, TraceRayDontHitPlayersOrEntity, entity);
	bool bHit = TR_DidHit(hTrace);
	ref = TR_GetEntityIndex(hTrace);
	delete hTrace;
	return bHit;
}

stock bool IsSpaceOccupiedPlayer(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle hTrace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_PLAYERSOLID, TraceRayDontHitEntity, entity);
	bool bHit = TR_DidHit(hTrace);
	ref = TR_GetEntityIndex(hTrace);
	delete hTrace;
	return bHit;
}

stock bool IsSpaceOccupiedNPC(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle hTrace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_NPCSOLID, TraceRayDontHitEntity, entity);
	bool bHit = TR_DidHit(hTrace);
	ref = TR_GetEntityIndex(hTrace);
	delete hTrace;
	return bHit;
}

int EntitySetAnimation(int iEntity, const char[] sName, float flPlaybackRate = 1.0, int iForceSequence = -1)
{
	int iSequence = iForceSequence;
	if (iForceSequence == -1)
	{
		iSequence = CBaseAnimating_LookupSequence(iEntity, sName);
	}
	
	SDKCall(g_hSDKResetSequence, iEntity, iSequence);
	
	if (flPlaybackRate<-12.0) flPlaybackRate = -12.0;
	if (flPlaybackRate>12.0) flPlaybackRate = 12.0;
	SetEntPropFloat(iEntity, Prop_Send, "m_flPlaybackRate", flPlaybackRate);
	return iSequence;
}

stock void EntitySetBlendAnimation(int iEntity, const char[] sParameter, float flSpeed)
{
	int iParameter = utils_EntityLookupPoseParameter(iEntity, sParameter);
	if (iParameter < 0)
		return;
	float flNewValue;
	utils_StudioSetPoseParameter(iEntity, iParameter, flSpeed, flNewValue);
	SetEntPropFloat(iEntity, Prop_Send, "m_flPoseParameter", flNewValue, iParameter);
	//PrintToChatAll("called");
}
stock void SDK_GetVectors(int iEntity, float vecForward[3], float vecRight[3], float vecUp[3])
{
	if (g_hSDKGetVectors != INVALID_HANDLE)
	{
		SDKCall(g_hSDKGetVectors, iEntity, vecForward, vecRight, vecUp);
		return;
	}
}

stock void SDK_GetSmoothedVelocity(int iEntity, float flVector[3])
{
	if (g_hSDKGetSmoothedVelocity == INVALID_HANDLE)
	{
		LogError("SDKCall for GetSmoothedVelocity is invalid!");
		return;
	}
	SDKCall(g_hSDKGetSmoothedVelocity, iEntity, flVector);
}

//  =========================================================
//  GLOW FUNCTIONS
//
//I borrowed this glow creation code from Pelipoika, cause It's efficient and clean 
stock int TF2_CreateGlow(int iEnt)
{
	char oldEntName[64];
	GetEntPropString(iEnt, Prop_Data, "m_iName", oldEntName, sizeof(oldEntName));

	char strName[126], strClass[64];
	GetEntityClassname(iEnt, strClass, sizeof(strClass));
	Format(strName, sizeof(strName), "%s%i", strClass, iEnt);
	DispatchKeyValue(iEnt, "targetname", strName);
	
	int ent = CreateEntityByName("tf_glow");
	DispatchKeyValue(ent, "target", strName);
	Format(strName, sizeof(strName), "tf_glow_%i", iEnt);
	DispatchKeyValue(ent, "targetname", strName);
	DispatchKeyValue(ent, "Mode", "0");
	DispatchSpawn(ent);
	
	AcceptEntityInput(ent, "Enable");
	
	//Change name back to old name because we don't need it anymore.
	SetEntPropString(iEnt, Prop_Data, "m_iName", oldEntName);

	return ent;
}
//	==========================================================
//	CLIENT ENTITY FUNCTIONS
//	==========================================================

//Credits to Linux_lover for this stock and signature.
stock void SDK_PlaySpecificSequence(int client, const char[] strSequence)
{
	if(g_hSDKPlaySpecificSequence != INVALID_HANDLE)
	{
#if defined DEBUG
		static bool once = true;
		if(once)
		{
			PrintToServer("(SDK_PlaySpecificSequence) Calling on player %N \"%s\"..", client, strSequence);
			once = false;
		}
#endif
		SDKCall(g_hSDKPlaySpecificSequence, client, strSequence);
	}
}

stock void SDK_EquipWearable(int client, int entity)
{
	if(g_hSDKEquipWearable != INVALID_HANDLE)
	{
		SDKCall( g_hSDKEquipWearable, client, entity );
	}
}

stock void KillClient(int client)
{
	if (client != -1)
	{
		SDKHooks_TakeDamage(client, 0, 0, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		ForcePlayerSuicide(client);
		SetVariantInt(9001);
		AcceptEntityInput(client, "RemoveHealth");
	}
}

#define SF_IGNORE_LOS	0x0004
#define SF_NO_DISGUISED_SPY_HEALING	0x0008

/* Hack around server code logic to call CTFPlayerShared::StopHealing */
stock void SDK_StopHealing(int iHealer, int iClient)
{
	int iEntity = CreateEntityByName("obj_dispenser");
	if(iEntity > MaxClients)
	{
		int iTeam = GetClientTeam(iClient);
		DispatchSpawn(iEntity);
		float vecPos[3];
		GetClientEyePosition(iClient, vecPos);
		TeleportEntity(iEntity, vecPos, NULL_VECTOR, NULL_VECTOR);

		char strTeam[5];
		IntToString(iTeam, strTeam, sizeof(strTeam));
		DispatchKeyValue(iEntity, "teamnum", strTeam);

		SetVariantInt(iTeam);
		AcceptEntityInput(iEntity, "setteam");
		AcceptEntityInput(iEntity, "setbuilder", iHealer);
		SetVariantInt(999);
		AcceptEntityInput(iEntity, "SetHealth");

		//Set various property to get the dispenser working asap
		SetEntProp(iEntity, Prop_Data, "m_spawnflags", SF_IGNORE_LOS);
		SetEntPropEnt(iEntity, Prop_Send, "m_hBuilder", iHealer);
		SetEntProp(iEntity, Prop_Send, "m_bBuilding", false);
		SetEntProp(iEntity, Prop_Send, "m_bDisabled", false);
		SetEntProp(iEntity, Prop_Send, "m_bCarryDeploy", false);
		
		// Remove the team glow outline.
		/*int flags = GetEntProp(iEntity, Prop_Send, "m_fEffects");
		flags |= EF_NODRAW;
		SetEntProp(iEntity, Prop_Send, "m_fEffects", flags);*/
		
		//Start the healing
		SDK_StartTouch(iEntity, iClient);
		SetEntProp(iEntity, Prop_Send, "m_bCarryDeploy", true);
		//SDK_EndTouch(iEntity, iClient);
		CreateTimer(10.0, Timer_KillEntity, EntIndexToEntRef(iEntity));
	}
}

int SDK_SwitchWeapon(int client, int weapon)
{
	if(g_hSDKWeaponSwitch != INVALID_HANDLE)
	{
		return SDKCall(g_hSDKWeaponSwitch, client, weapon, 0);
	}

	return -1;
}

stock bool IsClientInKart(int client)
{
	if (TF2_IsPlayerInCondition(client, TFCond_HalloweenKart) ||
		TF2_IsPlayerInCondition(client, TFCond_HalloweenKartDash) ||
		TF2_IsPlayerInCondition(client, TFCond_HalloweenKartNoTurn) ||
		TF2_IsPlayerInCondition(client, TFCond_HalloweenKartCage))
	{
		return true;
	}
	return false;
}

stock bool IsClientCritUbercharged(int client)
{
	if (TF2_IsPlayerInCondition(client, TFCond_Ubercharged) ||
		TF2_IsPlayerInCondition(client, TFCond_UberchargeFading) ||
		TF2_IsPlayerInCondition(client, TFCond_UberchargedHidden) ||
		TF2_IsPlayerInCondition(client, TFCond_UberchargedOnTakeDamage) ||
		TF2_IsPlayerInCondition(client, TFCond_UberchargedCanteen))
	{
		return true;
	}
	return false;
}

stock bool IsClientCritBoosted(int client)
{
	if (TF2_IsPlayerInCondition(client, TFCond_Kritzkrieged) ||
		TF2_IsPlayerInCondition(client, TFCond_HalloweenCritCandy) ||
		TF2_IsPlayerInCondition(client, TFCond_CritCanteen) ||
		TF2_IsPlayerInCondition(client, TFCond_CritOnFirstBlood) ||
		TF2_IsPlayerInCondition(client, TFCond_CritOnWin) ||
		TF2_IsPlayerInCondition(client, TFCond_CritOnFlagCapture) ||
		TF2_IsPlayerInCondition(client, TFCond_CritOnKill) ||
		TF2_IsPlayerInCondition(client, TFCond_CritOnDamage) ||
		TF2_IsPlayerInCondition(client, TFCond_CritMmmph))
	{
		return true;
	}
	
	int iActiveWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if (IsValidEdict(iActiveWeapon))
	{
		char sNetClass[64];
		GetEntityNetClass(iActiveWeapon, sNetClass, sizeof(sNetClass));
		
		if (strcmp(sNetClass, "CTFFlameThrower") == 0)
		{
			if (GetEntProp(iActiveWeapon, Prop_Send, "m_bCritFire")) return true;
		
			int iItemDef = GetEntProp(iActiveWeapon, Prop_Send, "m_iItemDefinitionIndex");
			if (iItemDef == 594 && TF2_IsPlayerInCondition(client, TFCond_CritMmmph)) return true;
		}
		else if (strcmp(sNetClass, "CTFMinigun") == 0)
		{
			if (GetEntProp(iActiveWeapon, Prop_Send, "m_bCritShot")) return true;
		}
	}
	
	return false;
}

stock void TF2_StripWearables(int client)
{
	int iEntity = MaxClients+1;
	while((iEntity = FindEntityByClassname(iEntity, "tf_wearable")) > MaxClients)
	{
		if(GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity") == client)
		{
			AcceptEntityInput(iEntity, "Kill");
		}
	}

	iEntity = MaxClients+1;
	while((iEntity = FindEntityByClassname(iEntity, "tf_powerup_bottle")) > MaxClients)
	{
		if(GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity") == client)
		{
			AcceptEntityInput(iEntity, "Kill");
		}
	}
}

stock void TF2_ChangePlayerName(int iClient, const char[] sNewName, bool bPrintInChat = false)
{
	char sOldName[64];
	GetEntPropString(iClient, Prop_Data, "m_szNetname", sOldName, sizeof(sOldName));
	
	/*Event event_namechange = CreateEvent("player_changename");
	event_namechange.SetInt("userid", GetClientUserId(iClient));
	event_namechange.SetString("oldname", sOldName);
	event_namechange.SetString("newname", sNewName);
	event_namechange.Fire();*/
	
	int players[MAXPLAYERS+1];
	int playersNum;
	for (int player = 1; player <= MaxClients; player++)
	{
		if (!IsClientInGame(player)) continue;
		players[playersNum++] = player;
	}
	UTIL_SayText2(players, playersNum, iClient, bPrintInChat, "#TF_Name_Change", sOldName, sNewName);
	
	
	SetEntPropString(iClient, Prop_Data, "m_szNetname", sNewName);
}

stock int TF2_FindNoiseMaker(int iClient)
{
	int iEntity = MaxClients + 1;
	while ((iEntity = FindEntityByClassname(iEntity, "tf_wearable")) > MaxClients)
	{
		if (GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity") == iClient)
		{
			if (TF2_WeaponFindAttribute(iEntity, 196) > 0.0)
			{
				return iEntity;
			}
		}
	}
	
	return -1;
}

stock float TF2_WeaponFindAttribute(int iWeapon, int iAttrib)
{
	Address addAttrib = TF2Attrib_GetByDefIndex(iWeapon, iAttrib);
	if (addAttrib == Address_Null)
	{
		int iItemDefIndex = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
		int iAttributes[16];
		float flAttribValues[16];
		
		int iMaxAttrib = TF2Attrib_GetStaticAttribs(iItemDefIndex, iAttributes, flAttribValues);
		for (int i = 0; i < iMaxAttrib; i++)
		{
			if (iAttributes[i] == iAttrib)
			{
				return flAttribValues[i];
			}
		}
		
		return 0.0;
	}
	
	return TF2Attrib_GetValue(addAttrib);
}

stock void ClientSwitchToWeaponSlot(int client,int iSlot)
{
	int iWeapon = GetPlayerWeaponSlot(client, iSlot);
	if (iWeapon < MaxClients) return;
	
	SDK_SwitchWeapon(client, iWeapon);
}

stock void ChangeClientTeamNoSuicide(int client,int team, bool bRespawn=true)
{
	if (!IsClientInGame(client)) return;
	
	if (GetClientTeam(client) != team)
	{
		SetEntProp(client, Prop_Send, "m_lifeState", 2);
		ChangeClientTeam(client, team);
		SetEntProp(client, Prop_Send, "m_lifeState", 0);
		if (bRespawn) TF2_RespawnPlayer(client);
	}
}

stock void UTIL_SayText2(int[] players, int playersNum, int iEntity, bool bChat, const char[] msg_name, const char[] param1="", const char[] param2="", const char[] param3="", const char[] param4="")
{
	BfWrite message = UserMessageToBfWrite(StartMessage("SayText2", players, playersNum, USERMSG_RELIABLE|USERMSG_BLOCKHOOKS)); 
	
	message.WriteByte(iEntity);
	
	message.WriteByte(bChat);

	message.WriteString(msg_name); 
	
	message.WriteString(param1); 
	
	message.WriteString(param2); 
	
	message.WriteString(param3);

	message.WriteString(param4);
	delete message;
	EndMessage();
}

stock void UTIL_ClientScreenShake(int client, float amplitude, float duration, float frequency)
{
	Handle hBf = StartMessageOne("Shake", client);
	if (hBf != INVALID_HANDLE)
	{
		BfWriteByte(hBf, 0);
		BfWriteFloat(hBf, amplitude);
		BfWriteFloat(hBf, frequency);
		BfWriteFloat(hBf, duration);
		delete hBf;
		EndMessage();
	}
}

public void UTIL_ScreenFade(int client,int duration,int time,int flags,int r,int g,int b,int a)
{
	int clients[1];
	Handle bf;
	clients[0] = client;
	
	bf = StartMessage("Fade", clients, 1);
	BfWriteShort(bf, duration);
	BfWriteShort(bf, time);
	BfWriteShort(bf, flags);
	BfWriteByte(bf, r);
	BfWriteByte(bf, g);
	BfWriteByte(bf, b);
	BfWriteByte(bf, a);
	delete bf;
	EndMessage();
}

stock bool IsValidClient(int client)
{
	return view_as<bool>((client > 0 && client <= MaxClients && IsClientInGame(client)));
}

stock void PrintToSourceTV(const char[] Message)
{
	int iClient = GetClientOfUserId(g_iSourceTVUserID);
	if (MaxClients >= iClient > 0 && IsClientInGame(iClient) && IsClientSourceTV(iClient))
	{
		CPrintToChat(iClient, Message);
	}
}
//	==========================================================
//	TF2-SPECIFIC FUNCTIONS
//	==========================================================
stock bool TF2_IsMiniCritBuffed(int iClient)
{
	return (TF2_IsPlayerInCondition(iClient, TFCond_CritCola)
        || TF2_IsPlayerInCondition(iClient, TFCond_CritHype)
        || TF2_IsPlayerInCondition(iClient, TFCond_Buffed)
    );
}

stock bool TF2_IsPlayerCritBuffed(int iClient)
{
    return (TF2_IsPlayerInCondition(iClient, TFCond_Kritzkrieged)
        || TF2_IsPlayerInCondition(iClient, TFCond_HalloweenCritCandy)
        || TF2_IsPlayerInCondition(iClient, TFCond_CritCanteen)
        || TF2_IsPlayerInCondition(iClient, TFCond_CritDemoCharge)
        || TF2_IsPlayerInCondition(iClient, TFCond_CritOnFirstBlood)
        || TF2_IsPlayerInCondition(iClient, TFCond_CritOnWin)
        || TF2_IsPlayerInCondition(iClient, TFCond_CritOnFlagCapture)
        || TF2_IsPlayerInCondition(iClient, TFCond_CritOnKill)
        || TF2_IsPlayerInCondition(iClient, TFCond_CritMmmph)
		|| TF2_IsPlayerInCondition(iClient, TFCond_CritOnDamage)
    );
}

stock bool IsTauntWep(int iWeapon)
{
	int Index = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
	if(Index==37 || Index==304 || Index==5 || Index==195 || Index==43 || Index==239 || Index==310 || Index==331 || Index==426 || Index==587 || Index==656 || Index==1084 || Index==1100 || Index == 1143)
		return true;
	return false;
}

stock void FindHealthBar()
{
	g_ihealthBar = FindEntityByClassname(-1, "monster_resource");
	
	if (g_ihealthBar == -1)
	{
		g_ihealthBar = CreateEntityByName("monster_resource");
		if (g_ihealthBar != -1)
		{
			DispatchSpawn(g_ihealthBar);
		}
	}
}

stock void ForceTeamWin(int team)
{
	int ent = FindEntityByClassname(-1, "team_control_point_master");
	if (ent == -1)
	{
		ent = CreateEntityByName("team_control_point_master");
		DispatchSpawn(ent);
		AcceptEntityInput(ent, "Enable");
	}
	
	SetVariantInt(team);
	AcceptEntityInput(ent, "SetWinner");
}

stock void GameTextTFMessage(const char[] message, const char[] icon="")
{
	int ent = CreateEntityByName("game_text_tf");
	DispatchKeyValue(ent, "message", message);
	DispatchKeyValue(ent, "display_to_team", "0");
	DispatchKeyValue(ent, "icon", icon);
	DispatchSpawn(ent);
	AcceptEntityInput(ent, "Display");
	AcceptEntityInput(ent, "Kill");
}

stock int BuildAnnotationBitString(const int[] clients,int iMaxClients)
{
	int iBitString = 1;
	for (int i = 0; i < maxClients; i++)
	{
		int client = clients[i];
		if (!IsClientInGame(client) || !IsPlayerAlive(client)) continue;
	
		iBitString |= RoundFloat(Pow(2.0, float(client)));
	}
	
	return iBitString;
}

stock void SpawnAnnotation(int client,int entity, const float pos[3], const char[] message, float lifetime)
{
	Handle event = CreateEvent("show_annotation", true);
	if (event != INVALID_HANDLE)
	{
		new bitstring = BuildAnnotationBitString(id, pos, type, team);
		if (bitstring > 1)
		{
			pos[2] -= 35.0;
			SetEventFloat(event, "worldPosX", pos[0]);
			SetEventFloat(event, "worldPosY", pos[1]);
			SetEventFloat(event, "worldPosZ", pos[2]);
			SetEventFloat(event, "lifetime", lifetime);
			SetEventInt(event, "id", id);
			SetEventString(event, "text", message);
			SetEventInt(event, "visibilityBitfield", bitstring);
			FireEvent(event);
			KillTimer(event);
		}
		
	}
}

stock float TF2_GetClassBaseSpeed(TFClassType class)
{
	switch (class)
	{
		case TFClass_Scout:
		{
			return 400.0;
		}
		case TFClass_Soldier:
		{
			return 240.0;
		}
		case TFClass_Pyro:
		{
			return 300.0;
		}
		case TFClass_DemoMan:
		{
			return 280.0;
		}
		case TFClass_Heavy:
		{
			return 230.0;
		}
		case TFClass_Engineer:
		{
			return 300.0;
		}
		case TFClass_Medic:
		{
			return 320.0;
		}
		case TFClass_Sniper:
		{
			return 300.0;
		}
		case TFClass_Spy:
		{
			return 320.0;
		}
	}
	
	return 0.0;
}

stock Handle PrepareItemHandle(char[] classname,int index,int level,int quality, char[] att)
{
	Handle hItem = TF2Items_CreateItem(OVERRIDE_ALL | FORCE_GENERATION);
	TF2Items_SetClassname(hItem, classname);
	TF2Items_SetItemIndex(hItem, index);
	TF2Items_SetLevel(hItem, level);
	TF2Items_SetQuality(hItem, quality);
	
	// Set attributes.
	char atts[32][32];
	int count = ExplodeString(att, " ; ", atts, 32, 32);
	if (count > 1)
	{
		TF2Items_SetNumAttributes(hItem, count / 2);
		int i2 = 0;
		for (int i = 0; i < count; i+= 2)
		{
			TF2Items_SetAttribute(hItem, i2, StringToInt(atts[i]), StringToFloat(atts[i+1]));
			i2++;
		}
	}
	else
	{
		TF2Items_SetNumAttributes(hItem, 0);
	}
	
	return hItem;
}
stock void SpecialRoundGameText(const char[] strMessage, const char strIcon[]="")
{
	int iEntity = CreateEntityByName("game_text_tf");
	DispatchKeyValue(iEntity,"message", strMessage);
	DispatchKeyValue(iEntity,"display_to_team", "0");
	DispatchKeyValue(iEntity,"icon", strIcon);
	DispatchKeyValue(iEntity,"targetname", "game_text1");
	DispatchKeyValue(iEntity,"background", "0");
	DispatchSpawn(iEntity);
	AcceptEntityInput(iEntity, "Display", iEntity, iEntity);
	CreateTimer(2.0, Timer_KillEntity, EntIndexToEntRef(iEntity));
}
// Removes wearables such as botkillers from weapons.
stock void TF2_RemoveWeaponSlotAndWearables(int client,int iSlot)
{
	int iWeapon = GetPlayerWeaponSlot(client, iSlot);
	if (!IsValidEntity(iWeapon)) return;
	
	int iWearable = INVALID_ENT_REFERENCE;
	while ((iWearable = FindEntityByClassname(iWearable, "tf_wearable")) != -1)
	{
		int iWeaponAssociated = GetEntPropEnt(iWearable, Prop_Send, "m_hWeaponAssociatedWith");
		if (iWeaponAssociated == iWeapon)
		{
			AcceptEntityInput(iWearable, "Kill");
		}
	}
	
	iWearable = INVALID_ENT_REFERENCE;
	while ((iWearable = FindEntityByClassname(iWearable, "tf_wearable_vm")) != -1)
	{
		int iWeaponAssociated = GetEntPropEnt(iWearable, Prop_Send, "m_hWeaponAssociatedWith");
		if (iWeaponAssociated == iWeapon)
		{
			AcceptEntityInput(iWearable, "Kill");
		}
	}
	
	iWearable = INVALID_ENT_REFERENCE;
	while ((iWearable = FindEntityByClassname(iWearable, "tf_wearable_campaign_item")) != -1)
	{
		int iWeaponAssociated = GetEntPropEnt(iWearable, Prop_Send, "m_hWeaponAssociatedWith");
		if (iWeaponAssociated == iWeapon)
		{
			AcceptEntityInput(iWearable, "Kill");
		}
	}
	
	TF2_RemoveWeaponSlot(client, iSlot);
}

void TE_Particle(int iParticleIndex, float origin[3]=NULL_VECTOR, float start[3]=NULL_VECTOR, float angles[3]=NULL_VECTOR, int entindex=-1, int attachtype=-1, int attachpoint=-1, bool resetParticles=true)
{
    TE_Start("TFParticleEffect");
    TE_WriteFloat("m_vecOrigin[0]", origin[0]);
    TE_WriteFloat("m_vecOrigin[1]", origin[1]);
    TE_WriteFloat("m_vecOrigin[2]", origin[2]);
    TE_WriteFloat("m_vecStart[0]", start[0]);
    TE_WriteFloat("m_vecStart[1]", start[1]);
    TE_WriteFloat("m_vecStart[2]", start[2]);
    TE_WriteVector("m_vecAngles", angles);
    TE_WriteNum("m_iParticleSystemIndex", iParticleIndex);
    TE_WriteNum("entindex", entindex);

    if(attachtype != -1)
    {
        TE_WriteNum("m_iAttachType", attachtype);
    }
    if(attachpoint != -1)
    {
        TE_WriteNum("m_iAttachmentPointIndex", attachpoint);
    }
    TE_WriteNum("m_bResetParticles", resetParticles ? 1 : 0);
}

stock void UTIL_ScreenShake(float center[3], float amplitude, float frequency, float duration, float radius, int command, bool airShake)
{
	for(int i=1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			if(!airShake && command == 0 && !(GetEntityFlags(i) && FL_ONGROUND)) continue;

			float playerPos[3];
			GetClientAbsOrigin(i, playerPos);

			float localAmplitude = ComputeShakeAmplitude(center, playerPos, amplitude, radius);

			if(localAmplitude < 0.0) continue;

			if(localAmplitude > 0 || command == 1)
			{
				Handle msg = StartMessageOne("Shake", i, USERMSG_RELIABLE);
				if(msg != null)
				{
					BfWriteByte(msg, command);
					BfWriteFloat(msg, localAmplitude);
					BfWriteFloat(msg, frequency);
					BfWriteFloat(msg, duration);
					delete msg;
					EndMessage();
				}
			}
		}
	}
}

stock float ComputeShakeAmplitude(float center[3], float playerPos[3], float amplitude, float radius)
{
	if(radius <= 0.0) return amplitude;

	float localAmplitude = -1.0;
	float delta[3];
	SubtractVectors(center, playerPos, delta);
	float distance = GetVectorLength(delta);

	if(distance <= radius)
	{
		float perc = 1.0 - (distance / radius);
		localAmplitude = amplitude * perc;
	}

	return localAmplitude;
}

//	==========================================================
//	FLOAT FUNCTIONS
//	==========================================================

/**
 *	Converts a given timestamp into hours, minutes, and seconds.
 */
stock void FloatToTimeHMS(float time,int &h=0,int &m=0,int &s=0)
{
	s = RoundFloat(time);
	h = s / 3600;
	s -= h * 3600;
	m = s / 60;
	s = s % 60;
}

stock int FixedUnsigned16(float value,int scale)
{
	int iOutput;
	
	iOutput = RoundToFloor(value * float(scale));
	
	if (iOutput < 0)
	{
		iOutput = 0;
	}
	
	if (iOutput > 0xFFFF)
	{
		iOutput = 0xFFFF;
	}
	
	return iOutput;
}

stock float FloatMin(float a, float b)
{
	if (a < b) return a;
	return b;
}

stock float FloatMax(float a, float b)
{
	if (a > b) return a;
	return b;
}

//	==========================================================
//	NAV FUNCTIONS
//	==========================================================

stock CNavArea SDK_GetLastKnownArea(int iEntity)//Only parse entities that their server class inherits from CBaseCombatCharacter and nothing else!
{
	if (g_hSDKGetLastKnownArea != null)
	{
		Address lastNavArea = SDKCall(g_hSDKGetLastKnownArea, iEntity);
		if (!IsValidAddress(lastNavArea)) return INVALID_NAV_AREA;
		
		int iNavID = GetNavAreaIDFromNavAreaPointer(lastNavArea);
		return NavMesh_FindAreaByID(iNavID);
	}
	return INVALID_NAV_AREA;
}

stock void SDK_UpdateLastKnownArea(int iEntity)
{
	if (g_hSDKUpdateLastKnownArea != null)
	{
		SDKCall(g_hSDKUpdateLastKnownArea, iEntity);
	}
}

stock int GetNavAreaIDFromNavAreaPointer(Address pNavArea)
{
	return LoadFromAddress(view_as<Address>(view_as<int>(pNavArea)+(g_iOffset_m_id*4)), NumberType_Int32);
}

bool IsValidAddress(Address addr)
{
	if (addr == Address_Null) return false;
	if (addr <= view_as<Address>(VALID_MINIMUM_MEMORY_ADDRESS)) return false;
	
	return true;
}
//	==========================================================
//	VECTOR FUNCTIONS
//	==========================================================

/**
 *	Copies a vector into another vector.
 */
stock void CopyVector(const float flCopy[3], float flDest[3])
{
	flDest[0] = flCopy[0];
	flDest[1] = flCopy[1];
	flDest[2] = flCopy[2];
}

stock void LerpVectors(const float fA[3] , const float fB[3], float fC[3], float t)
{
    if (t < 0.0) t = 0.0;
    if (t > 1.0) t = 1.0;
    
    fC[0] = fA[0] + (fB[0] - fA[0]) * t;
    fC[1] = fA[1] + (fB[1] - fA[1]) * t;
    fC[2] = fA[2] + (fB[2] - fA[2]) * t;
}

/**
 *	Translates and re-orients a given offset vector into world space, given a world position and angle.
 */
stock void VectorTransform(const float offset[3], const float worldpos[3], const float ang[3], float buffer[3])
{
	float fwd[3],right[3], up[3];
	GetAngleVectors(ang, fwd, right, up);
	
	NormalizeVector(fwd, fwd);
	NormalizeVector(right, right);
	NormalizeVector(up, up);
	
	ScaleVector(right, offset[1]);
	ScaleVector(fwd, offset[0]);
	ScaleVector(up, offset[2]);
	
	buffer[0] = worldpos[0] + right[0] + fwd[0] + up[0];
	buffer[1] = worldpos[1] + right[1] + fwd[1] + up[1];
	buffer[2] = worldpos[2] + right[2] + fwd[2] + up[2];
}
stock void GetPositionForward(float vPos[3], float vAng[3], float vReturn[3], float fDistance)
{
	float vDir[3];
	GetAngleVectors(vAng, vDir, NULL_VECTOR, NULL_VECTOR);
	vReturn = vPos;
	for(int i=0; i<3; i++) vReturn[i] += vDir[i] * fDistance;
}
//	==========================================================
//	ANGLE FUNCTIONS
//	==========================================================

stock float ApproachAngle(float target, float value, float speed)
{
	float delta = AngleDiff(value, target);
	
	if (speed < 0.0) speed = -speed;
	
	if (delta > speed) value += speed;
	else if (delta < -speed) value -= speed;
	else value = target;
	
	return AngleNormalize(value);
}

stock float AngleNormalize(float angle)
{
	while (angle > 180.0) angle -= 360.0;
	while (angle < -180.0) angle += 360.0;
	return angle;
}

stock float AngleDiff(float firstAngle, float secondAngle)
{
	float diff = secondAngle - firstAngle;
	return AngleNormalize(diff);
}

//	==========================================================
//	PRECACHING FUNCTIONS
//	==========================================================

stock void PrecacheSound2(const char[] path)
{
	PrecacheSound(path, true);
	char buffer[PLATFORM_MAX_PATH];
	Format(buffer, sizeof(buffer), "sound/%s", path);
	AddFileToDownloadsTable(buffer);
}

stock void PrecacheMaterial2(const char[] path)
{
	char buffer[PLATFORM_MAX_PATH];
	Format(buffer, sizeof(buffer), "materials/%s.vmt", path);
	AddFileToDownloadsTable(buffer);
	Format(buffer, sizeof(buffer), "materials/%s.vtf", path);
	AddFileToDownloadsTable(buffer);
}

stock int PrecacheParticleSystem(const char[] particleSystem)
{
	static int particleEffectNames = INVALID_STRING_TABLE;

	if (particleEffectNames == INVALID_STRING_TABLE) {
		if ((particleEffectNames = FindStringTable("ParticleEffectNames")) == INVALID_STRING_TABLE) {
			return INVALID_STRING_INDEX;
		}
	}

	int index = FindStringIndex2(particleEffectNames, particleSystem);
	if (index == INVALID_STRING_INDEX) {
		int numStrings = GetStringTableNumStrings(particleEffectNames);
		if (numStrings >= GetStringTableMaxStrings(particleEffectNames)) {
			return INVALID_STRING_INDEX;
		}
		
		AddToStringTable(particleEffectNames, particleSystem);
		index = numStrings;
	}
	
	return index;
}

stock int FindStringIndex2(int tableidx, const char[] str)
{
	char buf[1024];
	
	int numStrings = GetStringTableNumStrings(tableidx);
	for (int i=0; i < numStrings; i++) {
		ReadStringTable(tableidx, i, buf, sizeof(buf));
		
		if (StrEqual(buf, str)) {
			return i;
		}
	}
	
	return INVALID_STRING_INDEX;
}

stock void InsertNodesAroundPoint(Handle hArray, const float flOrigin[3], float flDist, float flAddAng, Function iCallback=INVALID_FUNCTION, any data=-1)
{
	float flDirection[3];
	float flPos[3];
	
	for (float flAng = 0.0; flAng < 360.0; flAng += flAddAng)
	{
		flDirection[0] = 0.0;
		flDirection[1] = flAng;
		flDirection[2] = 0.0;
		
		GetAngleVectors(flDirection, flDirection, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(flDirection, flDirection);
		ScaleVector(flDirection, flDist);
		AddVectors(flDirection, flOrigin, flPos);
		
		float flPos2[3];
		for (int i = 0; i < 2; i++) flPos2[i] = flPos[i];
		
		if (iCallback != INVALID_FUNCTION)
		{
			Action iAction = Plugin_Continue;
			
			Call_StartFunction(INVALID_HANDLE, iCallback);
			Call_PushArray(flOrigin, 3);
			Call_PushArrayEx(flPos2, 3, SM_PARAM_COPYBACK);
			Call_PushCell(data);
			Call_Finish(iAction);
			
			if (iAction == Plugin_Stop || iAction == Plugin_Handled) continue;
			else if (iAction == Plugin_Changed)
			{
				for (int i = 0; i < 2; i++) flPos[i] = flPos2[i];
			}
		}
		
		PushArrayArray(hArray, flPos, 3);
	}
}

//	==========================================================
//	TRACE FUNCTIONS
//	==========================================================

public bool TraceRayDontHitEntity(int entity,int mask,any data)
{
	if (entity == data) return false;
	return true;
}

public bool TraceRayDontHitPlayers(int entity,int mask, any data)
{
	if (entity > 0 && entity <= MaxClients) return false;
	return true;
}

public bool TraceRayDontHitPlayersOrEntity(int entity,int mask,any data)
{
	if (entity == data) return false;
	if (entity > 0 && entity <= MaxClients) return false;
	
	return true;
}

//	==========================================================
//	TIMER/CALLBACK FUNCTIONS
//	==========================================================
stock void CloseEvent(Event event)
{
	CreateTimer(10.0,CloseEventTimer,event);
}
stock void DeleteHandle(Handle handle)
{
	CreateTimer(0.1,CloseHandleTimer,handle);
}
public Action CloseEventTimer(Handle timer,Event event)
{
	delete event;
}
public Action CloseHandleTimer(Handle timer,Handle handle)
{
	delete handle;
}
public Action Timer_KillEntity(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (ent == INVALID_ENT_REFERENCE) return;
	
	AcceptEntityInput(ent, "Kill");
}

//	==========================================================
//	SPECIAL ROUND FUCNTIONS
//	==========================================================
stock bool IsInfiniteFlashlightEnabled()
{
	return view_as<bool>(g_bRoundInfiniteFlashlight || (GetConVarInt(g_cvPlayerInfiniteFlashlightOverride) == 1) || SF_SpecialRound(SPECIALROUND_INFINITEFLASHLIGHT) || ((GetConVarBool(g_cvNightvisionEnabled) || SF_SpecialRound(SPECIALROUND_NIGHTVISION)) && g_iNightvisionType == 1));
}

int g_iArraySpecialRoundType[SPECIALROUND_MAXROUNDS];

stock bool SF_SpecialRound(int iSpecialRound)
{
	if(!g_bSpecialRound)
		return false;
	for (int iArray = 0;iArray < SPECIALROUND_MAXROUNDS; iArray++)
	{
		if(iSpecialRound==g_iArraySpecialRoundType[iArray])
			return true;
	}
	return false;
}

stock void SF_AddSpecialRound(int iSpecialRound)
{
	for (int iArray = 0;iArray < SPECIALROUND_MAXROUNDS; iArray++)
	{
		if (g_iArraySpecialRoundType[iArray] == 0 || g_iArraySpecialRoundType[iArray] == iSpecialRound)
		{
			g_iArraySpecialRoundType[iArray] = iSpecialRound;
			break;
		}
	}
}

stock void SF_RemoveSpecialRound(int iSpecialRound)
{
	for (int iArray = 0;iArray < SPECIALROUND_MAXROUNDS; iArray++)
	{
		if (g_iArraySpecialRoundType[iArray] == iSpecialRound)
		{
			g_iArraySpecialRoundType[iArray] = 0;
			//Useless
			/*if (iArray != (SPECIALROUND_MAXROUNDS-1))
			{
				for (int iArray2 = iArray;iArray2 < SPECIALROUND_MAXROUNDS; iArray2++)
				{
					if (g_iArraySpecialRoundType[iArray2+1] != 0)
					{
						g_iArraySpecialRoundType[iArray2] = g_iArraySpecialRoundType[iArray2+1];
						g_iArraySpecialRoundType[iArray2+1] = 0;
					}
					else
					{
						g_iArraySpecialRoundType[iArray2] = 0;
						break;
					}
				}
			}*/
			break;
		}
	}
}

stock void SF_RemoveAllSpecialRound()
{
	for (int iArray = 0;iArray < SPECIALROUND_MAXROUNDS; iArray++)
	{
		g_iArraySpecialRoundType[iArray] = 0;
	}
}