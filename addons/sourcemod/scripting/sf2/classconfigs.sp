#if defined _sf2_client_classconfigs_included
#endinput
#endif
#define _sf2_client_classconfigs_included

#pragma semicolon 1
#pragma newdecls required

static KeyMap g_ClassStatsConfig = null;

float g_ClassRunSpeed[MAX_CLASSES + 1];
float g_ClassWalkSpeed[MAX_CLASSES + 1];
float g_ClassDangerSpeedMultipler[MAX_CLASSES + 1];
float g_ClassSprintDurationMultipler[MAX_CLASSES + 1];
float g_ClassScareSprintDurationMultipler[MAX_CLASSES + 1];
float g_ClassSprintPointLossJumping[MAX_CLASSES + 1];

float g_ClassProxyDamageVulnerability[MAX_CLASSES + 1];
bool g_ClassCanPickUpHealth[MAX_CLASSES + 1];
float g_ClassHealthPickupMultiplier[MAX_CLASSES + 1];

float g_ClassBossPriorityMultiplier[MAX_CLASSES + 1];
float g_ClassBossHearingSensitivity[MAX_CLASSES + 1];

float g_ClassBlinkRateMultiplier[MAX_CLASSES + 1];

float g_ClassResistanceStaticIncrease[MAX_CLASSES + 1];
float g_ClassResistanceStaticDecrease[MAX_CLASSES + 1];

float g_ClassUltravisionRadiusMultiplier[MAX_CLASSES + 1];
float g_ClassUltravisionBrightnessMultiplier[MAX_CLASSES + 1];
float g_ClassUltravisionFadeInTimer[MAX_CLASSES + 1];

float g_ClassNightvisionRadiusMultiplier[MAX_CLASSES + 1];
float g_ClassNightvisionBrightnessMultiplier[MAX_CLASSES + 1];

int g_ClassFlashlightBrightness[MAX_CLASSES + 1];
float g_ClassFlashlightRadius[MAX_CLASSES + 1];
float g_ClassFlashlightLength[MAX_CLASSES + 1];
float g_ClassFlashlightDamageMultiplier[MAX_CLASSES + 1];
float g_ClassFlashlightDrainRate[MAX_CLASSES + 1];
float g_ClassFlashlightRechargeRate[MAX_CLASSES + 1];
float g_ClassFlashlightSoundRadius[MAX_CLASSES + 1];

bool g_ClassBlockedOnThanatophobia[MAX_CLASSES + 1];

bool g_ClassInvulnerableToTraps[MAX_CLASSES + 1];

float g_ClassMedicAddedHealthRegen[MAX_CLASSES + 1];

void ReloadClassConfigs()
{
	if (g_ClassStatsConfig != null)
	{
		CleanupKeyMap(g_ClassStatsConfig);
	}

	char buffer[PLATFORM_MAX_PATH];
	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_CLASSCONFIGS);
	}
	else
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_CLASSCONFIGS_DATA);
	}
	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, buffer))
	{
		delete kv;
		LogError("Failed to load the class stats config! File not found!");
		return;
	}

	g_ClassStatsConfig = KeyValuesToKeyMap(kv);
	LogSF2Message("Reloaded class stats configuration file successfully");
	PrecacheClassProfiles();
}

bool IsClassConfigsValid()
{
	return g_ClassStatsConfig == null ? false : true;
}

KeyMap_Array GetClassHelpInfo(char[] buffer)
{
	KeyMap obj = g_ClassStatsConfig.GetSection(buffer);
	if (obj != null)
	{
		return obj.GetArray("help_info");
	}
	return null;
}

static bool GetClassProfileName(TFClassType class, char[] buffer, int bufferLen)
{
	if (!IsClassConfigsValid())
	{
		return false;
	}

	switch (class)
	{
		case TFClass_Scout:
		{
			if (g_ClassStatsConfig.GetSection("scout") != null)
			{
				strcopy(buffer, bufferLen, "scout");
			}
			else
			{
				return false;
			}
		}
		case TFClass_Soldier:
		{
			if (g_ClassStatsConfig.GetSection("soldier") != null)
			{
				strcopy(buffer, bufferLen, "soldier");
			}
			else
			{
				return false;
			}
		}
		case TFClass_Pyro:
		{
			if (g_ClassStatsConfig.GetSection("pyro") != null)
			{
				strcopy(buffer, bufferLen, "pyro");
			}
			else
			{
				return false;
			}
		}
		case TFClass_DemoMan:
		{
			if (g_ClassStatsConfig.GetSection("demoman") != null)
			{
				strcopy(buffer, bufferLen, "demoman");
			}
			else
			{
				return false;
			}
		}
		case TFClass_Heavy:
		{
			if (g_ClassStatsConfig.GetSection("heavy") != null)
			{
				strcopy(buffer, bufferLen, "heavy");
			}
			else
			{
				if (g_ClassStatsConfig.GetSection("heavyweapons") != null)
				{
					strcopy(buffer, bufferLen, "heavyweapons");
				}
				else
				{
					return false;
				}
			}
		}
		case TFClass_Engineer:
		{
			if (g_ClassStatsConfig.GetSection("engineer") != null)
			{
				strcopy(buffer, bufferLen, "engineer");
			}
			else
			{
				return false;
			}
		}
		case TFClass_Medic:
		{
			if (g_ClassStatsConfig.GetSection("medic") != null)
			{
				strcopy(buffer, bufferLen, "medic");
			}
			else
			{
				return false;
			}
		}
		case TFClass_Sniper:
		{
			if (g_ClassStatsConfig.GetSection("sniper") != null)
			{
				strcopy(buffer, bufferLen, "sniper");
			}
			else
			{
				return false;
			}
		}
		case TFClass_Spy:
		{
			if (g_ClassStatsConfig.GetSection("spy") != null)
			{
				strcopy(buffer, bufferLen, "spy");
			}
			else
			{
				return false;
			}
		}
		case TFClass_Unknown:
		{
			return false;
		}
	}
	return true;
}

static void PrecacheClassProfiles()
{
	if (!IsClassConfigsValid())
	{
		return;
	}

	for (int i = 0; i < MAX_CLASSES + 1; i++)
	{
		if (i == 0)
		{
			continue;
		}
		char className[35];
		TFClassType class = view_as<TFClassType>(i);
		GetClassProfileName(class, className, sizeof(className));
		KeyMap obj = g_ClassStatsConfig.GetSection(className);
		if (obj == null)
		{
			continue;
		}

		g_ClassRunSpeed[i] = obj.GetFloat("runspeed", ClientGetDefaultSprintSpeed(-1, class));
		g_ClassWalkSpeed[i] = obj.GetFloat("walkspeed", ClientGetDefaultWalkSpeed(-1, class));
		g_ClassDangerSpeedMultipler[i] = obj.GetFloat("danger_speed_multiplier", 1.34);
		g_ClassSprintDurationMultipler[i] = obj.GetFloat("sprint_multiplier", 1.0);
		g_ClassScareSprintDurationMultipler[i] = obj.GetFloat("scare_sprint_multiplier", 1.0);
		g_ClassSprintPointLossJumping[i] = obj.GetFloat("sprint_loss_while_jumping", 0.07);

		g_ClassProxyDamageVulnerability[i] = obj.GetFloat("proxy_damage_vulnerability");
		g_ClassCanPickUpHealth[i] = obj.GetInt("can_pickup_health", 1) != 0;
		g_ClassHealthPickupMultiplier[i] = obj.GetFloat("health_pickup_multiplier", 1.0);

		g_ClassBossPriorityMultiplier[i] = obj.GetFloat("boss_priority");
		g_ClassBossHearingSensitivity[i] = obj.GetFloat("boss_hearing_multiplier", 1.0);

		g_ClassBlinkRateMultiplier[i] = obj.GetFloat("blink_rate_multiplier", 1.0);

		g_ClassResistanceStaticIncrease[i] = obj.GetFloat("static_resistance_increase", 1.0);
		g_ClassResistanceStaticDecrease[i] = obj.GetFloat("static_resistance_decrease", 1.0);

		g_ClassUltravisionRadiusMultiplier[i] = obj.GetFloat("ultravision_radius_multiplier", 1.0);
		g_ClassUltravisionBrightnessMultiplier[i] = obj.GetFloat("ultravision_brightness_multiplier", 1.0);
		g_ClassUltravisionFadeInTimer[i] = obj.GetFloat("ultravision_fadein_timer");

		g_ClassNightvisionRadiusMultiplier[i] = obj.GetFloat("nightvision_radius_multiplier", 1.0);
		g_ClassNightvisionBrightnessMultiplier[i] = obj.GetFloat("nightvision_brightness_multiplier", 1.0);

		g_ClassFlashlightBrightness[i] = obj.GetInt("flashlight_brightness");
		g_ClassFlashlightRadius[i] = obj.GetFloat("flashlight_radius_multiplier", 1.0);
		g_ClassFlashlightLength[i] = obj.GetFloat("flashlight_length_multiplier", 1.0);
		g_ClassFlashlightDamageMultiplier[i] = obj.GetFloat("flashlight_damage_multiplier", 1.0);
		g_ClassFlashlightDrainRate[i] = obj.GetFloat("flashlight_drain_rate", 1.0);
		g_ClassFlashlightRechargeRate[i] = obj.GetFloat("flashlight_recharge_rate", 1.0);
		g_ClassFlashlightSoundRadius[i] = obj.GetFloat("flashlight_sound_radius", 0.5);

		g_ClassBlockedOnThanatophobia[i] = obj.GetInt("blocked_on_thanatophobia") != 0;

		g_ClassInvulnerableToTraps[i] = obj.GetInt("immune_to_traps") != 0;

		g_ClassMedicAddedHealthRegen[i] = obj.GetFloat("medic_add_health_regen");

		obj.ConvertValuesSectionToArray("help_info");
	}
}
