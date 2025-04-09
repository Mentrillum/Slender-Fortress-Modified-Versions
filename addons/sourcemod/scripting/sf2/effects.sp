#if defined _sf2_effects_included
 #endinput
#endif
#define _sf2_effects_included

#pragma semicolon 1

static EffectEvent g_EntityEffectEvent[2049];
static EffectType g_EntityEffectType[2049];
static ArrayList g_NpcEffectsArray[MAX_BOSSES];

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
				DispatchKeyValueFloat(entity, "modelscale", modelScale);
				SetEntProp(entity, Prop_Send, "m_nSkin", effectsInfo.ModelSkin);
				SetEntProp(entity, Prop_Send, "m_fEffects", EF_BONEMERGE|EF_PARENT_ANIMATES);
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
				spotlight.SetRenderColor(renderColor[0], renderColor[1], renderColor[2], renderColor[3]);
				spotlight.Length = effectsInfo.SpotlightLength;
				spotlight.Width = effectsInfo.SpotlightWidth;
				spotlight.EndWidth = spotlight.Width * 2.0;
				spotlight.Brightness = effectsInfo.LightBrightness;
				spotlight.Distance = effectsInfo.LightMaxDistance;
				spotlight.SpotlightRadius = effectsInfo.LightMaxDistance;
				spotlight.Cone = effectsInfo.LightCone;
				spotlight.HaloScale = effectsInfo.SpotlightHaloScale;

				spotlight.Spawn();
				spotlight.Activate();

				spotlight.TurnOn();

				//SDKHook(spotlight.Spotlight.index, SDKHook_SetTransmit, Hook_FlashlightSpotlightEffectSetTransmit);
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
