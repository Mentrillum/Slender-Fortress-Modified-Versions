#pragma semicolon 1

// Deathcam data.
int g_PlayerDeathCamBoss[MAXTF2PLAYERS] = { -1, ... };
static bool g_PlayerDeathCam[MAXTF2PLAYERS] = { false, ... };
bool g_PlayerDeathCamShowOverlay[MAXTF2PLAYERS] = { false, ... };
int g_PlayerDeathCamEnt[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerDeathCamEnt2[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerDeathCamTarget[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static Handle g_PlayerDeathCamTimer[MAXTF2PLAYERS] = { null, ... };
bool g_CameraInDeathCamAdvanced[2049] = { false, ... };
float g_CameraPlayerOffsetBackward[2049] = { 0.0, ... };
float g_CameraPlayerOffsetDownward[2049] = { 0.0, ... };
static float g_PlayerOriginalDeathcamPosition[MAXTF2PLAYERS][3];

void SetupDeathCams()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	ClientResetDeathCam(client.index);

	SDKHook(client.index, SDKHook_PreThink, Hook_DeathCamThink);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ClientResetDeathCam(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		ClientResetDeathCam(client.index);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetDeathCam(client.index);
}

bool IsClientInDeathCam(int client)
{
	return g_PlayerDeathCam[client];
}

static Action Hook_DeathCamSetTransmit(int slender,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (EntRefToEntIndex(g_PlayerDeathCamEnt2[other]) != slender)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

static void ClientResetDeathCam(int client)
{
	if (!IsClientInDeathCam(client))
	{
		return; // no really need to reset if it wasn't set.
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetDeathCam(%d)", client);
	}
	#endif

	int deathCamBoss = NPCGetFromUniqueID(g_PlayerDeathCamBoss[client]);

	g_PlayerDeathCamBoss[client] = -1;
	g_PlayerDeathCam[client] = false;
	g_PlayerDeathCamShowOverlay[client] = false;
	g_PlayerDeathCamTimer[client] = null;

	int ent = EntRefToEntIndex(g_PlayerDeathCamEnt[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		g_CameraInDeathCamAdvanced[ent] = false;
		AcceptEntityInput(ent, "Disable");
		RemoveEntity(ent);
	}

	ent = EntRefToEntIndex(g_PlayerDeathCamEnt2[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(ent, "Kill");
	}

	ent = EntRefToEntIndex(g_PlayerDeathCamTarget[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(ent);
	}

	g_PlayerDeathCamEnt[client] = INVALID_ENT_REFERENCE;
	g_PlayerDeathCamEnt2[client] = INVALID_ENT_REFERENCE;
	g_PlayerDeathCamTarget[client] = INVALID_ENT_REFERENCE;

	if (IsClientInGame(client))
	{
		SetClientViewEntity(client, client);
	}

	Call_StartForward(g_OnClientEndDeathCamFwd);
	Call_PushCell(client);
	Call_PushCell(deathCamBoss);
	Call_Finish();

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetDeathCam(%d)", client);
	}
	#endif
}

void ClientStartDeathCam(int client,int bossIndex, const float lookPos[3], bool antiCamp = false)
{
	if (IsClientInDeathCam(client))
	{
		return;
	}
	if (!NPCIsValid(bossIndex))
	{
		return;
	}

	for (int npcIndex; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
		switch (NPCGetType(npcIndex))
		{
			case SF2BossType_Chaser:
			{
				if (g_SlenderState[npcIndex] == STATE_CHASE && EntRefToEntIndex(g_SlenderTarget[npcIndex]) == client)
				{
					g_SlenderGiveUp[npcIndex] = true;
				}
			}
		}
	}

	GetClientAbsOrigin(client, g_PlayerOriginalDeathcamPosition[client]);

	char buffer[PLATFORM_MAX_PATH];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	SF2BossProfileSoundInfo soundInfo;
	if (g_SlenderDeathCamScareSound[bossIndex])
	{
		GetBossProfileScareSounds(profile, soundInfo);
		soundInfo.EmitSound(true, client);
	}

	GetBossProfileClientDeathCamSounds(profile, soundInfo);
	soundInfo.EmitSound(true, client);

	GetBossProfileGlobalDeathCamSounds(profile, soundInfo);
	for (int i = 0; i < MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}
		soundInfo.EmitSound(true, i);
	}

	// Call our forward.
	Call_StartForward(g_OnClientCaughtByBossFwd);
	Call_PushCell(client);
	Call_PushCell(bossIndex);
	Call_Finish();

	if (!NPCHasDeathCamEnabled(bossIndex) && !(NPCGetFlags(bossIndex) & SFF_FAKE))
	{
		SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol changes our lifestate.

		float value = NPCGetAttributeValue(bossIndex, SF2Attribute_IgnitePlayerOnDeath);
		if (value > 0.0)
		{
			TF2_IgnitePlayer(client, client);
		}

		int slenderEnt = NPCGetEntIndex(bossIndex);
		if (slenderEnt > MaxClients)
		{
			SDKHooks_TakeDamage(client, slenderEnt, slenderEnt, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		}
		SDKHooks_TakeDamage(client, 0, 0, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		ForcePlayerSuicide(client);//Sometimes SDKHooks_TakeDamage doesn't work (probably because of point_viewcontrol), the player is still alive and result in a endless round.
		KillClient(client);
		return;
	}
	else if (NPCGetFlags(bossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(bossIndex);
	}

	g_PlayerDeathCamBoss[client] = NPCGetUniqueID(bossIndex);
	g_PlayerDeathCam[client] = true;
	g_PlayerDeathCamShowOverlay[client] = false;

	float eyePos[3], eyeAng[3], angle[3];
	GetClientEyePosition(client, eyePos);
	GetClientEyeAngles(client, eyeAng);
	SubtractVectors(eyePos, lookPos, angle);
	GetVectorAngles(angle, angle);
	angle[0] = 0.0;
	angle[2] = 0.0;

	// Create fake model.
	int slender = SpawnSlenderModel(bossIndex, lookPos, true);
	TeleportEntity(slender, lookPos, angle, NULL_VECTOR);
	g_PlayerDeathCamEnt2[client] = EntIndexToEntRef(slender);
	if (!g_SlenderPublicDeathCam[bossIndex])
	{
		SDKHook(slender, SDKHook_SetTransmit, Hook_DeathCamSetTransmit);
	}
	else
	{
		GetBossProfileLocalDeathCamSounds(profile, soundInfo);
		soundInfo.EmitSound(_, slender);
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
		if (!antiCamp)
		{
			int slenderEnt = NPCGetEntIndex(bossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_SlenderInDeathcam[bossIndex] = true;
				SetEntityRenderMode(slenderEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(slenderEnt, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);
				NPCChaserUpdateBossAnimation(bossIndex, slenderEnt, STATE_IDLE);
				g_SlenderDeathCamTarget[bossIndex] = EntIndexToEntRef(client);
				if (g_SlenderEntityThink[bossIndex] != null)
				{
					KillTimer(g_SlenderEntityThink[bossIndex]);
				}
				g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderPublicDeathCamThink, EntIndexToEntRef(slenderEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}

	// Create camera look point.
	char name[64];
	FormatEx(name, sizeof(name), "sf2_boss_%d", EntIndexToEntRef(slender));

	float offsetPos[3];
	int target = CreateEntityByName("info_target");
	if (!g_SlenderPublicDeathCam[bossIndex])
	{
		GetBossProfileDeathCamPosition(profile, offsetPos);
		AddVectors(lookPos, offsetPos, offsetPos);
		TeleportEntity(target, offsetPos, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(target, "targetname", name);
		SetVariantString("!activator");
		AcceptEntityInput(target, "SetParent", slender);
	}
	else
	{
		char boneName[PLATFORM_MAX_PATH];
		AddVectors(lookPos, offsetPos, offsetPos);
		TeleportEntity(target, offsetPos, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(target, "targetname", name);
		SetVariantString("!activator");
		AcceptEntityInput(target, "SetParent", slender);
		GetBossProfilePublicDeathCamTargetAttachment(profile, boneName, sizeof(boneName));
		if (boneName[0] != '\0')
		{
			SetVariantString(boneName);
			AcceptEntityInput(target, "SetParentAttachment");
		}
	}
	g_PlayerDeathCamTarget[client] = EntIndexToEntRef(target);

	// Create the camera itself.
	int camera = CreateEntityByName("point_viewcontrol");
	TeleportEntity(camera, eyePos, eyeAng, NULL_VECTOR);
	DispatchKeyValue(camera, "spawnflags", "12");
	DispatchKeyValue(camera, "target", name);
	DispatchSpawn(camera);
	AcceptEntityInput(camera, "Enable", client);
	g_PlayerDeathCamEnt[client] = EntIndexToEntRef(camera);
	if (g_SlenderPublicDeathCam[bossIndex])
	{
		float camSpeed, camAcceleration, camDeceleration;

		camSpeed = g_SlenderPublicDeathCamSpeed[bossIndex];
		camAcceleration = g_SlenderPublicDeathCamAcceleration[bossIndex];
		camDeceleration = g_SlenderPublicDeathCamDeceleration[bossIndex];
		FloatToString(camSpeed, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "acceleration", buffer);
		FloatToString(camAcceleration, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "deceleration", buffer);
		FloatToString(camDeceleration, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "speed", buffer);

		SetVariantString("!activator");
		AcceptEntityInput(camera, "SetParent", slender);
		char attachmentName[PLATFORM_MAX_PATH];
		GetBossProfilePublicDeathCamAttachment(profile, attachmentName, sizeof(attachmentName));
		if (attachmentName[0] != '\0')
		{
			SetVariantString(attachmentName);
			AcceptEntityInput(camera, "SetParentAttachment");
		}

		g_CameraInDeathCamAdvanced[camera] = true;
		g_CameraPlayerOffsetBackward[camera] = g_SlenderPublicDeathCamBackwardOffset[bossIndex];
		g_CameraPlayerOffsetDownward[camera] = g_SlenderPublicDeathCamDownwardOffset[bossIndex];
		RequestFrame(Frame_PublicDeathCam, camera); //Resend taunt sound to eliminated players only
	}

	if (g_SlenderDeathCamOverlay[bossIndex] && g_SlenderDeathCamOverlayTimeStart[bossIndex] >= 0.0)
	{
		if (g_SlenderPublicDeathCam[bossIndex] && !antiCamp)
		{
			int slenderEnt = NPCGetEntIndex(bossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_SlenderDeathCamTimer[bossIndex] = CreateTimer(g_SlenderDeathCamOverlayTimeStart[bossIndex], Timer_BossDeathCamDelay, EntIndexToEntRef(slenderEnt), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		g_PlayerDeathCamTimer[client] = CreateTimer(g_SlenderDeathCamOverlayTimeStart[bossIndex], Timer_ClientResetDeathCam1, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		if (g_SlenderPublicDeathCam[bossIndex] && !antiCamp)
		{
			int slenderEnt = NPCGetEntIndex(bossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_SlenderDeathCamTimer[bossIndex] = CreateTimer(g_SlenderDeathCamTime[bossIndex], Timer_BossDeathCamDuration, EntIndexToEntRef(slenderEnt), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		g_PlayerDeathCamTimer[client] = CreateTimer(g_SlenderDeathCamTime[bossIndex], Timer_ClientResetDeathCamEnd, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}

	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));

	Call_StartForward(g_OnClientStartDeathCamFwd);
	Call_PushCell(client);
	Call_PushCell(bossIndex);
	Call_Finish();
}

static void Frame_PublicDeathCam(int cameraRef)
{
	int camera = EntRefToEntIndex(cameraRef);
	if (!camera || camera == INVALID_ENT_REFERENCE)
	{
		return;
	}
	int slender = GetEntPropEnt(camera, Prop_Data, "m_hOwnerEntity");
	int client = GetEntPropEnt(camera, Prop_Data, "m_hPlayer");
	if (IsValidEntity(slender) && IsValidClient(client))
	{
		float camPos[3], camAngs[3];
		GetEntPropVector(camera, Prop_Data, "m_angAbsRotation", camAngs);
		GetEntPropVector(camera, Prop_Data, "m_vecAbsOrigin", camPos);

		camPos[0] -= g_CameraPlayerOffsetBackward[camera];
		camPos[2] -= g_CameraPlayerOffsetDownward[camera];

		TeleportEntity(client, camPos, camAngs, NULL_VECTOR);

		RequestFrame(Frame_PublicDeathCam, EntIndexToEntRef(cameraRef));
	}
}

static Action Timer_ClientResetDeathCam1(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerDeathCamTimer[client])
	{
		return Plugin_Stop;
	}

	SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(NPCGetFromUniqueID(g_PlayerDeathCamBoss[client]));

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];

	if (Npc.IsValid())
	{
		g_PlayerDeathCamShowOverlay[client] = true;
		Npc.GetProfile(profile, sizeof(profile));
		SF2BossProfileSoundInfo soundInfo;
		GetBossProfilePlayerDeathcamOverlaySounds(profile, soundInfo);
		soundInfo.EmitSound(true, client);
		g_PlayerDeathCamTimer[client] = CreateTimer(g_SlenderDeathCamTime[Npc.Index], Timer_ClientResetDeathCamEnd, userid, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Stop;
}

static Action Timer_BossDeathCamDelay(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(NPCGetFromEntIndex(slender));

	if (timer != g_SlenderDeathCamTimer[Npc.Index])
	{
		return Plugin_Stop;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	Npc.GetProfile(profile, sizeof(profile));

	g_SlenderDeathCamTimer[Npc.Index] = CreateTimer(g_SlenderDeathCamTime[Npc.Index], Timer_BossDeathCamDuration, slender, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

static Action Timer_BossDeathCamDuration(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	SF2NPC_Chaser Npc = SF2NPC_Chaser(NPCGetFromEntIndex(slender));

	if (timer != g_SlenderDeathCamTimer[Npc.Index])
	{
		return Plugin_Stop;
	}

	if (g_SlenderInDeathcam[Npc.Index])
	{
		SetEntityRenderMode(slender, RENDER_NORMAL);
		if (!Npc.CloakEnabled)
		{
			SetEntityRenderColor(slender, Npc.GetRenderColor(0), Npc.GetRenderColor(1), Npc.GetRenderColor(2), Npc.GetRenderColor(3));
		}
		g_SlenderEntityThink[Npc.Index] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (!(Npc.Flags & SFF_FAKE))
		{
			g_SlenderInDeathcam[Npc.Index] = false;
		}
		Npc.UpdateAnimation(slender, Npc.State);
	}
	if ((Npc.Flags & SFF_FAKE))
	{
		if (g_SlenderInDeathcam[Npc.Index])
		{
			g_SlenderInDeathcam[Npc.Index] = false;
		}
		Npc.MarkAsFake();
	}
	g_SlenderDeathCamTimer[Npc.Index] = null;

	return Plugin_Stop;
}

static Action Timer_ClientResetDeathCamEnd(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerDeathCamTimer[client])
	{
		return Plugin_Stop;
	}

	SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol entity changes our damage state.

	SF2NPC_BaseNPC deathCamBoss = SF2NPC_BaseNPC(NPCGetFromUniqueID(g_PlayerDeathCamBoss[client]));
	if (deathCamBoss != SF2_INVALID_NPC)
	{
		float value = deathCamBoss.GetAttributeValue(SF2Attribute_IgnitePlayerOnDeath);
		if (value > 0.0)
		{
			TF2_IgnitePlayer(client, client);
		}
		if (!(deathCamBoss.Flags & SFF_FAKE))
		{
			int slenderEnt = deathCamBoss.EntIndex;
			if (slenderEnt > MaxClients)
			{
				SDKHooks_TakeDamage(client, slenderEnt, slenderEnt, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
			}
			SDKHooks_TakeDamage(client, 0, 0, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
			ForcePlayerSuicide(client);//Sometimes SDKHooks_TakeDamage doesn't work (probably because of point_viewcontrol), the player is still alive and result in a endless round.
			KillClient(client);
		}
		else
		{
			SetEntityMoveType(client, MOVETYPE_WALK);
			TeleportEntity(client, g_PlayerOriginalDeathcamPosition[client], NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
		}
	}
	else //The boss is invalid? But the player got a death cam?
	{
		//Then kill him anyways.
		KillClient(client);
		ForcePlayerSuicide(client);
	}
	ClientResetDeathCam(client);

	return Plugin_Stop;
}

static void Hook_DeathCamThink(int client)
{
	if (!g_Enabled)
	{
		return;
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsValid || !player.IsInDeathCam || player.IsInGhostMode)
	{
		return;
	}

	CBaseEntity ent = CBaseEntity(EntRefToEntIndex(g_PlayerDeathCamEnt[client]));
	if (ent.IsValid() && g_CameraInDeathCamAdvanced[ent.index])
	{
		float camPos[3], camAngs[3];
		ent.GetAbsAngles(camAngs);
		ent.GetAbsOrigin(camPos);

		camPos[0] -= g_CameraPlayerOffsetBackward[ent.index];
		camPos[2] -= g_CameraPlayerOffsetDownward[ent.index];

		player.SetLocalOrigin(camPos);
		player.SetLocalAngles(camAngs);
	}
}