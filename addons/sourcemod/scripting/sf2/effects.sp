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

EffectEvent g_iEntityEffectType[2049];

void SlenderSpawnEffects(int bossIndex)
{
	if (bossIndex < 0 || bossIndex >= MAX_BOSSES) return;
	
	int iBossID = NPCGetUniqueID(bossIndex);
	if (iBossID == -1) return;
	
	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	int iSlender = NPCGetEntIndex(bossIndex);
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (NPCGetDiscoModeState(bossIndex))
	{
		int iLight = CreateEntityByName("light_dynamic");
		int iParticle = CreateEntityByName("info_particle_system");
		if (iLight != -1)
		{
			float flEffectPos[3], flEffectAng[3], flBasePosX[3], flBaseAngX[3];
			GetEntPropVector(iSlender, Prop_Data, "m_vecAbsOrigin", flBasePosX);
			GetEntPropVector(iSlender, Prop_Data, "m_angAbsRotation", flBaseAngX);
			flEffectPos[2] = 50.0;
			VectorTransform(flEffectPos, flBasePosX, flBaseAngX, flEffectPos);
			AddVectors(flEffectAng, flBaseAngX, flEffectAng);
			TeleportEntity(iLight, flEffectPos, flEffectAng, NULL_VECTOR);
			SetVariantInt(5);
			AcceptEntityInput(iLight, "Brightness");
			SetVariantFloat(GetRandomFloat(NPCGetDiscoModeRadiusMin(bossIndex), NPCGetDiscoModeRadiusMax(bossIndex)));
			AcceptEntityInput(iLight, "Distance");
			SetVariantFloat(GetRandomFloat(NPCGetDiscoModeRadiusMin(bossIndex), NPCGetDiscoModeRadiusMax(bossIndex)));
			AcceptEntityInput(iLight, "spotlight_radius");
			SetVariantInt(1);
			AcceptEntityInput(iLight, "cone");
			DispatchKeyValue(iLight, "spawnflags", "0");
			int rChase = GetRandomInt(75, 250);
			int gChase = GetRandomInt(75, 250);
			int bChase = GetRandomInt(75, 250);
			SetEntityRenderColor(iLight, rChase, gChase, bChase, 255);
			DispatchSpawn(iLight);
			ActivateEntity(iLight);
			AcceptEntityInput(iLight, "TurnOn");
			SetVariantString("!activator");
			AcceptEntityInput(iLight, "SetParent", iSlender);
			CreateTimer(0.1, Timer_DiscoLight, EntIndexToEntRef(iLight), TIMER_REPEAT);
			SDKHook(iLight, SDKHook_SetTransmit, Hook_EffectTransmitX);
		}

		if (iParticle != -1)
		{
			float flEffectPos[3], flEffectAng[3], flBasePosX[3], flBaseAngX[3];
			GetEntPropVector(iSlender, Prop_Data, "m_vecAbsOrigin", flBasePosX);
			GetEntPropVector(iSlender, Prop_Data, "m_angAbsRotation", flBaseAngX);
			CopyVector(NPCGetDiscoModePos(bossIndex), flEffectPos);
			VectorTransform(flEffectPos, flBasePosX, flBaseAngX, flEffectPos);
			AddVectors(flEffectAng, flBaseAngX, flEffectAng);
			TeleportEntity(iParticle, flEffectPos, flEffectAng, NULL_VECTOR);

			DispatchKeyValue(iParticle, "effect_name", "utaunt_disco_party");
			DispatchSpawn(iParticle);
			ActivateEntity(iParticle);
			AcceptEntityInput(iParticle, "start");
			SetVariantString("!activator");
			AcceptEntityInput(iParticle, "SetParent", iSlender);
			SDKHook(iParticle, SDKHook_SetTransmit, Hook_EffectTransmitX);
		}
	}
	if (NPCGetFestiveLightState(bossIndex))
	{
		int iLight = CreateEntityByName("light_dynamic");
		if (iLight != -1)
		{
			float flEffectPos[3], flEffectAng[3], flBasePosX[3], flBaseAngX[3];
			GetEntPropVector(iSlender, Prop_Data, "m_vecAbsOrigin", flBasePosX);
			GetEntPropVector(iSlender, Prop_Data, "m_angAbsRotation", flBaseAngX);
			CopyVector(NPCGetFestiveLightPosition(bossIndex), flEffectPos);
			CopyVector(NPCGetFestiveLightAngle(bossIndex), flEffectAng);
			VectorTransform(flEffectPos, flBasePosX, flBaseAngX, flEffectPos);
			AddVectors(flEffectAng, flBaseAngX, flEffectAng);
			TeleportEntity(iLight, flEffectPos, flEffectAng, NULL_VECTOR);
			SetVariantInt(NPCGetFestiveLightBrightness(bossIndex));
			AcceptEntityInput(iLight, "Brightness");
			SetVariantFloat(NPCGetFestiveLightDistance(bossIndex));
			AcceptEntityInput(iLight, "Distance");
			SetVariantFloat(NPCGetFestiveLightRadius(bossIndex));
			AcceptEntityInput(iLight, "spotlight_radius");
			SetVariantInt(1);
			AcceptEntityInput(iLight, "cone");
			DispatchKeyValue(iLight, "spawnflags", "0");
			int iFunnyFestive = GetRandomInt(1, 3);
			switch (iFunnyFestive)
			{
				case 1:
				{
					SetEntityRenderColor(iLight, 230, 37, 37, 255);
				}
				case 2:
				{
					SetEntityRenderColor(iLight, 94, 227, 79, 255);
				}
				case 3:
				{
					SetEntityRenderColor(iLight, 235, 235, 235, 255);
				}
			}
			DispatchSpawn(iLight);
			ActivateEntity(iLight);
			CreateTimer(0.5, Timer_FestiveLight, EntIndexToEntRef(iLight), TIMER_REPEAT);
			AcceptEntityInput(iLight, "TurnOn");
			SetVariantString("!activator");
			AcceptEntityInput(iLight, "SetParent", iSlender);
			SDKHook(iLight, SDKHook_SetTransmit, Hook_EffectTransmitX);
		}
	}
	
	g_Config.Rewind();
	if (!g_Config.JumpToKey(profile) || !g_Config.JumpToKey("effects") || !g_Config.GotoFirstSubKey()) return;
	
	ArrayList hArray = new ArrayList(64);
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hArray in SlenderSpawnEffects.", hArray);
	#endif
	char sSectionName[64];
	
	do
	{
		g_Config.GetSectionName(sSectionName, sizeof(sSectionName));
		hArray.PushString(sSectionName);
	}
	while (g_Config.GotoNextKey());
	
	if (hArray.Length == 0)
	{
		delete hArray;
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArray in SlenderSpawnEffects due to no length.", hArray);
		#endif
		return;
	}

	float flBasePos[3], flBaseAng[3];
	
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("effects");
	
	for (int  i = 0, iSize = hArray.Length; i < iSize; i++)
	{
		hArray.GetString(i, sSectionName, sizeof(sSectionName));
		g_Config.JumpToKey(sSectionName);
		
		// Validate effect event. Check to see if it matches with ours.
		char sEffectEvent[64];
		g_Config.GetString("event", sEffectEvent, sizeof(sEffectEvent));
		if (strcmp(sEffectEvent, "constant", false) == 0 || strcmp(sEffectEvent, "boss_hitplayer", false) == 0 || strcmp(sEffectEvent, "boss_seenbyplayer", false) == 0) 
		{
			// Validate effect type.
			char sEffectType[64];
			g_Config.GetString("type", sEffectType, sizeof(sEffectType));
			EffectType iEffectType = GetEffectTypeFromString(sEffectType);
			
			if (iEffectType != EffectType_Invalid)
			{
				// Check base position behavior.
				char sBasePosCustom[64];
				g_Config.GetString("origin_custom", sBasePosCustom, sizeof(sBasePosCustom));
				if (strcmp(sBasePosCustom, "&CURRENTTARGET&", false) == 0)
				{
					int  iTarget = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
					if (!iTarget || iTarget == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read position of target due to no target!");
						g_Config.GoBack();
						continue;
					}
					
					GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flBasePos);
				}
				else
				{
					if (!iSlender || iSlender == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read position due to boss entity not in game!");
						g_Config.GoBack();
						continue;
					}
					
					GetEntPropVector(iSlender, Prop_Data, "m_vecAbsOrigin", flBasePos);
				}
				
				char sBaseAngCustom[64];
				g_Config.GetString("angles_custom", sBaseAngCustom, sizeof(sBaseAngCustom));
				if (strcmp(sBaseAngCustom, "&CURRENTTARGET&", false) == 0)
				{
					int  iTarget = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
					if (!iTarget || iTarget == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read angles of target due to no target!");
						g_Config.GoBack();
						continue;
					}
					
					GetEntPropVector(iTarget, Prop_Data, "m_angAbsRotation", flBaseAng);
				}
				else
				{
					if (!iSlender || iSlender == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read angles due to boss entity not in game!");
						g_Config.GoBack();
						continue;
					}
					
					GetEntPropVector(iSlender, Prop_Data, "m_angAbsRotation", flBaseAng);
				}

				int difficultyIndex = g_Config.GetNum("difficulty_indexes", 123456);
				char sIndexes[8], sCurrentIndex[2];
				FormatEx(sIndexes, sizeof(sIndexes), "%d", difficultyIndex);
				FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", g_DifficultyConVar.IntValue);
				char sNumber = sCurrentIndex[0];
				int difficultyNumber = 0;
				if (FindCharInString(sIndexes, sNumber) != -1)
				{
					difficultyNumber += g_DifficultyConVar.IntValue;
				}
				if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && difficultyNumber != -1)
				{
					int iCurrentIndex = StringToInt(sCurrentIndex);
					if (difficultyNumber != iCurrentIndex)
					{
						g_Config.GoBack();
						continue;
					}
				}

				int  iEnt = -1;
				
				switch (iEffectType)
				{
					case EffectType_Steam: iEnt = CreateEntityByName("env_steam");
					case EffectType_DynamicLight: iEnt = CreateEntityByName("light_dynamic");
					case EffectType_Particle: iEnt = CreateEntityByName("info_particle_system");
					case EffectType_Trail: iEnt = CreateEntityByName("env_spritetrail");
					case EffectType_PropDynamic: iEnt = CreateEntityByName("prop_dynamic");
					case EffectType_PointSpotlight: iEnt = CreateEntityByName("point_spotlight");
					case EffectType_Sprite: iEnt = CreateEntityByName("env_sprite");
				}
				
				if (iEnt != -1)
				{
					char sValue[PLATFORM_MAX_PATH];
					g_Config.GetString("renderamt", sValue, sizeof(sValue), "255");
					DispatchKeyValue(iEnt, "renderamt", sValue);
					g_Config.GetString("rendermode", sValue, sizeof(sValue));
					DispatchKeyValue(iEnt, "rendermode", sValue);
					g_Config.GetString("renderfx", sValue, sizeof(sValue), "0");
					DispatchKeyValue(iEnt, "renderfx", sValue);
					g_Config.GetString("spawnflags", sValue, sizeof(sValue));
					DispatchKeyValue(iEnt, "spawnflags", sValue);

					float flEffectPos[3], flEffectAng[3];
					
					g_Config.GetVector("origin", flEffectPos);
					g_Config.GetVector("angles", flEffectAng);
					VectorTransform(flEffectPos, flBasePos, flBaseAng, flEffectPos);
					AddVectors(flEffectAng, flBaseAng, flEffectAng);
					TeleportEntity(iEnt, flEffectPos, flEffectAng, NULL_VECTOR);
					
					switch (iEffectType)
					{
						case EffectType_Steam:
						{
							g_Config.GetString("spreadspeed", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "SpreadSpeed", sValue);
							g_Config.GetString("speed", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "Speed", sValue);
							g_Config.GetString("startsize", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "StartSize", sValue);
							g_Config.GetString("endsize", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "EndSize", sValue);
							g_Config.GetString("rate", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "Rate", sValue);
							g_Config.GetString("jetlength", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "Jetlength", sValue);
							g_Config.GetString("rollspeed", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "RollSpeed", sValue);
							g_Config.GetString("particletype", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "type", sValue);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
						}
						case EffectType_DynamicLight:
						{
							SetVariantInt(g_Config.GetNum("brightness"));
							AcceptEntityInput(iEnt, "Brightness");
							SetVariantFloat(g_Config.GetFloat("distance"));
							AcceptEntityInput(iEnt, "Distance");
							SetVariantFloat(g_Config.GetFloat("distance"));
							AcceptEntityInput(iEnt, "spotlight_radius");
							SetVariantInt(g_Config.GetNum("cone"));
							AcceptEntityInput(iEnt, "cone");
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
							
							int r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_lights", 0)) || view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal: g_Config.GetColor("rendercolor", r, g, b, a);
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
												if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
													if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
								}
							}
							else g_Config.GetColor("rendercolor", r, g, b, a);
							SetEntityRenderColor(iEnt, r, g, b, a);
							SetEntProp(iEnt, Prop_Data, "m_LightStyle", g_Config.GetNum("lightstyle", 0));
						}
						case EffectType_Particle:
						{
							g_Config.GetString("particlename", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "effect_name", sValue);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
						}
						case EffectType_Trail:
						{
							DispatchKeyValueFloat(iEnt, "lifetime", g_Config.GetFloat("trailtime", 1.0));
							DispatchKeyValueFloat(iEnt, "startwidth", g_Config.GetFloat("startwidth", 6.0));
							DispatchKeyValueFloat(iEnt, "endwidth", g_Config.GetFloat("endwidth", 15.0));
							g_Config.GetString("spritename", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "spritename", sValue);
							SetEntPropFloat(iEnt, Prop_Send, "m_flTextureRes", 0.05);
							int  r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal: g_Config.GetColor("rendercolor", r, g, b, a);
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
												if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
													if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
								}
							}
							else g_Config.GetColor("rendercolor", r, g, b, a);
							SetEntityRenderColor(iEnt, r, g, b, a);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
						}
						case EffectType_PropDynamic:
						{
							g_Config.GetString("modelname", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "model", sValue);
							float flModelScale = g_Config.GetFloat("modelscale", GetEntPropFloat(iSlender, Prop_Send, "m_flModelScale"));
							if (SF_SpecialRound(SPECIALROUND_TINYBOSSES) && flModelScale != GetEntPropFloat(iSlender, Prop_Send, "m_flModelScale")) flModelScale *= 0.5;
							DispatchKeyValueFloat(iEnt, "modelscale", flModelScale);
							SetEntProp(iEnt, Prop_Send, "m_nSkin", g_Config.GetNum("modelskin", 0));
							SetEntProp(iEnt, Prop_Send, "m_fEffects", EF_BONEMERGE|EF_PARENT_ANIMATES);
							g_Config.GetString("modelanimation", sValue, sizeof(sValue));
							if (sValue[0] != '\0')
							{
								SetVariantString(sValue);
								AcceptEntityInput(iEnt, "SetAnimation");
							}
							int  r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal: g_Config.GetColor("rendercolor", r, g, b, a);
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
												if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
													if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
								}
							}
							else g_Config.GetColor("rendercolor", r, g, b, a);
							SetEntityRenderColor(iEnt, r, g, b, a);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
						}
						case EffectType_PointSpotlight:
						{
							g_Config.GetString("spotlightwidth", sValue, sizeof(sValue), "512");
							DispatchKeyValue(iEnt, "spotlightwidth", sValue);
							g_Config.GetString("spotlightlength", sValue, sizeof(sValue), "1024");
							DispatchKeyValue(iEnt, "spotlightlength", sValue);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
							
							int r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_lights", 0)) || view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal: g_Config.GetColor("rendercolor", r, g, b, a);
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
												if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
													if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
								}
							}
							else g_Config.GetColor("rendercolor", r, g, b, a);
							SetEntityRenderColor(iEnt, r, g, b, a);
						}
						case EffectType_Sprite:
						{
							DispatchKeyValue(iEnt, "classname", "env_sprite");
							g_Config.GetString("spritename", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "model", sValue);
							FormatEx(sValue, sizeof(sValue), "%f", g_Config.GetFloat("spritescale", 1.0));
							DispatchKeyValue(iEnt, "scale", sValue);
							int r, g, b, a;
							if (view_as<bool>(g_Config.GetNum("difficulty_rendercolor", 0)))
							{
								switch (difficulty)
								{
									case Difficulty_Normal: g_Config.GetColor("rendercolor", r, g, b, a);
									case Difficulty_Hard:
									{
										g_Config.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Insane:
									{
										g_Config.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_Config.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
												if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
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
													if (r == 0 && g == 0 && b == 0 && a == 0) g_Config.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
								}
							}
							else g_Config.GetColor("rendercolor", r, g, b, a);
							SetEntityRenderColor(iEnt, r, g, b, a);
						}
					}
					
					float flLifeTime = g_Config.GetFloat("lifetime");
					if (flLifeTime > 0.0) CreateTimer(flLifeTime, Timer_KillEntity, EntIndexToEntRef(iEnt), TIMER_FLAG_NO_MAPCHANGE);
					
					char sParentCustom[64];
					g_Config.GetString("parent_custom", sParentCustom, sizeof(sParentCustom));
					if (strcmp(sParentCustom, "&CURRENTTARGET&", false) == 0)
					{
						int  iTarget = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
						if (!iTarget || iTarget == INVALID_ENT_REFERENCE)
						{
							LogError("Could not parent effect %s of boss %d to current target: target does not exist!", sSectionName, bossIndex);
							g_Config.GoBack();
							continue;
						}
					
						SetVariantString("!activator");
						AcceptEntityInput(iEnt, "SetParent", iTarget);
						if (view_as<bool>(g_Config.GetNum("attach_point", 0)))
						{
							char sAttachment[PLATFORM_MAX_PATH];
							g_Config.GetString("attachment_point", sAttachment, sizeof(sAttachment));
							if (sAttachment[0] != '\0')
							{
								SetVariantString(sAttachment);
								if (iEffectType != EffectType_PropDynamic) AcceptEntityInput(iEnt, "SetParentAttachment");
								else AcceptEntityInput(iEnt, "SetParentAttachmentMaintainOffset");
							}
						}
					}
					else
					{
						if (!iSlender || iSlender == INVALID_ENT_REFERENCE)
						{
							LogError("Could not parent effect %s of boss %d to itself: boss entity does not exist!", sSectionName, bossIndex);
							g_Config.GoBack();
							continue;
						}
						
						SetVariantString("!activator");
						AcceptEntityInput(iEnt, "SetParent", iSlender);
						if (view_as<bool>(g_Config.GetNum("attach_point", 0)))
						{
							char sAttachment[PLATFORM_MAX_PATH];
							g_Config.GetString("attachment_point", sAttachment, sizeof(sAttachment));
							if (sAttachment[0] != '\0')
							{
								SetVariantString(sAttachment);
								if (iEffectType != EffectType_PropDynamic) AcceptEntityInput(iEnt, "SetParentAttachment");
								else AcceptEntityInput(iEnt, "SetParentAttachmentMaintainOffset");
							}
						}
					}
					
					switch (iEffectType)
					{
						case EffectType_Steam,
							EffectType_DynamicLight: 
						{
							AcceptEntityInput(iEnt, "TurnOn");
						}
						case EffectType_Particle:
						{
							AcceptEntityInput(iEnt, "start");
						}
						case EffectType_Trail:
						{
							AcceptEntityInput(iEnt, "showsprite");
						}
						case EffectType_PointSpotlight:
						{
							AcceptEntityInput(iEnt, "LightOn");
							int iOffset = FindDataMapInfo(iEnt, "m_nHaloSprite");
							if (iOffset != -1)
							{
								// m_hSpotlight
								int iSpotlight = GetEntDataEnt2(iEnt, iOffset + 4);
								if (IsValidEntity(iSpotlight))
								{
									SDKHook(iSpotlight, SDKHook_SetTransmit, Hook_EffectTransmit);
								}

								// m_hSpotlightTarget
								iSpotlight = GetEntDataEnt2(iEnt, iOffset + 8);
								if (IsValidEntity(iSpotlight))
								{
									SDKHook(iSpotlight, SDKHook_SetTransmit, Hook_EffectTransmit);
								}
							}
						}
					}
					SDKHook(iEnt, SDKHook_SetTransmit, Hook_EffectTransmit);
					g_iEntityEffectType[iEnt] = GetEffectEventFromString(sEffectEvent);
				}
			}
			else
			{
				LogError("Could not spawn effect %s for boss %d: invalid type!", sSectionName, bossIndex);
			}
		}
		
		g_Config.GoBack();
	}
	
	delete hArray;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArray in SlenderSpawnEffects.", hArray);
	#endif
}
public Action Hook_EffectTransmit(int ent,int other)
{
	if (!g_Enabled) return Plugin_Continue;

	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
	int bossIndex = NPCGetFromEntIndex(slender);

	if (bossIndex != -1 && NPCChaserIsCloaked(bossIndex)) return Plugin_Handled;
	if (g_iEntityEffectType[ent] == EffectEvent_PlayerSeesBoss && IsValidClient(other) && bossIndex != -1 && !g_PlayerEliminated[other] && !IsClientInGhostMode(other) && 
	!DidClientEscape(other) && !PlayerCanSeeSlender(other, bossIndex, true)) return Plugin_Handled;

	return Plugin_Continue;
}
public Action Hook_EffectTransmitX(int ent,int other)
{
	if (!g_Enabled) return Plugin_Continue;

	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
	int bossIndex = NPCGetFromEntIndex(slender);

	if (bossIndex != -1 && NPCChaserIsCloaked(bossIndex)) return Plugin_Handled;

	return Plugin_Continue;
}
void SlenderToggleParticleEffects(int iSlender,bool bReverse=false)
{
	int iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "info_particle_system")) > MaxClients)
	{
		if (GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			if (!bReverse)
			{
				AcceptEntityInput(iEffect, "stop");
				AcceptEntityInput(iEffect, "stop");
			}
			else
			{
				AcceptEntityInput(iEffect, "stop");
				AcceptEntityInput(iEffect, "start");
			}
		}
	}
}
void SlenderRemoveEffects(int iSlender,bool bKill=false)
{
	int iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "light_dynamic")) > MaxClients)
	{
		if (GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "TurnOff");
			if (bKill)
				RemoveEntity(iEffect);
		}
	}
	
	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "env_steam")) > MaxClients)
	{
		if (GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "TurnOff");
			if (bKill)
				RemoveEntity(iEffect);
		}
	}

	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "info_particle_system")) > MaxClients)
	{
		if (GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "stop");
			if (bKill)
				RemoveEntity(iEffect);
		}
	}

	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "env_spritetrail")) > MaxClients)
	{
		if (GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "hidesprite");
			if (bKill)
				RemoveEntity(iEffect);
		}
	}

	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "prop_dynamic")) > MaxClients)
	{
		if (GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender && bKill)
		{
			RemoveEntity(iEffect);
		}
	}

	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "point_spotlight")) > MaxClients)
	{
		if (GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "LightOff");
			if (bKill)
			{
				int iOffset = FindDataMapInfo(iEffect, "m_nHaloSprite");
				if (iOffset != -1)
				{
					// m_hSpotlight
					int iSpotlight = GetEntDataEnt2(iEffect, iOffset + 4);
					if (IsValidEntity(iSpotlight))
					{
						RemoveEntity(iSpotlight);
					}

					// m_hSpotlightTarget
					iSpotlight = GetEntDataEnt2(iEffect, iOffset + 8);
					if (IsValidEntity(iSpotlight))
					{
						RemoveEntity(iSpotlight);
					}
				}
			}
		}
	}
}

stock void GetEffectEventString(EffectEvent iEvent, char[] sBuffer,int iBufferLen)
{
	switch (iEvent)
	{
		case EffectEvent_Constant: strcopy(sBuffer, iBufferLen, "constant");
		case EffectEvent_HitPlayer: strcopy(sBuffer, iBufferLen, "boss_hitplayer");
		case EffectEvent_PlayerSeesBoss: strcopy(sBuffer, iBufferLen, "boss_seenbyplayer");
		default: sBuffer[0] = '\0';
	}
}

stock EffectType GetEffectTypeFromString(const char[] sType)
{
	if (strcmp(sType, "steam", false) == 0) return EffectType_Steam;
	if (strcmp(sType, "dynamiclight", false) == 0) return EffectType_DynamicLight;
	if (strcmp(sType, "particle", false) == 0) return EffectType_Particle;
	if (strcmp(sType, "trail", false) == 0) return EffectType_Trail;
	if (strcmp(sType, "propdynamic", false) == 0) return EffectType_PropDynamic;
	if (strcmp(sType, "pointspotlight", false) == 0) return EffectType_PointSpotlight;
	if (strcmp(sType, "sprite", false) == 0) return EffectType_Sprite;
	return EffectType_Invalid;
}

stock EffectEvent GetEffectEventFromString(const char[] sType)
{
	if (strcmp(sType, "constant", false) == 0) return EffectEvent_Constant;
	if (strcmp(sType, "boss_hitplayer", false) == 0) return EffectEvent_HitPlayer;
	if (strcmp(sType, "boss_seenbyplayer", false) == 0) return EffectEvent_PlayerSeesBoss;
	return EffectEvent_Invalid;
}

static Action Timer_DiscoLight(Handle timer, any iEffect)
{
	if (iEffect == -1) return Plugin_Stop;
	
	int ent = EntRefToEntIndex(iEffect);
	if (!IsValidEntity(ent)) return Plugin_Stop;
	
	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1) return Plugin_Stop;
	
	int rChase = GetRandomInt(75, 250);
	int gChase = GetRandomInt(75, 250);
	int bChase = GetRandomInt(75, 250);
	SetEntityRenderColor(iEffect, rChase, gChase, bChase, 255);

	float DistanceRNG = GetRandomFloat(NPCGetDiscoModeRadiusMin(bossIndex), NPCGetDiscoModeRadiusMax(bossIndex));

	SetVariantFloat(DistanceRNG);
	AcceptEntityInput(iEffect, "Distance");
	SetVariantFloat(DistanceRNG);
	AcceptEntityInput(iEffect, "spotlight_radius");

	return Plugin_Continue;
}

static Action Timer_FestiveLight(Handle timer, any iEffect)
{
	if (iEffect == -1) return Plugin_Stop;
	
	int ent = EntRefToEntIndex(iEffect);
	if (!IsValidEntity(ent)) return Plugin_Stop;
	
	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int bossIndex = SF2_EntIndexToBossIndex(slender);
	if (bossIndex == -1) return Plugin_Stop;

	int iFunnyFestive = GetRandomInt(1, 3);
	switch (iFunnyFestive)
	{
		case 1:
		{
			SetEntityRenderColor(iEffect, 230, 37, 37, 255);
		}
		case 2:
		{
			SetEntityRenderColor(iEffect, 94, 227, 79, 255);
		}
		case 3:
		{
			SetEntityRenderColor(iEffect, 235, 235, 235, 255);
		}
	}

	return Plugin_Continue;
}
