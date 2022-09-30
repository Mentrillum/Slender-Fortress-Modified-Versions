#if defined _sf2_client_music_included
 #endinput
#endif
#define _sf2_client_music_included

#pragma semicolon 1

void ClientUpdateMusicSystem(int client, bool initialize=false)
{
	int oldPageMusicMaster = EntRefToEntIndex(g_PlayerPageMusicMaster[client]);
	int oldPageMusicActiveIndex = g_PageMusicActiveIndex[client];
	int oldMusicFlags = g_PlayerMusicFlags[client];
	int chasingBoss = -1;
	int chasingSeeBoss = -1;
	int alertBoss = -1;
	int twentyDollarsBoss = -1;
	int idleBoss = -1;

	if (IsRoundEnding() || !IsClientInGame(client) || IsFakeClient(client) || DidClientEscape(client) || (g_PlayerEliminated[client] && !IsClientInGhostMode(client) && !g_PlayerProxy[client]))
	{
		g_PlayerMusicFlags[client] = 0;
		g_PlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
		g_PageMusicActiveIndex[client] = -1;

		if (MusicActive())//A boss is overriding the music.
		{
			char path[PLATFORM_MAX_PATH];
			GetBossMusic(path,sizeof(path));
			if (path[0] != '\0')
			{
				StopSound(client, MUSIC_CHAN, path);
			}
		}
	}
	else
	{
		bool playMusicOnEscape = !g_RoundStopPageMusicOnEscape;

		// Page music first.
		int pageRange = 0;

		if (g_PageMusicRanges.Length > 0) // Map has its own defined page music?
		{
			for (int i = 0, size = g_PageMusicRanges.Length; i < size; i++)
			{
				int ent = EntRefToEntIndex(g_PageMusicRanges.Get(i));
				if (!ent || ent == INVALID_ENT_REFERENCE)
				{
					continue;
				}

				int min = g_PageMusicRanges.Get(i, 1);
				int max = g_PageMusicRanges.Get(i, 2);

				if (g_PageCount >= min && g_PageCount <= max)
				{
					g_PlayerPageMusicMaster[client] = g_PageMusicRanges.Get(i);
					g_PageMusicActiveIndex[client] = i;
					break;
				}
			}
		}
		else // Nope. Use old system instead.
		{
			g_PlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
			g_PageMusicActiveIndex[client] = -1;

			float percent = g_PageMax > 0 ? (float(g_PageCount) / float(g_PageMax)) : 0.0;
			if (percent > 0.0 && percent <= 0.25)
			{
				pageRange = 1;
			}
			else if (percent > 0.25 && percent <= 0.5)
			{
				pageRange = 2;
			}
			else if (percent > 0.5 && percent <= 0.75)
			{
				pageRange = 3;
			}
			else if (percent > 0.75)
			{
				pageRange = 4;
			}

			if (pageRange == 1)
			{
				ClientAddMusicFlag(client, MUSICF_PAGES1PERCENT);
			}
			else if (pageRange == 2)
			{
				ClientAddMusicFlag(client, MUSICF_PAGES25PERCENT);
			}
			else if (pageRange == 3)
			{
				ClientAddMusicFlag(client, MUSICF_PAGES50PERCENT);
			}
			else if (pageRange == 4)
			{
				ClientAddMusicFlag(client, MUSICF_PAGES75PERCENT);
			}
		}

		if (pageRange != 1)
		{
			ClientRemoveMusicFlag(client, MUSICF_PAGES1PERCENT);
		}
		if (pageRange != 2)
		{
			ClientRemoveMusicFlag(client, MUSICF_PAGES25PERCENT);
		}
		if (pageRange != 3)
		{
			ClientRemoveMusicFlag(client, MUSICF_PAGES50PERCENT);
		}
		if (pageRange != 4)
		{
			ClientRemoveMusicFlag(client, MUSICF_PAGES75PERCENT);
		}

		if (IsRoundInEscapeObjective() && !playMusicOnEscape)
		{
			ClientRemoveMusicFlag(client, MUSICF_PAGES75PERCENT);
			g_PlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
			g_PageMusicActiveIndex[client] = -1;
		}

		int oldChasingBoss = g_PlayerChaseMusicMaster[client];
		int oldChasingSeeBoss = g_PlayerChaseMusicSeeMaster[client];
		int oldAlertBoss = g_PlayerAlertMusicMaster[client];
		int oldIdleBoss = g_PlayerIdleMusicMaster[client];
		int old20DollarsBoss = g_Player20DollarsMusicMaster[client];

		float buffer[3], buffer2[3], buffer3[3];

		char profile[SF2_MAX_PROFILE_NAME_LENGTH];

		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1)
			{
				continue;
			}

			if (NPCGetEntIndex(i) == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			NPCGetProfile(i, profile, sizeof(profile));

			int bossType = NPCGetType(i);

			switch (bossType)
			{
				case SF2BossType_Chaser:
				{
					SF2BossProfileSoundInfo soundInfo;
					ArrayList soundList;
					GetClientAbsOrigin(client, buffer);
					SlenderGetAbsOrigin(i, buffer3);

					int target = EntRefToEntIndex(g_SlenderTarget[i]);
					if (target != -1)
					{
						GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", buffer2);

						if ((g_SlenderState[i] == STATE_CHASE || g_SlenderState[i] == STATE_ATTACK || g_SlenderState[i] == STATE_STUN) &&
							!(NPCGetFlags(i) & SFF_MARKEDASFAKE))
						{
							GetChaserProfileChaseMusics(profile, soundInfo);

							if ((target == client || GetVectorSquareMagnitude(buffer, buffer2) <= SquareFloat(soundInfo.Radius) ||
							GetVectorSquareMagnitude(buffer, buffer3) <= SquareFloat(soundInfo.Radius) || GetVectorSquareMagnitude(buffer, g_SlenderGoalPos[i]) <= SquareFloat(soundInfo.Radius)))
							{
								soundList = soundInfo.Paths;
								if (soundList != null && soundList.Length > 0)
								{
									chasingBoss = i;
								}

								if ((g_SlenderState[i] == STATE_CHASE || g_SlenderState[i] == STATE_ATTACK) &&
									PlayerCanSeeSlender(client, i, false))
								{
									if (oldChasingSeeBoss == -1 || !PlayerCanSeeSlender(client, oldChasingSeeBoss, false))
									{
										GetChaserProfileChaseVisibleMusics(profile, soundInfo);
										soundList = soundInfo.Paths;
										if (soundList != null && soundList.Length > 0)
										{
											chasingSeeBoss = i;
										}
									}

									if (g_20Dollars || SF_SpecialRound(SPECIALROUND_20DOLLARS))
									{
										if (old20DollarsBoss == -1 || !PlayerCanSeeSlender(client, old20DollarsBoss, false))
										{
											GetChaserProfileTwentyDollarMusics(profile, soundInfo);
											soundList = soundInfo.Paths;

											if ((soundList != null && soundList.Length > 0) || SF_SpecialRound(SPECIALROUND_20DOLLARS))
											{
												twentyDollarsBoss = i;
											}
										}
									}
								}
							}
						}
					}

					if (g_SlenderState[i] == STATE_ALERT)
					{
						GetChaserProfileAlertMusics(profile, soundInfo);
						soundList = soundInfo.Paths;
						if (soundList == null || soundList.Length <= 0)
						{
							continue;
						}

						if (!(NPCGetFlags(i) & SFF_MARKEDASFAKE))
						{
							if (GetVectorSquareMagnitude(buffer, buffer3) <= SquareFloat(soundInfo.Radius) || GetVectorSquareMagnitude(buffer, g_SlenderGoalPos[i]) <= SquareFloat(soundInfo.Radius))
							{
								alertBoss = i;
							}
						}
					}

					if (g_SlenderState[i] == STATE_IDLE || g_SlenderState[i] == STATE_WANDER)
					{
						GetChaserProfileIdleMusics(profile, soundInfo);
						soundList = soundInfo.Paths;
						if (soundList == null || soundList.Length <= 0)
						{
							continue;
						}

						if (!(NPCGetFlags(i) & SFF_MARKEDASFAKE))
						{
							if (GetVectorSquareMagnitude(buffer, buffer3) <= SquareFloat(soundInfo.Radius) || GetVectorSquareMagnitude(buffer, g_SlenderGoalPos[i]) <= SquareFloat(soundInfo.Radius))
							{
								idleBoss = i;
							}
						}
					}
					soundList = null;
				}
			}
		}

		if (chasingBoss != oldChasingBoss)
		{
			if (chasingBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_CHASE);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_CHASE);
			}
		}

		if (chasingSeeBoss != oldChasingSeeBoss)
		{
			if (chasingSeeBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_CHASEVISIBLE);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_CHASEVISIBLE);
			}
		}

		if (alertBoss != oldAlertBoss)
		{
			if (alertBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_ALERT);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_ALERT);
			}
		}

		if (idleBoss != oldIdleBoss)
		{
			if (idleBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_IDLE);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_IDLE);
			}
		}

		if (twentyDollarsBoss != old20DollarsBoss)
		{
			if (twentyDollarsBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_20DOLLARS);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_20DOLLARS);
			}
		}
	}

	if (IsValidClient(client))
	{
		bool wasChase = ClientHasMusicFlag2(oldMusicFlags, MUSICF_CHASE);
		bool inChase = ClientHasMusicFlag(client, MUSICF_CHASE);
		bool wasChaseSee = ClientHasMusicFlag2(oldMusicFlags, MUSICF_CHASEVISIBLE);
		bool inChaseSee = ClientHasMusicFlag(client, MUSICF_CHASEVISIBLE);
		bool inAlert = ClientHasMusicFlag(client, MUSICF_ALERT);
		bool wasAlert = ClientHasMusicFlag2(oldMusicFlags, MUSICF_ALERT);
		bool inIdle = ClientHasMusicFlag(client, MUSICF_IDLE);
		bool wasIdle = ClientHasMusicFlag2(oldMusicFlags, MUSICF_IDLE);
		bool in20Dollars = ClientHasMusicFlag(client, MUSICF_20DOLLARS);
		bool was20Dollars = ClientHasMusicFlag2(oldMusicFlags, MUSICF_20DOLLARS);
		char path[PLATFORM_MAX_PATH];

		if (IsRoundEnding() || !IsClientInGame(client) || IsFakeClient(client) || DidClientEscape(client) || (g_PlayerEliminated[client] && !IsClientInGhostMode(client) && !g_PlayerProxy[client]))
		{
		}
		else if (MusicActive()) //A boss is overriding the music.
		{
			GetBossMusic(path,sizeof(path));
			ClientMusicStart(client, path, _, MUSIC_PAGE_VOLUME);
			return;
		}

		// Custom system.
		if (g_PageMusicRanges.Length > 0)
		{
			int master = EntRefToEntIndex(g_PlayerPageMusicMaster[client]);
			int pageMusicActiveIndex = g_PageMusicActiveIndex[client];

			if (pageMusicActiveIndex != oldPageMusicActiveIndex)
			{
				// Page music was changed.

				// Stop the old music.
				if (oldPageMusicActiveIndex != -1 && oldPageMusicMaster && oldPageMusicMaster != INVALID_ENT_REFERENCE)
				{
					int oldPageRangeMin = g_PageMusicRanges.Get(oldPageMusicActiveIndex, 1);

					SF2PageMusicEntity oldPageMusic = SF2PageMusicEntity(oldPageMusicMaster);
					if (oldPageMusic.IsValid())
					{
						oldPageMusic.GetRangeMusic(oldPageRangeMin, path, sizeof(path));
					}
					else
					{
						GetEntPropString(oldPageMusicMaster, Prop_Data, "m_iszSound", path, sizeof(path));
					}

					if (path[0] != '\0')
					{
						StopSound(client, MUSIC_CHAN, path);
					}
				}

				// Play new music.
				if (pageMusicActiveIndex != -1 && master && master != INVALID_ENT_REFERENCE)
				{
					int pageRangeMin = g_PageMusicRanges.Get(pageMusicActiveIndex, 1);
					int pageRangeMax = g_PageMusicRanges.Get(pageMusicActiveIndex, 2);

					SF2PageMusicEntity pageMusic = SF2PageMusicEntity(master);
					if (pageMusic.IsValid())
					{
						pageMusic.GetRangeMusic(g_PageCount, path, sizeof(path));
					}
					else
					{
						GetEntPropString(master, Prop_Data, "m_iszSound", path, sizeof(path));
					}

					// Play the new music.
					if (path[0] == '\0')
					{
						LogError("Could not play music of page range %d - %d: no valid sound path specified!", pageRangeMin, pageRangeMax);
					}
					else
					{
						ClientMusicStart(client, path, _, MUSIC_PAGE_VOLUME, inChase || inAlert);
					}
				}
			}
		}
		else
		{
			// Old system.
			if ((initialize || ClientHasMusicFlag2(oldMusicFlags, MUSICF_PAGES1PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES1PERCENT))
			{
				StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES1_SOUND);
			}
			else if ((initialize || !ClientHasMusicFlag2(oldMusicFlags, MUSICF_PAGES1PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES1PERCENT))
			{
				ClientMusicStart(client, MUSIC_GOTPAGES1_SOUND, _, MUSIC_PAGE_VOLUME, inChase || inAlert || inIdle);
			}

			if ((initialize || ClientHasMusicFlag2(oldMusicFlags, MUSICF_PAGES25PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES25PERCENT))
			{
				StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES2_SOUND);
			}
			else if ((initialize || !ClientHasMusicFlag2(oldMusicFlags, MUSICF_PAGES25PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES25PERCENT))
			{
				ClientMusicStart(client, MUSIC_GOTPAGES2_SOUND, _, MUSIC_PAGE_VOLUME, inChase || inAlert || inIdle);
			}

			if ((initialize || ClientHasMusicFlag2(oldMusicFlags, MUSICF_PAGES50PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES50PERCENT))
			{
				StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES3_SOUND);
			}
			else if ((initialize || !ClientHasMusicFlag2(oldMusicFlags, MUSICF_PAGES50PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES50PERCENT))
			{
				ClientMusicStart(client, MUSIC_GOTPAGES3_SOUND, _, MUSIC_PAGE_VOLUME, inChase || inAlert || inIdle);
			}

			if ((initialize || ClientHasMusicFlag2(oldMusicFlags, MUSICF_PAGES75PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES75PERCENT))
			{
				StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES4_SOUND);
			}
			else if ((initialize || !ClientHasMusicFlag2(oldMusicFlags, MUSICF_PAGES75PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES75PERCENT))
			{
				ClientMusicStart(client, MUSIC_GOTPAGES4_SOUND, _, MUSIC_PAGE_VOLUME, inChase || inAlert || inIdle);
			}
		}

		int mainMusicState = 0;

		if (inIdle != wasIdle || idleBoss != g_PlayerIdleMusicMaster[client])
		{
			if (inIdle && !inAlert && !inChase)
			{
				ClientIdleMusicStart(client, idleBoss);
				if (!wasIdle)
				{
					mainMusicState = -1;
				}
			}
			else
			{
				ClientIdleMusicStop(client, g_PlayerIdleMusicMaster[client]);
				if (!inChase && !inAlert && wasIdle)
				{
					mainMusicState = 1;
				}
			}
		}

		if (inAlert != wasAlert || alertBoss != g_PlayerAlertMusicMaster[client])
		{
			if (inAlert && !inChase)
			{
				ClientAlertMusicStart(client, alertBoss);
				if (!wasAlert)
				{
					mainMusicState = -1;
				}
			}
			else
			{
				ClientAlertMusicStop(client, g_PlayerAlertMusicMaster[client]);
				if (!inChase && wasAlert)
				{
					mainMusicState = 1;
				}
			}
		}

		if (inChase != wasChase || chasingBoss != g_PlayerChaseMusicMaster[client])
		{
			if (inChase)
			{
				ClientMusicChaseStart(client, chasingBoss);

				if (!wasChase)
				{
					mainMusicState = -1;

					if (inAlert)
					{
						ClientAlertMusicStop(client, g_PlayerAlertMusicMaster[client]);
					}
					else if (inIdle)
					{
						ClientIdleMusicStop(client, g_PlayerIdleMusicMaster[client]);
					}
				}
			}
			else
			{
				ClientMusicChaseStop(client, g_PlayerChaseMusicMaster[client]);
				if (wasChase)
				{
					if (inAlert)
					{
						ClientAlertMusicStart(client, alertBoss);
					}
					else if (inIdle)
					{
						ClientIdleMusicStart(client, idleBoss);
					}
					else
					{
						mainMusicState = 1;
					}
				}
			}
		}

		if (inChaseSee != wasChaseSee || chasingSeeBoss != g_PlayerChaseMusicSeeMaster[client])
		{
			if (inChaseSee)
			{
				ClientMusicChaseSeeStart(client, chasingSeeBoss);
			}
			else
			{
				ClientMusicChaseSeeStop(client, g_PlayerChaseMusicSeeMaster[client]);
			}
		}

		if (in20Dollars != was20Dollars || twentyDollarsBoss != g_Player20DollarsMusicMaster[client])
		{
			if (in20Dollars)
			{
				Client20DollarsMusicStart(client, twentyDollarsBoss);
			}
			else
			{
				Client20DollarsMusicStop(client, g_Player20DollarsMusicMaster[client]);
			}
		}

		if (mainMusicState == 1)
		{
			ClientMusicStart(client, g_PlayerMusicString[client], _, MUSIC_PAGE_VOLUME, inChase || inAlert || inIdle);
		}
		else if (mainMusicState == -1)
		{
			ClientMusicStop(client);
		}

		if (inChase || inAlert) //Lets not add an idle variable, this whole if statement just adds stress.
		{
			int bossToUse = -1;
			if (inChase)
			{
				bossToUse = chasingBoss;
			}
			else
			{
				bossToUse = alertBoss;
			}

			if (bossToUse != -1)
			{
				// We got some alert/chase music going on! The player's excitement will no doubt go up!
				// Excitement, though, really depends on how close the boss is in relation to the
				// player.

				float bossDist = NPCGetDistanceFromEntity(bossToUse, client);
				float scalar = (bossDist / SquareFloat(700.0));
				if (scalar > 1.0)
				{
					scalar = 1.0;
				}
				float stressAdd = 0.1 * (1.0 - scalar);

				ClientAddStress(client, stressAdd);
			}
		}
	}
}

void ClientMusicReset(int client)
{
	char oldMusic[PLATFORM_MAX_PATH];
	strcopy(oldMusic, sizeof(oldMusic), g_PlayerMusicString[client]);
	g_PlayerMusicString[client][0] = '\0';
	if (IsValidClient(client) && oldMusic[0] != '\0')
	{
		StopSound(client, MUSIC_CHAN, oldMusic);
	}

	g_PlayerMusicFlags[client] = 0;
	g_PlayerMusicVolume[client] = 0.0;
	g_PlayerMusicTargetVolume[client] = 0.0;

	g_PlayerMusicTimer[client] = null;
	g_PlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
	g_PageMusicActiveIndex[client] = -1;
}

void ClientMusicStart(int client, const char[] newMusic, float volume=-1.0, float targetVolume=-1.0, bool copyOnly=false)
{
	if (!IsValidClient(client))
	{
		return;
	}
	if (newMusic[0] == '\0')
	{
		return;
	}

	char oldMusic[PLATFORM_MAX_PATH];
	strcopy(oldMusic, sizeof(oldMusic), g_PlayerMusicString[client]);

	if (strcmp(oldMusic, newMusic, false) != 0 && oldMusic[0] != '\0')
	{
		StopSound(client, MUSIC_CHAN, oldMusic);
	}
	strcopy(g_PlayerMusicString[client], sizeof(g_PlayerMusicString[]), newMusic);
	if (MusicActive())//A boss is overriding the music.
	{
		GetBossMusic(g_PlayerMusicString[client],sizeof(g_PlayerMusicString[]));
	}
	if (volume >= 0.0)
	{
		g_PlayerMusicVolume[client] = volume;
	}
	if (targetVolume >= 0.0)
	{
		g_PlayerMusicTargetVolume[client] = targetVolume;
	}

	if (!copyOnly)
	{
		bool playMusicOnEscape = !g_RoundStopPageMusicOnEscape;

		if (g_PageCount < g_PageMax || playMusicOnEscape)
		{
			g_PlayerMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeInMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			TriggerTimer(g_PlayerMusicTimer[client], true);
		}
	}
	else
	{
		g_PlayerMusicTimer[client] = null;
	}
}

void ClientMusicStop(int client)
{
	g_PlayerMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeOutMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerMusicTimer[client], true);
}

void Client20DollarsMusicReset(int client)
{
	g_Player20DollarsMusicMaster[client] = -1;
	g_Player20DollarsMusicOldMaster[client] = -1;
	ClientRemoveMusicFlag(client, MUSICF_20DOLLARS);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_Player20DollarsMusicTimer[client][i] = null;
		g_Player20DollarsMusicVolumes[client][i] = 0.0;
		g_Player20DollarsMusicString[client][i][0] = '\0';

		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				StopSound(client, MUSIC_CHAN, TWENTYDOLLARS_MUSIC);
				NPCGetProfile(i, profile, sizeof(profile));

				SF2BossProfileSoundInfo soundInfo;
				GetChaserProfileTwentyDollarMusics(profile, soundInfo);
				soundInfo.StopAllSounds(client);
			}
		}
	}
}

void Client20DollarsMusicStart(int client,int bossIndex)
{
	if (!IsValidClient(client))
	{
		return;
	}

	int oldMaster = g_Player20DollarsMusicMaster[client];
	if (oldMaster == bossIndex)
	{
		return;
	}

	g_Player20DollarsMusicOldMaster[client] = oldMaster;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char buffer[PLATFORM_MAX_PATH];
	SF2BossProfileSoundInfo soundInfo;
	GetChaserProfileTwentyDollarMusics(profile, soundInfo);
	if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
	{
		soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, sizeof(buffer));
	}

	if (SF_SpecialRound(SPECIALROUND_20DOLLARS))
	{
		if (buffer[0] == '\0')
		{
			buffer = TWENTYDOLLARS_MUSIC;
		}
	}
	else
	{
		if (buffer[0] == '\0')
		{
			return;
		}
	}

	g_Player20DollarsMusicMaster[client] = bossIndex;
	if (g_Player20DollarsMusicVolumes[client][bossIndex] <= 0.0)
	{
		strcopy(g_Player20DollarsMusicString[client][bossIndex], sizeof(g_Player20DollarsMusicString[][]), buffer);
	}
	if (oldMaster != -1 && g_Player20DollarsMusicString[client][oldMaster][0] != '\0' &&
		strcmp(g_Player20DollarsMusicString[client][oldMaster], g_Player20DollarsMusicString[client][bossIndex]) == 0)
	{
		if (g_Player20DollarsMusicVolumes[client][bossIndex] < 1.0)
		{
			g_Player20DollarsMusicVolumes[client][bossIndex] = g_Player20DollarsMusicVolumes[client][oldMaster];
			g_Player20DollarsMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeIn20DollarsMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			TriggerTimer(g_Player20DollarsMusicTimer[client][bossIndex], true);
		}
		return;
	}
	g_Player20DollarsMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeIn20DollarsMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_Player20DollarsMusicTimer[client][bossIndex], true);

	if (oldMaster != -1)
	{
		ClientAlertMusicStop(client, oldMaster);
		ClientIdleMusicStop(client, oldMaster);
	}
}

void Client20DollarsMusicStop(int client,int bossIndex)
{
	if (!IsValidClient(client))
	{
		return;
	}
	if (bossIndex == -1)
	{
		return;
	}

	if (bossIndex == g_Player20DollarsMusicMaster[client])
	{
		g_Player20DollarsMusicMaster[client] = -1;
	}

	g_Player20DollarsMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeOut20DollarsMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_Player20DollarsMusicTimer[client][bossIndex], true);
}

void ClientAlertMusicReset(int client)
{
	g_PlayerAlertMusicMaster[client] = -1;
	g_PlayerAlertMusicOldMaster[client] = -1;
	ClientRemoveMusicFlag(client, MUSICF_ALERT);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_PlayerAlertMusicTimer[client][i] = null;
		g_PlayerAlertMusicVolumes[client][i] = 0.0;
		g_PlayerAlertMusicString[client][i][0] = '\0';

		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, profile, sizeof(profile));

				SF2BossProfileSoundInfo soundInfo;
				GetChaserProfileAlertMusics(profile, soundInfo);
				soundInfo.StopAllSounds(client);
			}
		}
	}
}

void ClientAlertMusicStart(int client,int bossIndex)
{
	if (!IsValidClient(client))
	{
		return;
	}

	int oldMaster = g_PlayerAlertMusicMaster[client];
	if (oldMaster == bossIndex)
	{
		return;
	}

	g_PlayerAlertMusicOldMaster[client] = oldMaster;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char buffer[PLATFORM_MAX_PATH];
	SF2BossProfileSoundInfo soundInfo;
	GetChaserProfileAlertMusics(profile, soundInfo);
	if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
	{
		soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, sizeof(buffer));
	}

	if (buffer[0] == '\0')
	{
		return;
	}

	g_PlayerAlertMusicMaster[client] = bossIndex;
	if (g_PlayerAlertMusicVolumes[client][bossIndex] <= 0.0)
	{
		strcopy(g_PlayerAlertMusicString[client][bossIndex], sizeof(g_PlayerAlertMusicString[][]), buffer);
	}
	if (oldMaster != -1 && g_PlayerAlertMusicString[client][oldMaster][0] != '\0' &&
		strcmp(g_PlayerAlertMusicString[client][oldMaster], g_PlayerAlertMusicString[client][bossIndex]) == 0)
	{
		if (g_PlayerAlertMusicVolumes[client][bossIndex] < 1.0)
		{
			g_PlayerAlertMusicVolumes[client][bossIndex] = g_PlayerAlertMusicVolumes[client][oldMaster];
			g_PlayerAlertMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeInAlertMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			TriggerTimer(g_PlayerAlertMusicTimer[client][bossIndex], true);
		}
		return;
	}
	g_PlayerAlertMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeInAlertMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerAlertMusicTimer[client][bossIndex], true);

	if (oldMaster != -1)
	{
		ClientAlertMusicStop(client, oldMaster);
	}
}

void ClientAlertMusicStop(int client,int bossIndex)
{
	if (!IsValidClient(client))
	{
		return;
	}
	if (bossIndex == -1)
	{
		return;
	}

	if (bossIndex == g_PlayerAlertMusicMaster[client])
	{
		g_PlayerAlertMusicMaster[client] = -1;
	}

	g_PlayerAlertMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutAlertMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerAlertMusicTimer[client][bossIndex], true);
}

void ClientIdleMusicReset(int client)
{
	g_PlayerIdleMusicMaster[client] = -1;
	g_PlayerIdleMusicOldMaster[client] = -1;
	ClientRemoveMusicFlag(client, MUSICF_IDLE);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_PlayerIdleMusicTimer[client][i] = null;
		g_PlayerIdleMusicVolumes[client][i] = 0.0;
		g_PlayerIdleMusicString[client][i][0] = '\0';

		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, profile, sizeof(profile));

				SF2BossProfileSoundInfo soundInfo;
				GetChaserProfileIdleMusics(profile, soundInfo);
				soundInfo.StopAllSounds(client);
			}
		}
	}
}

void ClientIdleMusicStart(int client,int bossIndex)
{
	if (!IsValidClient(client))
	{
		return;
	}

	int oldMaster = g_PlayerIdleMusicMaster[client];
	if (oldMaster == bossIndex)
	{
		return;
	}

	g_PlayerIdleMusicOldMaster[client] = oldMaster;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char buffer[PLATFORM_MAX_PATH];
	SF2BossProfileSoundInfo soundInfo;
	GetChaserProfileIdleMusics(profile, soundInfo);
	if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
	{
		soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, sizeof(buffer));
	}

	if (buffer[0] == '\0')
	{
		return;
	}

	g_PlayerIdleMusicMaster[client] = bossIndex;
	if (g_PlayerIdleMusicVolumes[client][bossIndex] <= 0.0 && strcmp(buffer, g_PlayerIdleMusicString[client][bossIndex], true) != 0)
	{
		strcopy(g_PlayerIdleMusicString[client][bossIndex], sizeof(g_PlayerIdleMusicString[][]), buffer);
	}
	if (oldMaster != -1 && g_PlayerIdleMusicString[client][oldMaster][0] != '\0' &&
		strcmp(g_PlayerIdleMusicString[client][oldMaster], g_PlayerIdleMusicString[client][bossIndex]) == 0)
	{
		if (g_PlayerIdleMusicVolumes[client][bossIndex] < 1.0)
		{
			g_PlayerIdleMusicVolumes[client][bossIndex] = g_PlayerIdleMusicVolumes[client][oldMaster];
			g_PlayerIdleMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeInIdleMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			TriggerTimer(g_PlayerIdleMusicTimer[client][bossIndex], true);
		}
		return;
	}
	g_PlayerIdleMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeInIdleMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerIdleMusicTimer[client][bossIndex], true);

	if (oldMaster != -1)
	{
		ClientIdleMusicStop(client, oldMaster);
	}
}

void ClientIdleMusicStop(int client,int bossIndex)
{
	if (!IsValidClient(client))
	{
		return;
	}
	if (bossIndex == -1)
	{
		return;
	}

	if (bossIndex == g_PlayerIdleMusicMaster[client])
	{
		g_PlayerIdleMusicMaster[client] = -1;
	}

	g_PlayerIdleMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutIdleMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerIdleMusicTimer[client][bossIndex], true);
}

void ClientChaseMusicReset(int client)
{
	g_PlayerChaseMusicMaster[client] = -1;
	g_PlayerChaseMusicOldMaster[client] = -1;
	ClientRemoveMusicFlag(client, MUSICF_CHASE);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_PlayerChaseMusicVolumes[client][i] = 0.0;
		g_PlayerChaseMusicTimer[client][i] = null;
		g_PlayerChaseMusicString[client][i][0] = '\0';

		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, profile, sizeof(profile));

				SF2BossProfileSoundInfo soundInfo;
				GetChaserProfileChaseMusics(profile, soundInfo);
				soundInfo.StopAllSounds(client);
			}
		}
	}
}

void ClientMusicChaseStart(int client,int bossIndex)
{
	if (!IsValidClient(client))
	{
		return;
	}

	int oldMaster = g_PlayerChaseMusicMaster[client];
	if (oldMaster == bossIndex)
	{
		return;
	}

	g_PlayerChaseMusicOldMaster[client] = oldMaster;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char buffer[PLATFORM_MAX_PATH];
	SF2BossProfileSoundInfo soundInfo;
	GetChaserProfileChaseMusics(profile, soundInfo);
	if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
	{
		soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, sizeof(buffer));
	}

	if (buffer[0] == '\0')
	{
		return;
	}

	g_PlayerChaseMusicMaster[client] = bossIndex;
	if (g_PlayerChaseMusicVolumes[client][bossIndex] <= 0.0)
	{
		strcopy(g_PlayerChaseMusicString[client][bossIndex], sizeof(g_PlayerChaseMusicString[][]), buffer);
	}
	if (oldMaster != -1 && g_PlayerChaseMusicString[client][oldMaster][0] != '\0' &&
		strcmp(g_PlayerChaseMusicString[client][oldMaster], g_PlayerChaseMusicString[client][bossIndex]) == 0)
	{
		if (g_PlayerChaseMusicVolumes[client][bossIndex] < 1.0)
		{
			g_PlayerChaseMusicVolumes[client][bossIndex] = g_PlayerChaseMusicVolumes[client][oldMaster];
			g_PlayerChaseMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeInChaseMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			TriggerTimer(g_PlayerChaseMusicTimer[client][bossIndex], true);
		}
		return;
	}
	if (MusicActive())//A boss is overriding the music.
	{
		GetBossMusic(g_PlayerChaseMusicString[client][bossIndex],sizeof(g_PlayerChaseMusicString[][]));
	}
	g_PlayerChaseMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeInChaseMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerChaseMusicTimer[client][bossIndex], true);

	if (oldMaster != -1)
	{
		ClientMusicChaseStop(client, oldMaster);
	}
}

void ClientMusicChaseStop(int client,int bossIndex)
{
	if (!IsClientInGame(client))
	{
		return;
	}
	if (bossIndex == -1)
	{
		return;
	}

	if (bossIndex == g_PlayerChaseMusicMaster[client])
	{
		g_PlayerChaseMusicMaster[client] = -1;
	}

	g_PlayerChaseMusicTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutChaseMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerChaseMusicTimer[client][bossIndex], true);
}

void ClientChaseMusicSeeReset(int client)
{
	g_PlayerChaseMusicSeeMaster[client] = -1;
	g_PlayerChaseMusicSeeOldMaster[client] = -1;
	ClientRemoveMusicFlag(client, MUSICF_CHASEVISIBLE);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_PlayerChaseMusicSeeTimer[client][i] = null;
		g_PlayerChaseMusicSeeVolumes[client][i] = 0.0;
		g_PlayerChaseMusicSeeString[client][i][0] = '\0';

		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, profile, sizeof(profile));

				SF2BossProfileSoundInfo soundInfo;
				GetChaserProfileChaseVisibleMusics(profile, soundInfo);
				soundInfo.StopAllSounds(client);
			}
		}
	}
}

void ClientMusicChaseSeeStart(int client,int bossIndex)
{
	if (!IsClientInGame(client))
	{
		return;
	}

	int oldMaster = g_PlayerChaseMusicSeeMaster[client];
	if (oldMaster == bossIndex)
	{
		return;
	}

	g_PlayerChaseMusicSeeOldMaster[client] = oldMaster;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char buffer[PLATFORM_MAX_PATH];
	SF2BossProfileSoundInfo soundInfo;
	GetChaserProfileChaseVisibleMusics(profile, soundInfo);
	if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
	{
		soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, sizeof(buffer));
	}

	if (buffer[0] == '\0')
	{
		return;
	}

	g_PlayerChaseMusicSeeMaster[client] = bossIndex;
	if (g_PlayerChaseMusicSeeVolumes[client][bossIndex] <= 0.0)
	{
		strcopy(g_PlayerChaseMusicSeeString[client][bossIndex], sizeof(g_PlayerChaseMusicSeeString[][]), buffer);
	}
	if (oldMaster != -1 && g_PlayerChaseMusicSeeString[client][oldMaster][0] != '\0' &&
		strcmp(g_PlayerChaseMusicSeeString[client][oldMaster], g_PlayerChaseMusicSeeString[client][bossIndex]) == 0)
	{
		if (g_PlayerChaseMusicSeeVolumes[client][bossIndex] < 1.0)
		{
			g_PlayerChaseMusicSeeVolumes[client][bossIndex] = g_PlayerChaseMusicSeeVolumes[client][oldMaster];
			g_PlayerChaseMusicSeeTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeInChaseMusicSee, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			TriggerTimer(g_PlayerChaseMusicSeeTimer[client][bossIndex], true);
		}
		return;
	}
	g_PlayerChaseMusicSeeTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeInChaseMusicSee, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerChaseMusicSeeTimer[client][bossIndex], true);

	if (oldMaster != -1)
	{
		ClientMusicChaseSeeStop(client, oldMaster);
	}
}

void ClientMusicChaseSeeStop(int client,int bossIndex)
{
	if (!IsClientInGame(client))
	{
		return;
	}
	if (bossIndex == -1)
	{
		return;
	}

	if (bossIndex == g_PlayerChaseMusicSeeMaster[client])
	{
		g_PlayerChaseMusicSeeMaster[client] = -1;
	}

	g_PlayerChaseMusicSeeTimer[client][bossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutChaseMusicSee, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerChaseMusicSeeTimer[client][bossIndex], true);
}

void Client90sMusicReset(int client)
{
	char oldMusic[PLATFORM_MAX_PATH];
	strcopy(oldMusic, sizeof(oldMusic), g_Player90sMusicString[client]);
	g_Player90sMusicString[client][0] = '\0';
	if (IsValidClient(client) && oldMusic[0] != '\0')
	{
		StopSound(client, MUSIC_CHAN, oldMusic);
	}

	g_Player90sMusicTimer[client] = null;
	g_Player90sMusicVolumes[client] = 0.0;

	if (IsValidClient(client))
	{
		oldMusic = NINETYSMUSIC;
		if (oldMusic[0] != '\0')
		{
			StopSound(client, MUSIC_CHAN, oldMusic);
		}
	}
}

void Client90sMusicStart(int client)
{
	if (!IsValidClient(client))
	{
		return;
	}

	char buffer[PLATFORM_MAX_PATH];
	buffer = NINETYSMUSIC;

	if (buffer[0] == '\0')
	{
		return;
	}

	strcopy(g_Player90sMusicString[client], sizeof(g_Player90sMusicString[]), buffer);
	g_Player90sMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeIn90sMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_Player90sMusicTimer[client], true);
}

void Client90sMusicStop(int client)
{
	if (!IsValidClient(client))
	{
		return;
	}

	if (!IsClientSprinting(client))
	{
		g_Player90sMusicString[client][0] = '\0';
	}

	g_Player90sMusicTimer[client]= CreateTimer(0.01, Timer_PlayerFadeOut90sMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_Player90sMusicTimer[client], true);
}

Action Timer_PlayerFadeInMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerMusicTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerMusicVolume[client] += 0.07;
	if (g_PlayerMusicVolume[client] > g_PlayerMusicTargetVolume[client])
	{
		g_PlayerMusicVolume[client] = g_PlayerMusicTargetVolume[client];
	}

	if (g_PlayerMusicString[client][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerMusicString[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, g_PlayerMusicVolume[client], 100);
	}

	if (g_PlayerMusicVolume[client] >= g_PlayerMusicTargetVolume[client])
	{
		g_PlayerMusicTimer[client] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeOutMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerMusicTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerMusicVolume[client] -= 0.07;
	if (g_PlayerMusicVolume[client] < 0.0)
	{
		g_PlayerMusicVolume[client] = 0.0;
	}

	if (g_PlayerMusicString[client][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerMusicString[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, g_PlayerMusicVolume[client], 100);
	}

	if (g_PlayerMusicVolume[client] <= 0.0)
	{
		g_PlayerMusicTimer[client] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeIn20DollarsMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_Player20DollarsMusicTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	/*int oldBoss = g_Player20DollarsMusicOldMaster[client];

	if (oldBoss != -1 && bossIndex != oldBoss && strcmp(g_Player20DollarsMusicString[client][bossIndex], g_Player20DollarsMusicString[client][oldBoss], false) == 0)
	{
		g_Player20DollarsMusicTimer[client][bossIndex] = null;
		g_Player20DollarsMusicVolumes[client][bossIndex] = 1.0;
		return Plugin_Stop;
	}*/

	g_Player20DollarsMusicVolumes[client][bossIndex] += 0.07;
	if (g_Player20DollarsMusicVolumes[client][bossIndex] > 1.0)
	{
		g_Player20DollarsMusicVolumes[client][bossIndex] = 1.0;
	}

	if (g_Player20DollarsMusicString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_Player20DollarsMusicString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_Player20DollarsMusicVolumes[client][bossIndex], 100);
	}

	if (g_Player20DollarsMusicVolumes[client][bossIndex] >= 1.0)
	{
		g_Player20DollarsMusicTimer[client][bossIndex] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeOut20DollarsMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_Player20DollarsMusicTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	int oldBoss = g_Player20DollarsMusicOldMaster[client];
	int newBoss = g_Player20DollarsMusicMaster[client];

	if (oldBoss != -1 && newBoss != -1 && newBoss != oldBoss && strcmp(g_Player20DollarsMusicString[client][newBoss], g_Player20DollarsMusicString[client][oldBoss], false) == 0)
	{
		g_Player20DollarsMusicTimer[client][oldBoss] = null;
		g_Player20DollarsMusicString[client][oldBoss][0] = '\0';
		g_Player20DollarsMusicVolumes[client][oldBoss] = 0.0;
		g_Player20DollarsMusicOldMaster[client] = -1;
		return Plugin_Stop;
	}

	g_Player20DollarsMusicVolumes[client][bossIndex] -= 0.07;
	if (g_Player20DollarsMusicVolumes[client][bossIndex] < 0.0)
	{
		g_Player20DollarsMusicVolumes[client][bossIndex] = 0.0;
	}

	if (g_Player20DollarsMusicString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_Player20DollarsMusicString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_Player20DollarsMusicVolumes[client][bossIndex], 100);
	}

	if (g_Player20DollarsMusicVolumes[client][bossIndex] <= 0.0)
	{
		g_Player20DollarsMusicTimer[client][bossIndex] = null;
		g_Player20DollarsMusicString[client][bossIndex][0] = '\0';
		g_Player20DollarsMusicOldMaster[client] = -1;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeInAlertMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_PlayerAlertMusicTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	/*int oldBoss = g_PlayerAlertMusicOldMaster[client];

	if (oldBoss != -1 && bossIndex != oldBoss && strcmp(g_PlayerAlertMusicString[client][bossIndex], g_PlayerAlertMusicString[client][oldBoss], false) == 0)
	{
		g_PlayerAlertMusicTimer[client][bossIndex] = null;
		g_PlayerAlertMusicVolumes[client][bossIndex] = 1.0;
		return Plugin_Stop;
	}*/

	g_PlayerAlertMusicVolumes[client][bossIndex] += 0.07;
	if (g_PlayerAlertMusicVolumes[client][bossIndex] > 1.0)
	{
		g_PlayerAlertMusicVolumes[client][bossIndex] = 1.0;
	}

	if (g_PlayerAlertMusicString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerAlertMusicString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_PlayerAlertMusicVolumes[client][bossIndex], 100);
	}

	if (g_PlayerAlertMusicVolumes[client][bossIndex] >= 1.0)
	{
		g_PlayerAlertMusicTimer[client][bossIndex] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeOutAlertMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_PlayerAlertMusicTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	int oldBoss = g_PlayerAlertMusicOldMaster[client];
	int newBoss = g_PlayerAlertMusicMaster[client];

	if (oldBoss != -1 && newBoss != -1 && newBoss != oldBoss && strcmp(g_PlayerAlertMusicString[client][newBoss], g_PlayerAlertMusicString[client][oldBoss], false) == 0)
	{
		g_PlayerAlertMusicTimer[client][oldBoss] = null;
		g_PlayerAlertMusicString[client][oldBoss][0] = '\0';
		g_PlayerAlertMusicVolumes[client][oldBoss] = 0.0;
		g_PlayerAlertMusicOldMaster[client] = -1;
		return Plugin_Stop;
	}

	g_PlayerAlertMusicVolumes[client][bossIndex] -= 0.07;
	if (g_PlayerAlertMusicVolumes[client][bossIndex] < 0.0)
	{
		g_PlayerAlertMusicVolumes[client][bossIndex] = 0.0;
	}

	if (g_PlayerAlertMusicString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerAlertMusicString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_PlayerAlertMusicVolumes[client][bossIndex], 100);
	}

	if (g_PlayerAlertMusicVolumes[client][bossIndex] <= 0.0)
	{
		g_PlayerAlertMusicTimer[client][bossIndex] = null;
		g_PlayerAlertMusicString[client][bossIndex][0] = '\0';
		g_PlayerAlertMusicOldMaster[client] = -1;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeInIdleMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_PlayerIdleMusicTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	/*int oldBoss = g_PlayerIdleMusicOldMaster[client];

	if (oldBoss != -1 && bossIndex != oldBoss && strcmp(g_PlayerIdleMusicString[client][bossIndex], g_PlayerIdleMusicString[client][oldBoss], false) == 0)
	{
		g_PlayerIdleMusicTimer[client][bossIndex] = null;
		g_PlayerIdleMusicVolumes[client][bossIndex] = 1.0;
		return Plugin_Stop;
	}*/

	g_PlayerIdleMusicVolumes[client][bossIndex] += 0.07;
	if (g_PlayerIdleMusicVolumes[client][bossIndex] > 1.0)
	{
		g_PlayerIdleMusicVolumes[client][bossIndex] = 1.0;
	}

	if (g_PlayerIdleMusicString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerIdleMusicString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_PlayerIdleMusicVolumes[client][bossIndex], 100);
	}

	if (g_PlayerIdleMusicVolumes[client][bossIndex] >= 1.0)
	{
		g_PlayerIdleMusicTimer[client][bossIndex] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeOutIdleMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_PlayerIdleMusicTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	int oldBoss = g_PlayerIdleMusicOldMaster[client];
	int newBoss = g_PlayerIdleMusicMaster[client];

	if (oldBoss != -1 && newBoss != -1 && newBoss != oldBoss && strcmp(g_PlayerIdleMusicString[client][newBoss], g_PlayerIdleMusicString[client][oldBoss], false) == 0)
	{
		g_PlayerIdleMusicTimer[client][oldBoss] = null;
		g_PlayerIdleMusicString[client][oldBoss][0] = '\0';
		g_PlayerIdleMusicVolumes[client][oldBoss] = 0.0;
		g_PlayerIdleMusicOldMaster[client] = -1;
		return Plugin_Stop;
	}

	g_PlayerIdleMusicVolumes[client][bossIndex] -= 0.07;
	if (g_PlayerIdleMusicVolumes[client][bossIndex] < 0.0)
	{
		g_PlayerIdleMusicVolumes[client][bossIndex] = 0.0;
	}

	if (g_PlayerIdleMusicString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerIdleMusicString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_PlayerIdleMusicVolumes[client][bossIndex], 100);
	}

	if (g_PlayerIdleMusicVolumes[client][bossIndex] <= 0.0)
	{
		g_PlayerIdleMusicTimer[client][bossIndex] = null;
		g_PlayerIdleMusicString[client][bossIndex][0] = '\0';
		g_PlayerIdleMusicOldMaster[client] = -1;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeInChaseMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_PlayerChaseMusicTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	/*int oldBoss = g_PlayerChaseMusicOldMaster[client];

	if (oldBoss != -1 && bossIndex != oldBoss && strcmp(g_PlayerChaseMusicString[client][bossIndex], g_PlayerChaseMusicString[client][oldBoss], false) == 0)
	{
		g_PlayerChaseMusicTimer[client][bossIndex] = null;
		g_PlayerChaseMusicVolumes[client][bossIndex] = 1.0;
		return Plugin_Stop;
	}*/

	g_PlayerChaseMusicVolumes[client][bossIndex] += 0.07;
	if (g_PlayerChaseMusicVolumes[client][bossIndex] > 1.0)
	{
		g_PlayerChaseMusicVolumes[client][bossIndex] = 1.0;
	}

	if (g_PlayerChaseMusicString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerChaseMusicString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_PlayerChaseMusicVolumes[client][bossIndex], 100);
	}

	if (g_PlayerChaseMusicVolumes[client][bossIndex] >= 1.0)
	{
		g_PlayerChaseMusicTimer[client][bossIndex] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeInChaseMusicSee(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_PlayerChaseMusicSeeTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	/*int oldBoss = g_PlayerChaseMusicSeeOldMaster[client];

	if (oldBoss != -1 && bossIndex != oldBoss && strcmp(g_PlayerChaseMusicSeeString[client][bossIndex], g_PlayerChaseMusicSeeString[client][oldBoss], false) == 0)
	{
		g_PlayerChaseMusicSeeTimer[client][bossIndex] = null;
		g_PlayerChaseMusicSeeVolumes[client][bossIndex] = 1.0;
		return Plugin_Stop;
	}*/

	g_PlayerChaseMusicSeeVolumes[client][bossIndex] += 0.07;
	if (g_PlayerChaseMusicSeeVolumes[client][bossIndex] > 1.0)
	{
		g_PlayerChaseMusicSeeVolumes[client][bossIndex] = 1.0;
	}

	if (g_PlayerChaseMusicSeeString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerChaseMusicSeeString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_PlayerChaseMusicSeeVolumes[client][bossIndex], 100);
	}

	if (g_PlayerChaseMusicSeeVolumes[client][bossIndex] >= 1.0)
	{
		g_PlayerChaseMusicSeeTimer[client][bossIndex] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeOutChaseMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_PlayerChaseMusicTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	int oldBoss = g_PlayerChaseMusicOldMaster[client];
	int newBoss = g_PlayerChaseMusicMaster[client];

	if (oldBoss != -1 && newBoss != -1 && newBoss != oldBoss && strcmp(g_PlayerChaseMusicString[client][newBoss], g_PlayerChaseMusicString[client][oldBoss], false) == 0)
	{
		g_PlayerChaseMusicTimer[client][oldBoss] = null;
		g_PlayerChaseMusicString[client][oldBoss][0] = '\0';
		g_PlayerChaseMusicVolumes[client][oldBoss] = 0.0;
		g_PlayerChaseMusicOldMaster[client] = -1;
		return Plugin_Stop;
	}

	g_PlayerChaseMusicVolumes[client][bossIndex] -= 0.07;
	if (g_PlayerChaseMusicVolumes[client][bossIndex] < 0.0)
	{
		g_PlayerChaseMusicVolumes[client][bossIndex] = 0.0;
	}

	if (g_PlayerChaseMusicString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerChaseMusicString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_PlayerChaseMusicVolumes[client][bossIndex], 100);
	}

	if (g_PlayerChaseMusicVolumes[client][bossIndex] <= 0.0)
	{
		g_PlayerChaseMusicTimer[client][bossIndex] = null;
		g_PlayerChaseMusicString[client][bossIndex][0] = '\0';
		g_PlayerChaseMusicOldMaster[client] = -1;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeOutChaseMusicSee(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int bossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_PlayerChaseMusicSeeTimer[client][i] == timer)
		{
			bossIndex = i;
			break;
		}
	}

	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	int oldBoss = g_PlayerChaseMusicSeeOldMaster[client];
	int newBoss = g_PlayerChaseMusicSeeMaster[client];

	if (oldBoss != -1 && newBoss != -1 && newBoss != oldBoss && strcmp(g_PlayerChaseMusicSeeString[client][newBoss], g_PlayerChaseMusicSeeString[client][oldBoss], false) == 0)
	{
		g_PlayerChaseMusicSeeTimer[client][oldBoss] = null;
		g_PlayerChaseMusicSeeString[client][oldBoss][0] = '\0';
		g_PlayerChaseMusicSeeVolumes[client][oldBoss] = 0.0;
		g_PlayerChaseMusicSeeOldMaster[client] = -1;
		return Plugin_Stop;
	}

	g_PlayerChaseMusicSeeVolumes[client][bossIndex] -= 0.07;
	if (g_PlayerChaseMusicSeeVolumes[client][bossIndex] < 0.0)
	{
		g_PlayerChaseMusicSeeVolumes[client][bossIndex] = 0.0;
	}

	if (g_PlayerChaseMusicSeeString[client][bossIndex][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerChaseMusicSeeString[client][bossIndex], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_PlayerChaseMusicSeeVolumes[client][bossIndex], 100);
	}

	if (g_PlayerChaseMusicSeeVolumes[client][bossIndex] <= 0.0)
	{
		g_PlayerChaseMusicSeeTimer[client][bossIndex] = null;
		g_PlayerChaseMusicSeeString[client][bossIndex][0] = '\0';
		g_PlayerChaseMusicSeeOldMaster[client] = -1;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeIn90sMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (g_Player90sMusicTimer[client] != timer)
	{
		return Plugin_Stop;
	}

	g_Player90sMusicVolumes[client] += 0.28;
	if (g_Player90sMusicVolumes[client] > 0.5)
	{
		g_Player90sMusicVolumes[client] = 0.5;
	}

	if (g_Player90sMusicString[client][0] != '\0')
	{
		EmitSoundToClient(client, g_Player90sMusicString[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_Player90sMusicVolumes[client], 100);
	}

	if (g_Player90sMusicVolumes[client] >= 0.5)
	{
		g_Player90sMusicTimer[client] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_PlayerFadeOut90sMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (g_Player90sMusicTimer[client] != timer)
	{
		return Plugin_Stop;
	}

	char buffer[PLATFORM_MAX_PATH];
	buffer = NINETYSMUSIC;

	if (strcmp(buffer, g_Player90sMusicString[client], false) == 0)
	{
		g_Player90sMusicTimer[client] = null;
		return Plugin_Stop;
	}

	g_Player90sMusicVolumes[client] -= 0.28;
	if (g_Player90sMusicVolumes[client] < 0.0)
	{
		g_Player90sMusicVolumes[client] = 0.0;
	}

	if (buffer[0] != '\0')
	{
		EmitSoundToClient(client, buffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_Player90sMusicVolumes[client], 100);
	}

	if (g_Player90sMusicVolumes[client] <= 0.0)
	{
		g_Player90sMusicTimer[client] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

bool ClientHasMusicFlag(int client,int flag)
{
	return view_as<bool>(g_PlayerMusicFlags[client] & flag);
}

bool ClientHasMusicFlag2(int iValue,int flag)
{
	return view_as<bool>(iValue & flag);
}

void ClientAddMusicFlag(int client,int flag)
{
	if (!ClientHasMusicFlag(client, flag))
	{
		g_PlayerMusicFlags[client] |= flag;
	}
}

void ClientRemoveMusicFlag(int client,int flag)
{
	if (ClientHasMusicFlag(client, flag))
	{
		g_PlayerMusicFlags[client] &= ~flag;
	}
}
