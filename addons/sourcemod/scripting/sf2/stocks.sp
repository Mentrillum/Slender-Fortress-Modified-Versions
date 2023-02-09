#if defined _sf2_stocks_included
 #endinput
#endif
#define _sf2_stocks_included

#pragma semicolon 1

#define VALID_MINIMUM_MEMORY_ADDRESS 0x10000

#define SF2_FLASHLIGHT_LENGTH 1024.0 // How far the player's Flashlight can reach in world units.

#define HalfHumanHeight 35.5

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

//  ==========================================================
//	Map Functions
//  ==========================================================

bool SF_IsSurvivalMap()
{
	return !!(g_IsSurvivalMap || (g_SurvivalMapConVar.IntValue == 1));
}

bool SF_IsRaidMap()
{
	return !!(g_IsRaidMap || (g_RaidMapConVar.IntValue == 1));
}

bool SF_IsProxyMap()
{
	return !!(g_IsProxyMap || (g_ProxyMapConVar.IntValue == 1));
}

bool SF_BossesChaseEndlessly()
{
	return !!(g_BossesChaseEndlessly || (g_BossChaseEndlesslyConVar.IntValue == 1));
}

bool SF_IsBoxingMap()
{
	return !!(g_IsBoxingMap || (g_BoxingMapConVar.IntValue == 1));
}

bool SF_IsSlaughterRunMap()
{
	return !!(g_IsSlaughterRunMap || (g_SlaughterRunMapConVar.IntValue == 1));
}
/*
int SDK_StartTouch(int entity, int iOther)
{
	if (g_SDKStartTouch != null)
	{
		return SDKCall(g_SDKStartTouch, entity, iOther);
	}
	return -1;
}

int SDK_EndTouch(int entity, int iOther)
{
	if (g_SDKEndTouch != null)
	{
		return SDKCall(g_SDKEndTouch, entity, iOther);
	}
	return -1;
}
*/
bool SDK_PointIsWithin(int func, float pos[3])
{
	if (g_SDKPointIsWithin != null)
	{
		return !!(SDKCall(g_SDKPointIsWithin, func, pos));
	}

	return false;
}
//	==========================================================
//	ENTITY & ENTITY NETWORK FUNCTIONS
//	==========================================================

int EnsureEntRef(int entIndex)
{
	if (entIndex & (1 << 31))
	{
		return entIndex;
	}

	return IsValidEntity(entIndex) ? EntIndexToEntRef(entIndex) : INVALID_ENT_REFERENCE;
}

int SetEntityTransmitState(int entity, int newFlags)
{
    if (!IsValidEdict(entity))
    {
		return 0;
	}

    int flags = GetEdictFlags(entity);
    flags &= ~(FL_EDICT_ALWAYS | FL_EDICT_PVSCHECK | FL_EDICT_DONTSEND);
    flags |= newFlags;
    SetEdictFlags(entity, flags);

    return flags;
}

bool IsEntityClassname(int entIndex, const char[] classname, bool caseSensitive=true)
{
	if (!IsValidEntity(entIndex))
	{
		return false;
	}

	char buffer[256];
	GetEntityClassname(entIndex, buffer, sizeof(buffer));

	return strcmp(buffer, classname, caseSensitive) == 0;
}

int FindEntityByTargetname(const char[] targetName, const char[] className, bool caseSensitive=true)
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, className)) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, caseSensitive) == 0)
		{
			return ent;
		}
	}

	return INVALID_ENT_REFERENCE;
}

float GetVectorSquareMagnitude(const float vec1[3], const float vec2[3])
{
	return GetVectorDistance(vec1, vec2, true);
}

/*float GetVectorAnglesTwoPoints(const float startPos[3], const float endPos[3], float angles[3])
{
    static float tmpVec[3];
    tmpVec[0] = endPos[0] - startPos[0];
    tmpVec[1] = endPos[1] - startPos[1];
    tmpVec[2] = endPos[2] - startPos[2];
    GetVectorAngles(tmpVec, angles);
}*/

float SquareFloat(const float value)
{
	return value * value; //Using this to combine GetVectorSquareMagnitude() to improve performance
}

float EntityDistanceFromEntity(int ent1, int ent2)
{
	if (!IsValidEntity(ent1) || !IsValidEntity(ent2))
	{
		return -1.0;
	}

	float myPos[3],hisPos[3];
	GetEntPropVector(ent1, Prop_Data, "m_vecAbsOrigin", myPos);
	GetEntPropVector(ent2, Prop_Data, "m_vecAbsOrigin", hisPos);
	return GetVectorSquareMagnitude(myPos, hisPos);
}

bool IsSpaceOccupied(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle trace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_VISIBLE, TraceRayDontHitEntity, entity);
	bool hit = TR_DidHit(trace);
	ref = TR_GetEntityIndex(trace);
	delete trace;
	return hit;
}

bool IsSpaceOccupiedIgnorePlayers(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle trace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_VISIBLE, TraceRayDontHitPlayersOrEntity, entity);
	bool hit = TR_DidHit(trace);
	ref = TR_GetEntityIndex(trace);
	delete trace;
	return hit;
}

bool IsSpaceOccupiedIgnorePlayersAndEnts(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle trace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_VISIBLE, TraceRayDontHitCharactersOrEntity, entity);
	bool hit = TR_DidHit(trace);
	ref = TR_GetEntityIndex(trace);
	delete trace;
	return hit;
}

bool IsSpaceOccupiedPlayer(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle trace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_PLAYERSOLID, TraceRayDontHitEntity, entity);
	bool hit = TR_DidHit(trace);
	ref = TR_GetEntityIndex(trace);
	delete trace;
	return hit;
}

bool IsSpaceOccupiedNPC(const float pos[3], const float mins[3], const float maxs[3],int entity=-1,int &ref=-1)
{
	Handle trace = TR_TraceHullFilterEx(pos, pos, mins, maxs, MASK_NPCSOLID, TraceRayDontHitEntity, entity);
	bool hit = TR_DidHit(trace);
	ref = TR_GetEntityIndex(trace);
	delete trace;
	return hit;
}

int EntitySetAnimation(int entity, const char[] name, float playbackRate = 1.0, int forceSequence = -1, float cycle = 0.0)
{
	CBaseCombatCharacter animationEntity = CBaseCombatCharacter(entity);
	int sequence = forceSequence;
	Activity activity = TranslateProfileActivityFromName(name);
	if (activity != ACT_INVALID)
	{
		sequence = animationEntity.SelectWeightedSequence(activity);
	}
	else if (activity == ACT_INVALID && forceSequence == -1)
	{
		sequence = animationEntity.LookupSequence(name);
	}

	if (sequence != -1)
	{
		animationEntity.ResetSequence(sequence);
		if (cycle > 0.0)
		{
			animationEntity.SetPropFloat(Prop_Data, "m_flCycle", cycle);
		}
	}

	if (playbackRate < -12.0)
	{
		playbackRate = -12.0;
	}
	if (playbackRate > 12.0)
	{
		playbackRate = 12.0;
	}
	animationEntity.SetPropFloat(Prop_Send, "m_flPlaybackRate", playbackRate);
	return sequence;
}

void CBaseNPC_RemoveAllLayers(int entity)
{
	if (!IsValidEntity(entity))
	{
		return;
	}
	CBaseCombatCharacter animationEntity = CBaseCombatCharacter(entity);
	int count = animationEntity.GetNumAnimOverlays();
	for(int i = 0; i < count; i++)
	{
		CAnimationLayer overlay = animationEntity.GetAnimOverlay(i);
		if (!overlay.IsAlive())
		{
			continue;
		}
		overlay.KillMe();
	}
}

/*void SDK_GetSmoothedVelocity(int entity, float vector[3])
{
	if (g_SDKGetSmoothedVelocity == null)
	{
		LogError("SDKCall for GetSmoothedVelocity is invalid!");
		return;
	}
	SDKCall(g_SDKGetSmoothedVelocity, entity, vector);
}*/

bool NavHasFuncPrefer(CNavArea area)
{
	if (g_FuncNavPrefer == null)
	{
		return false;
	}
	float center[3];
	area.GetCenter(center);
	if (g_FuncNavPrefer.Length > 0)
	{
		for (int a = 1; a <= (g_FuncNavPrefer.Length - 1); a++)
		{
			int func = g_FuncNavPrefer.Get(a);
			if (SDK_PointIsWithin(func, center))
			{
				return true;
			}
		}
	}
	return false;
}

//  =========================================================
//  GLOW FUNCTIONS
//  =========================================================
//I borrowed this glow creation code from Pelipoika, cause It's efficient and clean
int TF2_CreateGlow(int entIndex)
{
	char oldEntName[64];
	GetEntPropString(entIndex, Prop_Data, "m_iName", oldEntName, sizeof(oldEntName));

	char strName[126], strClass[64];
	GetEntityClassname(entIndex, strClass, sizeof(strClass));
	FormatEx(strName, sizeof(strName), "%s%i", strClass, entIndex);
	DispatchKeyValue(entIndex, "targetname", strName);

	int ent = CreateEntityByName("tf_glow");
	DispatchKeyValue(ent, "target", strName);
	FormatEx(strName, sizeof(strName), "tf_glow_%i", entIndex);
	DispatchKeyValue(ent, "targetname", strName);
	DispatchKeyValue(ent, "Mode", "0");
	DispatchSpawn(ent);

	AcceptEntityInput(ent, "Enable");

	//Change name back to old name because we don't need it anymore.
	SetEntPropString(entIndex, Prop_Data, "m_iName", oldEntName);

	return ent;
}
//	==========================================================
//	CLIENT ENTITY FUNCTIONS
//	==========================================================

//Credits to Linux_lover for this and signature.
void SDK_PlaySpecificSequence(int client, const char[] strSequence)
{
	if (g_SDKPlaySpecificSequence != null)
	{
		#if defined DEBUG
		static bool once = true;
		if (once)
		{
			PrintToServer("(SDK_PlaySpecificSequence) Calling on player %N \"%s\"..", client, strSequence);
			once = false;
		}
		#endif
		SDKCall(g_SDKPlaySpecificSequence, client, strSequence);
	}
}

void SDK_EquipWearable(int client, int entity)
{
	if (g_SDKEquipWearable != null)
	{
		SDKCall(g_SDKEquipWearable, client, entity);
	}
}

void KillClient(int client)
{
	if (client != -1)
	{
		SDKHooks_TakeDamage(client, 0, 0, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		ForcePlayerSuicide(client);
		SetVariantInt(9001);
		AcceptEntityInput(client, "RemoveHealth");
	}
}

bool IsEntityAProjectile(int entity)
{
	char classname[64];
	if (IsValidEntity(entity) && GetEntityClassname(entity, classname, sizeof(classname)) &&
	(strcmp(classname, "env_explosion") == 0 ||
	strcmp(classname, "tf_projectile_sentryrocket") == 0 ||
	strcmp(classname, "tf_projectile_rocket") == 0 ||
	strcmp(classname, "tf_projectile_pipe") == 0 ||
	strcmp(classname, "tf_projectile_arrow") == 0))
	{
		return true;
	}
	return false;
}

void DestroyAllActiveWeapons(int client)
{
	for (int i = 0; i <= 5; i++)
	{
		int weaponEnt = GetPlayerWeaponSlot(client, i);
		if (!IsValidEntity(weaponEnt))
		{
			continue;
		}
		RemoveEntity(weaponEnt);
	}
}

#define SF_IGNORE_LOS	0x0004
#define SF_NO_DISGUISED_SPY_HEALING	0x0008

int SDK_SwitchWeapon(int client, int weapon)
{
	if (g_SDKWeaponSwitch != null)
	{
		return SDKCall(g_SDKWeaponSwitch, client, weapon, 0);
	}

	return -1;
}

bool IsClientInKart(int client)
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

bool IsClientCritUbercharged(int client)
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

bool IsClientCritBoosted(int client)
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

	int activeWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if (IsValidEdict(activeWeapon))
	{
		char netClass[64];
		GetEntityNetClass(activeWeapon, netClass, sizeof(netClass));

		if (strcmp(netClass, "CTFFlameThrower") == 0)
		{
			if (GetEntProp(activeWeapon, Prop_Send, "m_bCritFire"))
			{
				return true;
			}

			int iItemDef = GetEntProp(activeWeapon, Prop_Send, "m_iItemDefinitionIndex");
			if (iItemDef == 594 && TF2_IsPlayerInCondition(client, TFCond_CritMmmph))
			{
				return true;
			}
		}
		else if (strcmp(netClass, "CTFMinigun") == 0)
		{
			if (GetEntProp(activeWeapon, Prop_Send, "m_bCritShot"))
			{
				return true;
			}
		}
	}

	return false;
}

void TF2_StripWearables(int client)
{
	int entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_wearable")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") == client)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_wearable_vm")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") == client)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_powerup_bottle")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") == client)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_wearable_razorback")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") == client)
		{
			RemoveEntity(entity);
		}
	}
}

void TF2_DestroySpyWeapons()
{
	int entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_weapon_revolver")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") < 1)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_weapon_builder")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") < 1)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_weapon_knife")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") < 1)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "saxxy")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") < 1)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_weapon_pda_spy")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") < 1)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_weapon_invis")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") < 1)
		{
			RemoveEntity(entity);
		}
	}

	entity = MaxClients+1;
	while((entity = FindEntityByClassname(entity, "tf_weapon_sapper")) > MaxClients)
	{
		if (GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity") < 1)
		{
			RemoveEntity(entity);
		}
	}
}

void ClientSwitchToWeaponSlot(int client,int slot)
{
	int weaponEnt = GetPlayerWeaponSlot(client, slot);
	if (weaponEnt <= MaxClients)
	{
		return;
	}

	SDK_SwitchWeapon(client, weaponEnt);
}

void ChangeClientTeamNoSuicide(int client,int team, bool respawn=true)
{
	if (!IsClientInGame(client))
	{
		return;
	}

	if (GetClientTeam(client) != team)
	{
		SetEntProp(client, Prop_Send, "m_lifeState", 2);
		ChangeClientTeam(client, team);
		SetEntProp(client, Prop_Send, "m_lifeState", 0);
		if (respawn)
		{
			TF2_RespawnPlayer(client);
		}
	}
}

void UTIL_ClientScreenShake(int client, float amplitude, float duration, float frequency)
{
	Handle bf = StartMessageOne("Shake", client);
	if (bf != null)
	{
		BfWriteByte(bf, 0);
		BfWriteFloat(bf, amplitude);
		BfWriteFloat(bf, frequency);
		BfWriteFloat(bf, duration);
		delete bf;
		EndMessage();
	}
}

void UTIL_ScreenFade(int client,int duration,int time,int flags,int r,int g,int b,int a)
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

bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client);
}

void PrintToSourceTV(const char[] message)
{
	int client = GetClientOfUserId(g_SourceTVUserID);
	if (MaxClients >= client > 0 && IsClientInGame(client) && IsClientSourceTV(client))
	{
		CPrintToChat(client, message);
	}
}
//	==========================================================
//	TF2-SPECIFIC FUNCTIONS
//	==========================================================
bool TF2_IsMiniCritBuffed(int client)
{
	return (TF2_IsPlayerInCondition(client, TFCond_CritCola)
        || TF2_IsPlayerInCondition(client, TFCond_CritHype)
        || TF2_IsPlayerInCondition(client, TFCond_Buffed)
    );
}

bool IsTauntWep(int weaponEnt)
{
	int index = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
	if (index==37 || index==304 || index==5 || index==195 || index==43 || index==239 || index==310 || index==331 || index==426 || index==587 || index==656 || index==1084 || index==1100 || index == 1143)
	{
		return true;
	}
	return false;
}

void FindHealthBar()
{
	g_HealthBar = FindEntityByClassname(-1, "monster_resource");

	if (g_HealthBar == -1)
	{
		g_HealthBar = CreateEntityByName("monster_resource");
		if (g_HealthBar != -1)
		{
			DispatchSpawn(g_HealthBar);
		}
	}
}

void ForceTeamWin(int team)
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

Handle PrepareItemHandle(char[] classname,int index,int level,int quality, char[] att)
{
	Handle item = TF2Items_CreateItem(OVERRIDE_ALL | FORCE_GENERATION);
	TF2Items_SetClassname(item, classname);
	TF2Items_SetItemIndex(item, index);
	TF2Items_SetLevel(item, level);
	TF2Items_SetQuality(item, quality);

	// Set attributes.
	char atts[32][32];
	int count = ExplodeString(att, " ; ", atts, 32, 32);
	if (count > 1)
	{
		TF2Items_SetNumAttributes(item, count / 2);
		int i2 = 0;
		for (int i = 0; i < count; i+= 2)
		{
			TF2Items_SetAttribute(item, i2, StringToInt(atts[i]), StringToFloat(atts[i+1]));
			i2++;
		}
	}
	else
	{
		TF2Items_SetNumAttributes(item, 0);
	}

	return item;
}

void SpeakResponseConcept(int client, const char[] concept) //Thanks The Gaben
{
	SetVariantString(concept);
	AcceptEntityInput(client, "SpeakResponseConcept");
}

void SpecialRoundGameText(const char[] message, const char[] icon = "")
{
	int entity = CreateEntityByName("game_text_tf");
	DispatchKeyValue(entity,"message", message);
	DispatchKeyValue(entity,"display_to_team", "0");
	DispatchKeyValue(entity,"icon", icon);
	DispatchKeyValue(entity,"targetname", "game_text1");
	DispatchKeyValue(entity,"background", "0");
	DispatchSpawn(entity);
	AcceptEntityInput(entity, "Display", entity, entity); //The only time I keep this.
	CreateTimer(2.0, Timer_KillEntity, EntIndexToEntRef(entity), TIMER_FLAG_NO_MAPCHANGE);
}
// Removes wearables such as botkillers from weapons.
void TF2_RemoveWeaponSlotAndWearables(int client,int slot)
{
	int weaponEnt = GetPlayerWeaponSlot(client, slot);
	if (!IsValidEntity(weaponEnt)) return;

	int wearable = INVALID_ENT_REFERENCE;
	while ((wearable = FindEntityByClassname(wearable, "tf_wearable")) != -1)
	{
		int weaponAssociated = GetEntPropEnt(wearable, Prop_Send, "m_hWeaponAssociatedWith");
		if (weaponAssociated == weaponEnt)
		{
			RemoveEntity(wearable);
		}
	}

	wearable = INVALID_ENT_REFERENCE;
	while ((wearable = FindEntityByClassname(wearable, "tf_wearable_vm")) != -1)
	{
		int weaponAssociated = GetEntPropEnt(wearable, Prop_Send, "m_hWeaponAssociatedWith");
		if (weaponAssociated == weaponEnt)
		{
			RemoveEntity(wearable);
		}
	}

	wearable = INVALID_ENT_REFERENCE;
	while ((wearable = FindEntityByClassname(wearable, "tf_wearable_campaign_item")) != -1)
	{
		int weaponAssociated = GetEntPropEnt(wearable, Prop_Send, "m_hWeaponAssociatedWith");
		if (weaponAssociated == weaponEnt)
		{
			RemoveEntity(wearable);
		}
	}

	TF2_RemoveWeaponSlot(client, slot);
}

void TF2_StripContrackerOnly(int client)
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "tf_wearable_campaign_item")) > MaxClients)
	{
		if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
		{
			RemoveEntity(ent);
			break;
		}
	}
}

void TE_Particle(int particleIndex, float origin[3]=NULL_VECTOR, float start[3]=NULL_VECTOR, float angles[3]=NULL_VECTOR, int entindex=-1, int attachtype=-1, int attachpoint=-1, bool resetParticles=true)
{
    TE_Start("TFParticleEffect");
    TE_WriteFloat("m_vecOrigin[0]", origin[0]);
    TE_WriteFloat("m_vecOrigin[1]", origin[1]);
    TE_WriteFloat("m_vecOrigin[2]", origin[2]);
    TE_WriteFloat("m_vecStart[0]", start[0]);
    TE_WriteFloat("m_vecStart[1]", start[1]);
    TE_WriteFloat("m_vecStart[2]", start[2]);
    TE_WriteVector("m_vecAngles", angles);
    TE_WriteNum("m_iParticleSystemIndex", particleIndex);
    TE_WriteNum("entindex", entindex);

    if (attachtype != -1)
    {
        TE_WriteNum("m_iAttachType", attachtype);
    }
    if (attachpoint != -1)
    {
        TE_WriteNum("m_iAttachmentPointIndex", attachpoint);
    }
    TE_WriteNum("m_bResetParticles", resetParticles ? 1 : 0);
}

void UTIL_ScreenShake(float center[3], float amplitude, float frequency, float duration, float radius, int command, bool airShake)
{
	for(int i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i) && !IsClientInGhostMode(i))
		{
			if (!airShake && command == 0 && !(GetEntityFlags(i) && FL_ONGROUND))
			{
				continue;
			}

			float playerPos[3];
			GetClientAbsOrigin(i, playerPos);

			float localAmplitude = ComputeShakeAmplitude(center, playerPos, amplitude, radius);

			if (localAmplitude < 0.0)
			{
				continue;
			}

			if (localAmplitude > 0 || command == 1)
			{
				Handle msg = StartMessageOne("Shake", i, USERMSG_RELIABLE);
				if (msg != null)
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

float ComputeShakeAmplitude(float center[3], float playerPos[3], float amplitude, float radius)
{
	if (radius <= 0.0)
	{
		return amplitude;
	}

	float localAmplitude = -1.0;
	float delta[3];
	SubtractVectors(center, playerPos, delta);
	float distance = GetVectorLength(delta, true);

	if (distance <= SquareFloat(radius))
	{
		float perc = 1.0 - ((distance / SquareFloat(radius)));
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
void FloatToTimeHMS(float time,int &h=0,int &m=0,int &s=0)
{
	s = RoundFloat(time);
	h = s / 3600;
	s -= h * 3600;
	m = s / 60;
	s = s % 60;
}

int FixedUnsigned16(float value,int scale)
{
	int output;

	output = RoundToFloor(value * float(scale));

	if (output < 0)
	{
		output = 0;
	}

	if (output > 0xFFFF)
	{
		output = 0xFFFF;
	}

	return output;
}

float FloatClamp(float a, float min, float max)
{
	if (a < min)
	{
		a = min;
	}
	if (a > max)
	{
		a = max;
	}
	return a;
}

/**
 *	Linearly interpolates between a and b by t.
 */
/*float LerpFloats(const float a, const float b, float t)
{
    if (t < 0.0)
	{
		t = 0.0;
	}
    if (t > 1.0)
	{
		t = 1.0;
	}

    return a + (b - a) * t;
}*/

//	==========================================================
//	VECTOR FUNCTIONS
//	==========================================================

/**
 *	Copies a vector into another vector.
 */
void CopyVector(const float copy[3], float dest[3])
{
	dest[0] = copy[0];
	dest[1] = copy[1];
	dest[2] = copy[2];
}

/*void LerpVectors(const float a[3] , const float b[3], float c[3], float t)
{
    if (t < 0.0)
	{
		t = 0.0;
	}
    if (t > 1.0)
	{
		t = 1.0;
	}

    c[0] = a[0] + (b[0] - a[0]) * t;
    c[1] = a[1] + (b[1] - a[1]) * t;
    c[2] = a[2] + (b[2] - a[2]) * t;
}*/

/**
 *	Translates and re-orients a given offset vector into world space, given a world position and angle.
 */
void VectorTransform(const float offset[3], const float worldpos[3], const float ang[3], float buffer[3])
{
	float fwd[3], right[3], up[3];
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

void GetPositionForward(float pos[3], float ang[3], float returnValue[3], float distance)
{
	float dir[3];
	GetAngleVectors(ang, dir, NULL_VECTOR, NULL_VECTOR);
	returnValue = pos;
	for(int i=0; i<3; i++)
	{
		returnValue[i] += dir[i] * distance;
	}
}

//	==========================================================
//	ANGLE FUNCTIONS
//	==========================================================

/*float ApproachAngle(float target, float value, float speed)
{
	float delta = AngleDiff(value, target);

	if (speed < 0.0)
	{
		speed = -speed;
	}

	if (delta > speed)
	{
		value += speed;
	}
	else if (delta < -speed)
	{
		value -= speed;
	}
	else
	{
		value = target;
	}

	return AngleNormalize(value);
}*/

float AngleNormalize(float angle)
{
	while (angle > 180.0)
	{
		angle -= 360.0;
	}
	while (angle < -180.0)
	{
		angle += 360.0;
	}
	return angle;
}

float AngleDiff(float firstAngle, float secondAngle)
{
	float diff = secondAngle - firstAngle;
	return AngleNormalize(diff);
}
//Credits to Boikinov for figuring out these calculations I don't understand the thought process of
float GetAngleBetweenVectors(const float vector1[3], const float vector2[3], const float direction[3])
{
    float vector1_n[3], vector2_n[3], direction_n[3], cross[3];
    NormalizeVector(direction, direction_n);
    NormalizeVector(vector1, vector1_n);
    NormalizeVector(vector2, vector2_n);
    float degree = ArcCosine(GetVectorDotProduct( vector1_n, vector2_n )) * 57.29577951;
    GetVectorCrossProduct(vector1_n, vector2_n, cross);

    if (GetVectorDotProduct(cross, direction_n) < 0.0)
    {
        degree *= -1.0;
    }

    return degree;
}

void RotateYaw(float angles[3], float degree)
{
    float direction[3], normal[3];
    GetAngleVectors(angles, direction, NULL_VECTOR, normal);

    float sin = Sine(degree * 0.01745328);
    float cos = Cosine(degree * 0.01745328);
    float a = normal[0] * sin;
    float b = normal[1] * sin;
    float c = normal[2] * sin;
    float x = direction[2] * b + direction[0] * cos - direction[1] * c;
    float y = direction[0] * c + direction[1] * cos - direction[2] * a;
    float z = direction[1] * a + direction[2] * cos - direction[0] * b;
    direction[0] = x;
    direction[1] = y;
    direction[2] = z;

    GetVectorAngles(direction, angles);

    float up[3];
    GetVectorVectors(direction, NULL_VECTOR, up);

    float roll = GetAngleBetweenVectors(up, normal, direction);
    angles[2] += roll;
}

//	==========================================================
//	TRACE FUNCTIONS
//	==========================================================

bool TraceRayDontHitEntity(int entity,int mask,any data)
{
	if (entity == data)
	{
		return false;
	}
	if (IsValidEntity(entity))
	{
		char class[64];
		GetEntityClassname(entity, class, sizeof(class));
		if (strcmp(class, "base_npc"))
		{
			return false;
		}
	}
	return true;
}

bool TraceRayDontHitPlayers(int entity,int mask, any data)
{
	if (entity > 0 && entity <= MaxClients)
	{
		return false;
	}
	if (IsValidEntity(entity))
	{
		char class[64];
		GetEntityClassname(entity, class, sizeof(class));
		if (strcmp(class, "base_npc"))
		{
			return false;
		}
	}
	return true;
}

bool TraceRayDontHitPlayersOrEntity(int entity,int mask,any data)
{
	if (entity == data)
	{
		return false;
	}
	if (entity > 0 && entity <= MaxClients)
	{
		return false;
	}
	if (IsValidEntity(entity))
	{
		char class[64];
		GetEntityClassname(entity, class, sizeof(class));
		if (strcmp(class, "base_npc"))
		{
			return false;
		}
	}

	return true;
}

//	==========================================================
//	TIMER/CALLBACK FUNCTIONS
//	==========================================================
Action Timer_KillEntity(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (ent == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	if (!IsValidEntity(ent))
	{
		return Plugin_Stop;
	}

	RemoveEntity(ent);

	return Plugin_Stop;
}

Action Timer_KillEdict(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (!IsValidEdict(ent))
	{
		return Plugin_Stop;
	}

	RemoveEdict(ent);

	return Plugin_Stop;
}

//	==========================================================
//	SPECIAL ROUND FUNCTIONS
//	==========================================================
bool IsInfiniteFlashlightEnabled()
{
	return !!(g_RoundInfiniteFlashlight || (g_PlayerInfiniteFlashlightOverrideConVar.IntValue == 1) || SF_SpecialRound(SPECIALROUND_INFINITEFLASHLIGHT) || ((g_NightvisionEnabledConVar.BoolValue || SF_SpecialRound(SPECIALROUND_NIGHTVISION)) && g_NightvisionType == 1));
}

int g_ArraySpecialRoundType[SPECIALROUND_MAXROUNDS];

bool SF_SpecialRound(int specialRound)
{
	if (!g_IsSpecialRound)
	{
		return false;
	}
	for (int array = 0;array < SPECIALROUND_MAXROUNDS; array++)
	{
		if (specialRound==g_ArraySpecialRoundType[array])
		{
			return true;
		}
	}
	return false;
}

void SF_AddSpecialRound(int specialRound)
{
	for (int array = 0;array < SPECIALROUND_MAXROUNDS; array++)
	{
		if (g_ArraySpecialRoundType[array] == 0 || g_ArraySpecialRoundType[array] == specialRound)
		{
			g_ArraySpecialRoundType[array] = specialRound;
			break;
		}
	}
}

void SF_RemoveSpecialRound(int specialRound)
{
	for (int array = 0;array < SPECIALROUND_MAXROUNDS; array++)
	{
		if (g_ArraySpecialRoundType[array] == specialRound)
		{
			g_ArraySpecialRoundType[array] = 0;
			//Useless
			/*if (array != (SPECIALROUND_MAXROUNDS-1))
			{
				for (int iArray2 = array;iArray2 < SPECIALROUND_MAXROUNDS; iArray2++)
				{
					if (g_ArraySpecialRoundType[iArray2+1] != 0)
					{
						g_ArraySpecialRoundType[iArray2] = g_ArraySpecialRoundType[iArray2+1];
						g_ArraySpecialRoundType[iArray2+1] = 0;
					}
					else
					{
						g_ArraySpecialRoundType[iArray2] = 0;
						break;
					}
				}
			}*/
			break;
		}
	}
}

void SF_RemoveAllSpecialRound()
{
	for (int array = 0;array < SPECIALROUND_MAXROUNDS; array++)
	{
		g_ArraySpecialRoundType[array] = 0;
	}
}

//	==========================================================
//	OTHER FUNCTIONS
//	==========================================================
int GetLocalGlobalDifficulty(int npcIndex = -1)
{
	if (SF_IsBoxingMap())
	{
		if (NPCGetUniqueID(npcIndex) != -1)
		{
			return NPCChaserGetBoxingDifficulty(npcIndex);
		}
		else
		{
			return g_DifficultyConVar.IntValue;
		}
	}
	return g_DifficultyConVar.IntValue;
}

bool DispatchParticleEffect(int entity, const char[] particle, float startPos[3], float angles[3], float endPos[3],
									   int attachmentPointIndex = 0, ParticleAttachment attachType = PATTACH_CUSTOMORIGIN, bool resetAllParticlesOnEntity = false)
{
	char particleReal[PLATFORM_MAX_PATH];
	FormatEx(particleReal, PLATFORM_MAX_PATH, "%s", particle);
	if (particle[0] != '\0')
	{
		int tblidx = FindStringTable("ParticleEffectNames");
		if (tblidx == INVALID_STRING_TABLE)
		{
			LogError("Could not find string table: ParticleEffectNames");
			return false;
		}
		char tmp[256];
		int count = GetStringTableNumStrings(tblidx);
		int stridx = INVALID_STRING_INDEX;
		for (int i = 0; i < count; i++)
		{
			ReadStringTable(tblidx, i, tmp, sizeof(tmp));
			if (strcmp(tmp, particleReal, false) == 0)
			{
				stridx = i;
				break;
			}
		}
		if (stridx == INVALID_STRING_INDEX)
		{
			LogError("Could not find particle: %s", particleReal);
			return false;
		}

		TE_Start("TFParticleEffect");
		TE_WriteFloat("m_vecOrigin[0]", startPos[0]);
		TE_WriteFloat("m_vecOrigin[1]", startPos[1]);
		TE_WriteFloat("m_vecOrigin[2]", startPos[2]);
		TE_WriteVector("m_vecAngles", angles);
		TE_WriteNum("m_iParticleSystemIndex", stridx);
		TE_WriteNum("entindex", entity);
		TE_WriteNum("m_iAttachType", view_as<int>(attachType));
		TE_WriteNum("m_iAttachmentPointIndex", attachmentPointIndex);
		TE_WriteNum("m_bResetParticles", resetAllParticlesOnEntity);
		TE_WriteNum("m_bControlPoint1", 0);
		TE_WriteNum("m_ControlPoint1.m_eParticleAttachment", 0);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[0]", endPos[0]);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[1]", endPos[1]);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[2]", endPos[2]);
		TE_SendToAll();
	}
	else
	{
		//LogError("There is no valid particle to use for effects.");
		return false;
	}
	return true;
}

bool DispatchParticleEffectBeam(int entity, const char[] particle, float startPos[3], float angles[3], float endPos[3],
									   int attachmentPointIndex = 0, ParticleAttachment attachType = PATTACH_CUSTOMORIGIN, bool resetAllParticlesOnEntity = false)
{
	char particleReal[PLATFORM_MAX_PATH];
	FormatEx(particleReal, PLATFORM_MAX_PATH, "%s", particle);
	if (particle[0] != '\0')
	{
		int tblidx = FindStringTable("ParticleEffectNames");
		if (tblidx == INVALID_STRING_TABLE)
		{
			LogError("Could not find string table: ParticleEffectNames");
			return false;
		}
		char tmp[256];
		int count = GetStringTableNumStrings(tblidx);
		int stridx = INVALID_STRING_INDEX;
		for (int i = 0; i < count; i++)
		{
			ReadStringTable(tblidx, i, tmp, sizeof(tmp));
			if (strcmp(tmp, particleReal, false) == 0)
			{
				stridx = i;
				break;
			}
		}
		if (stridx == INVALID_STRING_INDEX)
		{
			LogError("Could not find particle: %s", particleReal);
			return false;
		}

		TE_Start("TFParticleEffect");
		TE_WriteFloat("m_vecOrigin[0]", startPos[0]);
		TE_WriteFloat("m_vecOrigin[1]", startPos[1]);
		TE_WriteFloat("m_vecOrigin[2]", startPos[2]);
		TE_WriteVector("m_vecAngles", angles);
		TE_WriteNum("m_iParticleSystemIndex", stridx);
		TE_WriteNum("entindex", entity);
		TE_WriteNum("m_iAttachType", view_as<int>(attachType));
		TE_WriteNum("m_iAttachmentPointIndex", attachmentPointIndex);
		TE_WriteNum("m_bResetParticles", resetAllParticlesOnEntity);
		TE_WriteNum("m_bControlPoint1", 1);
		TE_WriteNum("m_ControlPoint1.m_eParticleAttachment", 5);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[0]", endPos[0]);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[1]", endPos[1]);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[2]", endPos[2]);
		TE_SendToAll();
	}
	else
	{
		//LogError("There is no valid particle to use for effects.");
		return false;
	}
	return true;
}

MRESReturn Hook_GlowUpdateTransmitState(int glow, DHookReturn returnHook)
{
	returnHook.Value = SetEntityTransmitState(glow, FL_EDICT_FULLCHECK);
	return MRES_Supercede;
}