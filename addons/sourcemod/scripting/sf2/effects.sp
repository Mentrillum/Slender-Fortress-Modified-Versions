#if defined _sf2_effects_included
 #endinput
#endif
#define _sf2_effects_included

#pragma semicolon 1
#pragma newdecls required

static EffectEvent g_EntityEffectEvent[2049];
static EffectType g_EntityEffectType[2049];
static ArrayList g_NpcEffectsArray[MAX_BOSSES];

methodmap ProfileEffectMaster < ProfileObject
{
	public void Precache()
	{
		for (int i = 0; i < this.SectionLength; i++)
		{
			char key[128];
			this.GetSectionNameFromIndex(i, key, sizeof(key));
			ProfileEffect effect = view_as<ProfileEffect>(this.GetSection(key));
			if (effect != null)
			{
				effect.Precache();
			}
		}
	}
}

methodmap ProfileEffect < ProfileObject
{
	property EffectType Type
	{
		public get()
		{
			char effectTypeString[64];
			this.GetString("type", effectTypeString, sizeof(effectTypeString));
			if (strcmp(effectTypeString, "steam", false) == 0)
			{
				return EffectType_Steam;
			}
			else if (strcmp(effectTypeString, "dynamiclight", false) == 0)
			{
				return EffectType_DynamicLight;
			}
			else if (strcmp(effectTypeString, "particle", false) == 0)
			{
				return EffectType_Particle;
			}
			else if (strcmp(effectTypeString, "trail", false) == 0)
			{
				return EffectType_Trail;
			}
			else if (strcmp(effectTypeString, "propdynamic", false) == 0)
			{
				return EffectType_PropDynamic;
			}
			else if (strcmp(effectTypeString, "pointspotlight", false) == 0)
			{
				return EffectType_PointSpotlight;
			}
			else if (strcmp(effectTypeString, "sprite", false) == 0)
			{
				return EffectType_Sprite;
			}
			else if (strcmp(effectTypeString, "te_beamring", false) == 0)
			{
				return EffectType_TempEntBeamRing;
			}
			else if (strcmp(effectTypeString, "te_particle", false) == 0)
			{
				return EffectType_TempEntParticle;
			}
			else if (strcmp(effectTypeString, "sound", false) == 0)
			{
				return EffectType_Sound;
			}
		}
	}

	property EffectEvent Event
	{
		public get()
		{
			char effectTypeString[64];
			this.GetString("event", effectTypeString, sizeof(effectTypeString), "constant");
			if (strcmp(effectTypeString, "constant", false) == 0)
			{
				return EffectEvent_Constant;
			}
			if (strcmp(effectTypeString, "boss_hitplayer", false) == 0)
			{
				return EffectEvent_HitPlayer;
			}
			if (strcmp(effectTypeString, "boss_seenbyplayer", false) == 0)
			{
				return EffectEvent_PlayerSeesBoss;
			}
		}
	}

	property int DifficultyIndexes
	{
		public get()
		{
			return this.GetInt("difficulty_indexes", 123456);
		}
	}

	property RenderMode RenderMode
	{
		public get()
		{
			RenderMode val = view_as<RenderMode>(this.GetInt("rendermode", view_as<int>(RENDER_TRANSCOLOR)));
			if (this.Type == EffectType_PointSpotlight)
			{
				val = RENDER_TRANSCOLOR;
			}
			return val;
		}
	}

	property RenderFx RenderEffect
	{
		public get()
		{
			return view_as<RenderFx>(this.GetInt("renderfx", view_as<int>(RENDERFX_NONE)));
		}
	}

	property int SpawnFlags
	{
		public get()
		{
			return this.GetInt("spawnflags", 0);
		}
	}

	property int FadeAlpha
	{
		public get()
		{
			return this.GetInt("renderamt", 255);
		}
	}

	property float LifeTime
	{
		public get()
		{
			return this.GetFloat("lifetime", -1.0);
		}
	}

	property float Delay
	{
		public get()
		{
			return this.GetFloat("delay", 0.0);
		}
	}

	property bool AttachPlayer
	{
		public get()
		{
			return this.GetBool("attach_player", false);
		}
	}

	public void GetOrigin(float buffer[3])
	{
		this.GetVector("origin", buffer);
	}

	public void GetAngles(float buffer[3])
	{
		this.GetVector("angles", buffer);
	}

	public void GetAttachment(char[] buffer, int bufferSize)
	{
		this.GetString("attachment_point", buffer, bufferSize);
	}

	public void GetRenderColor(int difficulty, int buffer[4])
	{
		this.GetDifficultyColor("rendercolor", difficulty, buffer);
	}

	public void Precache()
	{
		switch (this.Type)
		{
			case EffectType_PropDynamic:
			{
				view_as<ProfileEffect_PropDynamic>(this).Precache();
			}

			case EffectType_TempEntBeamRing:
			{
				view_as<ProfileEffect_TEBeamRing>(this).Precache();
			}

			case EffectType_Sound:
			{
				view_as<ProfileEffect_Sound>(this).Precache();
			}
		}
	}
}

methodmap ProfileEffect_Steam < ProfileEffect
{
	property int SpreadSpeed
	{
		public get()
		{
			return this.GetInt("spreadspeed", 0);
		}
	}

	property int Speed
	{
		public get()
		{
			return this.GetInt("speed", 0);
		}
	}

	property int StartSize
	{
		public get()
		{
			return this.GetInt("startsize", 0);
		}
	}

	property int EndSize
	{
		public get()
		{
			return this.GetInt("endsize", 0);
		}
	}

	property int Rate
	{
		public get()
		{
			return this.GetInt("rate", 0);
		}
	}

	property int JetLength
	{
		public get()
		{
			return this.GetInt("jetlength", 0);
		}
	}

	property float RollSpeed
	{
		public get()
		{
			return this.GetFloat("rollspeed", 0.0);
		}
	}

	property int ParticleType
	{
		public get()
		{
			return this.GetInt("particletype", 0);
		}
	}
}

methodmap ProfileEffect_DynamicLight < ProfileEffect
{
	property int Brightness
	{
		public get()
		{
			return this.GetInt("brightness", 0);
		}
	}

	property float Distance
	{
		public get()
		{
			return this.GetFloat("distance", 0.0);
		}
	}

	property int Cone
	{
		public get()
		{
			return this.GetInt("cone", 0);
		}
	}

	property int LightStyle
	{
		public get()
		{
			return this.GetInt("lightstyle", 0);
		}
	}
}

methodmap ProfileEffect_Particle < ProfileEffect
{
	public void GetName(char[] buffer, int bufferSize)
	{
		this.GetString("particlename", buffer, bufferSize);
	}

	property bool HasControlPoint
	{
		public get()
		{
			return this.GetBool("control_point", false);
		}
	}

	public void GetControlPointOffset(float buffer[3])
	{
		this.GetVector("control_point_offset", buffer);
	}
}

methodmap ProfileEffect_Trail < ProfileEffect
{
	property float Time
	{
		public get()
		{
			return this.GetFloat("trailtime", 1.0);
		}
	}

	property float StartWidth
	{
		public get()
		{
			return this.GetFloat("startwidth", 6.0);
		}
	}

	property float EndWidth
	{
		public get()
		{
			return this.GetFloat("endwidth", 15.0);
		}
	}

	public void GetName(char[] buffer, int bufferSize)
	{
		this.GetString("spritename", buffer, bufferSize);
	}
}

methodmap ProfileEffect_PropDynamic < ProfileEffect
{
	property float Scale
	{
		public get()
		{
			return this.GetFloat("modelscale", 1.0);
		}
	}

	property int Skin
	{
		public get()
		{
			return this.GetInt("modelskin", 0);
		}
	}

	public void GetName(char[] buffer, int bufferSize)
	{
		this.GetString("modelname", buffer, bufferSize);
	}

	public void GetAnimation(char[] buffer, int bufferSize)
	{
		this.GetString("modelanimation", buffer, bufferSize);
	}

	public void Precache()
	{
		char path[PLATFORM_MAX_PATH];
		this.GetName(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheModel2(path, _, _, g_FileCheckConVar.BoolValue);
		}
	}
}

methodmap ProfileEffect_PointSpotlight < ProfileEffect
{
	property float Width
	{
		public get()
		{
			return this.GetFloat("spotlightwidth", 40.0);
		}
	}

	property float Length
	{
		public get()
		{
			return this.GetFloat("spotlightlength", 512.0);
		}
	}

	property float HaloScale
	{
		public get()
		{
			return this.GetFloat("halo_scale", 40.0);
		}
	}

	property int Brightness
	{
		public get()
		{
			return this.GetInt("brightness", 0);
		}
	}

	property float Distance
	{
		public get()
		{
			return this.GetFloat("distance", 0.0);
		}
	}

	property int Cone
	{
		public get()
		{
			return this.GetInt("cone", 0);
		}
	}
}

methodmap ProfileEffect_Sprite < ProfileEffect
{
	property float Scale
	{
		public get()
		{
			return this.GetFloat("spritescale", 1.0);
		}
	}

	public void GetName(char[] buffer, int bufferSize)
	{
		this.GetString("spritename", buffer, bufferSize);
	}
}

methodmap ProfileEffect_TEBeamRing < ProfileEffect
{
	property float StartRadius
	{
		public get()
		{
			return this.GetFloat("start_radius", 5.0);
		}
	}

	property float EndRadius
	{
		public get()
		{
			return this.GetFloat("end_radius", 10.0);
		}
	}

	property int StartFrame
	{
		public get()
		{
			return this.GetInt("start_frame", 0);
		}
	}

	property int FrameRate
	{
		public get()
		{
			return this.GetInt("framerate", 12);
		}
	}

	property float Width
	{
		public get()
		{
			return this.GetFloat("width", 100.0);
		}
	}

	property float Amplitude
	{
		public get()
		{
			return this.GetFloat("amplitude", 1.0);
		}
	}

	property int Speed
	{
		public get()
		{
			return this.GetInt("speed", 5);
		}
	}

	property int Flags
	{
		public get()
		{
			return this.GetInt("flags", 0);
		}
	}

	public void GetRingColor(int buffer[4])
	{
		this.GetColor("color", buffer);
	}

	public void GetBeamSprite(char[] buffer, int bufferSize)
	{
		this.GetString("beam_sprite", buffer, bufferSize, "sprites/laser.vmt");
	}

	public void GetHaloSprite(char[] buffer, int bufferSize)
	{
		this.GetString("halo_sprite", buffer, bufferSize, "sprites/halo01.vmt");
	}

	property int BeamModel
	{
		public get()
		{
			return this.GetInt("__beam_model", -1);
		}

		public set(int value)
		{
			this.SetInt("__beam_model", value);
		}
	}

	property int HaloModel
	{
		public get()
		{
			return this.GetInt("__halo_model", -1);
		}

		public set(int value)
		{
			this.SetInt("__halo_model", value);
		}
	}

	public void Precache()
	{
		char sprite[PLATFORM_MAX_PATH], buffer[PLATFORM_MAX_PATH];
		this.GetBeamSprite(sprite, sizeof(sprite));
		if (sprite[0] != '\0')
		{
			this.BeamModel = PrecacheModel(sprite, true);
			FormatEx(buffer, sizeof(buffer), "materials/%s", sprite);
			AddFileToDownloadsTable(buffer);
		}

		this.GetHaloSprite(sprite, sizeof(sprite));
		if (sprite[0] != '\0')
		{
			this.HaloModel = PrecacheModel(sprite, true);
			FormatEx(buffer, sizeof(buffer), "materials/%s", sprite);
			AddFileToDownloadsTable(buffer);
		}
	}
}

methodmap ProfileEffect_TEParticle < ProfileEffect
{
	property int AttachType
	{
		public get()
		{
			int val = 0;
			char attachType[64];
			this.GetString("attach_type", attachType, sizeof(attachType));
			if (strcmp(attachType, "follow_origin", false) == 0)
			{
				val = 1;
			}
			else if (strcmp(attachType, "start_at_customorigin", false) == 0)
			{
				val = 2;
			}
			else if (strcmp(attachType, "start_at_attachment", false) == 0)
			{
				val = 3;
			}
			else if (strcmp(attachType, "follow_attachment", false) == 0)
			{
				val = 4;
			}
			else if (strcmp(attachType, "start_at_worldorigin", false) == 0)
			{
				val = 5;
			}
			else if (strcmp(attachType, "follow_rootbone", false) == 0)
			{
				val = 6;
			}
			return val;
		}
	}

	property bool ResetParticles
	{
		public get()
		{
			return this.GetBool("reset_particles", true);
		}
	}

	property bool HasControlPoint
	{
		public get()
		{
			return this.GetBool("control_point", false);
		}
	}

	property int ControlPointAttachType
	{
		public get()
		{
			return this.GetInt("control_point_attach_type", 0);
		}
	}

	public void GetName(char[] buffer, int bufferSize)
	{
		this.GetString("particlename", buffer, bufferSize);
	}

	public void GetStartPos(float buffer[3])
	{
		this.GetVector("start", buffer);
	}

	public void GetControlPointOffset(float buffer[3])
	{
		this.GetVector("control_point_offset", buffer);
	}
}

methodmap ProfileEffect_Sound < ProfileEffect
{
	property ProfileSound Sounds
	{
		public get()
		{
			return view_as<ProfileSound>(this);
		}
	}

	public void Precache()
	{
		if (this.Sounds != null)
		{
			this.Sounds.Precache();
		}
	}
}

void InitializeEffects()
{
	g_OnEntityDestroyedPFwd.AddFunction(null, EntityDestroyed);
}

static void EntityDestroyed(CBaseEntity ent, const char[] classname)
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_NpcEffectsArray[i] == null)
		{
			continue;
		}

		int index = g_NpcEffectsArray[i].FindValue(ent.index);
		if (index != -1)
		{
			g_NpcEffectsArray[i].Erase(index);
		}
	}
}

void SlenderSpawnEffects(ArrayList effects, int bossIndex, bool nonEffects = true, const float overridePos[3] = { 0.0, 0.0, 0.0 }, const float overrideAng[3] = { 0.0, 0.0, 0.0 }, ArrayList &output = null, int entityOverride = INVALID_ENT_REFERENCE, bool noParenting = false)
{
	if (bossIndex < 0 || bossIndex >= MAX_BOSSES)
	{
		return;
	}

	int bossID = NPCGetUniqueID(bossIndex);
	if (bossID == -1)
	{
		return;
	}

	int slenderEnt = NPCGetEntIndex(bossIndex);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (g_NpcEffectsArray[bossIndex] == null)
	{
		g_NpcEffectsArray[bossIndex] = new ArrayList();
	}

	if (nonEffects)
	{
		if (NPCGetDiscoModeState(bossIndex))
		{
			int light = CreateEntityByName("light_dynamic");
			int particle = CreateEntityByName("info_particle_system");
			if (light != -1)
			{
				float effectPos[3], effectAng[3], basePosX[3], baseAngX[3];
				GetEntPropVector(slenderEnt, Prop_Data, "m_vecAbsOrigin", basePosX);
				GetEntPropVector(slenderEnt, Prop_Data, "m_angAbsRotation", baseAngX);
				effectPos[2] = 50.0;
				VectorTransform(effectPos, basePosX, baseAngX, effectPos);
				AddVectors(effectAng, baseAngX, effectAng);
				TeleportEntity(light, effectPos, effectAng, NULL_VECTOR);
				SetVariantInt(5);
				AcceptEntityInput(light, "Brightness");
				SetVariantFloat(GetRandomFloat(NPCGetDiscoModeRadiusMin(bossIndex), NPCGetDiscoModeRadiusMax(bossIndex)));
				AcceptEntityInput(light, "Distance");
				SetVariantFloat(GetRandomFloat(NPCGetDiscoModeRadiusMin(bossIndex), NPCGetDiscoModeRadiusMax(bossIndex)));
				AcceptEntityInput(light, "spotlight_radius");
				SetVariantInt(1);
				AcceptEntityInput(light, "cone");
				DispatchKeyValue(light, "spawnflags", "0");
				int rChase = GetRandomInt(75, 250);
				int gChase = GetRandomInt(75, 250);
				int bChase = GetRandomInt(75, 250);
				SetEntityRenderColor(light, rChase, gChase, bChase, 255);
				DispatchSpawn(light);
				ActivateEntity(light);
				AcceptEntityInput(light, "TurnOn");
				SetVariantString("!activator");
				AcceptEntityInput(light, "SetParent", slenderEnt);
				CreateTimer(0.1, Timer_DiscoLight, EntIndexToEntRef(light), TIMER_REPEAT);
				SDKHook(light, SDKHook_SetTransmit, Hook_EffectTransmitX);
				g_EntityEffectType[light] = EffectType_DynamicLight;
				g_NpcEffectsArray[bossIndex].Push(light);
			}

			if (particle != -1)
			{
				float effectPos[3], effectAng[3], basePosX[3], baseAngX[3];
				GetEntPropVector(slenderEnt, Prop_Data, "m_vecAbsOrigin", basePosX);
				GetEntPropVector(slenderEnt, Prop_Data, "m_angAbsRotation", baseAngX);
				CopyVector(NPCGetDiscoModePos(bossIndex), effectPos);
				VectorTransform(effectPos, basePosX, baseAngX, effectPos);
				AddVectors(effectAng, baseAngX, effectAng);
				TeleportEntity(particle, effectPos, effectAng, NULL_VECTOR);

				DispatchKeyValue(particle, "effect_name", "utaunt_disco_party");
				DispatchSpawn(particle);
				ActivateEntity(particle);
				AcceptEntityInput(particle, "start");
				SetVariantString("!activator");
				AcceptEntityInput(particle, "SetParent", slenderEnt);
				SDKHook(particle, SDKHook_SetTransmit, Hook_EffectTransmitX);
				g_EntityEffectType[particle] = EffectType_Particle;
				g_NpcEffectsArray[bossIndex].Push(particle);
			}
		}
		if (NPCGetFestiveLightState(bossIndex))
		{
			int light = CreateEntityByName("light_dynamic");
			if (light != -1)
			{
				float effectPos[3], effectAng[3], basePosX[3], baseAngX[3];
				GetEntPropVector(slenderEnt, Prop_Data, "m_vecAbsOrigin", basePosX);
				GetEntPropVector(slenderEnt, Prop_Data, "m_angAbsRotation", baseAngX);
				CopyVector(NPCGetFestiveLightPosition(bossIndex), effectPos);
				CopyVector(NPCGetFestiveLightAngle(bossIndex), effectAng);
				VectorTransform(effectPos, basePosX, baseAngX, effectPos);
				AddVectors(effectAng, baseAngX, effectAng);
				TeleportEntity(light, effectPos, effectAng, NULL_VECTOR);
				SetVariantInt(NPCGetFestiveLightBrightness(bossIndex));
				AcceptEntityInput(light, "Brightness");
				SetVariantFloat(NPCGetFestiveLightDistance(bossIndex));
				AcceptEntityInput(light, "Distance");
				SetVariantFloat(NPCGetFestiveLightRadius(bossIndex));
				AcceptEntityInput(light, "spotlight_radius");
				SetVariantInt(1);
				AcceptEntityInput(light, "cone");
				DispatchKeyValue(light, "spawnflags", "0");
				int funnyFestive = GetRandomInt(1, 3);
				switch (funnyFestive)
				{
					case 1:
					{
						SetEntityRenderColor(light, 230, 37, 37, 255);
					}
					case 2:
					{
						SetEntityRenderColor(light, 79, 227, 79, 255);
					}
					case 3:
					{
						SetEntityRenderColor(light, 255, 255, 255, 255);
					}
				}
				DispatchSpawn(light);
				ActivateEntity(light);
				CreateTimer(0.5, Timer_FestiveLight, EntIndexToEntRef(light), TIMER_REPEAT);
				AcceptEntityInput(light, "TurnOn");
				SetVariantString("!activator");
				AcceptEntityInput(light, "SetParent", slenderEnt);
				SDKHook(light, SDKHook_SetTransmit, Hook_EffectTransmitX);
				g_EntityEffectType[light] = EffectType_Particle;
				g_NpcEffectsArray[bossIndex].Push(light);
			}
		}
	}

	if (effects == null)
	{
		return;
	}

	SF2BossProfileBaseEffectInfo effectsInfo;
	for (int i = 0, size = effects.Length; i < size; i++)
	{
		effects.GetArray(i, effectsInfo, sizeof(effectsInfo));

		// Validate effect event and type. Check to see if it matches with ours.
		if (effectsInfo.Event != EffectEvent_Invalid)
		{
			if (effectsInfo.Type != EffectType_Invalid)
			{
				// Check base position behavior.
				if (!slenderEnt || slenderEnt == INVALID_ENT_REFERENCE)
				{
					LogError("Could not spawn effect %s for boss %d: unable to read position and angles due to boss entity not in game!");
					continue;
				}

				if (effectsInfo.Delay > 0.0)
				{
					DataPack pack;
					CreateDataTimer(effectsInfo.Delay, Timer_SpawnEffect, pack, TIMER_FLAG_NO_MAPCHANGE);
					pack.WriteCellArray(effectsInfo, sizeof(effectsInfo));
					pack.WriteCell(bossIndex);
					pack.WriteCellArray(overridePos, sizeof(overridePos));
					pack.WriteCellArray(overrideAng, sizeof(overrideAng));
					pack.WriteCell(output);
					pack.WriteCell(entityOverride);
					pack.WriteCell(noParenting);
				}
				else
				{
					SpawnEffect(effectsInfo, bossIndex, overridePos, overrideAng, output, entityOverride, noParenting);
				}
			}
			else
			{
				LogError("Could not spawn effect %s for boss %d: invalid type!", effectsInfo.SectionName, bossIndex);
			}
		}
	}
}

static Action Timer_SpawnEffect(Handle timer, DataPack pack)
{
	pack.Reset();
	SF2BossProfileBaseEffectInfo effect;
	pack.ReadCellArray(effect, sizeof(effect));
	int bossIndex = pack.ReadCell();
	float overridePos[3], overrideAng[3];
	pack.ReadCellArray(overridePos, sizeof(overridePos));
	pack.ReadCellArray(overrideAng, sizeof(overrideAng));
	ArrayList output = pack.ReadCell();
	int entityOverride = pack.ReadCell();
	bool noParenting = pack.ReadCell();
	SpawnEffect(effect, bossIndex, overridePos, overrideAng, output, entityOverride, noParenting);
	return Plugin_Stop;
}

static void SpawnEffect(SF2BossProfileBaseEffectInfo effectsInfo, int bossIndex, const float overridePos[3] = { 0.0, 0.0, 0.0 }, const float overrideAng[3] = { 0.0, 0.0, 0.0 }, ArrayList &output = null, int entityOverride = INVALID_ENT_REFERENCE, bool noParenting = false)
{
	int slenderEnt = NPCGetEntIndex(bossIndex);
	int attacher = slenderEnt;
	if (entityOverride != INVALID_ENT_REFERENCE && effectsInfo.AttachPlayer)
	{
		attacher = entityOverride;
	}
	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	float basePos[3], baseAng[3];
	if (!IsEmptyVector(overridePos))
	{
		basePos = overridePos;
	}
	else
	{
		GetEntPropVector(attacher, Prop_Data, "m_vecAbsOrigin", basePos);
	}
	if (!IsEmptyVector(overrideAng))
	{
		baseAng = overrideAng;
	}
	else
	{
		GetEntPropVector(attacher, Prop_Data, "m_angAbsRotation", baseAng);
	}

	int difficultyIndex = effectsInfo.DifficultyIndexes;
	char indexes[8], currentIndex[2];
	FormatEx(indexes, sizeof(indexes), "%d", difficultyIndex);
	FormatEx(currentIndex, sizeof(currentIndex), "%d", g_DifficultyConVar.IntValue);
	char number = currentIndex[0];
	int difficultyNumber = 0;
	if (FindCharInString(indexes, number) != -1)
	{
		difficultyNumber += g_DifficultyConVar.IntValue;
	}
	if (indexes[0] != '\0' && currentIndex[0] != '\0' && difficultyNumber != -1)
	{
		int currentIntegerIndex = StringToInt(currentIndex);
		if (difficultyNumber != currentIntegerIndex)
		{
			return;
		}
	}

	int entity = -1;
	bool isEntity = true;

	switch (effectsInfo.Type)
	{
		case EffectType_Steam:
		{
			entity = CreateEntityByName("env_steam");
		}
		case EffectType_DynamicLight:
		{
			entity = CreateEntityByName("light_dynamic");
		}
		case EffectType_Particle:
		{
			entity = CreateEntityByName("info_particle_system");
		}
		case EffectType_Trail:
		{
			entity = CreateEntityByName("env_spritetrail");
		}
		case EffectType_PropDynamic:
		{
			entity = CreateEntityByName("prop_dynamic");
		}
		case EffectType_PointSpotlight:
		{
			entity = CreateEntityByName("sf2_point_spotlight");
		}
		case EffectType_Sprite:
		{
			entity = CreateEntityByName("env_sprite");
		}
		case EffectType_TempEntBeamRing, EffectType_TempEntParticle, EffectType_Sound:
		{
			isEntity = false;
		}
	}

	float effectPos[3], effectAng[3];

	effectPos = effectsInfo.Origin;
	effectAng = effectsInfo.Angles;

	VectorTransform(effectPos, basePos, baseAng, effectPos);
	AddVectors(effectAng, baseAng, effectAng);

	if (entity != -1 && isEntity)
	{
		TeleportEntity(entity, effectPos, effectAng, NULL_VECTOR);
		char value[PLATFORM_MAX_PATH];
		DispatchKeyValueInt(entity, "renderamt", effectsInfo.FadeAlpha);
		DispatchKeyValueInt(entity, "rendermode", view_as<int>(effectsInfo.RenderModes));
		DispatchKeyValueInt(entity, "renderfx", view_as<int>(effectsInfo.RenderEffects));
		DispatchKeyValueInt(entity, "spawnflags", effectsInfo.SpawnFlags);

		switch (effectsInfo.Type)
		{
			case EffectType_Steam:
			{
				DispatchKeyValueInt(entity, "SpreadSpeed", effectsInfo.SteamSpreadSpeed);
				DispatchKeyValueInt(entity, "Speed", effectsInfo.SteamSpeed);
				DispatchKeyValueInt(entity, "StartSize", effectsInfo.SteamStartSize);
				DispatchKeyValueInt(entity, "EndSize", effectsInfo.SteamEndSize);
				DispatchKeyValueInt(entity, "Rate", effectsInfo.SteamRate);
				DispatchKeyValueInt(entity, "Jetlength", effectsInfo.SteamJetLength);
				DispatchKeyValueFloat(entity, "RollSpeed", effectsInfo.SteamRollSpeed);
				DispatchKeyValueInt(entity, "type", effectsInfo.SteamType);
				DispatchSpawn(entity);
				ActivateEntity(entity);
			}
			case EffectType_DynamicLight:
			{
				SetVariantInt(effectsInfo.LightBrightness);
				AcceptEntityInput(entity, "Brightness");
				SetVariantFloat(effectsInfo.LightMaxDistance);
				AcceptEntityInput(entity, "Distance");
				SetVariantFloat(effectsInfo.LightMaxDistance);
				AcceptEntityInput(entity, "spotlight_radius");
				SetVariantInt(effectsInfo.LightCone);
				AcceptEntityInput(entity, "cone");
				DispatchSpawn(entity);
				ActivateEntity(entity);

				int renderColor[4];
				effectsInfo.Colors.GetArray(difficulty, renderColor, sizeof(renderColor));

				SetEntityRenderColor(entity, renderColor[0], renderColor[1], renderColor[2], renderColor[3]);
				SetEntProp(entity, Prop_Data, "m_LightStyle", effectsInfo.LightStyle);
			}
			case EffectType_Particle:
			{
				DispatchKeyValue(entity, "effect_name", effectsInfo.ParticleName);
				DispatchSpawn(entity);
				ActivateEntity(entity);
			}
			case EffectType_Trail:
			{
				DispatchKeyValueFloat(entity, "lifetime", effectsInfo.TrailTime);
				DispatchKeyValueFloat(entity, "startwidth", effectsInfo.TrailStartWidth);
				DispatchKeyValueFloat(entity, "endwidth", effectsInfo.TrailEndWidth);
				DispatchKeyValue(entity, "spritename", effectsInfo.TrailName);
				SetEntPropFloat(entity, Prop_Send, "m_flTextureRes", 0.05);

				int renderColor[4];
				effectsInfo.Colors.GetArray(difficulty, renderColor, sizeof(renderColor));

				SetEntityRenderColor(entity, renderColor[0], renderColor[1], renderColor[2], renderColor[3]);
				DispatchSpawn(entity);
				ActivateEntity(entity);
			}
			case EffectType_PropDynamic:
			{
				DispatchKeyValue(entity, "model", effectsInfo.ModelName);
				float modelScale = effectsInfo.ModelScale;
				if (SF_SpecialRound(SPECIALROUND_TINYBOSSES) && modelScale != GetEntPropFloat(attacher, Prop_Send, "m_flModelScale") && !effectsInfo.AttachPlayer)
				{
					modelScale *= 0.5;
				}
				SetEntPropFloat(entity, Prop_Send, "m_flModelScale", modelScale);
				SetEntProp(entity, Prop_Send, "m_nSkin", effectsInfo.ModelSkin);
				SetEntProp(entity, Prop_Send, "m_fEffects", EF_BONEMERGE | EF_PARENT_ANIMATES);
				if (effectsInfo.ModelAnimation[0] != '\0')
				{
					SetVariantString(value);
					AcceptEntityInput(entity, "SetAnimation");
				}

				int renderColor[4];
				effectsInfo.Colors.GetArray(difficulty, renderColor, sizeof(renderColor));

				SetEntityRenderColor(entity, renderColor[0], renderColor[1], renderColor[2], renderColor[3]);
				DispatchSpawn(entity);
				ActivateEntity(entity);
			}
			case EffectType_PointSpotlight:
			{
				int renderColor[4];
				effectsInfo.Colors.GetArray(difficulty, renderColor, sizeof(renderColor));

				SF2PointSpotlightEntity spotlight = SF2PointSpotlightEntity(entity);
				if (effectsInfo.AttachmentName[0] != '\0')
				{
					SetVariantString("!activator");
					spotlight.Start.AcceptInput("ClearParent");
					SetVariantString("!activator");
					spotlight.Start.AcceptInput("SetParent", attacher);
					SetVariantString(effectsInfo.AttachmentName);
					spotlight.Start.AcceptInput("SetParentAttachmentMaintainOffset");
					SetVariantString("!activator");
					spotlight.End.AcceptInput("ClearParent");
					SetVariantString("!activator");
					spotlight.End.AcceptInput("SetParent", attacher);
					SetVariantString(effectsInfo.AttachmentName);
					spotlight.End.AcceptInput("SetParentAttachmentMaintainOffset");
				}
				spotlight.Length = effectsInfo.SpotlightLength;
				spotlight.Width = effectsInfo.SpotlightWidth;
				spotlight.EndWidth = spotlight.Width * 2.0;
				spotlight.Brightness = effectsInfo.LightBrightness;
				spotlight.Distance = effectsInfo.LightMaxDistance;
				spotlight.SpotlightRadius = effectsInfo.LightMaxDistance;
				spotlight.Cone = effectsInfo.LightCone;
				spotlight.HaloScale = effectsInfo.SpotlightHaloScale;

				spotlight.SetColor(renderColor);

				spotlight.Spawn();
				spotlight.Activate();

				spotlight.TurnOn();
			}
			case EffectType_Sprite:
			{
				DispatchKeyValue(entity, "classname", "env_sprite");
				DispatchKeyValue(entity, "model", effectsInfo.SpriteName);
				DispatchKeyValueFloat(entity, "scale", effectsInfo.SpriteScale);

				int renderColor[4];
				effectsInfo.Colors.GetArray(difficulty, renderColor, sizeof(renderColor));

				SetEntityRenderColor(entity, renderColor[0], renderColor[1], renderColor[2], renderColor[3]);

				DispatchSpawn(entity);
				ActivateEntity(entity);
			}
		}

		float lifeTime = effectsInfo.LifeTime;
		if (lifeTime > 0.0)
		{
			CreateTimer(lifeTime, Timer_KillEntity, EntIndexToEntRef(entity), TIMER_FLAG_NO_MAPCHANGE);
		}

		if (!noParenting)
		{
			if (!attacher || attacher == INVALID_ENT_REFERENCE)
			{
				LogError("Could not parent effect %s of boss %d to itself: boss entity does not exist!", effectsInfo.SectionName, bossIndex);
				return;
			}

			SetVariantString("!activator");
			AcceptEntityInput(entity, "SetParent", attacher);
			if (effectsInfo.Attachment)
			{
				if (effectsInfo.AttachmentName[0] != '\0')
				{
					SetVariantString(effectsInfo.AttachmentName);
					if (effectsInfo.Type != EffectType_PropDynamic && effectsInfo.Type != EffectType_PointSpotlight)
					{
						AcceptEntityInput(entity, "SetParentAttachment");
					}
					else
					{
						AcceptEntityInput(entity, "SetParentAttachmentMaintainOffset");
					}
				}
			}
		}

		switch (effectsInfo.Type)
		{
			case EffectType_Steam,
				EffectType_DynamicLight:
			{
				AcceptEntityInput(entity, "TurnOn");
			}
			case EffectType_Particle:
			{
				AcceptEntityInput(entity, "start");
			}
			case EffectType_Trail:
			{
				AcceptEntityInput(entity, "showsprite");
			}
			case EffectType_PointSpotlight:
			{
				AcceptEntityInput(entity, "TurnOn");
			}
			case EffectType_Sprite:
			{
				AcceptEntityInput(entity, "ShowSprite");
			}
		}
		SDKHook(entity, SDKHook_SetTransmit, Hook_EffectTransmit);
		g_EntityEffectType[entity] = effectsInfo.Type;
		g_EntityEffectEvent[entity] = effectsInfo.Event;
		if (!noParenting)
		{
			g_NpcEffectsArray[bossIndex].Push(entity);
		}

		if (output != null)
		{
			output.Push(EntIndexToEntRef(entity));
		}
	}
	else
	{
		switch (effectsInfo.Type)
		{
			case EffectType_TempEntBeamRing:
			{
				char colorString[32];
				strcopy(colorString, sizeof(colorString), effectsInfo.BeamRingColor);
				char keys[4][4];
				ExplodeString(colorString, " ", keys, sizeof(keys), sizeof(keys));
				int color[4];
				for (int i2 = 0; i2 < 4; i2++)
				{
					color[i2] = StringToInt(keys[i2]);
				}

				TE_SetupBeamRingPoint(effectPos, effectsInfo.BeamRingStartRadius, effectsInfo.BeamRingEndRadius, effectsInfo.BeamRingBeamModel, effectsInfo.BeamRingHaloModel, effectsInfo.BeamRingStartFrame, effectsInfo.BeamRingFrameRate, effectsInfo.LifeTime, effectsInfo.BeamRingWidth, effectsInfo.BeamRingAmplitude, color, effectsInfo.BeamRingSpeed, effectsInfo.BeamRingFlags);
				TE_SendToAll();
			}
			case EffectType_TempEntParticle:
			{
				if (effectsInfo.ParticleName[0] == '\0')
				{
					return;
				}

				int particle = PrecacheParticleSystem(effectsInfo.ParticleName);
				if (particle == -1)
				{
					return;
				}

				int attachment = LookupEntityAttachment(attacher, effectsInfo.AttachmentName);

				float start[3], pos[3], ang[3];
				start = effectsInfo.TEParticleStartPos;
				if (effectsInfo.TEParticleAttachType == 2)
				{
					VectorTransform(start, basePos, baseAng, start);
					pos = start;
					ang = effectAng;
				}
				else
				{
					pos = effectPos;
					ang = effectAng;
				}
				TE_Particle(particle, pos, start, ang, attacher, effectsInfo.TEParticleAttachType, attachment, effectsInfo.TEParticleReset, effectsInfo.TEParticleHasControlPoint, effectsInfo.TEParticleControlPointAttachType, effectsInfo.TEParticleControlPointOffset);
				TE_SendToAll();
			}
			case EffectType_Sound:
			{
				effectsInfo.SoundSounds.EmitSound(_, attacher);
			}
		}
	}
}

static Action Hook_EffectTransmit(int ent, int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_ChaserEntity slender = SF2_ChaserEntity(GetEntPropEnt(ent, Prop_Send, "moveparent"));

	if (!slender.IsValid())
	{
		return Plugin_Continue;
	}

	if (slender.IsValid() && slender.HasCloaked)
	{
		return Plugin_Handled;
	}

	SF2NPC_Chaser controller = slender.Controller;

	SF2_BasePlayer player = SF2_BasePlayer(other);
	if (player.IsValid && !player.IsEliminated && !player.IsInGhostMode && !player.HasEscaped)
	{
		if (g_EntityEffectEvent[ent] == EffectEvent_PlayerSeesBoss && !controller.PlayerCanSee(player.index))
		{
			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

static Action Hook_EffectTransmitX(int ent, int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_ChaserEntity slender = SF2_ChaserEntity(GetEntPropEnt(ent, Prop_Send, "moveparent"));

	if (slender.IsValid() && slender.HasCloaked)
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

void SlenderToggleParticleEffects(int slenderEnt, bool reverse = false)
{
	int effect = -1;
	while ((effect = FindEntityByClassname(effect, "info_particle_system")) > MaxClients)
	{
		if (GetEntPropEnt(effect, Prop_Send, "moveparent") == slenderEnt)
		{
			if (!reverse)
			{
				AcceptEntityInput(effect, "stop");
				AcceptEntityInput(effect, "stop");
			}
			else
			{
				AcceptEntityInput(effect, "stop");
				AcceptEntityInput(effect, "start");
			}
		}
	}
}

void SlenderRemoveEffects(int bossIndex, bool kill = false)
{
	if (g_NpcEffectsArray[bossIndex] == null)
	{
		return;
	}

	for (int effect = 0; effect < g_NpcEffectsArray[bossIndex].Length;)
	{
		int ent = g_NpcEffectsArray[bossIndex].Get(effect);
		if (!IsValidEntity(ent))
		{
			continue;
		}
		switch (g_EntityEffectType[ent])
		{
			case EffectType_Steam, EffectType_DynamicLight:
			{
				AcceptEntityInput(ent, "TurnOff");
			}
			case EffectType_Particle:
			{
				AcceptEntityInput(ent, "stop");
			}
			case EffectType_Trail:
			{
				AcceptEntityInput(ent, "hidesprite");
			}
			case EffectType_Sprite:
			{
				AcceptEntityInput(ent, "HideSprite");
			}
		}

		if (kill)
		{
			if (g_EntityEffectType[ent] == EffectType_PointSpotlight)
			{
				AcceptEntityInput(ent, "KillHierarchy");
			}
			else
			{
				RemoveEntity(ent);
			}
		}
	}
	delete g_NpcEffectsArray[bossIndex];
}

static Action Timer_DiscoLight(Handle timer, any effect)
{
	if (effect == -1)
	{
		return Plugin_Stop;
	}

	int ent = EntRefToEntIndex(effect);
	if (!ent || ent == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int slender = GetEntPropEnt(ent, Prop_Send, "moveparent");
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	int rChase = GetRandomInt(75, 250);
	int gChase = GetRandomInt(75, 250);
	int bChase = GetRandomInt(75, 250);
	SetEntityRenderColor(effect, rChase, gChase, bChase, 255);

	float distanceRNG = GetRandomFloat(NPCGetDiscoModeRadiusMin(bossIndex), NPCGetDiscoModeRadiusMax(bossIndex));

	SetVariantFloat(distanceRNG);
	AcceptEntityInput(effect, "Distance");
	SetVariantFloat(distanceRNG);
	AcceptEntityInput(effect, "spotlight_radius");

	return Plugin_Continue;
}

static Action Timer_FestiveLight(Handle timer, any effect)
{
	if (effect == -1)
	{
		return Plugin_Stop;
	}

	int ent = EntRefToEntIndex(effect);
	if (!ent || ent == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int funnyFestive = GetRandomInt(1, 3);
	switch (funnyFestive)
	{
		case 1:
		{
			SetEntityRenderColor(ent, 230, 37, 37, 255);
		}
		case 2:
		{
			SetEntityRenderColor(ent, 79, 227, 79, 255);
		}
		case 3:
		{
			SetEntityRenderColor(ent, 255, 255, 255, 255);
		}
	}

	return Plugin_Continue;
}

void SetupNPCEffectsAPI()
{
	CreateNative("SF2_ProfileEffect.Type.get", Native_GetEffectType);
	CreateNative("SF2_ProfileEffect.Precache", Native_EffectPrecache);

	CreateNative("SF2_ProfileEffectMaster.Precache", Native_MasterEffectPrecache);
	CreateNative("SF2_ProfileEffectMaster.Spawn", Native_MasterEffectSpawn);
}

static any Native_GetEffectType(Handle plugin, int numParams)
{
	ProfileEffect effect = GetNativeCell(1);
	if (effect == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Handle %x", effect);
	}

	return effect.Type;
}

static any Native_EffectPrecache(Handle plugin, int numParams)
{
	ProfileEffect effect = GetNativeCell(1);
	if (effect == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Handle %x", effect);
	}

	effect.Precache();
	return 0;
}

static any Native_MasterEffectPrecache(Handle plugin, int numParams)
{
	ProfileEffectMaster master = GetNativeCell(1);
	if (master == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Handle %x", master);
	}

	master.Precache();
	return 0;
}

static any Native_MasterEffectSpawn(Handle plugin, int numParams)
{
	ProfileEffectMaster master = GetNativeCell(1);
	if (master == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Handle %x", master);
	}

	float pos[3], ang[3];
	GetNativeArray(3, pos, 3);
	GetNativeArray(4, ang, 3);
	ArrayList output = GetNativeCellRef(5);
	ArrayList effectsArray = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
	ProfileEffect effect;
	for (int i = 0, size = master.SectionLength; i < size; i++)
	{
		char key[128];
		master.GetSectionNameFromIndex(i, key, sizeof(key));
		effect = view_as<ProfileEffect>(master.GetSection(key));

		if (effect == null)
		{
			continue;
		}

		// #define THIS_IS_A_FUCKING_MESS
		SF2BossProfileBaseEffectInfo info;
		info.Init();
		strcopy(info.SectionName, sizeof(info.SectionName), key);
		info.Type = effect.Type;
		info.Event = effect.Event;
		effect.GetOrigin(info.Origin);
		effect.GetAngles(info.Angles);
		info.RenderModes = effect.RenderMode;
		info.RenderEffects = effect.RenderEffect;
		info.SpawnFlags = effect.SpawnFlags;
		info.FadeAlpha = effect.FadeAlpha;
		info.LifeTime = effect.LifeTime;
		info.Attachment = effect.AttachPlayer;
		effect.GetAttachment(info.AttachmentName, sizeof(info.AttachmentName));
		if (info.AttachmentName[0] != '\0')
		{
			info.Attachment = true;
		}
		info.DifficultyIndexes = effect.DifficultyIndexes;
		info.Delay = effect.Delay;
		info.AttachPlayer = effect.AttachPlayer;
		info.Colors = new ArrayList(4);
		for (int i2 = 0; i2 < Difficulty_Max; i2++)
		{
			int color[4];
			effect.GetRenderColor(i2, color);
			info.Colors.PushArray(color);
		}

		switch (effect.Type)
		{
			case EffectType_Steam:
			{
				ProfileEffect_Steam steam = view_as<ProfileEffect_Steam>(effect);
				info.SteamSpreadSpeed = steam.SpreadSpeed;
				info.SteamSpeed = steam.Speed;
				info.SteamStartSize = steam.StartSize;
				info.SteamEndSize = steam.EndSize;
				info.SteamRate = steam.Rate;
				info.SteamJetLength = steam.JetLength;
				info.SteamRollSpeed = steam.RollSpeed;
				info.SteamType = steam.ParticleType;
			}

			case EffectType_DynamicLight:
			{
				ProfileEffect_DynamicLight light = view_as<ProfileEffect_DynamicLight>(effect);
				info.LightBrightness = light.Brightness;
				info.LightMaxDistance = light.Distance;
				info.LightCone = light.Cone;
				info.LightStyle = light.LightStyle;
			}

			case EffectType_Particle:
			{
				ProfileEffect_Particle particle = view_as<ProfileEffect_Particle>(effect);
				particle.GetName(info.ParticleName, sizeof(info.ParticleName));
			}

			case EffectType_Trail:
			{
				ProfileEffect_Trail trail = view_as<ProfileEffect_Trail>(effect);
				info.TrailTime = trail.Time;
				info.TrailStartWidth = trail.StartWidth;
				info.TrailEndWidth = trail.EndWidth;
				trail.GetName(info.TrailName, sizeof(info.TrailName));
			}

			case EffectType_PropDynamic:
			{
				ProfileEffect_PropDynamic prop = view_as<ProfileEffect_PropDynamic>(effect);
				prop.GetName(info.ModelName, sizeof(info.ModelName));
				info.ModelScale = prop.Scale;
				info.ModelSkin = prop.Skin;
				prop.GetAnimation(info.ModelAnimation, sizeof(info.ModelAnimation));
			}

			case EffectType_PointSpotlight:
			{
				ProfileEffect_PointSpotlight spotlight = view_as<ProfileEffect_PointSpotlight>(effect);
				info.SpotlightWidth = spotlight.Width;
				info.SpotlightLength = spotlight.Length;
				info.SpotlightHaloScale = spotlight.HaloScale;
				info.LightBrightness = spotlight.Brightness;
				info.LightMaxDistance = spotlight.Distance;
				info.LightCone = spotlight.Cone;
			}

			case EffectType_Sprite:
			{
				ProfileEffect_Sprite sprite = view_as<ProfileEffect_Sprite>(effect);
				sprite.GetName(info.SpriteName, sizeof(info.SpriteName));
				info.SpriteScale = sprite.Scale;
			}

			case EffectType_TempEntBeamRing:
			{
				ProfileEffect_TEBeamRing ring = view_as<ProfileEffect_TEBeamRing>(effect);
				info.BeamRingStartRadius = ring.StartRadius;
				info.BeamRingEndRadius = ring.EndRadius;
				info.BeamRingStartFrame = ring.StartFrame;
				info.BeamRingFrameRate = ring.FrameRate;
				info.BeamRingWidth = ring.Width;
				info.BeamRingAmplitude = ring.Amplitude;
				info.BeamRingSpeed = ring.Speed;
				info.BeamRingFlags = ring.Flags;
				ring.GetBeamSprite(info.BeamRingBeamSprite, sizeof(info.BeamRingBeamSprite));
				ring.GetHaloSprite(info.BeamRingHaloSprite, sizeof(info.BeamRingHaloSprite));
				info.BeamRingBeamModel = ring.BeamModel;
				info.BeamRingHaloModel = ring.HaloModel;
				int color[4];
				ring.GetRingColor(color);
				char colorString[32];
				FormatEx(colorString, sizeof(colorString), "%i %i %i %i", color[0], color[1], color[2], color[3]);
			}

			case EffectType_TempEntParticle:
			{
				ProfileEffect_TEParticle teParticle = view_as<ProfileEffect_TEParticle>(effect);
				teParticle.GetStartPos(info.TEParticleStartPos);
				info.TEParticleAttachType = teParticle.AttachType;
				info.TEParticleReset = teParticle.ResetParticles;
				info.TEParticleHasControlPoint = teParticle.HasControlPoint;
				info.TEParticleControlPointAttachType = teParticle.ControlPointAttachType;
				teParticle.GetControlPointOffset(info.TEParticleControlPointOffset);
			}

			case EffectType_Sound:
			{
				ProfileEffect_Sound sound = view_as<ProfileEffect_Sound>(effect);
				info.SoundSounds.Init();
				info.SoundSounds.Channel = sound.Sounds.GetChannel(1);
				info.SoundSounds.Volume = sound.Sounds.GetVolume(1);
				info.SoundSounds.Flags = sound.Sounds.GetFlags(1);
				info.SoundSounds.Level = sound.Sounds.GetLevel(1);
				info.SoundSounds.Pitch = sound.Sounds.GetPitch(1);
				info.SoundSounds.CooldownMin = sound.Sounds.GetCooldownMin(1);
				info.SoundSounds.CooldownMax = sound.Sounds.GetCooldownMax(1);
				info.SoundSounds.PitchRandomMin = sound.Sounds.GetPitchRandomMin(1);
				info.SoundSounds.PitchRandomMax = sound.Sounds.GetPitchRandomMax(1);
				info.SoundSounds.Chance = sound.Sounds.GetChance(1);
				info.SoundSounds.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
				for (int i2 = 0; i2 < sound.Sounds.GetPaths().Length; i2++)
				{
					char soundValue[PLATFORM_MAX_PATH];
					sound.Sounds.GetPaths().GetString(i2, soundValue, sizeof(soundValue));
					info.SoundSounds.Paths.PushString(soundValue);
				}
			}
		}

		effectsArray.PushArray(info);
	}
	SlenderSpawnEffects(effectsArray, GetNativeCell(2), false, pos, ang, output, GetNativeCell(6));
	for (int i = 0; i < effectsArray.Length; i++)
	{
		SF2BossProfileBaseEffectInfo effects;
		effectsArray.GetArray(i, effects, sizeof(effects));
		effects.Destroy();
	}
	delete effectsArray;
	return 0;
}