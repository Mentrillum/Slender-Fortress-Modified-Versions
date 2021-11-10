#if defined _sf2_client_music_included
 #endinput
#endif
#define _sf2_client_music_included

stock void ClientUpdateMusicSystem(int client, bool bInitialize=false)
{
	int iOldPageMusicMaster = EntRefToEntIndex(g_iPlayerPageMusicMaster[client]);
	int iOldPageMusicActiveIndex = g_iPageMusicActiveIndex[client];
	int iOldMusicFlags = g_iPlayerMusicFlags[client];
	int iChasingBoss = -1;
	int iChasingSeeBoss = -1;
	int iAlertBoss = -1;
	int i20DollarsBoss = -1;
	
	if (IsRoundEnding() || !IsClientInGame(client) || IsFakeClient(client) || DidClientEscape(client) || (g_bPlayerEliminated[client] && !IsClientInGhostMode(client) && !g_bPlayerProxy[client]) || SF_SpecialRound(SPECIALROUND_REALISM)) 
	{
		g_iPlayerMusicFlags[client] = 0;
		g_iPlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
		g_iPageMusicActiveIndex[client] = -1;

		if (MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))//A boss is overriding the music.
		{
			char sPath[PLATFORM_MAX_PATH];
			GetBossMusic(sPath,sizeof(sPath));
			StopSound(client, MUSIC_CHAN, sPath);
			if (SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				StopSound(client, MUSIC_CHAN, TRIPLEBOSSESMUSIC);
			}
		}
	}
	else
	{
		bool bPlayMusicOnEscape = !g_bRoundStopPageMusicOnEscape;

		// Page music first.
		int iPageRange = 0;
		
		if (g_hPageMusicRanges.Length > 0) // Map has its own defined page music?
		{
			for (int i = 0, iSize = g_hPageMusicRanges.Length; i < iSize; i++)
			{
				int ent = EntRefToEntIndex(g_hPageMusicRanges.Get(i));
				if (!ent || ent == INVALID_ENT_REFERENCE) continue;
				
				int iMin = g_hPageMusicRanges.Get(i, 1);
				int iMax = g_hPageMusicRanges.Get(i, 2);
				
				if (g_iPageCount >= iMin && g_iPageCount <= iMax)
				{
					g_iPlayerPageMusicMaster[client] = g_hPageMusicRanges.Get(i);
					g_iPageMusicActiveIndex[client] = i;
					break;
				}
			}
		}
		else // Nope. Use old system instead.
		{
			g_iPlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
			g_iPageMusicActiveIndex[client] = -1;
		
			float flPercent = g_iPageMax > 0 ? (float(g_iPageCount) / float(g_iPageMax)) : 0.0;
			if (flPercent > 0.0 && flPercent <= 0.25) iPageRange = 1;
			else if (flPercent > 0.25 && flPercent <= 0.5) iPageRange = 2;
			else if (flPercent > 0.5 && flPercent <= 0.75) iPageRange = 3;
			else if (flPercent > 0.75) iPageRange = 4;
			
			if (iPageRange == 1) ClientAddMusicFlag(client, MUSICF_PAGES1PERCENT);
			else if (iPageRange == 2) ClientAddMusicFlag(client, MUSICF_PAGES25PERCENT);
			else if (iPageRange == 3) ClientAddMusicFlag(client, MUSICF_PAGES50PERCENT);
			else if (iPageRange == 4) ClientAddMusicFlag(client, MUSICF_PAGES75PERCENT);
		}
		
		if (iPageRange != 1) ClientRemoveMusicFlag(client, MUSICF_PAGES1PERCENT);
		if (iPageRange != 2) ClientRemoveMusicFlag(client, MUSICF_PAGES25PERCENT);
		if (iPageRange != 3) ClientRemoveMusicFlag(client, MUSICF_PAGES50PERCENT);
		if (iPageRange != 4) ClientRemoveMusicFlag(client, MUSICF_PAGES75PERCENT);
		
		if (IsRoundInEscapeObjective() && !bPlayMusicOnEscape) 
		{
			ClientRemoveMusicFlag(client, MUSICF_PAGES75PERCENT);
			g_iPlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
			g_iPageMusicActiveIndex[client] = -1;
		}
		
		int iOldChasingBoss = g_iPlayerChaseMusicMaster[client];
		int iOldChasingSeeBoss = g_iPlayerChaseMusicSeeMaster[client];
		int iOldAlertBoss = g_iPlayerAlertMusicMaster[client];
		int iOld20DollarsBoss = g_iPlayer20DollarsMusicMaster[client];

		float flAnger = -1.0;
		float flSeeAnger = -1.0;
		float flAlertAnger = -1.0;
		float fl20DollarsAnger = -1.0;
		
		float flBuffer[3], flBuffer2[3], flBuffer3[3];
		
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		
		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1) continue;
			
			if (NPCGetEntIndex(i) == INVALID_ENT_REFERENCE) continue;
			
			NPCGetProfile(i, sProfile, sizeof(sProfile));
			
			int iBossType = NPCGetType(i);
			
			switch (iBossType)
			{
				case SF2BossType_Chaser:
				{
					GetClientAbsOrigin(client, flBuffer);
					SlenderGetAbsOrigin(i, flBuffer3);
					
					int iTarget = EntRefToEntIndex(g_iSlenderTarget[i]);
					if (iTarget != -1)
					{
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flBuffer2);
						
						if ((g_iSlenderState[i] == STATE_CHASE || g_iSlenderState[i] == STATE_ATTACK || g_iSlenderState[i] == STATE_STUN) &&
							!(NPCGetFlags(i) & SFF_MARKEDASFAKE) && 
							(iTarget == client || GetVectorSquareMagnitude(flBuffer, flBuffer2) <= SquareFloat(850.0) || GetVectorSquareMagnitude(flBuffer, flBuffer3) <= SquareFloat(850.0) || GetVectorSquareMagnitude(flBuffer, g_flSlenderGoalPos[i]) <= SquareFloat(850.0)))
						{
							static char sPath[PLATFORM_MAX_PATH];
							GetRandomStringFromProfile(sProfile, "sound_chase_music", sPath, sizeof(sPath), 1);
							if (sPath[0])
							{
								if (NPCGetAnger(i) > flAnger)
								{
									flAnger = NPCGetAnger(i);
									iChasingBoss = i;
								}
							}
							
							if ((g_iSlenderState[i] == STATE_CHASE || g_iSlenderState[i] == STATE_ATTACK) &&
								PlayerCanSeeSlender(client, i, false))
							{
								if (iOldChasingSeeBoss == -1 || !PlayerCanSeeSlender(client, iOldChasingSeeBoss, false) || (NPCGetAnger(i) > flSeeAnger))
								{
									GetRandomStringFromProfile(sProfile, "sound_chase_visible", sPath, sizeof(sPath), 1);
									
									if (sPath[0])
									{
										flSeeAnger = NPCGetAnger(i);
										iChasingSeeBoss = i;
									}
								}
								
								if (g_b20Dollars || SF_SpecialRound(SPECIALROUND_20DOLLARS))
								{
									if (iOld20DollarsBoss == -1 || !PlayerCanSeeSlender(client, iOld20DollarsBoss, false) || (NPCGetAnger(i) > fl20DollarsAnger))
									{
										if (!GetRandomStringFromProfile(sProfile, "sound_20dollars_music", sPath, sizeof(sPath), 1))
										GetRandomStringFromProfile(sProfile, "sound_20dollars", sPath, sizeof(sPath), 1);
										
										if (sPath[0] || SF_SpecialRound(SPECIALROUND_20DOLLARS))
										{
											fl20DollarsAnger = NPCGetAnger(i);
											i20DollarsBoss = i;
										}
									}
								}
							}
						}
					}
					
					if (g_iSlenderState[i] == STATE_ALERT)
					{
						char sPath[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(sProfile, "sound_alert_music", sPath, sizeof(sPath), 1);
						if (!sPath[0]) continue;
					
						if (!(NPCGetFlags(i) & SFF_MARKEDASFAKE))
						{
							if (GetVectorSquareMagnitude(flBuffer, flBuffer3) <= SquareFloat(850.0) || GetVectorSquareMagnitude(flBuffer, g_flSlenderGoalPos[i]) <= SquareFloat(850.0))
							{
								if (NPCGetAnger(i) > flAlertAnger)
								{
									flAlertAnger = NPCGetAnger(i);
									iAlertBoss = i;
								}
							}
						}
					}
				}
			}
		}
		
		if (iChasingBoss != iOldChasingBoss)
		{
			if (iChasingBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_CHASE);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_CHASE);
			}
		}
		
		if (iChasingSeeBoss != iOldChasingSeeBoss)
		{
			if (iChasingSeeBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_CHASEVISIBLE);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_CHASEVISIBLE);
			}
		}
		
		if (iAlertBoss != iOldAlertBoss)
		{
			if (iAlertBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_ALERT);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_ALERT);
			}
		}
		
		if (i20DollarsBoss != iOld20DollarsBoss)
		{
			if (i20DollarsBoss != -1)
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
		bool bWasChase = ClientHasMusicFlag2(iOldMusicFlags, MUSICF_CHASE);
		bool bChase = ClientHasMusicFlag(client, MUSICF_CHASE);
		bool bWasChaseSee = ClientHasMusicFlag2(iOldMusicFlags, MUSICF_CHASEVISIBLE);
		bool bChaseSee = ClientHasMusicFlag(client, MUSICF_CHASEVISIBLE);
		bool bAlert = ClientHasMusicFlag(client, MUSICF_ALERT);
		bool bWasAlert = ClientHasMusicFlag2(iOldMusicFlags, MUSICF_ALERT);
		bool b20Dollars = ClientHasMusicFlag(client, MUSICF_20DOLLARS);
		bool bWas20Dollars = ClientHasMusicFlag2(iOldMusicFlags, MUSICF_20DOLLARS);
		char sPath[PLATFORM_MAX_PATH];

		if (IsRoundEnding() || !IsClientInGame(client) || IsFakeClient(client) || DidClientEscape(client) || (g_bPlayerEliminated[client] && !IsClientInGhostMode(client) && !g_bPlayerProxy[client])) 
		{
		}
		else if (MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES)) //A boss is overriding the music.
		{
			if (!SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				GetBossMusic(sPath,sizeof(sPath));
				ClientMusicStart(client, sPath, _, MUSIC_PAGE_VOLUME);
				return;
			}
			else
			{
				ClientMusicStart(client, TRIPLEBOSSESMUSIC, _, 0.8);
				return;
			}
		}

		// Custom system.
		if (g_hPageMusicRanges.Length > 0) 
		{
			int iMaster = EntRefToEntIndex(g_iPlayerPageMusicMaster[client]);
			int iPageMusicActiveIndex = g_iPageMusicActiveIndex[client];

			if (iPageMusicActiveIndex != iOldPageMusicActiveIndex)
			{
				// Page music was changed.

				// Stop the old music.
				if (iOldPageMusicActiveIndex != -1 && iOldPageMusicMaster && iOldPageMusicMaster != INVALID_ENT_REFERENCE)
				{
					int iOldPageRangeMin = g_hPageMusicRanges.Get(iOldPageMusicActiveIndex, 1);

					SF2PageMusicEntity oldPageMusic = SF2PageMusicEntity(iOldPageMusicMaster);
					if (oldPageMusic.IsValid())
						oldPageMusic.GetRangeMusic(iOldPageRangeMin, sPath, sizeof(sPath));
					else
						GetEntPropString(iOldPageMusicMaster, Prop_Data, "m_iszSound", sPath, sizeof(sPath));

					if (sPath[0] != '\0') 
						StopSound(client, MUSIC_CHAN, sPath);
				}
				
				// Play new music.
				if (iPageMusicActiveIndex != -1 && iMaster && iMaster != INVALID_ENT_REFERENCE)
				{
					int iPageRangeMin = g_hPageMusicRanges.Get(iPageMusicActiveIndex, 1);
					int iPageRangeMax = g_hPageMusicRanges.Get(iPageMusicActiveIndex, 2);

					SF2PageMusicEntity pageMusic = SF2PageMusicEntity(iMaster);
					if (pageMusic.IsValid())
					{
						pageMusic.GetRangeMusic(g_iPageCount, sPath, sizeof(sPath));
					}
					else
					{
						GetEntPropString(iMaster, Prop_Data, "m_iszSound", sPath, sizeof(sPath));
					}

					// Play the new music.
					if (sPath[0] == '\0')
					{
						LogError("Could not play music of page range %d - %d: no valid sound path specified!", iPageRangeMin, iPageRangeMax);
					}
					else
					{
						ClientMusicStart(client, sPath, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
					}
				}
			}
		}
		else
		{
			// Old system.
			if ((bInitialize || ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES1PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES1PERCENT))
			{
				StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES1_SOUND);
			}
			else if ((bInitialize || !ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES1PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES1PERCENT))
			{
				ClientMusicStart(client, MUSIC_GOTPAGES1_SOUND, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
			}
			
			if ((bInitialize || ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES25PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES25PERCENT))
			{
				StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES2_SOUND);
			}
			else if ((bInitialize || !ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES25PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES25PERCENT))
			{
				ClientMusicStart(client, MUSIC_GOTPAGES2_SOUND, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
			}
			
			if ((bInitialize || ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES50PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES50PERCENT))
			{
				StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES3_SOUND);
			}
			else if ((bInitialize || !ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES50PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES50PERCENT))
			{
				ClientMusicStart(client, MUSIC_GOTPAGES3_SOUND, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
			}
			
			if ((bInitialize || ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES75PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES75PERCENT))
			{
				StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES4_SOUND);
			}
			else if ((bInitialize || !ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES75PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES75PERCENT))
			{
				ClientMusicStart(client, MUSIC_GOTPAGES4_SOUND, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
			}
		}
		
		int iMainMusicState = 0;
		
		if (bAlert != bWasAlert || iAlertBoss != g_iPlayerAlertMusicMaster[client])
		{
			if (bAlert && !bChase)
			{
				ClientAlertMusicStart(client, iAlertBoss);
				if (!bWasAlert) iMainMusicState = -1;
			}
			else
			{
				ClientAlertMusicStop(client, g_iPlayerAlertMusicMaster[client]);
				if (!bChase && bWasAlert) iMainMusicState = 1;
			}
		}
		
		if (bChase != bWasChase || iChasingBoss != g_iPlayerChaseMusicMaster[client])
		{
			if (bChase)
			{
				ClientMusicChaseStart(client, iChasingBoss);
				
				if (!bWasChase)
				{
					iMainMusicState = -1;
					
					if (bAlert)
					{
						ClientAlertMusicStop(client, g_iPlayerAlertMusicMaster[client]);
					}
				}
			}
			else
			{
				ClientMusicChaseStop(client, g_iPlayerChaseMusicMaster[client]);
				if (bWasChase)
				{
					if (bAlert)
					{
						ClientAlertMusicStart(client, iAlertBoss);
					}
					else
					{
						iMainMusicState = 1;
					}
				}
			}
		}
		
		if (bChaseSee != bWasChaseSee || iChasingSeeBoss != g_iPlayerChaseMusicSeeMaster[client])
		{
			if (bChaseSee)
			{
				ClientMusicChaseSeeStart(client, iChasingSeeBoss);
			}
			else
			{
				ClientMusicChaseSeeStop(client, g_iPlayerChaseMusicSeeMaster[client]);
			}
		}
		
		if (b20Dollars != bWas20Dollars || i20DollarsBoss != g_iPlayer20DollarsMusicMaster[client])
		{
			if (b20Dollars)
			{
				Client20DollarsMusicStart(client, i20DollarsBoss);
			}
			else
			{
				Client20DollarsMusicStop(client, g_iPlayer20DollarsMusicMaster[client]);
			}
		}
		
		if (iMainMusicState == 1)
		{
			ClientMusicStart(client, g_strPlayerMusic[client], _, MUSIC_PAGE_VOLUME, bChase || bAlert);
		}
		else if (iMainMusicState == -1)
		{
			ClientMusicStop(client);
		}
		
		if (bChase || bAlert)
		{
			int iBossToUse = -1;
			if (bChase)
			{
				iBossToUse = iChasingBoss;
			}
			else
			{
				iBossToUse = iAlertBoss;
			}
			
			if (iBossToUse != -1)
			{
				// We got some alert/chase music going on! The player's excitement will no doubt go up!
				// Excitement, though, really depends on how close the boss is in relation to the
				// player.
				
				float flBossDist = NPCGetDistanceFromEntity(iBossToUse, client);
				float flScalar = (flBossDist / SquareFloat(700.0));
				if (flScalar > 1.0) flScalar = 1.0;
				float flStressAdd = 0.1 * (1.0 - flScalar);
				
				ClientAddStress(client, flStressAdd);
			}
		}
	}
}

void ClientMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerMusic[client]);
	g_strPlayerMusic[client][0] = '\0';
	if (IsValidClient(client) && sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayerMusicFlags[client] = 0;
	g_flPlayerMusicVolume[client] = 0.0;
	g_flPlayerMusicTargetVolume[client] = 0.0;
	g_hPlayerMusicTimer[client] = null;
	g_iPlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
	g_iPageMusicActiveIndex[client] = -1;
}

void ClientMusicStart(int client, const char[] sNewMusic, float flVolume=-1.0, float flTargetVolume=-1.0, bool bCopyOnly=false)
{
	if (!IsValidClient(client)) return;
	if (sNewMusic[0] == '\0') return;
	
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerMusic[client]);
	
	if (strcmp(sOldMusic, sNewMusic, false) != 0)
	{
		if (sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
	}
	strcopy(g_strPlayerMusic[client], sizeof(g_strPlayerMusic[]), sNewMusic);
	if(MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))//A boss is overriding the music.
		GetBossMusic(g_strPlayerMusic[client],sizeof(g_strPlayerMusic[]));
	if (flVolume >= 0.0) g_flPlayerMusicVolume[client] = flVolume;
	if (flTargetVolume >= 0.0) g_flPlayerMusicTargetVolume[client] = flTargetVolume;

	if (!bCopyOnly)
	{
		bool bPlayMusicOnEscape = !g_bRoundStopPageMusicOnEscape;

		if (g_iPageCount < g_iPageMax || bPlayMusicOnEscape)
		{
			g_hPlayerMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeInMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			TriggerTimer(g_hPlayerMusicTimer[client], true);
		}
	}
	else
	{
		g_hPlayerMusicTimer[client] = null;
	}
}

void ClientMusicStop(int client)
{
	g_hPlayerMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeOutMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayerMusicTimer[client], true);
}

void Client20DollarsMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayer20DollarsMusic[client]);
	g_strPlayer20DollarsMusic[client][0] = '\0';
	if (IsValidClient(client) && sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayer20DollarsMusicMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_hPlayer20DollarsMusicTimer[client][i] = null;
		g_flPlayer20DollarsMusicVolumes[client][i] = 0.0;
		
		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, sProfile, sizeof(sProfile));
			
				if (!GetRandomStringFromProfile(sProfile, "sound_20dollars_music", sOldMusic, sizeof(sOldMusic), 1))
				GetRandomStringFromProfile(sProfile, "sound_20dollars", sOldMusic, sizeof(sOldMusic), 1);
			
				if (SF_SpecialRound(SPECIALROUND_20DOLLARS))
				{
					if (sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
					if (sOldMusic[0] == '\0') StopSound(client, MUSIC_CHAN, TWENTYDOLLARS_MUSIC);
				}
				else 
					if (sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
			}
		}
	}
}

void Client20DollarsMusicStart(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	
	int iOldMaster = g_iPlayer20DollarsMusicMaster[client];
	if (iOldMaster == iBossIndex) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	if (!GetRandomStringFromProfile(sProfile, "sound_20dollars_music", sBuffer, sizeof(sBuffer), 1))
	GetRandomStringFromProfile(sProfile, "sound_20dollars", sBuffer, sizeof(sBuffer), 1);
	
	if (SF_SpecialRound(SPECIALROUND_20DOLLARS))
	{
		if (sBuffer[0] == '\0') sBuffer = TWENTYDOLLARS_MUSIC;
	}
	else 
	{
		if (sBuffer[0] == '\0') return;
	}

	g_iPlayer20DollarsMusicMaster[client] = iBossIndex;
	strcopy(g_strPlayer20DollarsMusic[client], sizeof(g_strPlayer20DollarsMusic[]), sBuffer);
	g_hPlayer20DollarsMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeIn20DollarsMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayer20DollarsMusicTimer[client][iBossIndex], true);
	
	if (iOldMaster != -1)
	{
		ClientAlertMusicStop(client, iOldMaster);
	}
}

void Client20DollarsMusicStop(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	if (iBossIndex == -1) return;
	
	if (iBossIndex == g_iPlayer20DollarsMusicMaster[client])
	{
		g_iPlayer20DollarsMusicMaster[client] = -1;
		g_strPlayer20DollarsMusic[client][0] = '\0';
	}
	
	g_hPlayer20DollarsMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeOut20DollarsMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayer20DollarsMusicTimer[client][iBossIndex], true);
}

void ClientAlertMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerAlertMusic[client]);
	g_strPlayerAlertMusic[client][0] = '\0';
	if (IsValidClient(client) && sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayerAlertMusicMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_hPlayerAlertMusicTimer[client][i] = null;
		g_flPlayerAlertMusicVolumes[client][i] = 0.0;
		
		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, sProfile, sizeof(sProfile));
			
				GetRandomStringFromProfile(sProfile, "sound_alert_music", sOldMusic, sizeof(sOldMusic), 1);
				if (sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
			}
		}
	}
}

void ClientAlertMusicStart(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	
	int iOldMaster = g_iPlayerAlertMusicMaster[client];
	if (iOldMaster == iBossIndex) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_alert_music", sBuffer, sizeof(sBuffer), 1);
	
	if (sBuffer[0] == '\0') return;
	
	g_iPlayerAlertMusicMaster[client] = iBossIndex;
	strcopy(g_strPlayerAlertMusic[client], sizeof(g_strPlayerAlertMusic[]), sBuffer);
	g_hPlayerAlertMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeInAlertMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayerAlertMusicTimer[client][iBossIndex], true);
	
	if (iOldMaster != -1)
	{
		ClientAlertMusicStop(client, iOldMaster);
	}
}

void ClientAlertMusicStop(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	if (iBossIndex == -1) return;
	
	if (iBossIndex == g_iPlayerAlertMusicMaster[client])
	{
		g_iPlayerAlertMusicMaster[client] = -1;
		g_strPlayerAlertMusic[client][0] = '\0';
	}
	
	g_hPlayerAlertMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutAlertMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayerAlertMusicTimer[client][iBossIndex], true);
}

void ClientChaseMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerChaseMusic[client]);
	g_strPlayerChaseMusic[client][0] = '\0';
	if (IsValidClient(client) && sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayerChaseMusicMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_hPlayerChaseMusicTimer[client][i] = null;
		g_flPlayerChaseMusicVolumes[client][i] = 0.0;
		
		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, sProfile, sizeof(sProfile));
				
				GetRandomStringFromProfile(sProfile, "sound_chase_music", sOldMusic, sizeof(sOldMusic), 1);
				if (sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
			}
		}
	}
}

void ClientMusicChaseStart(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	
	int iOldMaster = g_iPlayerChaseMusicMaster[client];
	if (iOldMaster == iBossIndex) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_chase_music", sBuffer, sizeof(sBuffer), 1);
	
	if (sBuffer[0] == '\0') return;
	
	g_iPlayerChaseMusicMaster[client] = iBossIndex;
	strcopy(g_strPlayerChaseMusic[client], sizeof(g_strPlayerChaseMusic[]), sBuffer);
	if(MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))//A boss is overriding the music.
		GetBossMusic(g_strPlayerChaseMusic[client],sizeof(g_strPlayerChaseMusic[]));
	g_hPlayerChaseMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeInChaseMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayerChaseMusicTimer[client][iBossIndex], true);
	
	if (iOldMaster != -1)
	{
		ClientMusicChaseStop(client, iOldMaster);
	}
}

void ClientMusicChaseStop(int client,int iBossIndex)
{
	if (!IsClientInGame(client)) return;
	if (iBossIndex == -1) return;
	
	if (iBossIndex == g_iPlayerChaseMusicMaster[client])
	{
		g_iPlayerChaseMusicMaster[client] = -1;
		g_strPlayerChaseMusic[client][0] = '\0';
	}
	
	g_hPlayerChaseMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutChaseMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayerChaseMusicTimer[client][iBossIndex], true);
}

void ClientChaseMusicSeeReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerChaseMusicSee[client]);
	g_strPlayerChaseMusicSee[client][0] = '\0';
	if (IsClientInGame(client) && sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayerChaseMusicSeeMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_hPlayerChaseMusicSeeTimer[client][i] = null;
		g_flPlayerChaseMusicSeeVolumes[client][i] = 0.0;
		
		if (NPCGetUniqueID(i) != -1)
		{
			if (IsClientInGame(client))
			{
				NPCGetProfile(i, sProfile, sizeof(sProfile));
			
				GetRandomStringFromProfile(sProfile, "sound_chase_visible", sOldMusic, sizeof(sOldMusic), 1);
				if (sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
			}
		}
	}
}

void ClientMusicChaseSeeStart(int client,int iBossIndex)
{
	if (!IsClientInGame(client)) return;
	
	int iOldMaster = g_iPlayerChaseMusicSeeMaster[client];
	if (iOldMaster == iBossIndex) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_chase_visible", sBuffer, sizeof(sBuffer), 1);
	if (sBuffer[0] == '\0') return;
	
	g_iPlayerChaseMusicSeeMaster[client] = iBossIndex;
	strcopy(g_strPlayerChaseMusicSee[client], sizeof(g_strPlayerChaseMusicSee[]), sBuffer);
	g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeInChaseMusicSee, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayerChaseMusicSeeTimer[client][iBossIndex], true);
	
	if (iOldMaster != -1)
	{
		ClientMusicChaseSeeStop(client, iOldMaster);
	}
}

void ClientMusicChaseSeeStop(int client,int iBossIndex)
{
	if (!IsClientInGame(client)) return;
	if (iBossIndex == -1) return;
	
	if (iBossIndex == g_iPlayerChaseMusicSeeMaster[client])
	{
		g_iPlayerChaseMusicSeeMaster[client] = -1;
		g_strPlayerChaseMusicSee[client][0] = '\0';
	}
	
	g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutChaseMusicSee, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayerChaseMusicSeeTimer[client][iBossIndex], true);
}

void Client90sMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayer90sMusic[client]);
	g_strPlayer90sMusic[client][0] = '\0';
	if (IsValidClient(client) && sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);

	g_hPlayer90sMusicTimer[client] = null;
	g_flPlayer90sMusicVolumes[client] = 0.0;

	if (IsValidClient(client))
	{
		sOldMusic = NINETYSMUSIC;
		if (sOldMusic[0] != '\0') StopSound(client, MUSIC_CHAN, sOldMusic);
	}
}

void Client90sMusicStart(int client)
{
	if (!IsValidClient(client)) return;

	char sBuffer[PLATFORM_MAX_PATH];
	sBuffer = NINETYSMUSIC;
	
	if (sBuffer[0] == '\0') return;

	strcopy(g_strPlayer90sMusic[client], sizeof(g_strPlayer90sMusic[]), sBuffer);
	g_hPlayer90sMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeIn90sMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayer90sMusicTimer[client], true);
}

void Client90sMusicStop(int client)
{
	if (!IsValidClient(client)) return;

	if (!IsClientSprinting(client))
	{
		g_strPlayer90sMusic[client][0] = '\0';
	}
	
	g_hPlayer90sMusicTimer[client]= CreateTimer(0.01, Timer_PlayerFadeOut90sMusic, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayer90sMusicTimer[client], true);
}

public Action Timer_PlayerFadeInMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerMusicTimer[client]) return Plugin_Stop;
	
	g_flPlayerMusicVolume[client] += 0.07;
	if (g_flPlayerMusicVolume[client] > g_flPlayerMusicTargetVolume[client]) g_flPlayerMusicVolume[client] = g_flPlayerMusicTargetVolume[client];
	
	if (g_strPlayerMusic[client][0] != '\0') EmitSoundToClient(client, g_strPlayerMusic[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, g_flPlayerMusicVolume[client], 100);

	if (g_flPlayerMusicVolume[client] >= g_flPlayerMusicTargetVolume[client])
	{
		g_hPlayerMusicTimer[client] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOutMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	if (timer != g_hPlayerMusicTimer[client]) return Plugin_Stop;

	g_flPlayerMusicVolume[client] -= 0.07;
	if (g_flPlayerMusicVolume[client] < 0.0) g_flPlayerMusicVolume[client] = 0.0;

	if (g_strPlayerMusic[client][0] != '\0') EmitSoundToClient(client, g_strPlayerMusic[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, g_flPlayerMusicVolume[client], 100);

	if (g_flPlayerMusicVolume[client] <= 0.0)
	{
		g_hPlayerMusicTimer[client] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeIn20DollarsMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayer20DollarsMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	g_flPlayer20DollarsMusicVolumes[client][iBossIndex] += 0.07;
	if (g_flPlayer20DollarsMusicVolumes[client][iBossIndex] > 1.0) g_flPlayer20DollarsMusicVolumes[client][iBossIndex] = 1.0;

	if (g_strPlayer20DollarsMusic[client][0] != '\0') EmitSoundToClient(client, g_strPlayer20DollarsMusic[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayer20DollarsMusicVolumes[client][iBossIndex], 100);
	
	if (g_flPlayer20DollarsMusicVolumes[client][iBossIndex] >= 1.0)
	{
		g_hPlayer20DollarsMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOut20DollarsMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayer20DollarsMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];

	if (!GetRandomStringFromProfile(sProfile, "sound_20dollars_music", sBuffer, sizeof(sBuffer), 1))
	GetRandomStringFromProfile(sProfile, "sound_20dollars", sBuffer, sizeof(sBuffer), 1);

	if (SF_SpecialRound(SPECIALROUND_20DOLLARS) && sBuffer[0] == '\0')
	{
		sBuffer = TWENTYDOLLARS_MUSIC;
	}
	
	if (strcmp(sBuffer, g_strPlayer20DollarsMusic[client], false) == 0)
	{
		g_hPlayer20DollarsMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	g_flPlayer20DollarsMusicVolumes[client][iBossIndex] -= 0.07;
	if (g_flPlayer20DollarsMusicVolumes[client][iBossIndex] < 0.0) g_flPlayer20DollarsMusicVolumes[client][iBossIndex] = 0.0;

	if (sBuffer[0] != '\0') EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayer20DollarsMusicVolumes[client][iBossIndex], 100);
	
	if (g_flPlayer20DollarsMusicVolumes[client][iBossIndex] <= 0.0)
	{
		g_hPlayer20DollarsMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeInAlertMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerAlertMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	g_flPlayerAlertMusicVolumes[client][iBossIndex] += 0.07;
	if (g_flPlayerAlertMusicVolumes[client][iBossIndex] > 1.0) g_flPlayerAlertMusicVolumes[client][iBossIndex] = 1.0;

	if (g_strPlayerAlertMusic[client][0] != '\0') EmitSoundToClient(client, g_strPlayerAlertMusic[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerAlertMusicVolumes[client][iBossIndex], 100);
	
	if (g_flPlayerAlertMusicVolumes[client][iBossIndex] >= 1.0)
	{
		g_hPlayerAlertMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOutAlertMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerAlertMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_alert_music", sBuffer, sizeof(sBuffer), 1);

	if (strcmp(sBuffer, g_strPlayerAlertMusic[client], false) == 0)
	{
		g_hPlayerAlertMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	g_flPlayerAlertMusicVolumes[client][iBossIndex] -= 0.07;
	if (g_flPlayerAlertMusicVolumes[client][iBossIndex] < 0.0) g_flPlayerAlertMusicVolumes[client][iBossIndex] = 0.0;

	if (sBuffer[0] != '\0') EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerAlertMusicVolumes[client][iBossIndex], 100);
	
	if (g_flPlayerAlertMusicVolumes[client][iBossIndex] <= 0.0)
	{
		g_hPlayerAlertMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeInChaseMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerChaseMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	g_flPlayerChaseMusicVolumes[client][iBossIndex] += 0.07;
	if (g_flPlayerChaseMusicVolumes[client][iBossIndex] > 1.0) g_flPlayerChaseMusicVolumes[client][iBossIndex] = 1.0;

	if (g_strPlayerChaseMusic[client][0] != '\0') EmitSoundToClient(client, g_strPlayerChaseMusic[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerChaseMusicVolumes[client][iBossIndex], 100);
	
	if (g_flPlayerChaseMusicVolumes[client][iBossIndex] >= 1.0)
	{
		g_hPlayerChaseMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeInChaseMusicSee(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerChaseMusicSeeTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] += 0.07;
	if (g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] > 1.0) g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] = 1.0;

	if (g_strPlayerChaseMusicSee[client][0] != '\0') EmitSoundToClient(client, g_strPlayerChaseMusicSee[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerChaseMusicSeeVolumes[client][iBossIndex], 100);
	
	if (g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] >= 1.0)
	{
		g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOutChaseMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerChaseMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_chase_music", sBuffer, sizeof(sBuffer), 1);

	if (strcmp(sBuffer, g_strPlayerChaseMusic[client], false) == 0)
	{
		g_hPlayerChaseMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	g_flPlayerChaseMusicVolumes[client][iBossIndex] -= 0.07;
	if (g_flPlayerChaseMusicVolumes[client][iBossIndex] < 0.0) g_flPlayerChaseMusicVolumes[client][iBossIndex] = 0.0;

	if (sBuffer[0] != '\0') EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerChaseMusicVolumes[client][iBossIndex], 100);
	
	if (g_flPlayerChaseMusicVolumes[client][iBossIndex] <= 0.0)
	{
		g_hPlayerChaseMusicTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOutChaseMusicSee(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerChaseMusicSeeTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_chase_visible", sBuffer, sizeof(sBuffer), 1);

	if (strcmp(sBuffer, g_strPlayerChaseMusic[client], false) == 0)
	{
		g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] -= 0.07;
	if (g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] < 0.0) g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] = 0.0;

	if (sBuffer[0] != '\0') EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerChaseMusicSeeVolumes[client][iBossIndex], 100);
	
	if (g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] <= 0.0)
	{
		g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeIn90sMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	if (g_hPlayer90sMusicTimer[client] != timer) return Plugin_Stop;

	g_flPlayer90sMusicVolumes[client] += 0.28;
	if (g_flPlayer90sMusicVolumes[client] > 0.5) g_flPlayer90sMusicVolumes[client] = 0.5;

	if (g_strPlayer90sMusic[client][0] != '\0') EmitSoundToClient(client, g_strPlayer90sMusic[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayer90sMusicVolumes[client], 100);
	
	if (g_flPlayer90sMusicVolumes[client] >= 0.5)
	{
		g_hPlayer90sMusicTimer[client] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOut90sMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	if (g_hPlayer90sMusicTimer[client] != timer) return Plugin_Stop;

	char sBuffer[PLATFORM_MAX_PATH];
	sBuffer = NINETYSMUSIC;

	if (strcmp(sBuffer, g_strPlayer90sMusic[client], false) == 0)
	{
		g_hPlayer90sMusicTimer[client] = null;
		return Plugin_Stop;
	}
	
	g_flPlayer90sMusicVolumes[client] -= 0.28;
	if (g_flPlayer90sMusicVolumes[client] < 0.0) g_flPlayer90sMusicVolumes[client] = 0.0;

	if (sBuffer[0] != '\0') EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayer90sMusicVolumes[client], 100);
	
	if (g_flPlayer90sMusicVolumes[client] <= 0.0)
	{
		g_hPlayer90sMusicTimer[client] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

bool ClientHasMusicFlag(int client,int iFlag)
{
	return view_as<bool>(g_iPlayerMusicFlags[client] & iFlag);
}

bool ClientHasMusicFlag2(int iValue,int iFlag)
{
	return view_as<bool>(iValue & iFlag);
}

void ClientAddMusicFlag(int client,int iFlag)
{
	if (!ClientHasMusicFlag(client, iFlag)) g_iPlayerMusicFlags[client] |= iFlag;
}

void ClientRemoveMusicFlag(int client,int iFlag)
{
	if (ClientHasMusicFlag(client, iFlag)) g_iPlayerMusicFlags[client] &= ~iFlag;
}
