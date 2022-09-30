#if defined _sf2_effects_included
 #endinput
#endif
#define _sf2_effects_included

#pragma semicolon 1

EffectEvent g_EntityEffectEvent[2049];
EffectType g_EntityEffectType[2049];
static ArrayList g_NpcEffectsArray[MAX_BOSSES];
static float g_EffectSpotlightEndLength[2049];
static int g_EffectSpotlightEndEntity[2049] = { INVALID_ENT_REFERENCE, ... };

void SlenderSpawnEffects(int bossIndex)
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

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	int slenderEnt = NPCGetEntIndex(bossIndex);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (g_NpcEffectsArray[bossIndex] == null)
	{
		g_NpcEffectsArray[bossIndex] = new ArrayList();
	}

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
					SetEntityRenderColor(light, 94, 227, 79, 255);
				}
				case 3:
				{
					SetEntityRenderColor(light, 235, 235, 235, 255);
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

	ArrayList array = GetBossProfileEffectsArray(profile);
	char sectionName[64];

	if (array == null)
	{
		return;
	}

	float basePos[3], baseAng[3];
	SF2BossProfileBaseEffectInfo effectsInfo;
	for (int  i = 0, size = array.Length; i < size; i++)
	{
		array.GetArray(i, effectsInfo, sizeof(effectsInfo));

		// Validate effect event and type. Check to see if it matches with ours.
		if (effectsInfo.Event != EffectEvent_Invalid)
		{
			if (effectsInfo.Type != EffectType_Invalid)
			{
				// Check base position behavior.
				if (!slenderEnt || slenderEnt == INVALID_ENT_REFERENCE)
				{
					LogError("Could not spawn effect %s for boss %d: unable to read position due to boss entity not in game!");
					continue;
				}

				GetEntPropVector(slenderEnt, Prop_Data, "m_vecAbsOrigin", basePos);

				if (!slenderEnt || slenderEnt == INVALID_ENT_REFERENCE)
				{
					LogError("Could not spawn effect %s for boss %d: unable to read angles due to boss entity not in game!");
					continue;
				}

				GetEntPropVector(slenderEnt, Prop_Data, "m_angAbsRotation", baseAng);

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
						continue;
					}
				}

				int entity = -1;

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
						entity = CreateEntityByName("env_beam");
					}
					case EffectType_Sprite:
					{
						entity = CreateEntityByName("env_sprite");
					}
				}

				if (entity != -1)
				{
					char value[PLATFORM_MAX_PATH];
					DispatchKeyValueInt(entity, "renderamt", effectsInfo.FadeAlpha);
					DispatchKeyValueInt(entity, "rendermode", view_as<int>(effectsInfo.RenderModes));
					DispatchKeyValueInt(entity, "renderfx", view_as<int>(effectsInfo.RenderEffects));
					DispatchKeyValueInt(entity, "spawnflags", effectsInfo.SpawnFlags);

					float effectPos[3], effectAng[3];

					effectPos = effectsInfo.Origin;
					effectAng = effectsInfo.Angles;

					VectorTransform(effectPos, basePos, baseAng, effectPos);
					AddVectors(effectAng, baseAng, effectAng);
					TeleportEntity(entity, effectPos, effectAng, NULL_VECTOR);

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
							if (SF_SpecialRound(SPECIALROUND_TINYBOSSES) && modelScale != GetEntPropFloat(slenderEnt, Prop_Send, "m_flModelScale"))
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
							int startEnt = CreateEntityByName("info_target");
							int endEnt = CreateEntityByName("info_target");
							if (startEnt != -1) // Start
							{
								SetEntPropString(startEnt, Prop_Data, "m_iClassname", "sf2_boss_spotlight_start");
								SetEntProp(startEnt, Prop_Data, "m_spawnflags", 1);
								TeleportEntity(startEnt, effectPos, effectAng, NULL_VECTOR);
								SetVariantString("!activator");
								AcceptEntityInput(startEnt, "SetParent", slenderEnt);

								DispatchSpawn(startEnt);
								SetEntityOwner(startEnt, slenderEnt);

								SetEntityTransmitState(startEnt, FL_EDICT_FULLCHECK);
								g_DHookUpdateTransmitState.HookEntity(Hook_Pre, startEnt, Hook_SpotlightEffectUpdateTransmitState);
								g_DHookShouldTransmit.HookEntity(Hook_Pre, startEnt, Hook_SpotlightEffectShouldTransmit);
							}
							if (endEnt != -1) // End
							{
								SetEntPropString(endEnt, Prop_Data, "m_iClassname", "sf2_boss_spotlight_end");
								SetEntProp(endEnt, Prop_Data, "m_spawnflags", 1);
								TeleportEntity(endEnt, effectPos, effectAng, NULL_VECTOR);
								SetVariantString("!activator");
								AcceptEntityInput(endEnt, "SetParent", slenderEnt);
								DispatchSpawn(endEnt);

								SetEntityOwner(endEnt, slenderEnt);

								SetEntityTransmitState(endEnt, FL_EDICT_FULLCHECK);
								g_DHookUpdateTransmitState.HookEntity(Hook_Pre, endEnt, Hook_SpotlightEffectUpdateTransmitState);
								g_DHookShouldTransmit.HookEntity(Hook_Pre, endEnt, Hook_SpotlightEffectShouldTransmit);
							}
							int renderColor[4];
							effectsInfo.Colors.GetArray(difficulty, renderColor, sizeof(renderColor));

							SetEntityRenderColor(entity, renderColor[0], renderColor[1], renderColor[2], renderColor[3]);
							SetEntityModel(entity, SF2_FLASHLIGHT_BEAM_MATERIAL);
							SetEntityRenderMode(entity, effectsInfo.RenderModes);
							SetEntPropFloat(entity, Prop_Data, "m_life", 0.0);

							DispatchSpawn(entity);
							ActivateEntity(entity);

							SetEntPropEnt(entity, Prop_Send, "m_hAttachEntity", startEnt, 0);
							SetEntPropEnt(entity, Prop_Send, "m_hAttachEntity", endEnt, 1);
							SetEntProp(entity, Prop_Send, "m_nNumBeamEnts", 2);
							SetEntProp(entity, Prop_Send, "m_nBeamType", 2);

							float width = effectsInfo.SpotlightWidth;
							SetEntPropFloat(entity, Prop_Send, "m_fWidth", width);

							float endWidth = width * 2.0;
							SetEntPropFloat(entity, Prop_Data, "m_fEndWidth", endWidth);

							SetEntPropFloat(entity, Prop_Send, "m_fFadeLength", 0.0);
							SetEntProp(entity, Prop_Send, "m_nHaloIndex", g_FlashlightHaloModel);
							SetEntPropFloat(entity, Prop_Send, "m_fHaloScale", 40.0);
							SetEntProp(entity, Prop_Send, "m_nBeamFlags", 0x80 | 0x200);
							SetEntProp(entity, Prop_Data, "m_spawnflags", 0x8000);
							g_EffectSpotlightEndEntity[entity] = EntIndexToEntRef(endEnt);

							g_EffectSpotlightEndLength[entity] = effectsInfo.SpotlightLength;

							AcceptEntityInput(entity, "TurnOn");

							SetEntityOwner(entity, slenderEnt);

							SetEntityTransmitState(entity, FL_EDICT_FULLCHECK);
							g_DHookUpdateTransmitState.HookEntity(Hook_Pre, entity, Hook_SpotlightEffectUpdateTransmitState);
							g_DHookShouldTransmit.HookEntity(Hook_Pre, entity, Hook_SpotlightEffectShouldTransmit);
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

					if (!slenderEnt || slenderEnt == INVALID_ENT_REFERENCE)
					{
						LogError("Could not parent effect %s of boss %d to itself: boss entity does not exist!", sectionName, bossIndex);
						continue;
					}

					SetVariantString("!activator");
					AcceptEntityInput(entity, "SetParent", slenderEnt);
					if (effectsInfo.Attachment)
					{
						if (effectsInfo.AttachmentName[0] != '\0')
						{
							SetVariantString(effectsInfo.AttachmentName);
							if (effectsInfo.Type != EffectType_PropDynamic)
							{
								AcceptEntityInput(entity, "SetParentAttachment");
							}
							else
							{
								AcceptEntityInput(entity, "SetParentAttachmentMaintainOffset");
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
					g_NpcEffectsArray[bossIndex].Push(entity);
				}
			}
			else
			{
				LogError("Could not spawn effect %s for boss %d: invalid type!", sectionName, bossIndex);
			}
		}
	}

	if (g_NpcEffectsArray[bossIndex] != null && g_NpcEffectsArray[bossIndex].Length > 0)
	{
		for (int effects = 0; effects < g_NpcEffectsArray[bossIndex].Length; effects++)
		{
			int ent = g_NpcEffectsArray[bossIndex].Get(effects);
			if (!IsValidEntity(ent))
			{
				continue;
			}
			if (g_EntityEffectType[ent] == EffectType_PointSpotlight)
			{
				SDKHook(slenderEnt, SDKHook_ThinkPost, SlenderSpotlightThink);
				break;
			}
		}
	}
}
public Action Hook_EffectTransmit(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int slender = GetEntPropEnt(ent, Prop_Send, "moveparent");
	int bossIndex = NPCGetFromEntIndex(slender);

	if (bossIndex != -1 && NPCChaserIsCloaked(bossIndex))
	{
		return Plugin_Handled;
	}
	if (g_EntityEffectEvent[ent] == EffectEvent_PlayerSeesBoss && IsValidClient(other) && bossIndex != -1 && !g_PlayerEliminated[other] && !IsClientInGhostMode(other) &&
	!DidClientEscape(other) && !PlayerCanSeeSlender(other, bossIndex, true))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}
public Action Hook_EffectTransmitX(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
	int bossIndex = NPCGetFromEntIndex(slender);

	if (bossIndex != -1 && NPCChaserIsCloaked(bossIndex))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

MRESReturn Hook_SpotlightEffectUpdateTransmitState(int entity, DHookReturn returnHook)
{
	returnHook.Value = SetEntityTransmitState(entity, FL_EDICT_FULLCHECK);
	return MRES_Supercede;
}

MRESReturn Hook_SpotlightEffectShouldTransmit(int entity, DHookReturn returnHook, DHookParam params)
{
	returnHook.Value = FL_EDICT_ALWAYS;
	return MRES_Supercede;
}

void SlenderToggleParticleEffects(int slenderEnt,bool reverse=false)
{
	int effect = -1;
	while((effect = FindEntityByClassname(effect, "info_particle_system")) > MaxClients)
	{
		if (GetEntPropEnt(effect,Prop_Send,"moveparent") == slenderEnt)
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
void SlenderRemoveEffects(int slenderEnt,bool kill=false)
{
	int bossIndex = NPCGetFromEntIndex(slenderEnt);
	if (bossIndex == -1)
	{
		return;
	}

	if (g_NpcEffectsArray[bossIndex] == null)
	{
		return;
	}

	if (g_NpcEffectsArray[bossIndex] != null && g_NpcEffectsArray[bossIndex].Length <= 0)
	{
		return;
	}

	for (int effect = 0; effect < g_NpcEffectsArray[bossIndex].Length; effect++)
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
static void SlenderSpotlightThink(int slenderEnt)
{
	if (IsValidEntity(slenderEnt))
	{
		int bossIndex = NPCGetFromEntIndex(slenderEnt);
		if (bossIndex != -1 && g_NpcEffectsArray[bossIndex] != null && g_NpcEffectsArray[bossIndex].Length > 0)
		{
			for (int effect = 0; effect < g_NpcEffectsArray[bossIndex].Length; effect++)
			{
				int ent = g_NpcEffectsArray[bossIndex].Get(effect);
				if (!IsValidEntity(ent))
				{
					continue;
				}
				if (g_EntityEffectType[ent] != EffectType_PointSpotlight)
				{
					continue;
				}
				float entPos[3], entRot[3], endPos[3];
				GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", entPos);
				GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", entRot);
				GetAngleVectors(entRot, entRot, NULL_VECTOR, NULL_VECTOR);
				endPos = entRot;
				ScaleVector(endPos, g_EffectSpotlightEndLength[ent]);
				AddVectors(endPos, entPos, endPos);

				CBaseEntity spotlightEnd = CBaseEntity(EntRefToEntIndex(g_EffectSpotlightEndEntity[ent]));
				if (spotlightEnd.IsValid())
				{
					TR_TraceRayFilter(entPos, endPos, MASK_SOLID_BRUSHONLY, RayType_EndPoint, TraceRayDontHitEntity, ent);

					float hitPos[3];
					TR_GetEndPosition(hitPos);

					spotlightEnd.SetAbsOrigin(hitPos);
				}
			}
		}
	}
}

stock EffectType GetEffectTypeFromString(const char[] type)
{
	if (strcmp(type, "steam", false) == 0)
	{
		return EffectType_Steam;
	}
	if (strcmp(type, "dynamiclight", false) == 0)
	{
		return EffectType_DynamicLight;
	}
	if (strcmp(type, "particle", false) == 0)
	{
		return EffectType_Particle;
	}
	if (strcmp(type, "trail", false) == 0)
	{
		return EffectType_Trail;
	}
	if (strcmp(type, "propdynamic", false) == 0)
	{
		return EffectType_PropDynamic;
	}
	if (strcmp(type, "pointspotlight", false) == 0)
	{
		return EffectType_PointSpotlight;
	}
	if (strcmp(type, "sprite", false) == 0)
	{
		return EffectType_Sprite;
	}
	return EffectType_Invalid;
}

stock EffectEvent GetEffectEventFromString(const char[] type)
{
	if (strcmp(type, "constant", false) == 0)
	{
		return EffectEvent_Constant;
	}
	if (strcmp(type, "boss_hitplayer", false) == 0)
	{
		return EffectEvent_HitPlayer;
	}
	if (strcmp(type, "boss_seenbyplayer", false) == 0)
	{
		return EffectEvent_PlayerSeesBoss;
	}
	return EffectEvent_Invalid;
}

static Action Timer_DiscoLight(Handle timer, any effect)
{
	if (effect == -1)
	{
		return Plugin_Stop;
	}

	int ent = EntRefToEntIndex(effect);
	if (!IsValidEntity(ent))
	{
		return Plugin_Stop;
	}

	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
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
	if (!IsValidEntity(ent))
	{
		return Plugin_Stop;
	}

	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	int funnyFestive = GetRandomInt(1, 3);
	switch (funnyFestive)
	{
		case 1:
		{
			SetEntityRenderColor(effect, 230, 37, 37, 255);
		}
		case 2:
		{
			SetEntityRenderColor(effect, 94, 227, 79, 255);
		}
		case 3:
		{
			SetEntityRenderColor(effect, 235, 235, 235, 255);
		}
	}

	return Plugin_Continue;
}
