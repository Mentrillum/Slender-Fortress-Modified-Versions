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
	EffectType_PropDynamic
};

EffectEvent g_iEntityEffectType[2049];

void SlenderSpawnEffects(int iBossIndex)
{
	if (iBossIndex < 0 || iBossIndex >= MAX_BOSSES) return;
	
	int iBossID = NPCGetUniqueID(iBossIndex);
	if (iBossID == -1) return;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);

	int iSlender = NPCGetEntIndex(iBossIndex);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	if (NPCGetDiscoModeState(iBossIndex))
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
			SetVariantFloat(GetRandomFloat(NPCGetDiscoModeRadiusMin(iBossIndex), NPCGetDiscoModeRadiusMax(iBossIndex)));
			AcceptEntityInput(iLight, "Distance");
			SetVariantFloat(GetRandomFloat(NPCGetDiscoModeRadiusMin(iBossIndex), NPCGetDiscoModeRadiusMax(iBossIndex)));
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
			CopyVector(NPCGetDiscoModePos(iBossIndex), flEffectPos);
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
	if (NPCGetFestiveLightState(iBossIndex))
	{
		int iLight = CreateEntityByName("light_dynamic");
		if (iLight != -1)
		{
			float flEffectPos[3], flEffectAng[3], flBasePosX[3], flBaseAngX[3];
			GetEntPropVector(iSlender, Prop_Data, "m_vecAbsOrigin", flBasePosX);
			GetEntPropVector(iSlender, Prop_Data, "m_angAbsRotation", flBaseAngX);
			CopyVector(NPCGetFestiveLightPosition(iBossIndex), flEffectPos);
			CopyVector(NPCGetFestiveLightAngle(iBossIndex), flEffectAng);
			VectorTransform(flEffectPos, flBasePosX, flBaseAngX, flEffectPos);
			AddVectors(flEffectAng, flBaseAngX, flEffectAng);
			TeleportEntity(iLight, flEffectPos, flEffectAng, NULL_VECTOR);
			SetVariantInt(NPCGetFestiveLightBrightness(iBossIndex));
			AcceptEntityInput(iLight, "Brightness");
			SetVariantFloat(NPCGetFestiveLightDistance(iBossIndex));
			AcceptEntityInput(iLight, "Distance");
			SetVariantFloat(NPCGetFestiveLightRadius(iBossIndex));
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
	
	g_hConfig.Rewind();
	if (!g_hConfig.JumpToKey(sProfile) || !g_hConfig.JumpToKey("effects") || !g_hConfig.GotoFirstSubKey()) return;
	
	ArrayList hArray = new ArrayList(64);
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hArray in SlenderSpawnEffects.", hArray);
	#endif
	char sSectionName[64];
	
	do
	{
		g_hConfig.GetSectionName(sSectionName, sizeof(sSectionName));
		hArray.PushString(sSectionName);
	}
	while (g_hConfig.GotoNextKey());
	
	if (hArray.Length == 0)
	{
		delete hArray;
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArray in SlenderSpawnEffects due to no length.", hArray);
		#endif
		return;
	}

	float flBasePos[3], flBaseAng[3];
	
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	g_hConfig.JumpToKey("effects");
	
	for (int  i = 0, iSize = hArray.Length; i < iSize; i++)
	{
		hArray.GetString(i, sSectionName, sizeof(sSectionName));
		g_hConfig.JumpToKey(sSectionName);
		
		// Validate effect event. Check to see if it matches with ours.
		char sEffectEvent[64];
		g_hConfig.GetString("event", sEffectEvent, sizeof(sEffectEvent));
		if (strcmp(sEffectEvent, "constant", false) == 0 || strcmp(sEffectEvent, "boss_hitplayer", false) == 0 || strcmp(sEffectEvent, "boss_seenbyplayer", false) == 0) 
		{
			// Validate effect type.
			char sEffectType[64];
			g_hConfig.GetString("type", sEffectType, sizeof(sEffectType));
			EffectType iEffectType = GetEffectTypeFromString(sEffectType);
			
			if (iEffectType != EffectType_Invalid)
			{
				// Check base position behavior.
				char sBasePosCustom[64];
				g_hConfig.GetString("origin_custom", sBasePosCustom, sizeof(sBasePosCustom));
				if (strcmp(sBasePosCustom, "&CURRENTTARGET&", false) == 0)
				{
					int  iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
					if (!iTarget || iTarget == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read position of target due to no target!");
						g_hConfig.GoBack();
						continue;
					}
					
					GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flBasePos);
				}
				else
				{
					if (!iSlender || iSlender == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read position due to boss entity not in game!");
						g_hConfig.GoBack();
						continue;
					}
					
					GetEntPropVector(iSlender, Prop_Data, "m_vecAbsOrigin", flBasePos);
				}
				
				char sBaseAngCustom[64];
				g_hConfig.GetString("angles_custom", sBaseAngCustom, sizeof(sBaseAngCustom));
				if (strcmp(sBaseAngCustom, "&CURRENTTARGET&", false) == 0)
				{
					int  iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
					if (!iTarget || iTarget == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read angles of target due to no target!");
						g_hConfig.GoBack();
						continue;
					}
					
					GetEntPropVector(iTarget, Prop_Data, "m_angAbsRotation", flBaseAng);
				}
				else
				{
					if (!iSlender || iSlender == INVALID_ENT_REFERENCE)
					{
						LogError("Could not spawn effect %s for boss %d: unable to read angles due to boss entity not in game!");
						g_hConfig.GoBack();
						continue;
					}
					
					GetEntPropVector(iSlender, Prop_Data, "m_angAbsRotation", flBaseAng);
				}

				int iDifficultyIndex = g_hConfig.GetNum("difficulty_indexes", 123456);
				char sIndexes[8], sCurrentIndex[2];
				FormatEx(sIndexes, sizeof(sIndexes), "%d", iDifficultyIndex);
				FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", g_cvDifficulty.IntValue);
				char sNumber = sCurrentIndex[0];
				int iDifficultyNumber = 0;
				if (FindCharInString(sIndexes, sNumber) != -1)
				{
					iDifficultyNumber += g_cvDifficulty.IntValue;
				}
				if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iDifficultyNumber != -1)
				{
					int iCurrentIndex = StringToInt(sCurrentIndex);
					if (iDifficultyNumber != iCurrentIndex)
					{
						g_hConfig.GoBack();
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
				}
				
				if (iEnt != -1)
				{
					char sValue[PLATFORM_MAX_PATH];
					g_hConfig.GetString("renderamt", sValue, sizeof(sValue), "255");
					DispatchKeyValue(iEnt, "renderamt", sValue);
					g_hConfig.GetString("rendermode", sValue, sizeof(sValue));
					DispatchKeyValue(iEnt, "rendermode", sValue);
					g_hConfig.GetString("renderfx", sValue, sizeof(sValue), "0");
					DispatchKeyValue(iEnt, "renderfx", sValue);
					g_hConfig.GetString("spawnflags", sValue, sizeof(sValue));
					DispatchKeyValue(iEnt, "spawnflags", sValue);

					float flEffectPos[3], flEffectAng[3];
					
					g_hConfig.GetVector("origin", flEffectPos);
					g_hConfig.GetVector("angles", flEffectAng);
					VectorTransform(flEffectPos, flBasePos, flBaseAng, flEffectPos);
					AddVectors(flEffectAng, flBaseAng, flEffectAng);
					TeleportEntity(iEnt, flEffectPos, flEffectAng, NULL_VECTOR);
					
					switch (iEffectType)
					{
						case EffectType_Steam:
						{
							g_hConfig.GetString("spreadspeed", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "SpreadSpeed", sValue);
							g_hConfig.GetString("speed", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "Speed", sValue);
							g_hConfig.GetString("startsize", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "StartSize", sValue);
							g_hConfig.GetString("endsize", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "EndSize", sValue);
							g_hConfig.GetString("rate", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "Rate", sValue);
							g_hConfig.GetString("jetlength", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "Jetlength", sValue);
							g_hConfig.GetString("rollspeed", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "RollSpeed", sValue);
							g_hConfig.GetString("particletype", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "type", sValue);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
						}
						case EffectType_DynamicLight:
						{
							SetVariantInt(g_hConfig.GetNum("brightness"));
							AcceptEntityInput(iEnt, "Brightness");
							SetVariantFloat(g_hConfig.GetFloat("distance"));
							AcceptEntityInput(iEnt, "Distance");
							SetVariantFloat(g_hConfig.GetFloat("distance"));
							AcceptEntityInput(iEnt, "spotlight_radius");
							SetVariantInt(g_hConfig.GetNum("cone"));
							AcceptEntityInput(iEnt, "cone");
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
							
							int r, g, b, a;
							if (view_as<bool>(g_hConfig.GetNum("difficulty_lights", 0)) || view_as<bool>(g_hConfig.GetNum("difficulty_rendercolor", 0)))
							{
								switch (iDifficulty)
								{
									case Difficulty_Normal: g_hConfig.GetColor("rendercolor", r, g, b, a);
									case Difficulty_Hard:
									{
										g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Insane:
									{
										g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
										}
									}
									case Difficulty_Nightmare:
									{
										g_hConfig.GetColor("rendercolor_nightmare", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
											}
										}
									}
									case Difficulty_Apollyon: 
									{
										g_hConfig.GetColor("rendercolor_apollyon", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_nightmare", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
													if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
								}
							}
							else g_hConfig.GetColor("rendercolor", r, g, b, a);
							SetEntityRenderColor(iEnt, r, g, b, a);
							SetEntProp(iEnt, Prop_Data, "m_LightStyle", g_hConfig.GetNum("lightstyle", 0));
						}
						case EffectType_Particle:
						{
							g_hConfig.GetString("particlename", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "effect_name", sValue);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
						}
						case EffectType_Trail:
						{
							DispatchKeyValueFloat(iEnt, "lifetime", g_hConfig.GetFloat("trailtime", 1.0));
							DispatchKeyValueFloat(iEnt, "startwidth", g_hConfig.GetFloat("startwidth", 6.0));
							DispatchKeyValueFloat(iEnt, "endwidth", g_hConfig.GetFloat("endwidth", 15.0));
							g_hConfig.GetString("spritename", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "spritename", sValue);
							SetEntPropFloat(iEnt, Prop_Send, "m_flTextureRes", 0.05);
							int  r, g, b, a;
							if (view_as<bool>(g_hConfig.GetNum("difficulty_rendercolor", 0)))
							{
								switch (iDifficulty)
								{
									case Difficulty_Normal: g_hConfig.GetColor("rendercolor", r, g, b, a);
									case Difficulty_Hard:
									{
										g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Insane:
									{
										g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
										}
									}
									case Difficulty_Nightmare:
									{
										g_hConfig.GetColor("rendercolor_nightmare", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
											}
										}
									}
									case Difficulty_Apollyon: 
									{
										g_hConfig.GetColor("rendercolor_apollyon", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_nightmare", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
													if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
								}
							}
							else g_hConfig.GetColor("rendercolor", r, g, b, a);
							SetEntityRenderColor(iEnt, r, g, b, a);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
						}
						case EffectType_PropDynamic:
						{
							g_hConfig.GetString("modelname", sValue, sizeof(sValue));
							DispatchKeyValue(iEnt, "model", sValue);
							float flModelScale = g_hConfig.GetFloat("modelscale", GetEntPropFloat(iSlender, Prop_Send, "m_flModelScale"));
							if (SF_SpecialRound(SPECIALROUND_TINYBOSSES) && flModelScale != GetEntPropFloat(iSlender, Prop_Send, "m_flModelScale")) flModelScale *= 0.5;
							DispatchKeyValueFloat(iEnt, "modelscale", flModelScale);
							SetEntProp(iEnt, Prop_Send, "m_nSkin", g_hConfig.GetNum("modelskin", 0));
							SetEntProp(iEnt, Prop_Send, "m_fEffects", EF_BONEMERGE|EF_PARENT_ANIMATES);
							g_hConfig.GetString("modelanimation", sValue, sizeof(sValue));
							if (sValue[0] != '\0')
							{
								SetVariantString(sValue);
								AcceptEntityInput(iEnt, "SetAnimation");
							}
							int  r, g, b, a;
							if (view_as<bool>(g_hConfig.GetNum("difficulty_rendercolor", 0)))
							{
								switch (iDifficulty)
								{
									case Difficulty_Normal: g_hConfig.GetColor("rendercolor", r, g, b, a);
									case Difficulty_Hard:
									{
										g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
									}
									case Difficulty_Insane:
									{
										g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
										}
									}
									case Difficulty_Nightmare:
									{
										g_hConfig.GetColor("rendercolor_nightmare", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
											}
										}
									}
									case Difficulty_Apollyon: 
									{
										g_hConfig.GetColor("rendercolor_apollyon", r, g, b, a);
										if (r == 0 && g == 0 && b == 0 && a == 0)
										{
											g_hConfig.GetColor("rendercolor_nightmare", r, g, b, a);
											if (r == 0 && g == 0 && b == 0 && a == 0)
											{
												g_hConfig.GetColor("rendercolor_insane", r, g, b, a);
												if (r == 0 && g == 0 && b == 0 && a == 0)
												{
													g_hConfig.GetColor("rendercolor_hard", r, g, b, a);
													if (r == 0 && g == 0 && b == 0 && a == 0) g_hConfig.GetColor("rendercolor", r, g, b, a);
												}
											}
										}
									}
								}
							}
							else g_hConfig.GetColor("rendercolor", r, g, b, a);
							SetEntityRenderColor(iEnt, r, g, b, a);
							DispatchSpawn(iEnt);
							ActivateEntity(iEnt);
						}
					}
					
					float flLifeTime = g_hConfig.GetFloat("lifetime");
					if (flLifeTime > 0.0) CreateTimer(flLifeTime, Timer_KillEntity, EntIndexToEntRef(iEnt), TIMER_FLAG_NO_MAPCHANGE);
					
					char sParentCustom[64];
					g_hConfig.GetString("parent_custom", sParentCustom, sizeof(sParentCustom));
					if (strcmp(sParentCustom, "&CURRENTTARGET&", false) == 0)
					{
						int  iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
						if (!iTarget || iTarget == INVALID_ENT_REFERENCE)
						{
							LogError("Could not parent effect %s of boss %d to current target: target does not exist!", sSectionName, iBossIndex);
							g_hConfig.GoBack();
							continue;
						}
					
						SetVariantString("!activator");
						AcceptEntityInput(iEnt, "SetParent", iTarget);
						if (view_as<bool>(g_hConfig.GetNum("attach_point", 0)))
						{
							char sAttachment[PLATFORM_MAX_PATH];
							g_hConfig.GetString("attachment_point", sAttachment, sizeof(sAttachment));
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
							LogError("Could not parent effect %s of boss %d to itself: boss entity does not exist!", sSectionName, iBossIndex);
							g_hConfig.GoBack();
							continue;
						}
						
						SetVariantString("!activator");
						AcceptEntityInput(iEnt, "SetParent", iSlender);
						if (view_as<bool>(g_hConfig.GetNum("attach_point", 0)))
						{
							char sAttachment[PLATFORM_MAX_PATH];
							g_hConfig.GetString("attachment_point", sAttachment, sizeof(sAttachment));
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
					}
					SDKHook(iEnt, SDKHook_SetTransmit, Hook_EffectTransmit);
					g_iEntityEffectType[iEnt] = GetEffectEventFromString(sEffectEvent);
				}
			}
			else
			{
				LogError("Could not spawn effect %s for boss %d: invalid type!", sSectionName, iBossIndex);
			}
		}
		
		g_hConfig.GoBack();
	}
	
	delete hArray;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArray in SlenderSpawnEffects.", hArray);
	#endif
}
public Action Hook_EffectTransmit(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
	int iBossIndex = NPCGetFromEntIndex(slender);

	if (iBossIndex != -1 && NPCChaserIsCloaked(iBossIndex)) return Plugin_Handled;
	if (g_iEntityEffectType[ent] == EffectEvent_PlayerSeesBoss && IsValidClient(other) && iBossIndex != -1 && !g_bPlayerEliminated[other] && !IsClientInGhostMode(other) && 
	!DidClientEscape(other) && !PlayerCanSeeSlender(other, iBossIndex, true)) return Plugin_Handled;

	return Plugin_Continue;
}
public Action Hook_EffectTransmitX(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	int slender = GetEntPropEnt(ent,Prop_Send,"moveparent");
	int iBossIndex = NPCGetFromEntIndex(slender);

	if (iBossIndex != -1 && NPCChaserIsCloaked(iBossIndex)) return Plugin_Handled;

	return Plugin_Continue;
}
void SlenderToggleParticleEffects(int iSlender,bool bReverse=false)
{
	int iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "info_particle_system")) > MaxClients)
	{
		if(GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
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
		if(GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "TurnOff");
			if(bKill)
				RemoveEntity(iEffect);
		}
	}
	
	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "env_steam")) > MaxClients)
	{
		if(GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "TurnOff");
			if(bKill)
				RemoveEntity(iEffect);
		}
	}

	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "info_particle_system")) > MaxClients)
	{
		if(GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "stop");
			if(bKill)
				RemoveEntity(iEffect);
		}
	}

	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "env_spritetrail")) > MaxClients)
	{
		if(GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender)
		{
			AcceptEntityInput(iEffect, "hidesprite");
			if(bKill)
				RemoveEntity(iEffect);
		}
	}

	iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "prop_dynamic")) > MaxClients)
	{
		if(GetEntPropEnt(iEffect,Prop_Send,"moveparent") == iSlender && bKill)
		{
			RemoveEntity(iEffect);
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

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	int rChase = GetRandomInt(75, 250);
	int gChase = GetRandomInt(75, 250);
	int bChase = GetRandomInt(75, 250);
	SetEntityRenderColor(iEffect, rChase, gChase, bChase, 255);

	float DistanceRNG = GetRandomFloat(NPCGetDiscoModeRadiusMin(iBossIndex), NPCGetDiscoModeRadiusMax(iBossIndex));

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

	int iBossIndex = SF2_EntIndexToBossIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;

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
