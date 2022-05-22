#if defined _sf2_client_classconfigs_included
 #endinput
#endif
#define _sf2_client_classconfigs_included

float g_ClassRunSpeed[MAX_CLASSES + 1];
float g_ClassWalkSpeed[MAX_CLASSES + 1];
float g_ClassDangerSpeedMultipler[MAX_CLASSES + 1];
float g_ClassSprintDurationMultipler[MAX_CLASSES + 1];
float g_ClassScareSprintDurationMultipler[MAX_CLASSES + 1];
int g_ClassSprintPointLossJumping[MAX_CLASSES + 1];

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

void ReloadClassConfigs()
{
	if (g_ClassStatsConfig != null)
	{
		delete g_ClassStatsConfig;
		g_ClassStatsConfig = null;
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
	}
	else
	{
		g_ClassStatsConfig = kv;
		LogSF2Message("Reloaded class stats configuration file successfully");
	}
	PrecacheClassProfiles();
}

bool IsClassConfigsValid()
{
    return g_ClassStatsConfig == null ? false : true;
}

int GetClassStatNum(const char[] class, const char[] keyValue, int defaultValue = 0)
{
    g_ClassStatsConfig.Rewind();
    g_ClassStatsConfig.JumpToKey(class);

    return g_ClassStatsConfig.GetNum(keyValue, defaultValue);
}

float GetClassStatFloat(const char[] class, const char[] keyValue, float defaultValue = 0.0)
{
    g_ClassStatsConfig.Rewind();
    g_ClassStatsConfig.JumpToKey(class);

    return g_ClassStatsConfig.GetFloat(keyValue, defaultValue);
}

bool GetClassProfileName(TFClassType class, char[] buffer,int bufferLen)
{
	if (!IsClassConfigsValid())
	{
		return false;
	}
	g_RestrictedWeaponsConfig.Rewind();

	switch (class)
	{
		case TFClass_Scout:
		{
			if (g_RestrictedWeaponsConfig.JumpToKey("scout"))
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
			if (g_RestrictedWeaponsConfig.JumpToKey("soldier"))
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
			if (g_RestrictedWeaponsConfig.JumpToKey("pyro"))
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
			if (g_RestrictedWeaponsConfig.JumpToKey("demoman"))
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
			if (g_RestrictedWeaponsConfig.JumpToKey("heavy"))
			{
				strcopy(buffer, bufferLen, "heavy");
			}
			else
			{
				g_RestrictedWeaponsConfig.Rewind();
				if (g_RestrictedWeaponsConfig.JumpToKey("heavyweapons"))
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
			if (g_RestrictedWeaponsConfig.JumpToKey("engineer"))
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
			if (g_RestrictedWeaponsConfig.JumpToKey("medic"))
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
			if (g_RestrictedWeaponsConfig.JumpToKey("sniper"))
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
			if (g_RestrictedWeaponsConfig.JumpToKey("spy"))
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

void PrecacheClassProfiles()
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

		g_ClassRunSpeed[i] = GetClassStatFloat(className, "runspeed", ClientGetDefaultSprintSpeed(-1, class));
		g_ClassWalkSpeed[i] = GetClassStatFloat(className, "walkspeed", ClientGetDefaultWalkSpeed(-1, class));
		g_ClassDangerSpeedMultipler[i] = GetClassStatFloat(className, "danger_speed_multiplier", 1.34);
		g_ClassSprintDurationMultipler[i] = GetClassStatFloat(className, "sprint_multiplier", 1.0);
		g_ClassScareSprintDurationMultipler[i] = GetClassStatFloat(className, "scare_sprint_multiplier", 1.0);
		g_ClassSprintPointLossJumping[i] = GetClassStatNum(className, "sprint_loss_while_jumping", 7);

		g_ClassProxyDamageVulnerability[i] = GetClassStatFloat(className, "proxy_damage_vulnerability");
		g_ClassCanPickUpHealth[i] = view_as<bool>(GetClassStatNum(className, "can_pickup_health", 1));
		g_ClassHealthPickupMultiplier[i] = GetClassStatFloat(className, "health_pickup_multiplier", 1.0);

		g_ClassBossPriorityMultiplier[i] = GetClassStatFloat(className, "boss_priority");
		g_ClassBossHearingSensitivity[i] = GetClassStatFloat(className, "boss_hearing_multiplier", 1.0);
		
		g_ClassBlinkRateMultiplier[i] = GetClassStatFloat(className, "blink_rate_multiplier", 1.0);

		g_ClassResistanceStaticIncrease[i] = GetClassStatFloat(className, "static_resistance_increase", 1.0);
		g_ClassResistanceStaticDecrease[i] = GetClassStatFloat(className, "static_resistance_decrease", 1.0);

		g_ClassUltravisionRadiusMultiplier[i] = GetClassStatFloat(className, "ultravision_radius_multiplier", 1.0);
		g_ClassUltravisionBrightnessMultiplier[i] = GetClassStatFloat(className, "ultravision_brightness_multiplier", 1.0);
		g_ClassUltravisionFadeInTimer[i] = GetClassStatFloat(className, "ultravision_fadein_timer");

		g_ClassNightvisionRadiusMultiplier[i] = GetClassStatFloat(className, "nightvision_radius_multiplier", 1.0);
		g_ClassNightvisionBrightnessMultiplier[i] = GetClassStatFloat(className, "nightvision_brightness_multiplier", 1.0);

		g_ClassFlashlightBrightness[i] = GetClassStatNum(className, "flashlight_brightness");
		g_ClassFlashlightRadius[i] = GetClassStatFloat(className, "flashlight_radius_multiplier", 1.0);
		g_ClassFlashlightLength[i] = GetClassStatFloat(className, "flashlight_length_multiplier", 1.0);
		g_ClassFlashlightDamageMultiplier[i] = GetClassStatFloat(className, "flashlight_damage_multiplier", 1.0);
		g_ClassFlashlightDrainRate[i] = GetClassStatFloat(className, "flashlight_drain_rate", 1.0);
		g_ClassFlashlightRechargeRate[i] = GetClassStatFloat(className, "flashlight_recharge_rate", 1.0);
		g_ClassFlashlightSoundRadius[i] = GetClassStatFloat(className, "flashlight_sound_radius", 0.5);

		g_ClassBlockedOnThanatophobia[i] = view_as<bool>(GetClassStatNum(className, "blocked_on_thanatophobia"));

		g_ClassInvulnerableToTraps[i] = view_as<bool>(GetClassStatNum(className, "immune_to_traps"));
	}
}
