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
	EffectType_Trail
};

EffectEvent g_iEntityEffectType[2049];

void SlenderSpawnEffects(int iBossIndex)
{
	if (iBossIndex < 0 || iBossIndex >= MAX_BOSSES) return;
	
	int iBossID = NPCGetUniqueID(iBossIndex);
	if (iBossID == -1) return;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
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

	int  iSlender = NPCGetEntIndex(iBossIndex);
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
				
				int  iEnt = -1;
				
				switch (iEffectType)
				{
					case EffectType_Steam: iEnt = CreateEntityByName("env_steam");
					case EffectType_DynamicLight: iEnt = CreateEntityByName("light_dynamic");
					case EffectType_Particle: iEnt = CreateEntityByName("info_particle_system");
					case EffectType_Trail: iEnt = CreateEntityByName("env_spritetrail");
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
								AcceptEntityInput(iEnt, "SetParentAttachment");
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
								AcceptEntityInput(iEnt, "SetParentAttachment");
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
	return EffectType_Invalid;
}

stock EffectEvent GetEffectEventFromString(const char[] sType)
{
	if (strcmp(sType, "constant", false) == 0) return EffectEvent_Constant;
	if (strcmp(sType, "boss_hitplayer", false) == 0) return EffectEvent_HitPlayer;
	if (strcmp(sType, "boss_seenbyplayer", false) == 0) return EffectEvent_PlayerSeesBoss;
	return EffectEvent_Invalid;
}