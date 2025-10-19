#pragma semicolon 1

#include "actions/playsequenceandwait.sp"
#include "actions/deathcam.sp"

static CEntityFactory g_Factory;

enum SF2NPCMoveParameterType
{
	SF2NPCMoveParameter_None = 0,
	SF2NPCMoveParameter_XY,
	SF2NPCMoveParameter_Yaw
}

methodmap SF2_BaseBoss < CBaseCombatCharacter
{
	public SF2_BaseBoss(int ent)
	{
		return view_as<SF2_BaseBoss>(ent);
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
		g_Factory = new CEntityFactory("sf2_npc_boss_base", OnCreate, OnRemove);
		g_Factory.IsAbstract = true;
		g_Factory.DeriveFromNPC();
		g_Factory.BeginDataMapDesc()
			.DefineIntField("m_Controller")
			.DefineIntField("m_State")
			.DefineIntField("m_PreviousState")
			.DefineEntityField("m_Target")
			.DefineEntityField("m_OldTarget")
			.DefineIntField("m_InterruptConditions")
			.DefineBoolField("m_IsJumping")
			.DefineBoolField("m_IsEntityVisible", 2049)
			.DefineBoolField("m_IsEntityInFOV", 2049)
			.DefineBoolField("m_IsEntityNear", 2049)
			.DefineFloatField("m_CurrentChaseDuration")
			.DefineFloatField("m_InitialChaseDuration")
			.DefineFloatField("m_LegacyFootstepInterval")
			.DefineFloatField("m_LegacyFootstepTime")
			.DefineIntField("m_MovementType")
			.DefineIntField("m_MoveParameterType")
			.DefineIntField("m_MoveXPoseParameter")
			.DefineIntField("m_MoveYPoseParameter")
			.DefineIntField("m_MoveScalePoseParameter")
			.DefineIntField("m_MoveYawPoseParameter")
			.DefineFloatField("m_AnimationPlaybackRate")
			.DefineFloatField("m_EstimatedYaw")
			.DefineFloatField("m_LastKillTime")
			.DefineBoolField("m_DebugShouldGoToPos")
			.DefineVectorField("m_ForceWanderPos")
			.DefineBoolField("m_IsKillingSomeone")
			.DefineEntityField("m_KillTarget")
			.DefineBoolField("m_IsAttemptingToMove")
			.DefineIntField("m_EyeBoneIndex")
			.DefineBoolField("m_VelocityCancel")
			.DefineIntField("m_Teleporters")
		.EndDataMapDesc();
		g_Factory.Install();

		g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	}

	public static CEntityFactory GetFactory()
	{
		return g_Factory;
	}

	property SF2NPC_BaseNPC Controller
	{
		public get()
		{
			return SF2NPC_BaseNPC.FromUniqueId(this.GetProp(Prop_Data, "m_Controller"));
		}

		public set(SF2NPC_BaseNPC controller)
		{
			this.SetProp(Prop_Data, "m_Controller", controller.Index == -1 ? -1 : controller.UniqueID);
		}
	}

	property int State
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_State");
		}

		public set(int value)
		{
			if (this.Controller.IsValid())
			{
				Call_StartForward(g_OnBossChangeStateFwd);
				Call_PushCell(this.Controller.Index);
				Call_PushCell(this.GetProp(Prop_Data, "m_State"));
				Call_PushCell(value);
				Call_Finish();
			}

			this.SetProp(Prop_Data, "m_State", value);
		}
	}

	property int PreviousState
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_PreviousState");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_PreviousState", value);
		}
	}

	public SF2BossProfileData GetProfileData()
	{
		return this.Controller.GetProfileData();
	}

	property CBaseEntity Target
	{
		public get()
		{
			return CBaseEntity(EntRefToEntIndex(this.GetPropEnt(Prop_Data, "m_Target")));
		}

		public set(CBaseEntity entity)
		{
			this.SetPropEnt(Prop_Data, "m_Target", EnsureEntRef(entity.index));
		}
	}

	property CBaseEntity OldTarget
	{
		public get()
		{
			return CBaseEntity(EntRefToEntIndex(this.GetPropEnt(Prop_Data, "m_OldTarget")));
		}

		public set(CBaseEntity entity)
		{
			this.SetPropEnt(Prop_Data, "m_OldTarget", EnsureEntRef(entity.index));
		}
	}

	property int InterruptConditions
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_InterruptConditions");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_InterruptConditions", value);
		}
	}

	property bool IsJumping
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsJumping") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsJumping", value);
		}
	}

	public bool GetIsVisible(CBaseEntity entity)
	{
		return this.GetProp(Prop_Data, "m_IsEntityVisible", _, entity.index) != 0;
	}

	public void SetIsVisible(CBaseEntity entity, bool value)
	{
		this.SetProp(Prop_Data, "m_IsEntityVisible", value, _, entity.index);
	}

	public bool GetInFOV(CBaseEntity entity)
	{
		return this.GetProp(Prop_Data, "m_IsEntityInFOV", _, entity.index) != 0;
	}

	public void SetInFOV(CBaseEntity entity, bool value)
	{
		this.SetProp(Prop_Data, "m_IsEntityInFOV", value, _, entity.index);
	}

	public bool GetIsNear(CBaseEntity entity)
	{
		return this.GetProp(Prop_Data, "m_IsEntityNear", _, entity.index) != 0;
	}

	public void SetIsNear(CBaseEntity entity, bool value)
	{
		this.SetProp(Prop_Data, "m_IsEntityNear", value, _, entity.index);
	}

	property float CurrentChaseDuration
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_CurrentChaseDuration");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_CurrentChaseDuration", value);
		}
	}

	property float InitialChaseDuration
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_InitialChaseDuration");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_InitialChaseDuration", value);
		}
	}

	property float LegacyFootstepInterval
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_LegacyFootstepInterval");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_LegacyFootstepInterval", value);
		}
	}

	property float LegacyFootstepTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_LegacyFootstepTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_LegacyFootstepTime", value);
		}
	}

	property SF2NPCMoveTypes MovementType
	{
		public get()
		{
			return view_as<SF2NPCMoveTypes>(this.GetProp(Prop_Data, "m_MovementType"));
		}

		public set(SF2NPCMoveTypes value)
		{
			this.SetProp(Prop_Data, "m_MovementType", value);
		}
	}

	property SF2NPCMoveParameterType MoveParameterType
	{
		public get()
		{
			return view_as<SF2NPCMoveParameterType>(this.GetProp(Prop_Data, "m_MoveParameterType"));
		}

		public set(SF2NPCMoveParameterType value)
		{
			this.SetProp(Prop_Data, "m_MoveParameterType", value);
		}
	}

	property int MoveXParameter
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_MoveXPoseParameter");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_MoveXPoseParameter", value);
		}
	}

	property int MoveYParameter
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_MoveYPoseParameter");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_MoveYPoseParameter", value);
		}
	}

	property int MoveScaleParameter
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_MoveScalePoseParameter");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_MoveScalePoseParameter", value);
		}
	}

	property int MoveYawParameter
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_MoveYawPoseParameter");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_MoveYawPoseParameter", value);
		}
	}

	property float AnimationPlaybackRate
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_AnimationPlaybackRate");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_AnimationPlaybackRate", value);
		}
	}

	property float EstimatedYaw
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_EstimatedYaw");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_EstimatedYaw", value);
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

	property bool DebugShouldGoToPos
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_DebugShouldGoToPos") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_DebugShouldGoToPos", value);
		}
	}

	public void GetForceWanderPosition(float buffer[3])
	{
		this.GetPropVector(Prop_Data, "m_ForceWanderPos", buffer);
	}

	public void SetForceWanderPosition(float buffer[3])
	{
		this.SetPropVector(Prop_Data, "m_ForceWanderPos", buffer);
	}

	property bool IsKillingSomeone
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsKillingSomeone") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsKillingSomeone", value);
		}
	}

	property CBaseEntity KillTarget
	{
		public get()
		{
			return CBaseEntity(EntRefToEntIndex(this.GetPropEnt(Prop_Data, "m_KillTarget")));
		}

		public set(CBaseEntity entity)
		{
			this.SetPropEnt(Prop_Data, "m_KillTarget", EnsureEntRef(entity.index));
		}
	}

	property bool IsAttemptingToMove
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsAttemptingToMove") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsAttemptingToMove", value);
		}
	}

	property int EyeBoneIndex
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_EyeBoneIndex");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_EyeBoneIndex", value);
		}
	}

	property bool VelocityCancel
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_VelocityCancel") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_VelocityCancel", value);
		}
	}

	property ArrayList Teleporters
	{
		public get()
		{
			return view_as<ArrayList>(this.GetProp(Prop_Data, "m_Teleporters"));
		}

		public set(ArrayList value)
		{
			this.SetProp(Prop_Data, "m_Teleporters", value);
		}
	}

	public void EyePosition(float buffer[3], const float defaultValue[3] = { 0.0, 0.0, 0.0 })
	{
		this.Controller.GetEyePosition(buffer, defaultValue);
	}

	property int Team
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_iTeamNum");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_iTeamNum", value);
		}
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_BaseBossEntity.IsValid.get", Native_GetIsValid);
		CreateNative("SF2_BaseBossEntity.Controller.get", Native_GetController);
		CreateNative("SF2_BaseBossEntity.Target.get", Native_GetTarget);
		CreateNative("SF2_BaseBossEntity.State.get", Native_GetState);
		CreateNative("SF2_BaseBossEntity.CurrentChaseDuration.get", Native_GetCurrentChaseDuration);
		CreateNative("SF2_BaseBossEntity.CurrentChaseDuration.set", Native_SetCurrentChaseDuration);
		CreateNative("SF2_BaseBossEntity.InitialChaseDuration.get", Native_GetInitialChaseDuration);
		CreateNative("SF2_BaseBossEntity.InitialChaseDuration.set", Native_SetInitialChaseDuration);
		CreateNative("SF2_BaseBossEntity.IsKillingSomeone.get", Native_GetIsKillingSomeone);
		CreateNative("SF2_BaseBossEntity.EyePosition", Native_EyePosition);
		CreateNative("SF2_BaseBossEntity.GetProfileName", Native_GetProfileName);
		CreateNative("SF2_BaseBossEntity.GetName", Native_GetName);
		CreateNative("SF2_BaseBossEntity.ProfileData", Native_GetProfileData);
		CreateNative("SF2_BaseBossEntity.ResetProfileAnimation", Native_ResetProfileAnimation);
	}

	public int SelectProfileAnimation(const char[] animType, float &rate = 1.0, float &duration = 0.0, float &cycle = 0.0, float &footstepInterval = 0.0,
										int &index = 0, int preDefinedIndex = -1, const char[] preDefinedName = "", const char[] posture = NULL_STRING, bool &overrideLoop = false, bool &loop = false, char[] returnAnimation = "", int rtnAnimationLength = 0)
	{
		SF2NPC_BaseNPC controller = this.Controller;
		int difficulty = controller.Difficulty;

		char animation[64];

		bool found = false;

		if (controller.Type == SF2BossType_Chaser && !IsNullString(posture) && strcmp(posture, SF2_PROFILE_CHASER_DEFAULT_POSTURE) != 0)
		{
			SF2NPC_Chaser chaserController = view_as<SF2NPC_Chaser>(controller);
			SF2ChaserBossProfileData data;
			data = chaserController.GetProfileData();
			SF2ChaserBossProfilePostureInfo postureInfo;
			found = data.GetPosture(posture, postureInfo);
			if (found)
			{
				found = postureInfo.Animations.GetAnimation(animType, difficulty, animation, sizeof(animation),
																			rate, duration, cycle, footstepInterval, index, preDefinedIndex, preDefinedName, overrideLoop, loop);
				if (found)
				{
					this.AnimationPlaybackRate = rate;

					return LookupProfileAnimation(this.index, animation);
				}
			}
		}

		found = controller.GetProfileData().AnimationData.GetAnimation(animType, difficulty, animation, sizeof(animation),
																			rate, duration, cycle, footstepInterval, index, preDefinedIndex, preDefinedName, overrideLoop, loop);

		if (!found)
		{
			return -1;
		}

		int sequence = LookupProfileAnimation(this.index, animation);

		strcopy(returnAnimation, rtnAnimationLength, animation);

		this.AnimationPlaybackRate = rate;

		return sequence;
	}

	public int SelectProfileGesture(int definedIndex = -1, const char[] definedName = "", const char[] animType, float &rate = 1.0, float &cycle = 0.0)
	{
		SF2NPC_BaseNPC controller = view_as<SF2NPC_BaseNPC>(this.Controller);
		int difficulty = GetLocalGlobalDifficulty(controller.Index);

		char gesture[64];

		bool found = controller.GetProfileData().AnimationData.GetGesture(definedIndex, definedName, animType, difficulty, gesture, sizeof(gesture),
																			rate, cycle);

		if (!found)
		{
			return -1;
		}

		int sequence = LookupProfileAnimation(this.index, gesture);

		return sequence;
	}

	public bool ResetProfileAnimation(const char[] animType, int preDefinedIndex = -1, const char[] preDefinedName = "", float &duration = 0.0, const char[] posture = NULL_STRING)
	{
		if (this.Controller.IsValid() && (this.Controller.Flags & SFF_MARKEDASFAKE) != 0)
		{
			return false;
		}
		float rate = 1.0, cycle = 0.0, footstepInterval = 0.0;
		bool overrideLoop, loop;
		int index = 0;
		char animation[64];

		int sequence = this.SelectProfileAnimation(animType, rate, duration, cycle, footstepInterval, index, preDefinedIndex, preDefinedName, posture, overrideLoop, loop, animation, sizeof(animation));
		if (sequence == -1)
		{
			return false;
		}

		if (rate < 0.0)
		{
			rate = 0.0;
		}
		if (rate > 12.0)
		{
			rate = 12.0;
		}

		Action result = Plugin_Continue;
		Call_StartForward(g_OnBossAnimationUpdateFwd);
		Call_PushCell(this.Controller);
		Call_PushString(animation);
		Call_Finish(result);

		if (result != Plugin_Handled)
		{
			bool isMovement = strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Walk]) == 0 ||
							strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Run]) == 0;

			bool shouldLoop = isMovement || strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Idle]) == 0;
			this.ResetSequence(sequence);
			this.SetPropFloat(Prop_Send, "m_flCycle", cycle);
			if (strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Attack]) == 0 && this.MovementType == SF2NPCMoveType_Attack)
			{
				shouldLoop = true;
			}
			if (overrideLoop)
			{
				this.SetProp(Prop_Data, "m_bSequenceLoops", loop);
			}
			else
			{
				this.SetProp(Prop_Data, "m_bSequenceLoops", shouldLoop);
			}
			this.SetPropFloat(Prop_Send, "m_flPlaybackRate", rate);

			this.LegacyFootstepInterval = footstepInterval;
		}

		return true;
	}

	public bool AddGesture(const char[] animType, int definedIndex = -1, const char[] definedName = "")
	{
		float rate = 1.0, duration = 0.0, cycle = 0.0;
		int sequence = this.SelectProfileGesture(definedIndex, definedName, animType, rate, cycle);
		if (sequence == -1)
		{
			return false;
		}

		if (rate < 0.0)
		{
			rate = 0.0;
		}
		if (rate > 12.0)
		{
			rate = 12.0;
		}

		duration = this.SequenceDuration(sequence);
		int layer = this.AddLayeredSequence(sequence, 1);
		this.SetLayerDuration(layer, duration);
		this.SetLayerPlaybackRate(layer, rate);
		this.SetLayerCycle(layer, cycle);
		this.SetLayerAutokill(layer, true);
	}

	public bool IsLOSClearFromTarget(CBaseEntity target, bool checkGlass = true)
	{
		if (!target.IsValid())
		{
			return false;
		}
		int traceEnt;
		float eyePos[3], targetPos[3];
		this.WorldSpaceCenter(eyePos);
		target.WorldSpaceCenter(targetPos);
		if (IsValidClient(target.index))
		{
			GetClientEyePosition(target.index, targetPos);
		}
		int flags = CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP;
		if (checkGlass)
		{
			flags = flags | CONTENTS_GRATE | CONTENTS_WINDOW;
		}
		Handle trace = TR_TraceRayFilterEx(eyePos, targetPos,
		flags,
		RayType_EndPoint, TraceRayDontHitEntity, this.index);
		bool visible = !TR_DidHit(trace);
		traceEnt = TR_GetEntityIndex(trace);
		delete trace;
		if (!visible && traceEnt == target.index)
		{
			visible = true;
		}
		return visible;
	}

	public void CreateParticle(char[] particleName, float pos[3])
	{
		CBaseEntity particle = CBaseEntity(CreateEntityByName("info_particle_system"));
		if (particle.IsValid())
		{
			particle.KeyValue("effect_name", particleName);
			particle.Teleport(pos, NULL_VECTOR, NULL_VECTOR);
			particle.Spawn();
			particle.Activate();
			particle.AcceptInput("Start");
			CreateTimer(0.1, Timer_KillEntity, EntIndexToEntRef(particle.index), TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	public void ProcessRainbowOutline()
	{
		SF2NPC_BaseNPC controller = this.Controller;
		SF2BossProfileData data;
		data = controller.GetProfileData();
		int color[4];
		color[0] = RoundToNearest(Cosine((GetGameTime() * data.RainbowOutlineCycle) + controller.Index + 0) * 127.5 + 127.5);
		color[1] = RoundToNearest(Cosine((GetGameTime() * data.RainbowOutlineCycle) + controller.Index + 2) * 127.5 + 127.5);
		color[2] = RoundToNearest(Cosine((GetGameTime() * data.RainbowOutlineCycle) + controller.Index + 4) * 127.5 + 127.5);
		color[3] = 255;
		SetGlowColor(this.index, color);
	}

	public void CheckVelocityCancel()
	{
		CBaseNPC npc = TheNPCs.FindNPCByEntIndex(this.index);
		CBaseNPC_Locomotion loco = npc.GetLocomotion();
		if (loco.IsClimbingOrJumping())
		{
			this.VelocityCancel = false;
			return;
		}
		float mins[3], maxs[3];
		npc.GetBodyMins(mins);
		npc.GetBodyMaxs(maxs);
		mins[0] -= 20.0;
		mins[1] -= 20.0;

		maxs[0] += 20.0;
		maxs[1] += 20.0;

		mins[2] += loco.GetStepHeight();
		maxs[2] += 5.0;
		float myPos[3];
		this.GetAbsOrigin(myPos);

		if (!this.VelocityCancel && IsSpaceOccupiedIgnorePlayersAndEnts(myPos, mins, maxs, this.index))
		{
			float origin[3];
			loco.SetVelocity(origin);
			this.VelocityCancel = true;
		}
	}
}

static void OnCreate(SF2_BaseBoss boss)
{
	boss.Controller = SF2_INVALID_NPC;
	boss.Target = CBaseEntity(-1);
	boss.LastKillTime = 0.0;
	boss.Teleporters = new ArrayList();

	SDKHook(boss.index, SDKHook_SpawnPost, SpawnPost);
}

static void OnRemove(SF2_BaseBoss boss)
{
	if (boss.Teleporters != null)
	{
		delete boss.Teleporters;
	}
}

static void SpawnPost(int entIndex)
{
	SF2_BaseBoss boss = SF2_BaseBoss(entIndex);

	boss.MoveParameterType = SF2NPCMoveParameter_None;
	boss.MoveXParameter = boss.LookupPoseParameter("move_x");
	boss.MoveYParameter = boss.LookupPoseParameter("move_y");
	boss.EstimatedYaw = 0.0;
	if (boss.MoveXParameter != -1 && boss.MoveYParameter != -1)
	{
		boss.MoveParameterType = SF2NPCMoveParameter_XY;
	}

	if (boss.MoveParameterType == SF2NPCMoveParameter_None)
	{
		boss.MoveYawParameter = boss.LookupPoseParameter("move_yaw");
		if (boss.MoveYawParameter != -1)
		{
			boss.MoveParameterType = SF2NPCMoveParameter_Yaw;
		}
	}

	// This one is independent of move_x, move_y, and move_yaw.
	// Some models need move_scale in addition to move_yaw or move_x + move_y.
	boss.MoveScaleParameter = boss.LookupPoseParameter("move_scale");

	boss.SetForceWanderPosition(NULL_VECTOR);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (fake)
	{
		return;
	}

	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(NPCGetFromEntIndex(inflictor));
	if (!controller.IsValid())
	{
		return;
	}

	if (controller.HasAttribute(SF2Attribute_IgnitePlayerOnDeath))
	{
		client.Ignite(true);
	}

	#if defined _store_included
	char bossName[SF2_MAX_NAME_LENGTH];
	controller.GetName(bossName, sizeof(bossName));
	int difficulty = controller.Difficulty;
	if (NPCGetDrainCreditState(controller.Index))
	{
		Store_SetClientCredits(client.index, Store_GetClientCredits(client.index) - NPCGetDrainCreditAmount(controller.Index, difficulty));
		CPrintToChat(client.index, "{valve}%s{default} has stolen {green}%i credits{default} from you.", bossName, NPCGetDrainCreditAmount(controller.Index, difficulty));
	}
	#endif

	SlenderPrintChatMessage(controller.Index, client.index);
}

static any Native_GetIsValid(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	return bossEntity.IsValid();
}

static any Native_GetController(Handle plugin, int numParams)
{
	int ent = GetNativeCell(1);
	if (!IsValidEntity(ent))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", ent);
	}

	SF2_BaseBoss boss = SF2_BaseBoss(ent);
	if (!boss.Controller.IsValid())
	{
		return -1;
	}
	return boss.Controller;
}

static any Native_GetTarget(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	CBaseEntity target = bossEntity.Target;
	if (target.index == 0)
	{
		return CBaseEntity(-1);
	}
	return target;
}

static any Native_GetState(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	return bossEntity.State;
}

static any Native_GetCurrentChaseDuration(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	return bossEntity.CurrentChaseDuration;
}

static any Native_SetCurrentChaseDuration(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	bossEntity.CurrentChaseDuration = GetNativeCell(2);
	return 0;
}

static any Native_GetInitialChaseDuration(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	return bossEntity.InitialChaseDuration;
}

static any Native_SetInitialChaseDuration(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	bossEntity.InitialChaseDuration = GetNativeCell(2);
	return 0;
}

static any Native_GetIsKillingSomeone(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);
	return bossEntity.IsKillingSomeone;
}

static any Native_EyePosition(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);

	float buffer[3];
	bossEntity.EyePosition(buffer);
	SetNativeArray(2, buffer, 3);

	return 0;
}

static any Native_GetProfileName(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);

	if (!bossEntity.Controller.IsValid())
	{
		return 0;
	}

	char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
	bossEntity.Controller.GetProfile(buffer, sizeof(buffer));
	SetNativeString(2, buffer, sizeof(buffer));

	return 0;
}

static any Native_GetName(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);

	SF2NPC_BaseNPC controller = bossEntity.Controller;
	if (!controller.IsValid())
	{
		return 0;
	}

	char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
	controller.GetName(buffer, sizeof(buffer));
	SetNativeString(2, buffer, sizeof(buffer));

	return 0;
}

static any Native_GetProfileData(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);

	if (!bossEntity.Controller.IsValid())
	{
		return 0;
	}

	SF2BossProfileData data;
	data = bossEntity.Controller.GetProfileData();
	SetNativeArray(2, data, sizeof(data));
	return 0;
}

static any Native_ResetProfileAnimation(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_BaseBoss bossEntity = SF2_BaseBoss(entity);

	char animation[64], preDefinedName[64];
	GetNativeString(2, animation, sizeof(animation));
	GetNativeString(4, preDefinedName, sizeof(preDefinedName));
	float duration = GetNativeCellRef(5);
	bossEntity.ResetProfileAnimation(animation, GetNativeCell(3), preDefinedName, duration);
	return 0;
}
