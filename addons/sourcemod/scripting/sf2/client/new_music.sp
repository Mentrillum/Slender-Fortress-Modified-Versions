#pragma newdecls required
#pragma semicolon 1

enum SF2MusicFadeState
{
	SF2MusicFadeState_None = 0,
	SF2MusicFadeState_FadeIn = 1,
	SF2MusicFadeState_FadeOut = 2
}

enum SF2BossMusicState
{
	SF2BossMusicState_Invalid = -1,
	SF2BossMusicState_Idle = 0,
	SF2BossMusicState_Alert = 1,
	SF2BossMusicState_Chase = 2,
	SF2BossMusicState_Max = 3
}

enum SF2BossMusicTrackType
{
	SF2BossMusicTrackType_Unknown = 0,
	SF2BossMusicTrackType_Normal,
	SF2BossMusicTrackType_Visible,
	SF2BossMusicTrackType_Global,
	SF2BossMusicTrackType_Max
}

enum SF2BossGlobalMusicShuffleType
{
	SF2BossGlobalMusicShuffleType_None = 0,
	SF2BossGlobalMusicShuffleType_Order,
	SF2BossGlobalMusicShuffleType_Random,
	SF2BossGlobalMusicShuffleType_RandomOrder,
	SF2BossGlobalMusicShuffleType_Range
}

methodmap ProfileGlobalTracks < ProfileObject
{
	public SF2BossMusicState GetPriority(int difficulty = Difficulty_Normal)
	{
		return view_as<SF2BossMusicState>(this.GetDifficultyInt("priority", difficulty, view_as<int>(SF2BossMusicState_Max)));
	}

	public SF2BossGlobalMusicShuffleType GetShuffleType(int difficulty)
	{
		char value[64];
		this.GetDifficultyString("shuffle_type", difficulty, value, sizeof(value), "none");

		if (strcmp(value, "order", false) == 0)
		{
			return SF2BossGlobalMusicShuffleType_Order;
		}
		else if (strcmp(value, "random", false) == 0)
		{
			return SF2BossGlobalMusicShuffleType_Random;
		}
		else if (strcmp(value, "random_order", false) == 0)
		{
			return SF2BossGlobalMusicShuffleType_RandomOrder;
		}
		else if (strcmp(value, "pages", false) == 0)
		{
			return SF2BossGlobalMusicShuffleType_Range;
		}
		return SF2BossGlobalMusicShuffleType_None;
	}

	public KeyMap_Array GetTracks()
	{
		return this.GetArray("tracks");
	}

	public void Precache()
	{
		this.ConvertSectionsSectionToArray("tracks");
		if (this.GetTracks() != null)
		{
			for (int i = 0; i < this.GetTracks().Length; i++)
			{
				ProfileGlobalTrack track = view_as<ProfileGlobalTrack>(this.GetTracks().GetSection(i));
				if (track == null)
				{
					continue;
				}
				track.Precache();
			}
		}
	}
}

methodmap ProfileGlobalTrack < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", difficulty, true);
	}

	public void GetPath(int difficulty, char[] buffer, int bufferSize)
	{
		this.GetDifficultyString("path", difficulty, buffer, bufferSize);
	}

	public float GetVolume(int difficulty)
	{
		return this.GetDifficultyFloat("volume", difficulty, SNDVOL_NORMAL);
	}

	public int GetPitch(int difficulty)
	{
		return this.GetDifficultyInt("pitch", difficulty, SNDPITCH_NORMAL);
	}

	public float GetLength(int difficulty)
	{
		return this.GetDifficultyFloat("length", difficulty, -1.0);
	}

	public float GetMinPageRange(int difficulty)
	{
		return this.GetDifficultyFloat("min_range", difficulty, 0.0);
	}

	public float GetMaxPageRange(int difficulty)
	{
		return this.GetDifficultyFloat("max_range", difficulty, 0.0);
	}

	public void Precache()
	{
		char path[PLATFORM_MAX_PATH];
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.GetPath(i, path, sizeof(path));
			if (path[0] != '\0')
			{
				PrecacheSound2(path, g_FileCheckConVar.BoolValue);
			}
		}
	}
}

methodmap ProfileMusic < ProfileSound
{
	public float GetRadius(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyFloat("radius", difficulty, 850.0);
	}

	public float GetFadeSpeed(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyFloat("fade_speed", difficulty, 1.0);
	}

	public bool CanInstantFade(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyBool("instant_fade", difficulty, false);
	}

	public SF2BossMusicState GetGlobalMusicPriority(int difficulty = Difficulty_Normal)
	{
		return view_as<SF2BossMusicState>(this.GetDifficultyInt("priority", difficulty, view_as<int>(SF2BossMusicState_Max)));
	}
}

enum struct MusicState
{
	bool IsNull;
	char MusicPath[PLATFORM_MAX_PATH];
	float MaxVolume;
	float CurrentVolume;
	int Pitch;
	float FadeSpeed;
	SF2MusicFadeState FadeState;
	float Length;
	bool StopAfterFade;

	void Init()
	{
		this.IsNull = false;
		this.MusicPath[0] = '\0';
		this.MaxVolume = 1.0;
		this.CurrentVolume = 0.0;
		this.Pitch = 100;
		this.FadeSpeed = 1.0;
		this.FadeState = SF2MusicFadeState_None;
		this.Length = -1.0;
		this.StopAfterFade = false;
	}

	void FadeIn(SF2_BasePlayer client, float delta, bool instant = false)
	{
		if (this.IsNull)
		{
			return;
		}

		if (this.MusicPath[0] == '\0')
		{
			return;
		}

		if (this.CurrentVolume >= this.MaxVolume)
		{
			this.SetFadeState(SF2MusicFadeState_None);
			return;
		}

		this.CurrentVolume += this.FadeSpeed * delta;
		if (instant)
		{
			this.CurrentVolume = this.MaxVolume;
		}
		if (this.CurrentVolume >= this.MaxVolume)
		{
			this.CurrentVolume = this.MaxVolume;
			this.SetFadeState(SF2MusicFadeState_None);
		}
		float volume = this.CurrentVolume * g_PlayerPreferences[client.index].PlayerPreference_MusicVolume;
		EmitSoundToClient(client.index, this.MusicPath, _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, volume, this.Pitch);
	}

	void FadeOut(SF2_BasePlayer client, float delta, bool instant = false)
	{
		if (this.IsNull)
		{
			return;
		}

		if (this.MusicPath[0] == '\0')
		{
			return;
		}

		this.CurrentVolume -= this.FadeSpeed * delta;
		if (instant)
		{
			this.CurrentVolume = 0.0;
		}
		if (this.CurrentVolume <= 0.0)
		{
			this.CurrentVolume = 0.0;
			this.SetFadeState(SF2MusicFadeState_None);
			if (this.StopAfterFade)
			{
				EmitSoundToClient(client.index, this.MusicPath, _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, 0.015, this.Pitch);
				this.Stop(client);
				return;
			}
		}
		float volume = this.CurrentVolume * g_PlayerPreferences[client.index].PlayerPreference_MusicVolume;
		EmitSoundToClient(client.index, this.MusicPath, _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, volume, this.Pitch);
	}

	void Stop(SF2_BasePlayer client)
	{
		if (this.IsNull)
		{
			return;
		}

		if (this.MusicPath[0] == '\0')
		{
			return;
		}

		StopSound(client.index, MUSIC_CHAN, this.MusicPath);
		this.SetFadeState(SF2MusicFadeState_None);
	}

	void Reset()
	{
		if (this.MusicPath[0] != '\0')
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				SF2_BasePlayer client = SF2_BasePlayer(i);
				if (!client.IsValid)
				{
					continue;
				}

				if (client.IsEliminated && !client.IsInGhostMode && !client.IsProxy)
				{
					continue;
				}

				if (!client.IsEliminated && client.HasEscaped)
				{
					continue;
				}
				StopSound(client.index, MUSIC_CHAN, this.MusicPath);
			}
		}
		this.Init();
	}

	void SetFadeState(SF2MusicFadeState state)
	{
		if (this.IsNull)
		{
			return;
		}

		this.FadeState = state;
	}

	bool IsValid()
	{
		return this.MusicPath[0] != '\0';
	}
}

enum struct PageMusicInfo
{
	int MinRequiredPages;
	int MaxRequiredPages;
	MusicState State;
}

static ArrayList g_PageMusicRanges = null;
static ArrayList g_BossesWithGlobalMusic = null;
static bool g_CanSwapBackToDefault[MAXTF2PLAYERS] = { true, ... };
static float g_CurrentTrackLength[MAXTF2PLAYERS];
static StringMap g_QueuedThemes[MAXTF2PLAYERS]; // Fade out queue
static StringMap g_LayeredThemes[MAXTF2PLAYERS]; // Layered tracks
static MusicState g_CurrentTheme[MAXTF2PLAYERS];
static MusicState g_DefaultMusicState; // Pages
static MusicState g_OldDefaultMusicState;
static MusicState g_GlobalMusicState[MAXTF2PLAYERS]; // Boss global theme
static MusicState g_OldGlobalMusicState[MAXTF2PLAYERS];
static MusicState g_NullMusicState;
static float g_LastMusicThink;
static int g_PlayerActiveBoss[MAXTF2PLAYERS] = { -1, ... };
static int g_PlayerActiveLayerBoss[MAXTF2PLAYERS] = { -1, ... };
static SF2BossMusicState g_PlayerActiveBossState[MAXTF2PLAYERS] = { SF2BossMusicState_Invalid, ... };
static SF2BossMusicState g_PlayerActiveLayerBossState[MAXTF2PLAYERS] = { SF2BossMusicState_Invalid, ... };
static SF2BossMusicState g_GlobalMusicUpdateLimit[MAXTF2PLAYERS] = { SF2BossMusicState_Max, ... };
static int g_GlobalMusicTrackMasterID = -1;
static ArrayList g_CurrentTracks;
static int g_CurrentTrackIndex;
static SF2BossGlobalMusicShuffleType g_CurrentTrackShuffleType;

void SetupNewMusic()
{
	g_OnGamemodeEndPFwd.AddFunction(null, OnGamemodeEnd);
	g_OnMapStartPFwd.AddFunction(null, MapStart);
	g_OnConfigsExecutedPFwd.AddFunction(null, ConfigsExecuted);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPostInitMapEntitiesPFwd.AddFunction(null, OnPostInitMapEntities);
	g_OnPostInitNewGamePFwd.AddFunction(null, OnPostInitNewGame);
	g_OnPageCountChangedPFwd.AddFunction(null, OnPageCountChanged);
	g_OnBossAddedPFwd.AddFunction(null, OnBossAdded);
	g_OnBossRemovedPFwd.AddFunction(null, OnBossRemoved);
	g_OnDifficultyChangePFwd.AddFunction(null, OnDifficultyChange);

	g_PageMusicRanges = new ArrayList(sizeof(PageMusicInfo));
	g_BossesWithGlobalMusic = new ArrayList();
	g_NullMusicState.Init();
	g_NullMusicState.IsNull = true;
}

static void OnGamemodeEnd()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);
		if (!client.IsValid)
		{
			continue;
		}
		ClearMusic(client);
	}
}

static void MapStart()
{
	g_LastMusicThink = -1.0;
	RequestFrame(MusicThink);
	g_BossesWithGlobalMusic.Clear();
}

static void ConfigsExecuted()
{
	g_GlobalMusicTrackMasterID = -1;
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	ClearMusic(client);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		ClearMusic(client);
	}
}

static void OnPutInServer(SF2_BasePlayer client)
{
	g_QueuedThemes[client.index] = null;
	g_LayeredThemes[client.index] = null;
	ClearMusic(client);
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClearMusic(client);
}

static void OnDisconnected(SF2_BasePlayer client)
{
	if (g_QueuedThemes[client.index] != null)
	{
		delete g_QueuedThemes[client.index];
	}

	if (g_LayeredThemes[client.index] != null)
	{
		delete g_LayeredThemes[client.index];
	}
}

static void OnPostInitMapEntities()
{
	GetPageMusicRanges();
}

static void OnPostInitNewGame()
{
	UpdatePageMusic();
}

static void OnPageCountChanged(int pageCount, int oldPageCount)
{
	UpdatePageMusic();
}

static void OnBossAdded(SF2NPC_BaseNPC npc)
{
	if (SF_IsRaidMap() || SF_IsRenevantMap() || SF_IsProxyMap())
	{
		return;
	}

	if (npc.GetProfileDataEx().IsPvEBoss)
	{
		return;
	}

	if (npc.IsCopy)
	{
		return;
	}

	int oldId = g_GlobalMusicTrackMasterID;
	char path[PLATFORM_MAX_PATH];
	GetBossMusicTrack(npc, SF2BossMusicTrackType_Global, path, sizeof(path));

	if (path[0] != '\0')
	{
		g_BossesWithGlobalMusic.Push(npc.UniqueID);
		if (NPCGetFromUniqueID(oldId) == -1)
		{
			UpdateBossGlobalTracks();
		}
	}
}

static void OnBossRemoved(SF2NPC_BaseNPC npc)
{
	if (SF_IsRaidMap() || SF_IsRenevantMap() || SF_IsProxyMap())
	{
		return;
	}

	if (npc.GetProfileDataEx().IsPvEBoss)
	{
		return;
	}

	if (npc.IsCopy)
	{
		return;
	}

	int index;
	if ((index = g_BossesWithGlobalMusic.FindValue(npc.UniqueID)) != -1)
	{
		g_BossesWithGlobalMusic.Erase(index);
	}

	if (g_GlobalMusicTrackMasterID == npc.UniqueID)
	{
		UpdateBossGlobalTracks();
	}
}

static void OnDifficultyChange(int oldDifficulty, int newDifficulty)
{
	if (SF_IsRaidMap() || SF_IsRenevantMap() || SF_IsProxyMap())
	{
		return;
	}

	g_BossesWithGlobalMusic.Clear();
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(i);
		if (!npc.IsValid())
		{
			continue;
		}

		if (npc.GetProfileDataEx().IsPvEBoss)
		{
			continue;
		}

		char path[PLATFORM_MAX_PATH];
		GetBossMusicTrack(npc, SF2BossMusicTrackType_Global, path, sizeof(path));

		if (path[0] != '\0')
		{
			g_BossesWithGlobalMusic.Push(npc.UniqueID);
			UpdateBossGlobalTracks();
		}
	}
}

static void GetPageMusicRanges()
{
	g_PageMusicRanges.Clear();

	char name[64], path[PLATFORM_MAX_PATH];

	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "ambient_generic")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));

		if (name[0] != '\0' && !StrContains(name, "sf2_page_music_", false))
		{
			ReplaceString(name, sizeof(name), "sf2_page_music_", "", false);

			char pageRanges[2][32];
			ExplodeString(name, "-", pageRanges, 2, 32);

			PageMusicInfo musicInfo;
			GetEntPropString(ent, Prop_Data, "m_iszSound", path, sizeof(path));

			if (path[0] == '\0')
			{
				continue;
			}

			if (path[0] != '#' && path[1] != '#')
			{
				Format(path, sizeof(path), "#%s", path);
			}

			PrecacheSound(path, true);

			musicInfo.MinRequiredPages = StringToInt(pageRanges[0]);
			musicInfo.MaxRequiredPages = StringToInt(pageRanges[1]);
			musicInfo.State.MusicPath = path;

			g_PageMusicRanges.PushArray(musicInfo);
		}
	}

	/*while ((ent = FindEntityByClassname(ent, "sf2_info_page_music")) != -1)
	{
		SF2PageMusicEntity pageMusic = SF2PageMusicEntity(ent);
		if (!pageMusic.IsValid())
		{
			continue;
		}

		pageMusic.InsertRanges(g_PageMusicRanges);
	}

	// precache
	if (g_PageMusicRanges.Length > 0)
	{
		char path[PLATFORM_MAX_PATH];

		for (int i = 0; i < g_PageMusicRanges.Length; i++)
		{
			ent = EntRefToEntIndex(g_PageMusicRanges.Get(i));
			if (!ent || ent == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			SF2PageMusicEntity pageMusic = SF2PageMusicEntity(ent);
			if (pageMusic.IsValid())
			{
				// Don't do anything; entity already precached its own music.
			}
			else
			{
				GetEntPropString(ent, Prop_Data, "m_iszSound", path, sizeof(path));
				if (path[0] != '\0')
				{
					PrecacheSound(path);
				}
			}
		}
	}*/

	if (g_PageMusicRanges.Length == 0 && g_PageMax > 0)
	{
		int page25Pct = RoundToFloor(float(g_PageMax) * 0.25);
		int page50Pct = RoundToFloor(float(g_PageMax) * 0.5);
		int page75Pct = RoundToFloor(float(g_PageMax) * 0.75);

		PageMusicInfo musicInfo;

		musicInfo.State.Init();
		musicInfo.MinRequiredPages = 1;
		musicInfo.MaxRequiredPages = page25Pct;
		strcopy(path, sizeof(path), MUSIC_GOTPAGES1_SOUND);
		PrecacheSound2(path, false);
		musicInfo.State.MusicPath = path;
		g_PageMusicRanges.PushArray(musicInfo);

		musicInfo.State.Init();
		musicInfo.MinRequiredPages = page25Pct + 1;
		musicInfo.MaxRequiredPages = page50Pct;
		strcopy(path, sizeof(path), MUSIC_GOTPAGES2_SOUND);
		PrecacheSound2(path, false);
		musicInfo.State.MusicPath = path;
		g_PageMusicRanges.PushArray(musicInfo);

		musicInfo.State.Init();
		musicInfo.MinRequiredPages = page50Pct + 1;
		musicInfo.MaxRequiredPages = page75Pct;
		strcopy(path, sizeof(path), MUSIC_GOTPAGES3_SOUND);
		PrecacheSound2(path, false);
		musicInfo.State.MusicPath = path;
		g_PageMusicRanges.PushArray(musicInfo);

		musicInfo.State.Init();
		musicInfo.MinRequiredPages = page75Pct + 1;
		musicInfo.MaxRequiredPages = g_PageMax;
		strcopy(path, sizeof(path), MUSIC_GOTPAGES4_SOUND);
		PrecacheSound2(path, false);
		musicInfo.State.MusicPath = path;
		g_PageMusicRanges.PushArray(musicInfo);
	}

	LogSF2Message("Loaded page music ranges successfully!");
}

static void ClearMusic(SF2_BasePlayer client)
{
	g_CanSwapBackToDefault[client.index] = true;
	g_CurrentTrackLength[client.index] = 0.0;
	g_PlayerActiveBoss[client.index] = -1;
	g_PlayerActiveLayerBoss[client.index] = -1;
	g_PlayerActiveBossState[client.index] = SF2BossMusicState_Invalid;
	g_PlayerActiveLayerBossState[client.index] = SF2BossMusicState_Invalid;

	if (g_QueuedThemes[client.index] != null)
	{
		StringMapSnapshot snapshot = g_QueuedThemes[client.index].Snapshot();
		for (int i = 0; i < snapshot.Length; i++)
		{
			char key[PLATFORM_MAX_PATH];
			snapshot.GetKey(i, key, sizeof(key));
			MusicState state;
			g_QueuedThemes[client.index].GetArray(key, state, sizeof(state));
			state.Stop(client);
		}
		delete g_QueuedThemes[client.index];
		delete snapshot;
	}

	if (g_LayeredThemes[client.index] != null)
	{
		StringMapSnapshot snapshot = g_LayeredThemes[client.index].Snapshot();
		for (int i = 0; i < snapshot.Length; i++)
		{
			char key[PLATFORM_MAX_PATH];
			snapshot.GetKey(i, key, sizeof(key));
			MusicState state;
			g_LayeredThemes[client.index].GetArray(key, state, sizeof(state));
			state.Stop(client);
		}
		delete g_LayeredThemes[client.index];
		delete snapshot;
	}

	g_CurrentTheme[client.index].Stop(client);
	g_CurrentTheme[client.index] = g_NullMusicState;
}

static void UpdatePageMusic()
{
	if (g_BossesWithGlobalMusic.Length != 0)
	{
		return;
	}

	MusicState oldState;
	oldState = g_DefaultMusicState;
	g_OldDefaultMusicState = g_DefaultMusicState;
	g_DefaultMusicState = g_NullMusicState;

	if (g_PageCount < g_PageMax || !g_RoundStopPageMusicOnEscape)
	{
		PageMusicInfo info;

		for (int i = 0; i < g_PageMusicRanges.Length; i++)
		{
			g_PageMusicRanges.GetArray(i, info);
			if (g_PageCount >= info.MinRequiredPages && g_PageCount <= info.MaxRequiredPages)
			{
				g_DefaultMusicState = info.State;
				if (strcmp(oldState.MusicPath, info.State.MusicPath, false) != 0)
				{
					for (int i2 = 1; i2 <= MaxClients; i2++)
					{
						SF2_BasePlayer client = SF2_BasePlayer(i2);
						if (g_CanSwapBackToDefault[client.index])
						{
							AddMusicToQueue(client, g_DefaultMusicState);
						}
					}
				}
				break;
			}
		}
	}
}

static void UpdateBossGlobalTracks()
{
	if (g_BossesWithGlobalMusic.Length == 0)
	{
		UpdatePageMusic();
		if (g_CurrentTracks != null)
		{
			delete g_CurrentTracks;
		}
		g_CurrentTrackIndex = 0;
		g_GlobalMusicTrackMasterID = -1;
		g_CurrentTrackShuffleType = SF2BossGlobalMusicShuffleType_None;
		return;
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);
		UpdateBossGlobalTrackForPlayer(client);
	}

	UpdatePageMusic();
}

static void UpdateBossGlobalTrackForPlayer(SF2_BasePlayer client)
{
	if (!client.IsValid)
	{
		return;
	}
	g_OldGlobalMusicState[client.index] = g_GlobalMusicState[client.index];
	g_OldGlobalMusicState[client.index].StopAfterFade = true;

	for (int i = 0; i < g_BossesWithGlobalMusic.Length; i++)
	{
		SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(NPCGetFromUniqueID(g_BossesWithGlobalMusic.Get(i)));
		if (!npc.IsValid())
		{
			g_BossesWithGlobalMusic.Erase(i);
			i--;
			continue;
		}

		char path[PLATFORM_MAX_PATH];
		float volume = 1.0, length = -1.0;
		int pitch = 100;
		SF2BossMusicState priority = SF2BossMusicState_Max;
		GetBossMusicTrack(npc, SF2BossMusicTrackType_Global, path, sizeof(path), volume, pitch, .priority = priority, .length = length, .client = client);

		if (path[0] != '\0')
		{
			MusicState state;
			state.Init();
			state.MusicPath = path;
			state.MaxVolume = volume;
			state.Pitch = pitch;
			state.Length = length;
			g_GlobalMusicState[client.index] = state;
			g_GlobalMusicUpdateLimit[client.index] = priority;
			g_CurrentTrackLength[client.index] = 0.0;
			g_CurrentTheme[client.index].StopAfterFade = true;

			AddMusicToQueue(client, g_GlobalMusicState[client.index]);
			g_OldGlobalMusicState[client.index].Init();
			g_OldGlobalMusicState[client.index].IsNull = true;
			return;
		}
	}

	g_GlobalMusicState[client.index] = g_NullMusicState;
}

static void AddMusicToQueue(SF2_BasePlayer client, MusicState state)
{
	if (!client.IsValid)
	{
		return;
	}

	if (client.IsEliminated && !client.IsInGhostMode && !client.IsProxy)
	{
		return;
	}

	if (!client.IsEliminated && client.HasEscaped)
	{
		return;
	}

	MusicState currentState;
	currentState = g_CurrentTheme[client.index];
	if (strcmp(currentState.MusicPath, state.MusicPath, false) == 0)
	{
		return;
	}

	if (!currentState.IsNull)
	{
		if (g_QueuedThemes[client.index] == null)
		{
			g_QueuedThemes[client.index] = new StringMap();
		}
		else
		{
			MusicState temp;
			if (g_QueuedThemes[client.index].SetArray(state.MusicPath, temp, sizeof(temp)))
			{
				state.CurrentVolume = temp.CurrentVolume;
			}
		}
		if (strcmp(currentState.MusicPath, g_OldGlobalMusicState[client.index].MusicPath, false) == 0)
		{
			currentState.StopAfterFade = true;
		}
		currentState.SetFadeState(SF2MusicFadeState_FadeOut);
		g_QueuedThemes[client.index].SetArray(currentState.MusicPath, currentState, sizeof(currentState));
		if (g_LayeredThemes[client.index] != null)
		{
			StringMapSnapshot snapshot = g_LayeredThemes[client.index].Snapshot();
			for (int i = 0; i < snapshot.Length; i++)
			{
				char key[PLATFORM_MAX_PATH];
				snapshot.GetKey(i, key, sizeof(key));
				g_LayeredThemes[client.index].GetArray(key, currentState, sizeof(currentState));
				currentState.SetFadeState(SF2MusicFadeState_FadeOut);
				g_QueuedThemes[client.index].SetArray(currentState.MusicPath, currentState, sizeof(currentState));
			}
			delete g_LayeredThemes[client.index];
			delete snapshot;
		}
		g_QueuedThemes[client.index].Remove(state.MusicPath);
	}
	state.SetFadeState(SF2MusicFadeState_FadeIn);
	g_CurrentTheme[client.index] = state;
	g_CurrentTrackLength[client.index] = 0.0;
}

static void AddLayeredTrack(SF2_BasePlayer client, MusicState state, int index)
{
	if (!client.IsValid)
	{
		return;
	}

	if (client.IsEliminated && !client.IsInGhostMode && !client.IsProxy)
	{
		return;
	}

	if (!client.IsEliminated && client.HasEscaped)
	{
		return;
	}

	if (g_QueuedThemes[client.index] != null)
	{
		StringMapSnapshot snapshot = g_QueuedThemes[client.index].Snapshot();
		for (int i = 0; i < snapshot.Length; i++)
		{
			char key[PLATFORM_MAX_PATH];
			snapshot.GetKey(i, key, sizeof(key));
			MusicState oldState;
			g_QueuedThemes[client.index].GetArray(key, oldState, sizeof(oldState));
			if (strcmp(oldState.MusicPath, state.MusicPath, false) == 0)
			{
				g_QueuedThemes[client.index].Remove(key);
			}
		}
	}

	char intString[16];
	IntToString(index, intString, sizeof(intString));
	if (g_LayeredThemes[client.index] == null)
	{
		g_LayeredThemes[client.index] = new StringMap();
		state.SetFadeState(SF2MusicFadeState_FadeIn);
		g_LayeredThemes[client.index].SetArray(intString, state, sizeof(state));
	}
	else
	{
		RemoveLayeredTracks(client);
		StringMapSnapshot snapshot = g_LayeredThemes[client.index].Snapshot();
		bool exists = false;
		for (int i = 0; i < snapshot.Length; i++)
		{
			char key[PLATFORM_MAX_PATH];
			snapshot.GetKey(i, key, sizeof(key));
			MusicState oldState;
			g_LayeredThemes[client.index].GetArray(key, oldState, sizeof(oldState));
			if (strcmp(oldState.MusicPath, state.MusicPath, false) == 0)
			{
				oldState.SetFadeState(SF2MusicFadeState_FadeIn);
				g_LayeredThemes[client.index].SetArray(key, oldState, sizeof(oldState));
				exists = true;
				continue;
			}
		}
		delete snapshot;
		if (!exists)
		{
			state.SetFadeState(SF2MusicFadeState_FadeIn);
			g_LayeredThemes[client.index].SetArray(intString, state, sizeof(state));
		}
	}
}

static void RemoveLayeredTracks(SF2_BasePlayer client, int index = -1)
{
	if (!client.IsValid)
	{
		return;
	}

	if (client.IsEliminated && !client.IsInGhostMode && !client.IsProxy)
	{
		return;
	}

	if (!client.IsEliminated && client.HasEscaped)
	{
		return;
	}

	if (g_LayeredThemes[client.index] == null)
	{
		return;
	}

	char intString[16];
	IntToString(index, intString, sizeof(intString));
	StringMapSnapshot snapshot = g_LayeredThemes[client.index].Snapshot();
	for (int i = 0; i < snapshot.Length; i++)
	{
		char key[PLATFORM_MAX_PATH];
		snapshot.GetKey(i, key, sizeof(key));
		MusicState oldState;
		g_LayeredThemes[client.index].GetArray(key, oldState, sizeof(oldState));
		oldState.SetFadeState(SF2MusicFadeState_FadeOut);
		g_LayeredThemes[client.index].SetArray(key, oldState, sizeof(oldState));
	}
	delete snapshot;
}

static void MusicThink()
{
	float gameTime = GetGameTime();
	float delta = g_LastMusicThink < 0.0 ? 0.0 : gameTime - g_LastMusicThink;
	g_LastMusicThink = gameTime;
	bool globalMusic = g_BossesWithGlobalMusic.Length > 0;

	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);
		if (!client.IsValid)
		{
			continue;
		}

		if (client.IsEliminated && !client.IsInGhostMode && !client.IsProxy)
		{
			continue;
		}

		if (!client.IsEliminated && client.HasEscaped)
		{
			continue;
		}

		bool dontAdd = true;

		if (g_CurrentTheme[client.index].IsNull)
		{
			AddMusicToQueue(client, globalMusic ? g_GlobalMusicState[client.index] : g_DefaultMusicState);
		}

		if (globalMusic)
		{
			if (g_GlobalMusicState[client.index].Length > 0.0 && g_CurrentTrackLength[client.index] > g_GlobalMusicState[client.index].Length)
			{
				UpdateBossGlobalTrackForPlayer(client);
			}
		}

		if (g_CurrentTheme[client.index].FadeState == SF2MusicFadeState_FadeIn)
		{
			g_CurrentTheme[client.index].FadeIn(client, delta);
		}

		if (g_QueuedThemes[client.index] != null)
		{
			StringMapSnapshot snapshot = g_QueuedThemes[client.index].Snapshot();
			for (int i2 = 0; i2 < snapshot.Length; i2++)
			{
				char key[PLATFORM_MAX_PATH];
				snapshot.GetKey(i2, key, sizeof(key));
				MusicState state;
				g_QueuedThemes[client.index].GetArray(key, state, sizeof(state));
				if (globalMusic && strcmp(state.MusicPath, g_GlobalMusicState[client.index].MusicPath, false) == 0 && state.FadeState == SF2MusicFadeState_FadeOut)
				{
					// The global music track still lingers as fading out, keep adding to the delta to avoid weird offsets
					dontAdd = false;
				}
				if (strcmp(state.MusicPath, g_CurrentTheme[client.index].MusicPath, false) == 0)
				{
					g_QueuedThemes[client.index].Remove(key);
					g_CurrentTheme[client.index].CurrentVolume = state.CurrentVolume;
					continue;
				}
				if (state.FadeState == SF2MusicFadeState_FadeOut)
				{
					state.FadeOut(client, delta);
					// Seriously, why the fuck can I not get reference values out of arrays?
					g_QueuedThemes[client.index].SetArray(key, state, sizeof(state));
				}
				else
				{
					g_QueuedThemes[client.index].Remove(key);
				}
			}
			if (snapshot.Length == 0)
			{
				delete g_QueuedThemes[client.index];
			}
			delete snapshot;
		}
		else
		{
			if (globalMusic)
			{
				if (strcmp(g_CurrentTheme[client.index].MusicPath, g_GlobalMusicState[client.index].MusicPath, false) != 0)
				{
					// Our music is not the same as the global music, stop adding to the delta time
					dontAdd = true;
				}
				else
				{
					dontAdd = false;
				}
			}
		}

		if (!dontAdd)
		{
			g_CurrentTrackLength[client.index] += delta;
		}

		if (g_LayeredThemes[client.index] != null)
		{
			StringMapSnapshot snapshot = g_LayeredThemes[client.index].Snapshot();
			for (int i2 = 0; i2 < snapshot.Length; i2++)
			{
				char key[PLATFORM_MAX_PATH];
				snapshot.GetKey(i2, key, sizeof(key));
				MusicState state;
				g_LayeredThemes[client.index].GetArray(key, state, sizeof(state));
				if (state.FadeState == SF2MusicFadeState_FadeIn)
				{
					state.FadeIn(client, delta);
					g_LayeredThemes[client.index].SetArray(key, state, sizeof(state));
				}
				else if (state.FadeState == SF2MusicFadeState_FadeOut)
				{
					state.FadeOut(client, delta);
					g_LayeredThemes[client.index].SetArray(key, state, sizeof(state));
				}
			}
			delete snapshot;
		}

		if (SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsRenevantMap())
		{
			continue;
		}

		float clientPos[3], bossPos[3], targetPos[3];
		client.GetAbsOrigin(clientPos);
		char path[PLATFORM_MAX_PATH];
		float volume = 1.0, radius = 850.0;
		int pitch = 100;
		g_CanSwapBackToDefault[client.index] = true;
		int priorityBoss = -1, layeredBoss = -1;
		int priorityState = ConvertMusicStateToBossState(g_PlayerActiveBossState[client.index]);

		for (int i2 = MAX_BOSSES; i2 >= 0; i2--)
		{
			SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(i2);
			path[0] = '\0';
			if (!controller.IsValid())
			{
				continue;
			}

			if (controller.EntIndex == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			BaseBossProfile data = SF2NPC_BaseNPC(i).GetProfileDataEx();
			if (data.IsPvEBoss)
			{
				continue;
			}

			if (data.Type != SF2BossType_Chaser)
			{
				continue;
			}

			SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);

			if (chaser.State == STATE_DEATH)
			{
				continue;
			}

			chaser.GetAbsOrigin(bossPos);

			GetBossMusicTrack(controller, SF2BossMusicTrackType_Normal, path, sizeof(path), volume, pitch, radius);
			if (path[0] == '\0')
			{
				continue;
			}

			CBaseEntity target = chaser.Target;

			if (chaser.State != priorityState)
			{
				if ((priorityState == STATE_CHASE || priorityState == STATE_ATTACK || priorityState == STATE_STUN)
					&& chaser.State <= STATE_CHASE)
				{
					continue;
				}

				if (priorityState == STATE_ALERT && chaser.State <= priorityState)
				{
					continue;
				}
			}

			if (GetVectorDistance(clientPos, bossPos, true) <= SquareFloat(radius))
			{
				priorityBoss = i2;
				priorityState = chaser.State;
				continue;
			}

			if (chaser.State == STATE_CHASE || chaser.State == STATE_ATTACK || chaser.State == STATE_STUN)
			{
				if (target.IsValid())
				{
					target.GetAbsOrigin(targetPos);
					if (target.index == client.index || GetVectorDistance(clientPos, targetPos, true) <= SquareFloat(radius))
					{
						priorityBoss = i2;
						priorityState = chaser.State;
						continue;
					}
				}
			}

			if (controller.Path.IsValid())
			{
				controller.Path.GetEndPosition(targetPos);
				if (GetVectorDistance(clientPos, targetPos, true) <= SquareFloat(radius))
				{
					priorityBoss = i2;
					priorityState = chaser.State;
					continue;
				}
			}
		}

		SF2NPC_BaseNPC priorityController = SF2NPC_BaseNPC(priorityBoss);
		SF2BossMusicState newState = ConvertBossStateToMusicState(priorityState);
		if (priorityController.IsValid() && (!globalMusic || (globalMusic && newState >= g_GlobalMusicUpdateLimit[client.index])))
		{
			g_CanSwapBackToDefault[client.index] = false;
			int oldBoss = g_PlayerActiveBoss[client.index];
			SF2BossMusicState oldState = g_PlayerActiveBossState[client.index];
			if (oldBoss != priorityBoss || (newState != SF2BossMusicState_Invalid && oldState != ConvertBossStateToMusicState(priorityState)))
			{
				GetBossMusicTrack(priorityController, SF2BossMusicTrackType_Normal, path, sizeof(path), volume, pitch, radius);
				MusicState musicState;
				musicState.Init();
				musicState.MaxVolume = volume;
				musicState.Pitch = pitch;
				musicState.MusicPath = path;
				AddMusicToQueue(client, musicState);
			}
			g_PlayerActiveBoss[client.index] = priorityBoss;
			g_PlayerActiveBossState[client.index] = newState;
		}
		else
		{
			g_PlayerActiveBoss[client.index] = -1;
			g_PlayerActiveBossState[client.index] = SF2BossMusicState_Invalid;
			AddMusicToQueue(client, globalMusic ? g_GlobalMusicState[client.index] : g_DefaultMusicState);
		}

		for (int i2 = 0; i2 < MAX_BOSSES; i2++)
		{
			SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(i2);
			path[0] = '\0';
			if (!controller.IsValid())
			{
				continue;
			}

			if (controller.EntIndex == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			BaseBossProfile data = SF2NPC_BaseNPC(i).GetProfileDataEx();
			if (data.IsPvEBoss)
			{
				continue;
			}

			if (data.Type != SF2BossType_Chaser)
			{
				continue;
			}

			SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);

			if (chaser.State == STATE_DEATH || chaser.State == STATE_STUN)
			{
				continue;
			}

			GetBossMusicTrack(controller, SF2BossMusicTrackType_Visible, path, sizeof(path), volume, pitch, radius);
			if (path[0] == '\0')
			{
				continue;
			}

			if (priorityState != -1)
			{
				if ((priorityState == STATE_CHASE || priorityState == STATE_ATTACK || priorityState == STATE_STUN)
					&& chaser.State < STATE_CHASE)
				{
					continue;
				}

				if (priorityState == STATE_ALERT && chaser.State < priorityState)
				{
					continue;
				}
			}

			if (PlayerCanSeeSlender(client.index, i2, false))
			{
				layeredBoss = i2;
				priorityState = chaser.State;
				break;
			}
		}

		SF2NPC_BaseNPC priorityLayer = SF2NPC_BaseNPC(layeredBoss);
		newState = ConvertBossStateToMusicState(priorityState);
		if (priorityLayer.IsValid() && (!globalMusic || (globalMusic && newState >= g_GlobalMusicUpdateLimit[client.index])))
		{
			int oldBoss = g_PlayerActiveLayerBoss[client.index];
			SF2BossMusicState oldState = g_PlayerActiveLayerBossState[client.index];
			if (oldBoss != priorityBoss || (newState != SF2BossMusicState_Invalid && oldState != ConvertBossStateToMusicState(priorityState)))
			{
				MusicState musicState;
				musicState.Init();
				musicState.MaxVolume = volume;
				musicState.Pitch = pitch;
				musicState.MusicPath = path;
				AddLayeredTrack(client, musicState, layeredBoss);
			}
			g_PlayerActiveLayerBoss[client.index] = layeredBoss;
			g_PlayerActiveLayerBossState[client.index] = newState;
		}
		else if (!priorityLayer.IsValid())
		{
			RemoveLayeredTracks(client, g_PlayerActiveLayerBoss[client.index]);
			g_PlayerActiveLayerBoss[client.index] = -1;
			g_PlayerActiveLayerBossState[client.index] = SF2BossMusicState_Invalid;
		}
	}

	if (IsRoundInEscapeObjective() && g_RoundStopPageMusicOnEscape)
	{
		g_OldDefaultMusicState.Reset();
	}

	RequestFrame(MusicThink);
}

static SF2BossMusicState ConvertBossStateToMusicState(int state)
{
	if (state == STATE_IDLE)
	{
		return SF2BossMusicState_Idle;
	}
	else if (state == STATE_ALERT)
	{
		return SF2BossMusicState_Alert;
	}
	else if (state == STATE_CHASE || state == STATE_ATTACK || state == STATE_STUN)
	{
		return SF2BossMusicState_Chase;
	}
	return SF2BossMusicState_Invalid;
}

static int ConvertMusicStateToBossState(SF2BossMusicState state)
{
	if (state == SF2BossMusicState_Idle)
	{
		return STATE_IDLE;
	}
	else if (state == SF2BossMusicState_Alert)
	{
		return STATE_ALERT;
	}
	else if (state == SF2BossMusicState_Chase)
	{
		return STATE_CHASE;
	}
	return -1;
}

static void GetBossMusicTrack(SF2NPC_BaseNPC controller,
	SF2BossMusicTrackType trackType,
	char[] buffer,
	int bufferSize,
	float& volume = 1.0,
	int& pitch = 100,
	float& radius = 850.0,
	bool& instantFade = false,
	float& fadeSpeed = 1.0,
	SF2BossMusicState& priority = SF2BossMusicState_Max,
	float& length = -1.0,
	SF2BossGlobalMusicShuffleType& shuffleType = SF2BossGlobalMusicShuffleType_None,
	SF2_BasePlayer client = SF2_INVALID_PLAYER)
{
	if (!controller.IsValid())
	{
		return;
	}

	BaseBossProfile data = controller.GetProfileDataEx();
	if (data.IsPvEBoss)
	{
		return;
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);

	if (chaser.IsValid() && chaser.State == STATE_DEATH)
	{
		return;
	}

	ProfileMusic soundInfo;
	ProfileGlobalTracks globalTrack;
	int difficulty = controller.Difficulty;
	switch (trackType)
	{
		case SF2BossMusicTrackType_Normal:
		{
			if (!chaser.IsValid())
			{
				return;
			}

			if (data.Type != SF2BossType_Chaser)
			{
				return;
			}

			switch (chaser.State)
			{
				case STATE_IDLE:
				{
					soundInfo = view_as<ChaserBossProfile>(data).GetIdleMusics();
				}

				case STATE_ALERT:
				{
					soundInfo = view_as<ChaserBossProfile>(data).GetAlertMusics();
				}

				case STATE_CHASE, STATE_ATTACK, STATE_STUN:
				{
					soundInfo = view_as<ChaserBossProfile>(data).GetChaseMusics();
				}
			}
		}

		case SF2BossMusicTrackType_Visible:
		{
			if (!chaser.IsValid())
			{
				return;
			}

			if (data.Type != SF2BossType_Chaser)
			{
				return;
			}

			switch (chaser.State)
			{
				case STATE_IDLE:
				{
					soundInfo = view_as<ChaserBossProfile>(data).GetVisibleIdleMusics();
				}

				case STATE_ALERT:
				{
					soundInfo = view_as<ChaserBossProfile>(data).GetVisibleAlertMusics();
				}

				case STATE_CHASE, STATE_ATTACK:
				{
					soundInfo = view_as<ChaserBossProfile>(data).GetVisibleChaseMusics();
				}
			}
		}

		case SF2BossMusicTrackType_Global:
		{
			globalTrack = data.GetGlobalTracks();
			if (globalTrack == null)
			{
				return;
			}
			KeyMap_Array tracks = globalTrack.GetTracks();
			if (tracks == null || tracks.Length == 0)
			{
				return;
			}
			priority = globalTrack.GetPriority(difficulty);
			shuffleType = globalTrack.GetShuffleType(difficulty);
			bool changed = false;
			SF2BossGlobalMusicShuffleType oldType = g_CurrentTrackShuffleType;
			if (g_GlobalMusicTrackMasterID != controller.UniqueID)
			{
				if (g_CurrentTracks != null)
				{
					delete g_CurrentTracks;
				}
				g_CurrentTrackIndex = 0;
				g_GlobalMusicTrackMasterID = controller.UniqueID;
				g_CurrentTrackShuffleType = SF2BossGlobalMusicShuffleType_Random;
			}

			if (g_CurrentTracks == null)
			{
				for (int i = 0; i < tracks.Length; i++)
				{
					ProfileGlobalTrack track = view_as<ProfileGlobalTrack>(tracks.GetSection(i));
					if (track == null)
					{
						continue;
					}
					if (!track.IsEnabled(difficulty))
					{
						continue;
					}
					if (g_CurrentTracks == null)
					{
						g_CurrentTracks = new ArrayList();
					}
					g_CurrentTracks.Push(track);
				}
			}

			if (g_CurrentTracks == null)
			{
				// Wait that's illegal, fallback to the first track
				g_CurrentTracks = new ArrayList();
				g_CurrentTracks.Push(view_as<ProfileGlobalTrack>(tracks.GetSection(0)));
			}
			ProfileGlobalTrack track = null;
			g_CurrentTrackShuffleType = globalTrack.GetShuffleType(difficulty);
			if (oldType != g_CurrentTrackShuffleType)
			{
				changed = true;
			}
			switch (g_CurrentTrackShuffleType)
			{
				case SF2BossGlobalMusicShuffleType_None:
				{
					track = g_CurrentTracks.Get(g_CurrentTrackIndex);
				}

				case SF2BossGlobalMusicShuffleType_Random:
				{
					ArrayList tempTracks = g_CurrentTracks.Clone();
					if (client.IsValid)
					{
						for (int i = 0; i < tempTracks.Length; i++)
						{
							ProfileGlobalTrack tempTrack = view_as<ProfileGlobalTrack>(tempTracks.Get(i));
							if (tempTrack == null)
							{
								continue;
							}
							char temp[PLATFORM_MAX_PATH];
							tempTrack.GetPath(difficulty, temp, sizeof(temp));
							if (client.IsValid && !client.IsBot && strcmp(g_GlobalMusicState[client.index].MusicPath, temp, false) == 0)
							{
								tempTracks.Erase(i);
								i--;
							}
						}
					}

					track = tempTracks.Get(GetRandomInt(0, tempTracks.Length - 1));
					delete tempTracks;
				}

				case SF2BossGlobalMusicShuffleType_Order:
				{
					g_CurrentTrackIndex++;
					if (g_CurrentTrackIndex >= g_CurrentTracks.Length)
					{
						g_CurrentTrackIndex = 0;
					}
					track = g_CurrentTracks.Get(g_CurrentTrackIndex);
				}

				case SF2BossGlobalMusicShuffleType_RandomOrder:
				{
					if (!changed)
					{
						g_CurrentTracks.Sort(Sort_Random, Sort_Integer);
					}
					g_CurrentTrackIndex++;
					if (g_CurrentTrackIndex >= g_CurrentTracks.Length)
					{
						g_CurrentTrackIndex = 0;
					}
					track = g_CurrentTracks.Get(g_CurrentTrackIndex);
				}
			}
			track.GetPath(difficulty, buffer, bufferSize);
			volume = track.GetVolume(difficulty);
			pitch = track.GetPitch(difficulty);
			length = track.GetLength(difficulty);
			return;
		}
	}

	if (soundInfo != null)
	{
		if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
		{
			soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, bufferSize);
			volume = soundInfo.GetVolume();
			pitch = soundInfo.GetPitch();
			radius = soundInfo.GetRadius();
			instantFade = soundInfo.CanInstantFade();
			fadeSpeed = soundInfo.GetFadeSpeed();
			return;
		}
	}
}