#if defined _sf2_effects_included
 #endinput
#endif
#define _sf2_effects_included

enum EffectEvent
{
	EffectEvent_Invalid = -1,
	EffectEvent_Constant = 0,
	EffectEvent_HitPlayer,
	EffectEvent_PlayerSeesBoss
};

enum EffectType
{
	EffectType_Invalid = -1,
	EffectType_Steam = 0,
	EffectType_DynamicLight,
	EffectType_Particle,
	EffectType_Trail,
	EffectType_PropDynamic,
	EffectType_PointSpotlight,
	EffectType_Sprite
};

EffectEvent g_EntityEffectEvent[2049];
EffectType g_EntityEffectType[2049];
static ArrayList g_NpcEffectsArray[MAX_BOSSES];

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

	g_Config.Rewind();
	if (!g_Config.JumpToKey(profile) || !g_Config.JumpToKey("effects") || !g_Config.GotoFirstSubKey())
	{
		return;
	}

	ArrayList array = new ArrayList(64);
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for array in SlenderSpawnEffects.", array);
	#endif
	char sSectionName[64];

	do
	{
		g_Config.GetSectionName(sSectionName, sizeof(sSectionName));
		array.PushString(sSectionName);
	}
	while (g_Config.GotoNextKey());

	if (array.Length == 0)
	{
		delete array;
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for array in SlenderSpawnEffects due to no length.", array);
		#endif
		return;
	}

	float basePos[3], baseAng[3];

	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("effects");

	for (int  i = 0, iSize = array.Length; i < iSize; i++)
	{
		array.GetString(i, sSectionName, sizeof(sSectionName));
		g_Config.JumpToKey(sSectionName);

		// Validate effect event. Check to see if it matches with ours.
		char effectEvent[64];
		g_Config.GetString("event", effectEvent, sizeof(effectEvent));
		if (strcmp(effectEvent, "constant", false) == 0 || strcmp(effectEvent, "boss_hitplayer", false) == 0 || strcmp(effectEvent, "boss_seenbyplayer", false) == 0)
		{
			// Validate effect type.
			char effectTypeString[64];
			g_Config.GetString("type", effectTypeString, sizeof(effectTypeString));
			EffectType effectType = GetEffectTypeFromString(effectTypeString);

			if (effectType != EffectType_Invalid)
			{
				// Check base position behavior.
				char sBasePosCustom[64];
				g_Config.GetString("origin_custom", sBasePosCustom, sizeof(sBasePosCustom));
				if (strcmp(sBasePosCustom, "&CURRENTTARGET&", false) == 0)
				{
					int  target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
					if (!target || target == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read position of target due to no target!");
						g_Config.GoBack();
						continue;
					}

					GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", basePos);
				}
				else
				{
					if (!slenderEnt || slenderEnt == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read position due to boss entity not in game!");
						g_Config.GoBack();
						continue;
					}

					GetEntPropVector(slenderEnt, Prop_Data, "m_vecAbsOrigin", basePos);
				}

				char baseAngCustom[64];
				g_Config.GetString("angles_custom", baseAngCustom, sizeof(baseAngCustom));
				if (strcmp(baseAngCustom, "&CURRENTTARGET&", false) == 0)
				{
					int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
					if (!target || target == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read angles of target due to no target!");
						g_Config.GoBack();
						continue;
					}

					GetEntPropVector(target, Prop_Data, "m_angAbsRotation", baseAng);
				}
				else
				{
					if (!slenderEnt || slenderEnt == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read angles due to boss entity not in game!");
						g_Config.GoBack();
						continue;
					}

					GetEntPropVector(slenderEnt, Prop_Data, "m_angAbsRotation", baseAng);
				}

				int difficultyIndex = g_Config.GetNum("difficulty_indexes", 123456);
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
						g_Config.GoBack();
						continue;
					}
				}

				int  entity = -1;

				switch (effectType)
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
						entity = CreateEntityByName("point_spotlight");
					}
					case EffectType_Sprite:
					{
						entity = CreateEntityByName("env_sprite");
					}
				}

				if (entity != -1)
				{
					char value[PLATFORM_MAX_PATH];
					g_Config.GetString("renderamt", value, sizeof(value), "255");
					DispatchKeyValue(entity, "renderamt", value);
					g_Config.GetString("rendermode", value, sizeof(value));
					DispatchKeyValue(entity, "rendermode", value);
					g_Config.GetString("renderfx", value, sizeof(value), "0");
					DispatchKeyValue(entity, "renderfx", value);
					g_Config.GetString("spawnflags", value, sizeof(value));
					DispatchKeyValue(entity, "spawnflags", value);

					float effectPos[3], effectAng[3];

					g_Config.GetVector("origin", effectPos);
					g_Config.GetVector("angles", effectAng);
					VectorTransform(effectPos, basePos, baseAng, effectPos);
					AddVectors(effectAng, baseAng, effectAng);
					TeleportEntity(entity, effectPos, effectAng, NULL_VECTOR);

					switch (effectType)
					{
						case EffectType_Steam:
						{
							g_Config.GetString("spreadspeed", value, sizeof(value));
							DispatchKeyValue(entity, "SpreadSpeed", value);
							g_Config.GetString("speed", value, sizeof(value));
							DispatchKeyValue(entity, "Speed", value);
							g_Config.GetString("startsize", value, sizeof(value));
							DispatchKeyValue(entity, "StartSize", value);
							g_Config.GetString("endsize", value, sizeof(value));
							DispatchKeyValue(entity, "EndSize", value);
							g_Config.GetString("rate", value, sizeof(value));
							DispatchKeyValue(entity, "Rate", value);
							g_Config.GetString("jetlength", value, sizeof(value));
							DispatchKeyValue(entity, "Jetlength", value);
							g_Config.GetString("rollspeed", value, sizeof(value));
							DispatchKeyValue(entity, "RollSpeed", value);
							g_Config.GetString("particletype", value, sizeof(value));
							DispatchKeyValue(entity, "type", value);
							DispatchSpawn(entity);
							ActivateEntity(entity);
						}
						case EffectType_DynamicLight:
						{
							SetVariantInt(g_Config.GetNum("brightness"));
							AcceptEntityInput(entity, "Brightness");
							SetVariantFloat(g_Config.GetFloat("distance"));
							AcceptEntityInput(entity, "Distance");
							SetVariantFloat(g_Config.GetFloat("distance"));
							AcceptEntityInput(entity, "spotlight_radius");
							SetVariantInt(g_Config.GetNum("cone"));
							AcceptEntityInput(entity, "cone");
							DispatchSpawn(entity);
							ActivateEntity(entity);

							int r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_lights", 0)) || view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal:
									{
										g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor", r, g, b, a);
										}
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor", r, g, b, a);
											}
										}
									}
									case Difficulty_Nightmare:
									{
										g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_insane", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_hard", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
									case Difficulty_Apollyon:
									{
										g_Config.GetColor("rendercolor_apollyon", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_insane", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor_hard", r, g, b, a);
													if (r == 0 && g == 0 && b == 0 && a == 0)
													{
														g_Config.GetColor("rendercolor", r, g, b, a);
													}
												}
											}
										}
									}
								}
							}
							else
							{
								g_Config.GetColor("rendercolor", r, g, b, a);
							}
							SetEntityRenderColor(entity, r, g, b, a);
							SetEntProp(entity, Prop_Data, "m_LightStyle", g_Config.GetNum("lightstyle", 0));
						}
						case EffectType_Particle:
						{
							g_Config.GetString("particlename", value, sizeof(value));
							DispatchKeyValue(entity, "effect_name", value);
							DispatchSpawn(entity);
							ActivateEntity(entity);
						}
						case EffectType_Trail:
						{
							DispatchKeyValueFloat(entity, "lifetime", g_Config.GetFloat("trailtime", 1.0));
							DispatchKeyValueFloat(entity, "startwidth", g_Config.GetFloat("startwidth", 6.0));
							DispatchKeyValueFloat(entity, "endwidth", g_Config.GetFloat("endwidth", 15.0));
							g_Config.GetString("spritename", value, sizeof(value));
							DispatchKeyValue(entity, "spritename", value);
							SetEntPropFloat(entity, Prop_Send, "m_flTextureRes", 0.05);
							int  r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal:
									{
										g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor", r, g, b, a);
										}
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor", r, g, b, a);
											}
										}
									}
									case Difficulty_Nightmare:
									{
										g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_insane", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_hard", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
									case Difficulty_Apollyon:
									{
										g_Config.GetColor("rendercolor_apollyon", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_insane", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor_hard", r, g, b, a);
													if (r == 0 && g == 0 && b == 0 && a == 0)
													{
														g_Config.GetColor("rendercolor", r, g, b, a);
													}
												}
											}
										}
									}
								}
							}
							else
							{
								g_Config.GetColor("rendercolor", r, g, b, a);
							}
							SetEntityRenderColor(entity, r, g, b, a);
							DispatchSpawn(entity);
							ActivateEntity(entity);
						}
						case EffectType_PropDynamic:
						{
							g_Config.GetString("modelname", value, sizeof(value));
							DispatchKeyValue(entity, "model", value);
							float flModelScale = g_Config.GetFloat("modelscale", GetEntPropFloat(slenderEnt, Prop_Send, "m_flModelScale"));
							if (SF_SpecialRound(SPECIALROUND_TINYBOSSES) && flModelScale != GetEntPropFloat(slenderEnt, Prop_Send, "m_flModelScale"))
							{
								flModelScale *= 0.5;
							}
							DispatchKeyValueFloat(entity, "modelscale", flModelScale);
							SetEntProp(entity, Prop_Send, "m_nSkin", g_Config.GetNum("modelskin", 0));
							SetEntProp(entity, Prop_Send, "m_fEffects", EF_BONEMERGE|EF_PARENT_ANIMATES);
							g_Config.GetString("modelanimation", value, sizeof(value));
							if (value[0] != '\0')
							{
								SetVariantString(value);
								AcceptEntityInput(entity, "SetAnimation");
							}
							int  r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal:
									{
										g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor", r, g, b, a);
										}
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor", r, g, b, a);
											}
										}
									}
									case Difficulty_Nightmare:
									{
										g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_insane", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_hard", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
									case Difficulty_Apollyon:
									{
										g_Config.GetColor("rendercolor_apollyon", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_insane", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor_hard", r, g, b, a);
													if (r == 0 && g == 0 && b == 0 && a == 0)
													{
														g_Config.GetColor("rendercolor", r, g, b, a);
													}
												}
											}
										}
									}
								}
							}
							else
							{
								g_Config.GetColor("rendercolor", r, g, b, a);
							}
							SetEntityRenderColor(entity, r, g, b, a);
							DispatchSpawn(entity);
							ActivateEntity(entity);
						}
						case EffectType_PointSpotlight:
						{
							g_Config.GetString("spotlightwidth", value, sizeof(value), "512");
							DispatchKeyValue(entity, "spotlightwidth", value);
							g_Config.GetString("spotlightlength", value, sizeof(value), "1024");
							DispatchKeyValue(entity, "spotlightlength", value);
							DispatchSpawn(entity);
							ActivateEntity(entity);

							int r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_lights", 0)) || view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal:
									{
										g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor", r, g, b, a);
										}
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor", r, g, b, a);
											}
										}
									}
									case Difficulty_Nightmare:
									{
										g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_insane", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_hard", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
									case Difficulty_Apollyon:
									{
										g_Config.GetColor("rendercolor_apollyon", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_insane", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor_hard", r, g, b, a);
													if (r == 0 && g == 0 && b == 0 && a == 0)
													{
														g_Config.GetColor("rendercolor", r, g, b, a);
													}
												}
											}
										}
									}
								}
							}
							else
							{
								g_Config.GetColor("rendercolor", r, g, b, a);
							}
							SetEntityRenderColor(entity, r, g, b, a);
						}
						case EffectType_Sprite:
						{
							DispatchKeyValue(entity, "classname", "env_sprite");
							g_Config.GetString("spritename", value, sizeof(value));
							DispatchKeyValue(entity, "model", value);
							FormatEx(value, sizeof(value), "%f", g_Config.GetFloat("spritescale", 1.0));
							DispatchKeyValue(entity, "scale", value);
							int r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal:
									{
										g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor", r, g, b, a);
										}
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor", r, g, b, a);
											}
										}
									}
									case Difficulty_Nightmare:
									{
										g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_insane", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_hard", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
									case Difficulty_Apollyon:
									{
										g_Config.GetColor("rendercolor_apollyon", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_nightmare", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_Config.GetColor("rendercolor_insane", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_Config.GetColor("rendercolor_hard", r, g, b, a);
													if (r == 0 && g == 0 && b == 0 && a == 0)
													{
														g_Config.GetColor("rendercolor", r, g, b, a);
													}
												}
											}
										}
									}
								}
							}
							else
							{
								g_Config.GetColor("rendercolor", r, g, b, a);
							}
							SetEntityRenderColor(entity, r, g, b, a);
						}
					}

					float lifeTime = g_Config.GetFloat("lifetime");
					if (lifeTime > 0.0)
					{
						CreateTimer(lifeTime, Timer_KillEntity, EntIndexToEntRef(entity), TIMER_FLAG_NO_MAPCHANGE);
					}

					char parentCustom[64];
					g_Config.GetString("parent_custom", parentCustom, sizeof(parentCustom));
					if (strcmp(parentCustom, "&CURRENTTARGET&", false) == 0)
					{
						int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
						if (!target || target == INVALID_ENT_REFERENCE)
						{
							LogError("Could not parent effect %s of boss %d to current target: target does not exist!", sSectionName, bossIndex);
							g_Config.GoBack();
							continue;
						}

						SetVariantString("!activator");
						AcceptEntityInput(entity, "SetParent", target);
						if (view_as<bool>(g_Config.GetNum("attach_point", 0)))
						{
							char attachment[PLATFORM_MAX_PATH];
							g_Config.GetString("attachment_point", attachment, sizeof(attachment));
							if (attachment[0] != '\0')
							{
								SetVariantString(attachment);
								if (effectType != EffectType_PropDynamic)
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
					else
					{
						if (!slenderEnt || slenderEnt == INVALID_ENT_REFERENCE)
						{
							LogError("Could not parent effect %s of boss %d to itself: boss entity does not exist!", sSectionName, bossIndex);
							g_Config.GoBack();
							continue;
						}

						SetVariantString("!activator");
						AcceptEntityInput(entity, "SetParent", slenderEnt);
						if (view_as<bool>(g_Config.GetNum("attach_point", 0)))
						{
							char attachment[PLATFORM_MAX_PATH];
							g_Config.GetString("attachment_point", attachment, sizeof(attachment));
							if (attachment[0] != '\0')
							{
								SetVariantString(attachment);
								if (effectType != EffectType_PropDynamic)
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

					switch (effectType)
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
							AcceptEntityInput(entity, "LightOn");
							int offset = FindDataMapInfo(entity, "m_nHaloSprite");
							if (offset != -1)
							{
								// m_hSpotlight
								int spotlight = GetEntDataEnt2(entity, offset + 4);
								if (IsValidEntity(spotlight))
								{
									SDKHook(spotlight, SDKHook_SetTransmit, Hook_EffectTransmit);
								}

								// m_hSpotlightTarget
								spotlight = GetEntDataEnt2(entity, offset + 8);
								if (IsValidEntity(spotlight))
								{
									SDKHook(spotlight, SDKHook_SetTransmit, Hook_EffectTransmit);
								}
							}
						}
					}
					SDKHook(entity, SDKHook_SetTransmit, Hook_EffectTransmit);
					g_EntityEffectType[entity] = effectType;
					g_EntityEffectEvent[entity] = GetEffectEventFromString(effectEvent);
					g_NpcEffectsArray[bossIndex].Push(entity);
				}
			}
			else
			{
				LogError("Could not spawn effect %s for boss %d: invalid type!", sSectionName, bossIndex);
			}
		}

		g_Config.GoBack();
	}

	delete array;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for array in SlenderSpawnEffects.", array);
	#endif
}
public Action Hook_EffectTransmit(int ent,int other)
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
			case EffectType_PointSpotlight:
			{
				AcceptEntityInput(ent, "LightOff");
			}
		}

		if (kill)
		{
			if (g_EntityEffectType[ent] == EffectType_PointSpotlight)
			{
				int offset = FindDataMapInfo(ent, "m_nHaloSprite");
				if (offset != -1)
				{
					// m_hSpotlight
					int spotlight = GetEntDataEnt2(ent, offset + 4);
					if (IsValidEntity(spotlight))
					{
						RemoveEntity(spotlight);
					}

					// m_hSpotlightTarget
					spotlight = GetEntDataEnt2(ent, offset + 8);
					if (IsValidEntity(spotlight))
					{
						RemoveEntity(spotlight);
					}
				}
			}
			else
			{
				RemoveEntity(ent);
			}
		}
	}
	delete g_NpcEffectsArray[bossIndex];
}

stock void GetEffectEventString(EffectEvent event, char[] buffer,int bufferLen)
{
	switch (event)
	{
		case EffectEvent_Constant:
		{
			strcopy(buffer, bufferLen, "constant");
		}
		case EffectEvent_HitPlayer:
		{
			strcopy(buffer, bufferLen, "boss_hitplayer");
		}
		case EffectEvent_PlayerSeesBoss:
		{
			strcopy(buffer, bufferLen, "boss_seenbyplayer");
		}
		default:
		{
			buffer[0] = '\0';
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

	int bossIndex = SF2_EntIndexToBossIndex(slender);
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
