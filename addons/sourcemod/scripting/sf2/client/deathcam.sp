#pragma semicolon 1
#pragma newdecls required

methodmap BossProfileDeathCamData < ProfileObject
{
	property bool IsEnabled
	{
		public get()
		{
			return this != null;
		}
	}

	property bool PlayScareSound
	{
		public get()
		{
			return this.GetBool("scare_sound", false);
		}
	}

	property KeyMap_Array Overlays
	{
		public get()
		{
			return this.GetArray("overlays");
		}
	}

	property float LegacyOverlayStartTime
	{
		public get()
		{
			return this.GetFloat("__legacy_overlay_start", 0.0);
		}
	}

	property float LegacyDuration
	{
		public get()
		{
			return this.GetFloat("__legacy_duration", 0.0);
		}
	}

	public void GetLookPosition(float buffer[3])
	{
		this.GetVector("look_position", buffer);
	}

	property bool IsPublicDeathCamEnabled
	{
		public get()
		{
			return this.GetSection("public") != null;
		}
	}

	property float Speed
	{
		public get()
		{
			float def = 1000.0;
			ProfileObject obj = this.GetSection("public");
			if (obj != null)
			{
				def = obj.GetFloat("speed", def);
			}
			return def;
		}
	}

	property float Acceleration
	{
		public get()
		{
			float def = 1000.0;
			ProfileObject obj = this.GetSection("public");
			if (obj != null)
			{
				def = obj.GetFloat("acceleration", def);
			}
			return def;
		}
	}

	property float Deceleration
	{
		public get()
		{
			float def = 1000.0;
			ProfileObject obj = this.GetSection("public");
			if (obj != null)
			{
				def = obj.GetFloat("deceleration", def);
			}
			return def;
		}
	}

	property float BackwardOffset
	{
		public get()
		{
			float def = 0.0;
			ProfileObject obj = this.GetSection("public");
			obj = obj != null ? obj.GetSection("offset") : null;
			if (obj != null)
			{
				def = obj.GetFloat("backward", def);
			}
			return def;
		}
	}

	property float DownwardOffset
	{
		public get()
		{
			float def = 0.0;
			ProfileObject obj = this.GetSection("public");
			obj = obj != null ? obj.GetSection("offset") : null;
			if (obj != null)
			{
				def = obj.GetFloat("downward", def);
			}
			return def;
		}
	}

	public void GetAttachment(char[] buffer, int bufferSize)
	{
		ProfileObject obj = this.GetSection("public");
		if (obj != null)
		{
			obj.GetString("attachment", buffer, bufferSize);
		}
	}

	public void GetTargetAttachment(char[] buffer, int bufferSize)
	{
		ProfileObject obj = this.GetSection("public");
		if (obj != null)
		{
			obj.GetString("target_attachment", buffer, bufferSize);
		}
	}

	property bool Blackout
	{
		public get()
		{
			return this.GetBool("blackout", false);
		}
	}

	property bool StopSounds
	{
		public get()
		{
			return this.GetBool("stop_sounds", false);
		}
	}

	property ProfileSound ExecutionSounds
	{
		public get()
		{
			ProfileObject obj = this.GetSection("sounds");
			if (obj != null)
			{
				return view_as<ProfileSound>(obj.GetSection("execution"));
			}
			return null;
		}
	}

	public ProfileMasterAnimations GetAnimations()
	{
		return view_as<ProfileMasterAnimations>(this.GetSection("animations"));
	}

	public void Precache()
	{
		this.ConvertValuesSectionToArray("overlays");
		if (this.Overlays != null)
		{
			for (int i = 0; i < this.Overlays.Length; i++)
			{
				char value[PLATFORM_MAX_PATH];
				this.Overlays.GetString(i, value, sizeof(value));
				if (value[0] != '\0')
				{
					PrecacheMaterial2(value, g_FileCheckConVar.BoolValue);
				}
			}
		}
		if (this.ExecutionSounds != null)
		{
			this.ExecutionSounds.Precache();
		}
	}
}

methodmap DeathCamAnimation < ProfileAnimation
{
	public float GetPlayerDuration(int difficulty)
	{
		return this.GetDifficultyFloat("player_duration", difficulty, -1.0);
	}

	public float GetOverlayStartTime(int difficulty)
	{
		return this.GetDifficultyFloat("overlay_start_time", difficulty, -1.0);
	}
}

// Deathcam data.
int g_PlayerDeathCamBoss[MAXTF2PLAYERS] = { -1, ... };
static bool g_PlayerDeathCam[MAXTF2PLAYERS] = { false, ... };
static float g_PlayerDeathCamTimer[MAXTF2PLAYERS];
static bool g_PlayerDeathCamMustDoOverlay[MAXTF2PLAYERS];
static float g_PlayerDeathCamOverlayTimer[MAXTF2PLAYERS];
bool g_PlayerDeathCamShowOverlay[MAXTF2PLAYERS] = { false, ... };
char g_PlayerDeathCamCurrentOverlay[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
int g_PlayerDeathCamEnt[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerDeathCamEnt2[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerDeathCamTarget[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static ProfileSound g_PlayerDeathCamSound[MAXTF2PLAYERS] = { null, ... };
bool g_CameraInDeathCamAdvanced[2049] = { false, ... };
float g_CameraPlayerOffsetBackward[2049] = { 0.0, ... };
float g_CameraPlayerOffsetDownward[2049] = { 0.0, ... };
static float g_PlayerOriginalDeathcamPosition[MAXTF2PLAYERS][3];
static bool g_Hooked = false;

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
	g_PlayerDeathCamTimer[client] = 0.0;

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
		if (!SF2_BaseBoss(ent).IsValid() && !SF2_ChaserEntity(ent).IsValid() && !SF2_StatueEntity(ent).IsValid())
		{
			RemoveEntity(ent);
		}
	}

	ent = EntRefToEntIndex(g_PlayerDeathCamTarget[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(ent);
	}

	g_PlayerDeathCamEnt[client] = INVALID_ENT_REFERENCE;
	g_PlayerDeathCamEnt2[client] = INVALID_ENT_REFERENCE;
	g_PlayerDeathCamTarget[client] = INVALID_ENT_REFERENCE;

	SetClientViewEntity(client, client);

	if (deathCamBoss != -1)
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(deathCamBoss, profile, sizeof(profile));
		BossProfileDeathCamData data = GetBossProfile(profile).GetDeathCamData();
		if ((NPCGetFlags(deathCamBoss) & SFF_FAKE) == 0)
		{
			if (data.IsEnabled)
			{
				if (data.Blackout)
				{
					UTIL_ScreenFade(client, 10, 0, 0x0002 | 0x0010 | 0x0008, 0, 0, 0, 255);
					CreateTimer(0.1, Timer_DeleteRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
					TeleportEntity(client, {16000.0, 16000.0, 16000.0});

					UTIL_ScreenFade(client, 10, 0, 0x0002 | 0x0010 | 0x0008, 0, 0, 0, 255);
				}

				if (data.ExecutionSounds != null)
				{
					for (int i = 0; i < data.ExecutionSounds.Paths.Length; i++)
					{
						data.ExecutionSounds.EmitSound(true, client, SOUND_FROM_PLAYER, _, _, _, i);
					}
				}

				if (data.StopSounds && g_PlayerDeathCamSound[client] != null)
				{
					g_PlayerDeathCamSound[client].StopAllSounds(client);
					g_PlayerDeathCamSound[client] = null;
				}
			}
		}

		Call_StartForward(g_OnClientEndDeathCamFwd);
		Call_PushCell(client);
		Call_PushCell(deathCamBoss);
		Call_PushCell(SF2_BaseBoss(ent).IsValid() || SF2_ChaserEntity(ent).IsValid() || SF2_StatueEntity(ent).IsValid());
		Call_Finish();
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetDeathCam(%d)", client);
	}
	#endif
}

static Action NoPlayerVoiceHook(int clients[64], int& numClients, char sample[PLATFORM_MAX_PATH], int& client, int& channel, float& volume, int& level, int& pitch, int& flags)
{
	if (!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	if (channel == SNDCHAN_VOICE)
	{
		RemoveNormalSoundHook(NoPlayerVoiceHook);
		g_Hooked = false;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

static Action Timer_DeleteRagdoll(Handle timer, int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(GetClientOfUserId(client));
	if (!player.IsValid)
	{
		return Plugin_Continue;
	}

	int ragdoll = -1;
	while ((ragdoll = FindEntityByClassname(ragdoll, "tf_ragdoll")) != -1)
	{
		if (GetEntPropEnt(ragdoll, Prop_Send, "m_hPlayer") == player.index)
		{
			RemoveEntity(ragdoll);
			break;
		}
	}

	return Plugin_Continue;
}

void ClientStartDeathCam(int client, int bossIndex, const float lookPos[3], bool antiCamp = false)
{
	if (IsClientInDeathCam(client))
	{
		return;
	}
	if (!NPCIsValid(bossIndex))
	{
		return;
	}

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	GetClientAbsOrigin(client, g_PlayerOriginalDeathcamPosition[client]);

	char buffer[PLATFORM_MAX_PATH];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	BaseBossProfile data = GetBossProfile(profile);
	BossProfileDeathCamData deathCamData = data.GetDeathCamData();

	if (deathCamData.PlayScareSound)
	{
		data.GetScareSounds().EmitSound(true, client, SOUND_FROM_PLAYER);
	}

	g_PlayerDeathCamSound[client] = data.GetClientDeathCamSounds();
	g_PlayerDeathCamSound[client].EmitSound(true, client, SOUND_FROM_PLAYER);

	if ((NPCGetFlags(bossIndex) & SFF_FAKE) == 0)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsValidClient(i))
			{
				continue;
			}
			data.GetGlobalDeathCamSounds().EmitSound(true, i);
		}
	}

	// Call our forward.
	Call_StartForward(g_OnClientCaughtByBossFwd);
	Call_PushCell(client);
	Call_PushCell(bossIndex);
	Call_Finish();

	if ((NPCGetFlags(bossIndex) & SFF_FAKE) == 0)
	{
		if ((!deathCamData.IsEnabled || antiCamp))
		{
			SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol changes our lifestate.

			if (NPCHasAttribute(bossIndex, SF2Attribute_IgnitePlayerOnDeath))
			{
				TF2_IgnitePlayer(client, client);
			}

			CBaseEntity boss = CBaseEntity(NPCGetEntIndex(bossIndex));
			float damage = float(GetEntProp(client, Prop_Send, "m_iHealth")) * 4.0;
			SDKHooks_TakeDamage(client, boss.IsValid() ? boss.index : 0, boss.IsValid() ? boss.index : 0, damage, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, { 0.0, 0.0, 0.0 });
			ForcePlayerSuicide(client); // Sometimes SDKHooks_TakeDamage doesn't work (probably because of point_viewcontrol), the player is still alive and result in a endless round.
			KillClient(client);
			return;
		}
	}
	else
	{
		if (!deathCamData.IsEnabled)
		{
			SlenderMarkAsFake(bossIndex);
			return;
		}
	}

	g_PlayerDeathCamBoss[client] = NPCGetUniqueID(bossIndex);
	g_PlayerDeathCamShowOverlay[client] = false;

	float eyePos[3], eyeAng[3], angle[3];
	GetClientEyePosition(client, eyePos);
	GetClientEyeAngles(client, eyeAng);
	SubtractVectors(eyePos, lookPos, angle);
	GetVectorAngles(angle, angle);
	angle[0] = 0.0;
	angle[2] = 0.0;

	// Create fake model.
	int slender = -1;
	bool publicDeathcam = deathCamData.IsPublicDeathCamEnabled;
	if (!publicDeathcam)
	{
		slender = SpawnSlenderModel(bossIndex, lookPos, true);
		TeleportEntity(slender, lookPos, angle, NULL_VECTOR);
		SDKHook(slender, SDKHook_SetTransmit, Hook_DeathCamSetTransmit);
	}
	else
	{
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
		slender = NPCGetEntIndex(bossIndex);
		if (SF2_ChaserEntity(slender).IsValid() || SF2_StatueEntity(slender).IsValid())
		{
			SF2_BaseBoss(slender).IsKillingSomeone = true;
			SF2_BaseBoss(slender).KillTarget = CBaseEntity(client);
			SF2_BaseBoss(slender).FullDeathCamDuration = deathCamData.LegacyDuration <= 0.0;
		}
	}
	g_PlayerDeathCamEnt2[client] = EntIndexToEntRef(slender);

	char name[64];
	FormatEx(name, sizeof(name), "sf2_boss_%d", EntIndexToEntRef(slender));

	float offsetPos[3];
	int target = CreateEntityByName("info_target");
	if (!publicDeathcam)
	{
		deathCamData.GetLookPosition(offsetPos);
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
		deathCamData.GetAttachment(boneName, sizeof(boneName));
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
	int light = ClientGetFlashlightEntity(client);
	if (light && light != INVALID_ENT_REFERENCE)
	{
		SetVariantString("!activator");
		AcceptEntityInput(light, "ClearParent");
		TeleportEntity(light, eyePos, eyeAng, NULL_VECTOR);
		SetVariantString("!activator");
		AcceptEntityInput(light, "SetParent", camera);
	}
	if (publicDeathcam)
	{
		float camSpeed, camAcceleration, camDeceleration;

		camSpeed = deathCamData.Speed;
		camAcceleration = deathCamData.Acceleration;
		camDeceleration = deathCamData.Deceleration;
		FloatToString(camSpeed, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "acceleration", buffer);
		FloatToString(camAcceleration, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "deceleration", buffer);
		FloatToString(camDeceleration, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "speed", buffer);

		SetVariantString("!activator");
		AcceptEntityInput(camera, "SetParent", slender);
		char attachmentName[PLATFORM_MAX_PATH];
		deathCamData.GetAttachment(attachmentName, sizeof(attachmentName));
		if (attachmentName[0] != '\0')
		{
			SetVariantString(attachmentName);
			AcceptEntityInput(camera, "SetParentAttachment");
		}

		deathCamData.GetTargetAttachment(attachmentName, sizeof(attachmentName));
		DispatchKeyValue(camera, "targetname", attachmentName);

		g_CameraInDeathCamAdvanced[camera] = true;
		g_CameraPlayerOffsetBackward[camera] = deathCamData.BackwardOffset;
		g_CameraPlayerOffsetDownward[camera] = deathCamData.DownwardOffset;
		RequestFrame(Frame_PublicDeathCam, camera); //Resend taunt sound to eliminated players only
	}

	float duration = deathCamData.LegacyDuration;
	g_PlayerDeathCamMustDoOverlay[client] = deathCamData.Overlays != null;
	if (duration <= 0.0)
	{
		char animation[64];
		float rate = 1.0, cycle = 0.0;
		DeathCamAnimation section = view_as<DeathCamAnimation>(deathCamData.GetAnimations().GetAnimation("start"));
		if (section != null)
		{
			CBaseAnimating animator = CBaseAnimating(slender);
			section.GetAnimationName(difficulty, animation, sizeof(animation));
			rate = section.GetAnimationPlaybackRate(difficulty);
			cycle = section.GetAnimationCycle(difficulty);
			duration = section.GetDuration(difficulty);
			int sequence = animator.LookupSequence(animation);
			if (duration <= 0.0 && sequence != -1)
			{
				duration = animator.SequenceDuration(sequence) / rate;
				duration *= (1.0 - cycle);
			}
			if (section.GetPlayerDuration(difficulty) > 0.0)
			{
				duration = section.GetPlayerDuration(difficulty);
			}
		}
	}

	g_PlayerDeathCamTimer[client] = duration;
	g_PlayerDeathCamMustDoOverlay[client] = deathCamData.Overlays != null;
	if (g_PlayerDeathCamMustDoOverlay[client])
	{
		deathCamData.Overlays.GetString(GetRandomInt(0, deathCamData.Overlays.Length - 1), g_PlayerDeathCamCurrentOverlay[client], sizeof(g_PlayerDeathCamCurrentOverlay[]));
	}
	g_PlayerDeathCam[client] = true;

	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, { 0.0, 0.0, 0.0 });

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
		float camPos[3], camAngs[3], newPos[3];
		newPos[0] -= g_CameraPlayerOffsetBackward[camera];
		newPos[2] -= g_CameraPlayerOffsetDownward[camera];
		GetEntPropVector(camera, Prop_Data, "m_angAbsRotation", camAngs);
		GetEntPropVector(camera, Prop_Data, "m_vecAbsOrigin", camPos);
		VectorTransform(newPos, camPos, camAngs, newPos);

		TeleportEntity(client, newPos, camAngs, NULL_VECTOR);

		RequestFrame(Frame_PublicDeathCam, EntIndexToEntRef(cameraRef));
	}
}

static void StopDeathCam(int client)
{
	if (!IsValidClient(client))
	{
		return;
	}

	SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol entity changes our damage state.

	SF2NPC_BaseNPC deathCamBoss = SF2NPC_BaseNPC(NPCGetFromUniqueID(g_PlayerDeathCamBoss[client]));
	if (deathCamBoss != SF2_INVALID_NPC)
	{
		BossProfileDeathCamData deathCamData = deathCamBoss.GetProfileData().GetDeathCamData();
		if ((deathCamBoss.Flags & SFF_FAKE) == 0)
		{
			if (deathCamBoss.HasAttribute(SF2Attribute_IgnitePlayerOnDeath))
			{
				TF2_IgnitePlayer(client, client);
			}

			if (deathCamData.IsEnabled && deathCamData.Blackout && !g_Hooked)
			{
				AddNormalSoundHook(NoPlayerVoiceHook);
				g_Hooked = true;
			}

			Call_StartForward(g_OnClientPreKillDeathCamFwd);
			Call_PushCell(client);
			Call_PushCell(deathCamBoss.Index);
			Call_Finish();

			CBaseEntity boss = CBaseEntity(deathCamBoss.EntIndex);
			float damage = float(GetEntProp(client, Prop_Send, "m_iHealth")) * 4.0;
			SDKHooks_TakeDamage(client, boss.IsValid() ? boss.index : 0, boss.IsValid() ? boss.index : 0, damage, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, { 0.0, 0.0, 0.0 });
			ForcePlayerSuicide(client); // Sometimes SDKHooks_TakeDamage doesn't work (probably because of point_viewcontrol), the player is still alive and result in a endless round.
			KillClient(client);
		}
		else
		{
			deathCamBoss.MarkAsFake();
			SetEntityMoveType(client, MOVETYPE_WALK);
			TeleportEntity(client, g_PlayerOriginalDeathcamPosition[client], NULL_VECTOR, { 0.0, 0.0, 0.0 });
			int light = ClientGetFlashlightEntity(client);
			if (light && light != INVALID_ENT_REFERENCE)
			{
				float eyePos[3], eyeAng[3];
				GetClientEyePosition(client, eyePos);
				GetClientEyeAngles(client, eyeAng);
				SetVariantString("!activator");
				AcceptEntityInput(light, "ClearParent");
				TeleportEntity(light, eyePos, eyeAng, NULL_VECTOR);
				SetVariantString("!activator");
				AcceptEntityInput(light, "SetParent", client);
			}
		}
	}
	else // The boss is invalid? But the player got a death cam?
	{
		// Then kill him anyways.
		KillClient(client);
		ForcePlayerSuicide(client);
	}
	ClientResetDeathCam(client);
}

static void Hook_DeathCamThink(int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsValid || !player.IsInDeathCam || player.IsInGhostMode)
	{
		return;
	}

	CBaseEntity ent = CBaseEntity(EntRefToEntIndex(g_PlayerDeathCamEnt[client]));
	if (ent.IsValid() && g_CameraInDeathCamAdvanced[ent.index])
	{
		float camPos[3], camAngs[3], newPos[3];
		ent.GetAbsAngles(camAngs);
		ent.GetAbsOrigin(camPos);

		newPos[0] -= g_CameraPlayerOffsetBackward[ent.index];
		newPos[2] -= g_CameraPlayerOffsetDownward[ent.index];
		VectorTransform(newPos, camPos, camAngs, newPos);

		player.SetLocalOrigin(newPos);
		player.SetLocalAngles(camAngs);
	}

	g_PlayerDeathCamTimer[player.index] -= GetGameFrameTime();
	g_PlayerDeathCamOverlayTimer[player.index] -= GetGameFrameTime();
	if (g_PlayerDeathCamMustDoOverlay[player.index] && g_PlayerDeathCamOverlayTimer[player.index] <= 0.0)
	{
		g_PlayerDeathCamShowOverlay[player.index] = true;
		g_PlayerDeathCamMustDoOverlay[player.index] = false;
	}
	if (g_PlayerDeathCamTimer[player.index] <= 0.0)
	{
		StopDeathCam(player.index);
	}
}