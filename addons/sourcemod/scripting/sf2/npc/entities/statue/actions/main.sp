#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_StatueBaseAction < NextBotAction
{
	public SF2_StatueBaseAction()
	{
		return view_as<SF2_StatueBaseAction>(g_Factory.Create());
	}

	public static NextBotActionFactory GetFactory()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Statue_Main");
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
		}
		return g_Factory;
	}
}

static int Update(SF2_StatueBaseAction action, SF2_StatueEntity actor, float interval)
{
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(actor.index);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	INextBot bot = npc.GetBot();

	SF2NPC_Statue controller = actor.Controller;
	int bossIndex = controller.Index;

	int difficulty = g_DifficultyConVar.IntValue;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	controller.GetProfile(profile, sizeof(profile));

	bool attackWaiters = !!(controller.Flags & SFF_ATTACKWAITERS);

	float gameTime = GetGameTime();
	float chaseDurationTimeAddMin = controller.AddChaseDurationMin(difficulty);
	float chaseDurationTimeAddMax = controller.AddChaseDurationMax(difficulty);
	bool move = false;
	if (PeopleCanSeeSlender(bossIndex, true, true, !attackWaiters))
	{
		if (actor.ChaseTime < gameTime)
		{
			actor.ChaseTime = gameTime + controller.GetChaseDuration(difficulty);
		}
		actor.ChaseTime += chaseDurationTimeAddMin;
		if (actor.ChaseTime > (gameTime + controller.GetChaseDuration(difficulty)))
		{
			actor.ChaseTime = gameTime + controller.GetChaseDuration(difficulty);
		}
		for (int i = 0; i < MAX_NPCTELEPORTER; i++)
		{
			if (controller.GetTeleporter(i) != INVALID_ENT_REFERENCE)
			{
				controller.SetTeleporter(i, INVALID_ENT_REFERENCE);
			}
		}
	}

	SF2_BasePlayer origTarget = SF2_BasePlayer(actor.Target);
	if (SF_BossesChaseEndlessly() || SF_IsSlaughterRunMap() && origTarget.IsValid)
	{
		actor.ChaseTime = gameTime + controller.GetChaseDuration(difficulty);
	}

	if (SF_BossesChaseEndlessly() || SF_IsSlaughterRunMap())
	{
		if (!origTarget.IsValid || (origTarget.IsValid && origTarget.IsEliminated))
		{
			if (NPCAreAvailablePlayersAlive())
			{
				ArrayList arrayRaidTargets = new ArrayList();

				for (int i = 1; i < MaxClients; i++)
				{
					if (!IsValidClient(i) ||
						!IsPlayerAlive(i) ||
						g_PlayerEliminated[i] ||
						IsClientInGhostMode(i) ||
						DidClientEscape(i))
					{
						continue;
					}
					arrayRaidTargets.Push(i);
				}
				if (arrayRaidTargets.Length > 0)
				{
					SF2_BasePlayer raidTarget = SF2_BasePlayer(arrayRaidTargets.Get(GetRandomInt(0, arrayRaidTargets.Length - 1)));
					if (raidTarget.IsValid && !raidTarget.IsEliminated)
					{
						actor.Target = raidTarget.index;
						actor.ChaseTime = gameTime + controller.GetChaseDuration(difficulty);
					}
				}
				delete arrayRaidTargets;
			}
		}
	}

	int bestPlayer = -1;
	ArrayList array = new ArrayList();

	for (int i = 1; i < MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsPlayerAlive(i) ||
		IsClientInDeathCam(i) || (!attackWaiters && g_PlayerEliminated[i]) ||
		DidClientEscape(i) || IsClientInGhostMode(i) ||
		!PlayerCanSeeSlender(i, bossIndex, false, false, !attackWaiters))
		{
			continue;
		}

		if (!NPCShouldSeeEntity(bossIndex, i))
		{
			continue;
		}

		array.Push(i);
	}

	if (array.Length > 0)
	{
		float slenderPos[3];
		actor.GetAbsOrigin(slenderPos);

		float tempPos[3];
		int tempPlayer = -1;
		float tempDist = SquareFloat(16384.0);
		for (int i = 0; i < array.Length; i++)
		{
			SF2_BasePlayer client = SF2_BasePlayer(array.Get(i));
			client.GetAbsOrigin(tempPos);
			if (GetVectorSquareMagnitude(tempPos, slenderPos) < tempDist)
			{
				tempPlayer = client.index;
				tempDist = GetVectorSquareMagnitude(tempPos, slenderPos);
			}
			if (SF_SpecialRound(SPECIALROUND_BOO) && GetVectorSquareMagnitude(tempPos, slenderPos) < SquareFloat(SPECIALROUND_BOO_DISTANCE))
			{
				client.Stun(SPECIALROUND_BOO_DURATION, 0.0, TF_STUNFLAGS_GHOSTSCARE);
			}
		}

		bestPlayer = tempPlayer;
		if (bestPlayer != -1)
		{
			actor.Target = bestPlayer;
			if (actor.ChaseTime < gameTime)
			{
				actor.ChaseTime = gameTime + controller.GetChaseDuration(difficulty);
			}
		}
	}

	delete array;

	if (!PeopleCanSeeSlender(bossIndex, true, true, !attackWaiters))
	{
		SF2_BasePlayer target = SF2_BasePlayer(actor.Target);
		if (IsTargetValidForSlender(target, attackWaiters) && gameTime < actor.ChaseTime && (gameTime - actor.LastKillTime) >= NPCGetInstantKillCooldown(bossIndex, difficulty))
		{
			move = true;
			float slenderPos[3], pos[3];
			actor.GetAbsOrigin(slenderPos);
			target.GetAbsOrigin(pos);
			if (NPCGetTeleporter(bossIndex, 0) != INVALID_ENT_REFERENCE)
			{
				CBaseEntity teleporter = CBaseEntity(EntRefToEntIndex(NPCGetTeleporter(bossIndex, 0)));
				if (teleporter.IsValid() && teleporter.index > MaxClients)
				{
					teleporter.GetAbsOrigin(pos);
				}
			}
			controller.Path.ComputeToPos(bot, pos);

			float maxRange = NPCStatueGetModelChangeDistance(bossIndex, difficulty);
			float dist = GetVectorSquareMagnitude(slenderPos, pos);

			char buffer[PLATFORM_MAX_PATH];

			if (dist < SquareFloat(maxRange * 0.33))
			{
				controller.GetModel(2, buffer, sizeof(buffer));
			}
			else if (dist < SquareFloat(maxRange * 0.66))
			{
				controller.GetModel(1, buffer, sizeof(buffer));
			}
			else
			{
				controller.GetModel(_, buffer, sizeof(buffer));
			}

			// Fallback if error.
			if (buffer[0] == '\0' || strcmp(buffer, "models/") == 0)
			{
				controller.GetModel(_, buffer, sizeof(buffer));
			}

			actor.SetModel(buffer);

			if (target.CanSeeSlender(bossIndex, false, !attackWaiters))
			{
				float distRatio = (dist / SquareFloat(maxRange));

				float chaseDurationAdd = chaseDurationTimeAddMax - ((chaseDurationTimeAddMax - chaseDurationTimeAddMin) * distRatio);

				if (chaseDurationAdd > 0.0)
				{
					actor.ChaseTime += chaseDurationAdd;
					if (actor.ChaseTime > (gameTime + controller.GetChaseDuration(difficulty)))
					{
						actor.ChaseTime = gameTime + controller.GetChaseDuration(difficulty);
					}
				}
			}

			if (dist <= SquareFloat(controller.InstantKillRadius))
			{
				if (controller.Flags & SFF_FAKE)
				{
					controller.MarkAsFake();
					return action.Done("Faker");
				}
				else
				{
					actor.LastKillTime = gameTime;
					target.StartDeathCam(bossIndex, pos);
					g_LastStuckTime[bossIndex] = gameTime + controller.GetInstantKillCooldown(difficulty) + 0.1;
					if (controller.GetInstantKillCooldown(difficulty) > 0.0)
					{
						actor.IsMoving = false;
						loco.ClearStuckStatus();
					}
					actor.Target = -1;
				}
			}

			g_SlenderStatueIdleLifeTime[bossIndex] = gameTime + controller.GetIdleLifetime(difficulty);
		}
		else
		{
			float origin[3];
			actor.GetAbsOrigin(origin);
			origin[2] -= 10.0;
			g_LastPos[bossIndex] = origin;
		}
	}

	SF2BossProfileSoundInfo soundInfo;
	if (move)
	{
		ArrayList soundList;
		char buffer[PLATFORM_MAX_PATH];
		GetStatueProfileSingleMoveSounds(profile, soundInfo);
		soundInfo.EmitSound(_, actor.index);

		GetStatueProfileMoveSounds(profile, soundInfo);
		soundList = soundInfo.Paths;
		if (soundList != null && soundList.Length > 0)
		{
			soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToAll(buffer, actor.index, soundInfo.Channel, soundInfo.Level, SND_CHANGEVOL, soundInfo.Volume, soundInfo.Pitch);
			}
		}
		soundList = null;
	}
	else
	{
		GetStatueProfileMoveSounds(profile, soundInfo);
		soundInfo.StopAllSounds(actor.index);
	}
	actor.IsMoving = move;

	return action.Continue();
}