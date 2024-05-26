#pragma semicolon 1

#include "actions/mainlayer.sp"
#include "actions/idle.sp"
#include "actions/chase.sp"

static CEntityFactory g_Factory;

methodmap SF2_StatueEntity < SF2_BaseBoss
{
	public SF2_StatueEntity(int entity)
	{
		return view_as<SF2_StatueEntity>(entity);
	}

	public bool IsValid()
	{
		if (!CBaseCombatCharacter(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_Factory;
	}

	public static void Initialize()
	{
		g_Factory = new CEntityFactory("sf2_npc_boss_statue", OnCreate);
		g_Factory.DeriveFromFactory(SF2_BaseBoss.GetFactory());
		g_Factory.SetInitialActionFactory(SF2_StatueBaseAction.GetFactory());
		g_Factory.BeginDataMapDesc()
			.DefineBoolField("m_IsMoving")
			.DefineFloatField("m_LastKillTime")
		.EndDataMapDesc();
		g_Factory.Install();
	}

	property SF2NPC_Statue Controller
	{
		public get()
		{
			return view_as<SF2NPC_Statue>(view_as<SF2_BaseBoss>(this).Controller);
		}

		public set(SF2NPC_Statue controller)
		{
			view_as<SF2_BaseBoss>(this).Controller = controller;
		}
	}

	property bool IsMoving
	{
		public get()
		{
			return view_as<bool>(this.GetProp(Prop_Data, "m_IsMoving"));
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsMoving", value);
		}
	}
	property float LastKillTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_LastKillTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_LastKillTime", value);
		}
	}

	public void DoAlwaysLookAt(CBaseEntity target)
	{
		if (!target.IsValid())
		{
			return;
		}

		SF2_BasePlayer player = SF2_BasePlayer(target.index);
		if (player.IsValid && !player.IsAlive)
		{
			return;
		}

		INextBot bot = this.MyNextBotPointer();
		ILocomotion loco = bot.GetLocomotionInterface();
		if ((this.InterruptConditions & COND_ENEMYVISIBLE) == 0)
		{
			return;
		}

		float pos[3];
		target.GetAbsOrigin(pos);
		loco.FaceTowards(pos);
	}

	public static SF2_StatueEntity Create(SF2NPC_BaseNPC controller, const float pos[3], const float ang[3])
	{
		SF2_StatueEntity statue = SF2_StatueEntity(CreateEntityByName("sf2_npc_boss_statue"));
		if (!statue.IsValid())
		{
			return SF2_StatueEntity(-1);
		}
		if (controller == SF2_INVALID_NPC)
		{
			return SF2_StatueEntity(-1);
		}
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];

		controller.GetProfile(profile, sizeof(profile));
		statue.Controller = view_as<SF2NPC_Statue>(controller);

		SF2BossProfileData originalData;
		originalData = view_as<SF2NPC_BaseNPC>(statue.Controller).GetProfileData();

		char buffer[PLATFORM_MAX_PATH];

		GetSlenderModel(controller.Index, _, buffer, sizeof(buffer));
		statue.SetModel(buffer);
		statue.SetRenderMode(view_as<RenderMode>(g_SlenderRenderMode[controller.Index]));
		statue.SetRenderFx(view_as<RenderFx>(g_SlenderRenderFX[controller.Index]));
		statue.SetRenderColor(g_SlenderRenderColor[controller.Index][0], g_SlenderRenderColor[controller.Index][1],
								g_SlenderRenderColor[controller.Index][2], g_SlenderRenderColor[controller.Index][3]);

		if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
		{
			float scaleModel = controller.ModelScale * 0.5;
			statue.SetPropFloat(Prop_Send, "m_flModelScale", scaleModel);
		}
		else
		{
			statue.SetPropFloat(Prop_Send, "m_flModelScale", controller.ModelScale);
		}

		CBaseNPC npc = TheNPCs.FindNPCByEntIndex(statue.index);
		CBaseNPC_Locomotion loco = npc.GetLocomotion();

		npc.flMaxYawRate = 0.0;
		npc.flStepSize = 18.0;
		npc.flGravity = 800.0;
		npc.flDeathDropHeight = 99999.0;
		npc.flJumpHeight = 512.0;
		npc.flMaxYawRate = originalData.TurnRate;
		loco.SetCallback(LocomotionCallback_ShouldCollideWith, LocoCollideWith);
		loco.SetCallback(LocomotionCallback_ClimbUpToLedge, ClimbUpCBase);

		statue.SetPropVector(Prop_Send, "m_vecMins", HULL_HUMAN_MINS);
		statue.SetPropVector(Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);

		statue.SetPropVector(Prop_Send, "m_vecMinsPreScaled", HULL_HUMAN_MINS);
		statue.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);

		npc.SetBodyMins(HULL_HUMAN_MINS);
		npc.SetBodyMaxs(HULL_HUMAN_MAXS);

		statue.SetProp(Prop_Data, "m_nSolidType", SOLID_BBOX);
		SetEntityCollisionGroup(statue.index, COLLISION_GROUP_DEBRIS_TRIGGER);

		statue.Teleport(pos, ang, NULL_VECTOR);

		statue.Spawn();
		statue.Activate();

		return statue;
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_StatueBossEntity.IsValid.get", Native_GetIsValid);
		CreateNative("SF2_StatueBossEntity.IsMoving.get", Native_GetIsMoving);
		CreateNative("SF2_StatueBossEntity.LastKillTime.get", Native_GetLastKillTime);
		CreateNative("SF2_StatueBossEntity.ProfileData", Native_GetProfileData);
	}
}

static bool LocoCollideWith(CBaseNPC_Locomotion loco, int other)
{
	return false;
}

static void OnCreate(SF2_StatueEntity ent)
{
	ent.LastKillTime = 0.0;
	SDKHook(ent.index, SDKHook_Think, Think);
	SDKHook(ent.index, SDKHook_ThinkPost, ThinkPost);
	SetEntityTransmitState(ent.index, FL_EDICT_FULLCHECK);
	g_DHookShouldTransmit.HookEntity(Hook_Pre, ent.index, ShouldTransmit);
	g_DHookUpdateTransmitState.HookEntity(Hook_Pre, ent.index, UpdateTransmitState);
}

static Action Think(int entIndex)
{
	SF2_StatueEntity statue = SF2_StatueEntity(entIndex);
	int interruptConditions = 0;
	CBaseEntity target = ProcessVision(statue, interruptConditions);
	statue.InterruptConditions |= interruptConditions;
	statue.Target = target;

	if (statue.IsMoving)
	{
		statue.DoAlwaysLookAt(statue.Target);
	}

	statue.CheckVelocityCancel();

	return Plugin_Continue;
}

static void ThinkPost(int entIndex)
{
	SF2_StatueEntity statue = SF2_StatueEntity(entIndex);

	ProcessSpeed(statue);

	if (NPCGetCustomOutlinesState(statue.Controller.Index) && NPCGetRainbowOutlineState(statue.Controller.Index))
	{
		statue.ProcessRainbowOutline();
	}

	if (statue.IsMoving)
	{
		statue.DoAlwaysLookAt(statue.Target);
	}

	statue.InterruptConditions = 0;
	statue.SetNextThink(GetGameTime());
}

static MRESReturn UpdateTransmitState(int entIndex, DHookReturn ret, DHookParam params)
{
	if (entIndex == -1)
	{
		return MRES_Ignored;
	}

	ret.Value = SetEntityTransmitState(entIndex, FL_EDICT_FULLCHECK);
	return MRES_Supercede;
}

static MRESReturn ShouldTransmit(int entIndex, DHookReturn ret, DHookParam params)
{
	if (entIndex == -1)
	{
		return MRES_Ignored;
	}

	ret.Value = FL_EDICT_ALWAYS;
	return MRES_Supercede;
}

static CBaseEntity ProcessVision(SF2_StatueEntity statue, int &interruptConditions = 0)
{
	interruptConditions = 0;
	SF2NPC_Statue controller = statue.Controller;
	if (!controller.IsValid())
	{
		return CBaseEntity(-1);
	}
	bool attackEliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;
	SF2StatueBossProfileData data;
	data = controller.GetProfileData();
	SF2BossProfileData originalData;
	originalData = view_as<SF2NPC_BaseNPC>(controller).GetProfileData();
	int difficulty = controller.Difficulty;

	float playerDists[MAXTF2PLAYERS];
	int playerInterruptFlags[MAXTF2PLAYERS];

	float traceMins[3] = { -16.0, ... };
	traceMins[2] = 0.0;
	float traceMaxs[3] = { 16.0, ... };
	traceMaxs[2] = 0.0;
	float myEyeAng[3];
	statue.GetAbsAngles(myEyeAng);
	float traceStartPos[3], traceEndPos[3], myPos[3], targetPos[3];
	controller.GetEyePosition(traceStartPos);
	statue.GetAbsOrigin(myPos);

	int oldTarget = statue.OldTarget.index;
	if (!IsTargetValidForSlender(statue, CBaseEntity(oldTarget), attackEliminated))
	{
		statue.OldTarget = CBaseEntity(INVALID_ENT_REFERENCE);
		oldTarget = INVALID_ENT_REFERENCE;
	}

	int bestNewTarget = oldTarget;
	float searchRange = originalData.SearchRange[difficulty];
	float bestNewTargetDist = Pow(searchRange, 2.0);
	if (IsValidEntity(bestNewTarget))
	{
		CBaseEntity(bestNewTarget).GetAbsOrigin(targetPos);
		bestNewTargetDist = GetVectorSquareMagnitude(myPos, targetPos);
		if (bestNewTargetDist > Pow(searchRange, 2.0))
		{
			bestNewTargetDist = Pow(searchRange, 2.0);
		}
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);

		#if defined DEBUG
		if (client.IsValid && g_PlayerDebugFlags[client.index] & DEBUG_BOSS_EYES)
		{
			for (int i2 = 1; i2 <= MaxClients; i2++)
			{
				if (!IsTargetValidForSlender(statue, SF2_BasePlayer(i2), attackEliminated))
				{
					continue;
				}
				float eyes[3];
				SF2_BasePlayer(i2).GetEyePosition(eyes);
				int color[4] = { 0, 255, 0, 255 };
				TE_SetupBeamPoints(traceStartPos, eyes, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, 0.1, 5.0, 5.0, 5, 0.0, color, 1);
				TE_SendToClient(client.index);
			}
		}
		#endif

		if (!IsTargetValidForSlender(statue, client, attackEliminated))
		{
			continue;
		}

		statue.SetIsVisible(client, false);
		statue.SetInFOV(client, false);
		statue.SetIsNear(client, false);

		client.GetEyePosition(traceEndPos);

		float dist = 99999999999.9;

		bool isVisible = false;
		int traceHitEntity;
		TR_TraceHullFilter(traceStartPos,
		traceEndPos,
		traceMins,
		traceMaxs,
		CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP,
		TraceRayBossVisibility,
		statue.index);

		isVisible = !TR_DidHit();
		traceHitEntity = TR_GetEntityIndex();

		if (!isVisible && traceHitEntity == client.index)
		{
			isVisible = true;
		}

		if (isVisible)
		{
			isVisible = NPCShouldSeeEntity(controller.Index, client.index);
		}

		dist = GetVectorSquareMagnitude(traceStartPos, traceEndPos);

		if (g_PlayerFogCtrlOffset != -1 && g_FogCtrlEnableOffset != -1 && g_FogCtrlEndOffset != -1)
		{
			int fogEntity = client.GetDataEnt(g_PlayerFogCtrlOffset);
			if (IsValidEdict(fogEntity))
			{
				if (GetEntData(fogEntity, g_FogCtrlEnableOffset) &&
					dist >= SquareFloat(GetEntDataFloat(fogEntity, g_FogCtrlEndOffset)))
				{
					isVisible = false;
				}
			}
		}

		if (dist > Pow(originalData.SearchRange[difficulty], 2.0))
		{
			isVisible = false;
		}

		statue.SetIsVisible(client, isVisible);

		if (statue.GetIsVisible(client) && SF_SpecialRound(SPECIALROUND_BOO) && GetVectorSquareMagnitude(traceEndPos, traceStartPos) < SquareFloat(SPECIALROUND_BOO_DISTANCE))
		{
			TF2_StunPlayer(client.index, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
		}

		if (client.ShouldBeForceChased(controller))
		{
			bestNewTarget = client.index;
			playerInterruptFlags[client.index] |= COND_ENEMYRECHASE;
		}

		if (statue.GetIsVisible(client))
		{
			playerInterruptFlags[client.index] |= COND_ENEMYVISIBLE;
		}

		if (client.index != oldTarget)
		{
			playerInterruptFlags[client.index] |= COND_NEWENEMY;
		}

		playerDists[client.index] = dist;

		if (statue.GetIsVisible(client))
		{
			if (dist <= SquareFloat(searchRange))
			{
				if (dist < bestNewTargetDist)
				{
					bestNewTarget = client.index;
					bestNewTargetDist = dist;
					playerInterruptFlags[client.index] |= COND_SAWENEMY;
				}
			}
		}
	}

	if (SF_IsRaidMap() || SF_BossesChaseEndlessly() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsSlaughterRunMap() || g_RenevantBossesChaseEndlessly)
	{
		if (!IsTargetValidForSlender(statue, SF2_BasePlayer(bestNewTarget), attackEliminated))
		{
			if (statue.State != STATE_CHASE && NPCAreAvailablePlayersAlive())
			{
				ArrayList arrayRaidTargets = new ArrayList();

				for (int i = 1; i <= MaxClients; i++)
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
					int raidTarget = arrayRaidTargets.Get(GetRandomInt(0, arrayRaidTargets.Length - 1));
					if (IsValidClient(raidTarget) && !g_PlayerEliminated[raidTarget])
					{
						bestNewTarget = raidTarget;
						SF2_BasePlayer(bestNewTarget).SetForceChaseState(controller, true);
					}
				}
				delete arrayRaidTargets;
			}
		}
		statue.CurrentChaseDuration = data.ChaseDuration[difficulty];
	}

	if (bestNewTarget != INVALID_ENT_REFERENCE)
	{
		interruptConditions = playerInterruptFlags[bestNewTarget];
		statue.OldTarget = CBaseEntity(bestNewTarget);
	}

	return CBaseEntity(bestNewTarget);
}

static void ProcessSpeed(SF2_StatueEntity statue)
{
	SF2NPC_Statue controller = statue.Controller;
	SF2NPC_BaseNPC baseController = view_as<SF2NPC_BaseNPC>(controller);
	int difficulty = controller.Difficulty;
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(statue.index);
	SF2BossProfileData originalData;
	originalData = baseController.GetProfileData();

	float speed, acceleration;

	acceleration = originalData.Acceleration[difficulty];
	if (controller.HasAttribute(SF2Attribute_ReducedAccelerationOnLook) && controller.CanBeSeen(_, true))
	{
		acceleration *= controller.GetAttributeValue(SF2Attribute_ReducedAccelerationOnLook);
	}
	acceleration += controller.GetAddAcceleration();

	speed = originalData.RunSpeed[difficulty] * 10.0; // Backwards compatibility
	if (controller.HasAttribute(SF2Attribute_ReducedSpeedOnLook) && controller.CanBeSeen(_, true))
	{
		speed *= controller.GetAttributeValue(SF2Attribute_ReducedSpeedOnLook);
	}

	speed += baseController.GetAddSpeed();

	float forwardSpeed = speed;
	Action action = Plugin_Continue;
	Call_StartForward(g_OnBossGetSpeedFwd);
	Call_PushCell(controller.Index);
	Call_PushFloatRef(forwardSpeed);
	Call_Finish(action);
	if (action == Plugin_Changed)
	{
		speed = forwardSpeed;
	}

	if (g_InProxySurvivalRageMode)
	{
		speed *= 1.25;
	}

	speed = (speed + (speed * GetDifficultyModifier(difficulty)) / 15.0);
	acceleration = (acceleration + (acceleration * GetDifficultyModifier(difficulty)) / 15.0);

	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) || g_Renevant90sEffect)
	{
		if (speed < 520.0)
		{
			speed = 520.0;
		}
		acceleration += 9001.0;
	}
	if (SF_IsSlaughterRunMap())
	{
		float slaughterSpeed = g_SlaughterRunMinimumBossRunSpeedConVar.FloatValue;
		if (!originalData.SlaughterRunData.CustomMinimumSpeed[difficulty] && speed < slaughterSpeed)
		{
			speed = slaughterSpeed;
		}
		acceleration += 10000.0;
	}

	if ((!originalData.IsPvEBoss && IsBeatBoxBeating(2)) || statue.IsKillingSomeone || !statue.IsMoving)
	{
		speed = 0.0;
	}

	npc.flWalkSpeed = speed * 0.9;
	npc.flRunSpeed = speed;
	npc.flAcceleration = acceleration;
}

static any Native_GetIsValid(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	SF2_StatueEntity bossEntity = SF2_StatueEntity(entity);
	return bossEntity.IsValid();
}

static any Native_GetIsMoving(Handle plugin, int numParams)
{
	int ent = GetNativeCell(1);
	if (!IsValidEntity(ent))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", ent);
	}

	SF2_StatueEntity boss = SF2_StatueEntity(ent);
	return boss.IsMoving;
}

static any Native_GetLastKillTime(Handle plugin, int numParams)
{
	int ent = GetNativeCell(1);
	if (!IsValidEntity(ent))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", ent);
	}

	SF2_StatueEntity boss = SF2_StatueEntity(ent);
	return boss.LastKillTime;
}

static any Native_GetProfileData(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_StatueEntity bossEntity = SF2_StatueEntity(entity);

	SF2StatueBossProfileData data;
	data = bossEntity.Controller.GetProfileData();
	SetNativeArray(2, data, sizeof(data));
	return 0;
}
