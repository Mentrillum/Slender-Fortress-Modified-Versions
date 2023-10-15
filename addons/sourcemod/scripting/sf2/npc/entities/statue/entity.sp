#pragma semicolon 1

static CEntityFactory g_Factory;

methodmap SF2_StatueEntity < CBaseCombatCharacter
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
		g_Factory = new CEntityFactory("sf2_statue_npc", OnCreate, OnRemove);
		g_Factory.DeriveFromNPC();
		g_Factory.SetInitialActionFactory(SF2_StatueBaseAction.GetFactory());
		g_Factory.BeginDataMapDesc()
			.DefineIntField("m_Controller")
			.DefineBoolField("m_IsMoving")
			.DefineEntityField("m_Target")
			.DefineFloatField("m_ChaseTime")
			.DefineFloatField("m_LastKillTime")
		.EndDataMapDesc();
		g_Factory.Install();
	}

	property SF2NPC_Statue Controller
	{
		public get()
		{
			return view_as<SF2NPC_Statue>(SF2NPC_Statue.FromUniqueId(this.GetProp(Prop_Data, "m_Controller")));
		}

		public set(SF2NPC_Statue controller)
		{
			this.SetProp(Prop_Data, "m_Controller", controller.Index == -1 ? -1 : controller.UniqueID);
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

	property int Target
	{
		public get()
		{
			return this.GetPropEnt(Prop_Data, "m_Target");
		}
		public set(int entity)
		{
			this.SetPropEnt(Prop_Data, "m_Target", entity);
		}
	}

	property float ChaseTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_ChaseTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_ChaseTime", value);
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

	public static SF2_StatueEntity Create(SF2NPC_BaseNPC controller, const float pos[3], const float ang[3])
	{
		SF2_StatueEntity statue = SF2_StatueEntity(CreateEntityByName("sf2_statue_npc"));
		if (!statue.IsValid())
		{
			return SF2_StatueEntity(-1);
		}
		if (controller == SF2_INVALID_NPC_STATUE)
		{
			return SF2_StatueEntity(-1);
		}
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];

		controller.GetProfile(profile, sizeof(profile));
		statue.Controller = view_as<SF2NPC_Statue>(controller);

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
		npc.flGravity = g_Gravity;
		npc.flDeathDropHeight = 99999.0;
		npc.flJumpHeight = 512.0;
		loco.SetCallback(LocomotionCallback_IsAbleToJumpAcrossGaps, CanJumpAcrossGaps);
		loco.SetCallback(LocomotionCallback_IsAbleToClimb, CanJumpAcrossGaps);
		loco.SetCallback(LocomotionCallback_JumpAcrossGap, JumpAcrossGapsCBase);
		loco.SetCallback(LocomotionCallback_ClimbUpToLedge, ClimbUpCBase);

		statue.SetPropVector(Prop_Send, "m_vecMins", HULL_HUMAN_MINS);
		statue.SetPropVector(Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);

		statue.SetPropVector(Prop_Send, "m_vecMinsPreScaled", HULL_HUMAN_MINS);
		statue.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);

		statue.SetProp(Prop_Data, "m_nSolidType", SOLID_BBOX);
		statue.SetProp(Prop_Send, "m_CollisionGroup", COLLISION_GROUP_DEBRIS_TRIGGER);

		SDKHook(statue.iEnt, SDKHook_ThinkPost, SlenderStatueSetNextThink);
		SDKHook(statue.iEnt, SDKHook_Think, SlenderStatueBossProcessMovement);

		statue.Teleport(pos, ang, NULL_VECTOR);

		statue.Spawn();
		statue.Activate();

		return statue;
	}
}

static void OnCreate(int ent)
{
	// Do nothing
}

static void OnRemove(int ent)
{
	// Do nothing
}

static void SlenderStatueSetNextThink(int bossEnt)
{
	if (!g_Enabled)
	{
		return;
	}

	CBaseCombatCharacter(bossEnt).SetNextThink(GetGameTime());

	return;
}
