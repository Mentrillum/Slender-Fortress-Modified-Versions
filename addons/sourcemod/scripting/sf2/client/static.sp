#pragma semicolon 1

// Player static data.
int g_PlayerStaticMode[MAXTF2PLAYERS][MAX_BOSSES];
float g_PlayerStaticIncreaseRate[MAXTF2PLAYERS];
float g_PlayerStaticDecreaseRate[MAXTF2PLAYERS];
Handle g_PlayerStaticTimer[MAXTF2PLAYERS];
int g_PlayerStaticMaster[MAXTF2PLAYERS] = { -1, ... };
char g_PlayerStaticSound[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
char g_PlayerLastStaticSound[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
float g_PlayerLastStaticTime[MAXTF2PLAYERS];
float g_PlayerLastStaticVolume[MAXTF2PLAYERS];
Handle g_PlayerLastStaticTimer[MAXTF2PLAYERS];

// Static shake data.
int g_PlayerStaticShakeMaster[MAXTF2PLAYERS];
bool g_PlayerInStaticShake[MAXTF2PLAYERS];
char g_PlayerStaticShakeSound[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
float g_PlayerStaticShakeMinVolume[MAXTF2PLAYERS];
float g_PlayerStaticShakeMaxVolume[MAXTF2PLAYERS];

void SetupStatic()
{
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnBossRemovedPFwd.AddFunction(null, OnBossRemoved);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	ClientResetStatic(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		ClientResetStatic(client.index);
	}
}

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	ClientResetStatic(client.index);

	SDKHook(client.index, SDKHook_PreThink, Hook_StaticThink);
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetStatic(client.index);
}

static void OnBossRemoved(SF2NPC_BaseNPC npc)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		if (npc.UniqueID == g_PlayerStaticMaster[i])
		{
			g_PlayerStaticMaster[i] = -1;

			// No one is the static master.
			g_PlayerStaticTimer[i] = CreateTimer(g_PlayerStaticDecreaseRate[i],
				Timer_ClientDecreaseStatic,
				GetClientUserId(i),
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

			TriggerTimer(g_PlayerStaticTimer[i], true);
		}
	}
}

void ClientResetStatic(int client)
{
	g_PlayerStaticMaster[client] = -1;
	g_PlayerStaticTimer[client] = null;
	g_PlayerStaticIncreaseRate[client] = 0.0;
	g_PlayerStaticDecreaseRate[client] = 0.0;
	g_PlayerLastStaticTimer[client] = null;
	g_PlayerLastStaticTime[client] = 0.0;
	g_PlayerLastStaticVolume[client] = 0.0;
	g_PlayerInStaticShake[client] = false;
	g_PlayerStaticShakeMaster[client] = -1;
	g_PlayerStaticShakeMinVolume[client] = 0.0;
	g_PlayerStaticShakeMaxVolume[client] = 0.0;
	g_PlayerStaticAmount[client] = 0.0;

	if (IsValidClient(client))
	{
		if (g_PlayerStaticSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerStaticSound[client]);
		}
		if (g_PlayerLastStaticSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
		}
		if (g_PlayerStaticShakeSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerStaticShakeSound[client]);
		}
	}

	g_PlayerStaticSound[client][0] = '\0';
	g_PlayerLastStaticSound[client][0] = '\0';
	g_PlayerStaticShakeSound[client][0] = '\0';
}

// Static shaking should only affect the x, y portion of the player's view, not roll.
// This is purely for cosmetic effect.

void ClientProcessStaticShake(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client))
	{
		return;
	}

	bool oldStaticShake = g_PlayerInStaticShake[client];
	int oldStaticShakeMaster = NPCGetFromUniqueID(g_PlayerStaticShakeMaster[client]);
	int newStaticShakeMaster = -1;

	float oldPunchAng[3], oldPunchAngVel[3];
	GetEntDataVector(client, g_PlayerPunchAngleOffset, oldPunchAng);
	GetEntDataVector(client, g_PlayerPunchAngleOffsetVel, oldPunchAngVel);

	float newPunchAng[3], newPunchAngVel[3];

	for (int i = 0; i < 3; i++)
	{
		newPunchAng[i] = oldPunchAng[i];
		newPunchAngVel[i] = oldPunchAngVel[i];
	}

	int staticMaster = NPCGetFromUniqueID(g_PlayerStaticMaster[client]);
	if (staticMaster != -1 && NPCGetFlags(staticMaster) & SFF_HASSTATICSHAKE)
	{
		if (g_PlayerStaticMode[client][staticMaster] == Static_Increase)
		{
			newStaticShakeMaster = staticMaster;
		}
	}
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}

		if (NPCGetFlags(i) & SFF_HASSTATICSHAKE)
		{
			int master = NPCGetFromUniqueID(g_SlenderCopyMaster[i]);
			if (master == -1)
			{
				master = i;
			}
		}
	}

	if (newStaticShakeMaster != -1)
	{
		g_PlayerStaticShakeMaster[client] = NPCGetUniqueID(newStaticShakeMaster);

		if (newStaticShakeMaster != oldStaticShakeMaster)
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(newStaticShakeMaster, profile, sizeof(profile));

			if (g_PlayerStaticShakeSound[client][0] != '\0')
			{
				StopSound(client, SNDCHAN_STATIC, g_PlayerStaticShakeSound[client]);
			}

			g_PlayerStaticShakeMinVolume[client] = GetBossProfileStaticShakeLocalVolumeMin(profile);
			g_PlayerStaticShakeMaxVolume[client] = GetBossProfileStaticShakeLocalVolumeMax(profile);

			char staticSound[PLATFORM_MAX_PATH];
			GetBossProfileStaticShakeSound(profile, staticSound, sizeof(staticSound));
			if (staticSound[0] != '\0')
			{
				strcopy(g_PlayerStaticShakeSound[client], sizeof(g_PlayerStaticShakeSound[]), staticSound);
			}
			else
			{
				g_PlayerStaticShakeSound[client][0] = '\0';
			}
		}
	}

	if (g_PlayerInStaticShake[client])
	{
		if (g_PlayerStaticAmount[client] <= 0.0)
		{
			g_PlayerInStaticShake[client] = false;
		}
	}
	else
	{
		if (newStaticShakeMaster != -1)
		{
			g_PlayerInStaticShake[client] = true;
		}
	}

	if (g_PlayerInStaticShake[client] && !oldStaticShake)
	{
		for (int i = 0; i < 2; i++)
		{
			newPunchAng[i] = 0.0;
			newPunchAngVel[i] = 0.0;
		}

		SetEntDataVector(client, g_PlayerPunchAngleOffset, newPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, newPunchAngVel, true);
	}
	else if (!g_PlayerInStaticShake[client] && oldStaticShake)
	{
		for (int i = 0; i < 2; i++)
		{
			newPunchAng[i] = 0.0;
			newPunchAngVel[i] = 0.0;
		}

		g_PlayerStaticShakeMaster[client] = -1;

		if (g_PlayerStaticShakeSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerStaticShakeSound[client]);
		}

		g_PlayerStaticShakeSound[client][0] = '\0';

		g_PlayerStaticShakeMinVolume[client] = 0.0;
		g_PlayerStaticShakeMaxVolume[client] = 0.0;

		SetEntDataVector(client, g_PlayerPunchAngleOffset, newPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, newPunchAngVel, true);
	}

	if (g_PlayerInStaticShake[client])
	{
		if (g_PlayerStaticShakeSound[client][0] != '\0')
		{
			float volume = g_PlayerStaticAmount[client];
			if (GetRandomFloat(0.0, 1.0) <= 0.35)
			{
				volume = 0.0;
			}
			else
			{
				if (volume < g_PlayerStaticShakeMinVolume[client])
				{
					volume = g_PlayerStaticShakeMinVolume[client];
				}

				if (volume > g_PlayerStaticShakeMaxVolume[client])
				{
					volume = g_PlayerStaticShakeMaxVolume[client];
				}
			}

			EmitSoundToClient(client, g_PlayerStaticShakeSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL | SND_STOP, volume);
		}

		// Spazz our view all over the place.
		for (int i = 0; i < 2; i++)
		{
			newPunchAng[i] = AngleNormalize(GetRandomFloat(0.0, 360.0));
		}
		NormalizeVector(newPunchAng, newPunchAng);

		float angVelocityScalar = 5.0 * g_PlayerStaticAmount[client];
		if (angVelocityScalar < 0.0)
		{
			angVelocityScalar = 0.0;
		}
		ScaleVector(newPunchAng, angVelocityScalar);

		for (int i = 0; i < 2; i++)
		{
			newPunchAngVel[i] = 0.0;
		}

		SetEntDataVector(client, g_PlayerPunchAngleOffset, newPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, newPunchAngVel, true);
	}
}

static void Hook_StaticThink(int client)
{
	if (!g_Enabled)
	{
		return;
	}
	SF2_BasePlayer player = SF2_BasePlayer(client);

	if (g_IsPlayerShakeEnabled)
	{
		bool doShake = false;

		if (player.IsAlive)
		{
			int staticMaster = NPCGetFromUniqueID(g_PlayerStaticMaster[player.index]);
			if (staticMaster != -1 && NPCGetFlags(staticMaster) & SFF_HASVIEWSHAKE)
			{
				doShake = true;
			}
		}

		if (doShake)
		{
			float percent = g_PlayerStaticAmount[player.index];

			float amplitudeMax = g_PlayerShakeAmplitudeMaxConVar.FloatValue;
			float amplitude = amplitudeMax * percent;

			float frequencyMax = g_PlayerShakeFrequencyMaxConVar.FloatValue;
			float frequency = frequencyMax * percent;

			UTIL_ClientScreenShake(player.index, amplitude, 0.5, frequency);
		}
	}
}

Action Timer_ClientIncreaseStatic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerStaticTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerStaticAmount[client] += 0.05;
	if (g_PlayerStaticAmount[client] > 1.0)
	{
		g_PlayerStaticAmount[client] = 1.0;
	}

	if (g_PlayerStaticSound[client][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, g_PlayerStaticAmount[client]);

		if (g_PlayerStaticAmount[client] >= 0.5)
		{
			ClientAddStress(client, 0.03);
		}
		else
		{
			ClientAddStress(client, 0.02);
		}
	}

	return Plugin_Continue;
}

Action Timer_ClientDecreaseStatic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerStaticTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerStaticAmount[client] -= 0.05;
	if (g_PlayerStaticAmount[client] < 0.0)
	{
		g_PlayerStaticAmount[client] = 0.0;
	}

	if (g_PlayerLastStaticSound[client][0] != '\0')
	{
		float volume = g_PlayerStaticAmount[client];
		if (volume > 0.0)
		{
			EmitSoundToClient(client, g_PlayerLastStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, volume);
		}
	}

	if (g_PlayerStaticAmount[client] <= 0.0)
	{
		// I've done my job; no point to keep on doing it.
		if (g_PlayerLastStaticSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
		}
		g_PlayerStaticTimer[client] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_ClientFadeOutLastStaticSound(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerLastStaticTimer[client])
	{
		return Plugin_Stop;
	}

	if (strcmp(g_PlayerLastStaticSound[client], g_PlayerStaticSound[client], false) == 0)
	{
		// Wait, the player's current static sound is the same one we're stopping. Abort!
		g_PlayerLastStaticTimer[client] = null;
		return Plugin_Stop;
	}

	if (g_PlayerLastStaticSound[client][0] != '\0')
	{
		float diff = (GetGameTime() - g_PlayerLastStaticTime[client]) / 1.0;
		if (diff > 1.0)
		{
			diff = 1.0;
		}

		float volume = g_PlayerLastStaticVolume[client] - diff;
		if (volume < 0.0)
		{
			volume = 0.0;
		}

		if (volume <= 0.0)
		{
			// I've done my job; no point to keep on doing it.
			StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
			g_PlayerLastStaticTimer[client] = null;
			return Plugin_Stop;
		}
		else
		{
			EmitSoundToClient(client, g_PlayerLastStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, volume);
		}
	}
	else
	{
		// I've done my job; no point to keep on doing it.
		g_PlayerLastStaticTimer[client] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}
