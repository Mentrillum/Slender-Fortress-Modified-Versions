#pragma semicolon 1
#pragma newdecls required

methodmap BossProfileBearTrap < BossProfileBaseTrap
{
	public int GetDamageType(int difficulty)
	{
		return this.GetDifficultyInt("damagetype", difficulty, 128);
	}

	public ProfileMasterAnimations GetAnimations()
	{
		return view_as<ProfileMasterAnimations>(this.GetSection("animations"));
	}

	public ProfileSound GetCatchSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			return view_as<ProfileSound>(obj.GetSection("catch"));
		}
		return null;
	}

	public ProfileSound GetMissSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			return view_as<ProfileSound>(obj.GetSection("miss"));
		}
		return null;
	}

	public void Precache()
	{
		if (this.GetCatchSounds() != null)
		{
			this.GetCatchSounds().Precache();
		}

		if (this.GetMissSounds() != null)
		{
			this.GetMissSounds().Precache();
		}
	}
}

static CEntityFactory g_Factory;

methodmap SF2_BearTrap < SF2_BaseTrap
{
	public SF2_BearTrap(int entity)
	{
		return view_as<SF2_BearTrap>(entity);
	}

	public bool IsValid()
	{
		if (!CBaseAnimating(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_Factory;
	}

	public static void Initialize()
	{
		g_Factory = new CEntityFactory("sf2_trap_bear_trap", OnCreate);
		g_Factory.DeriveFromFactory(SF2_BaseTrap.GetFactory());
		g_Factory.BeginDataMapDesc()
			.DefineBoolField("m_Triggered")
			.DefineEntityField("m_Target")
		.EndDataMapDesc();
		g_Factory.Install();
	}

	property bool Triggered
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_Triggered") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_Triggered", value);
		}
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

	public bool UpdateAnimation(const char[] section, bool def = false)
	{
		if (!this.Controller.IsValid())
		{
			return false;
		}
		int difficulty = this.Controller.Difficulty;

		char animName[64];

		BossProfileBearTrap data = view_as<BossProfileBearTrap>(this.Controller.GetProfileData().GetTrapData().GetTrapFromName(this.GetName()));
		ProfileMasterAnimations animations = data.GetAnimations();
		if (animations == null)
		{
			return false;
		}
		ProfileAnimation animation = animations.GetAnimation(section);
		if (animation == null)
		{
			return false;
		}
		animation.GetAnimationName(difficulty, animName, sizeof(animName));
		SetVariantString(animName);
		if (def)
		{
			this.AcceptInput("SetDefaultAnimation");
		}
		else
		{
			this.AcceptInput("SetAnimation");
		}
		this.SetPropFloat(Prop_Data, "m_flPlaybackRate", animation.GetAnimationPlaybackRate(difficulty));
		this.SetProp(Prop_Data, "m_bSequenceLoops", false);
		return true;
	}

	public void Close(bool miss = false)
	{
		BossProfileBearTrap data = view_as<BossProfileBearTrap>(this.Controller.GetProfileData().GetTrapData().GetTrapFromName(this.GetName()));
		if (miss)
		{
			data.GetMissSounds().EmitSound(.entity = this.index);
		}
		else
		{
			data.GetCatchSounds().EmitSound(.entity = this.index);
		}
		bool state = this.UpdateAnimation("close");
		if (!state)
		{
			this.UpdateAnimation("closed");
		}
		this.UpdateAnimation("closed", true);
		this.AcceptInput("DisableCollision");
		this.Triggered = true;
	}
}

static void OnCreate(SF2_BearTrap entity)
{
	bool state = entity.UpdateAnimation("open");
	if (!state)
	{
		entity.UpdateAnimation("opened");
	}
	entity.UpdateAnimation("opened", true);
	entity.SetProp(Prop_Send, "m_usSolidFlags", FSOLID_TRIGGER_TOUCH_DEBRIS |FSOLID_TRIGGER | FSOLID_NOT_SOLID | FSOLID_CUSTOMBOXTEST);
	entity.SetProp(Prop_Data, "m_nSolidType", SOLID_BBOX);
	SetEntityCollisionGroup(entity.index, COLLISION_GROUP_DEBRIS_TRIGGER);

	float mins[3], maxs[3];
	mins[0] = -25.0;
	mins[1] = -25.0;
	mins[2] = 0.0;
	maxs[0] = 25.0;
	maxs[1] = 25.0;
	maxs[2] = 25.0;

	entity.SetPropVector(Prop_Send, "m_vecMins", mins);
	entity.SetPropVector(Prop_Send, "m_vecMaxs", maxs);
	entity.SetPropVector(Prop_Send, "m_vecMinsPreScaled", mins);
	entity.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", maxs);

	entity.AcceptInput("EnableCollision");

	CreateTimer(0.1, Timer_Think, EntIndexToEntRef(entity.index), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	SDKHook(entity.index, SDKHook_OnTakeDamage, OnTakeDamage);
}

static Action Timer_Think(Handle timer, int ref)
{
	int entity = EntRefToEntIndex(ref);
	if (!entity || entity == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	SF2_BearTrap trap = SF2_BearTrap(entity);
	SF2NPC_Chaser controller = trap.Controller;
	if (!controller.IsValid())
	{
		RemoveEntity(trap.index);
		return Plugin_Stop;
	}

	float gameTime = GetGameTime();
	int difficulty = controller.Difficulty;
	if (trap.Triggered)
	{
		if (trap.Target.IsValid())
		{
			trap.TimeUntilRemove = 5.0 + gameTime;
		}
		return Plugin_Continue;
	}

	BossProfileBearTrap data = view_as<BossProfileBearTrap>(controller.GetProfileData().GetTrapData().GetTrapFromName(trap.GetName()));
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid)
		{
			continue;
		}

		if (!player.IsAlive ||
			player.IsInDeathCam ||
			player.IsInGhostMode ||
			player.HasEscaped ||
			player.InCondition(view_as<TFCond>(130)) ||
			player.Team == TFTeam_Spectator)
		{
			continue;
		}

		/*if ((controller.Flags & SFF_ATTACKWAITERS) == 0 && player.IsEliminated)
		{
			continue;
		}*/

		if (!g_Enabled)
		{
			if (player.GetProp(Prop_Data, "m_iTeamNum") == controller.DefaultTeam)
			{
				continue;
			}
		}

		float entPos[3], otherPos[3];
		player.GetAbsOrigin(otherPos);
		trap.GetAbsOrigin(entPos);
		float zPos = otherPos[2] - entPos[2];
		float distance = GetVectorSquareMagnitude(otherPos, entPos);
		if (distance <= SquareFloat(50.0) && (zPos <= 25.0 && zPos >= -25.0))
		{
			TFClassType classType = player.Class;
			int classToInt = view_as<int>(classType);

			if (!IsClassConfigsValid())
			{
				if (classType != TFClass_Heavy)
				{
					player.IsTrapped = true;
					player.TrapCount = GetRandomInt(2, 4);
				}
			}
			else
			{
				if (!g_ClassInvulnerableToTraps[classToInt])
				{
					player.IsTrapped = true;
					player.TrapCount = GetRandomInt(2, 4);
				}
			}
			if (!player.HasHint(PlayerHint_Trap))
			{
				player.ShowHint(PlayerHint_Trap);
			}
			player.TakeDamage(true, _, _, data.GetDamage(difficulty), data.GetDamageType(difficulty));
			data.ApplyDamageEffects(player, difficulty, trap, controller);
			trap.Close();
			trap.Target = player;
			TF2Attrib_SetByName(player.index, "increased jump height", 0.0);
			TF2Attrib_SetByName(player.index, "move speed bonus", 0.0001);
			player.UpdateSpeed();
			break;
		}
	}
	return Plugin_Continue;
}

static Action OnTakeDamage(int entity, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	SF2_BearTrap trap = SF2_BearTrap(entity);
	if (trap.Triggered || !IsValidClient(attacker))
	{
		return Plugin_Continue;
	}

	if (g_Enabled/* && g_PlayerEliminated[attacker]*/)
	{
		return Plugin_Continue;
	}

	if ((damagetype & 0x80) == 0)
	{
		return Plugin_Continue;
	}

	trap.Close(true);
	trap.TimeUntilRemove = 5.0;

	return Plugin_Continue;
}