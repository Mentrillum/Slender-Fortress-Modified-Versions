#pragma semicolon 1
#pragma newdecls required

#include "actions/mainlayer.sp"
#include "actions/idle.sp"
#include "actions/alert.sp"
#include "actions/smell.sp"
#include "actions/chase.sp"
#include "actions/chaseinitial.sp"
#include "actions/attacklayer.sp"
#include "actions/chaselayer.sp"
#include "actions/attack.sp"
#include "actions/stun.sp"
#include "actions/death.sp"
#include "actions/spawn.sp"
#include "actions/tauntkill.sp"
#include "actions/beatbox_freeze.sp"
#include "actions/rage.sp"
#include "actions/flee_to_heal.sp"
#include "actions/despawn.sp"

#include "postures/rage_phase.sp"
#include "postures/running_away.sp"
#include "postures/within_bounds.sp"
#include "postures/within_range.sp"
#include "postures/on_look.sp"
#include "postures/on_alert.sp"
#include "postures/on_cloak.sp"

static CEntityFactory g_Factory;

methodmap SF2_ChaserEntity < SF2_BaseBoss
{
	public SF2_ChaserEntity(int entity)
	{
		return view_as<SF2_ChaserEntity>(entity);
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
		g_Factory = new CEntityFactory("sf2_npc_boss_chaser", OnCreate, OnRemove);
		g_Factory.DeriveFromFactory(SF2_BaseBoss.GetFactory());
		g_Factory.SetInitialActionFactory(SF2_ChaserMainAction.GetFactory());
		g_Factory.BeginDataMapDesc()
			.DefineBoolField("m_IsAllowedToDespawn")
			.DefineBoolField("m_IsSpawning")
			.DefineBoolField("m_IsInAirAnimation")
			.DefineStringField("m_OverrideSpawnAnimation")
			.DefineFloatField("m_OverrideSpawnAnimationRate")
			.DefineFloatField("m_OverrideSpawnAnimationDuration")
			.DefineFloatField("m_Override")
			.DefineBoolField("m_IsStunned")
			.DefineBoolField("m_WasStunned")
			.DefineFloatField("m_StunHealth")
			.DefineFloatField("m_NextStunTime")
			.DefineFloatField("m_MaxStunHealth")
			.DefineFloatField("m_MaxHealth")
			.DefineBoolField("m_IsInChaseInitial")
			.DefineStringField("m_Posture")
			.DefineStringField("m_DefaultPosture")
			.DefineBoolField("m_IsAttacking")
			.DefineBoolField("m_CancelAttack")
			.DefineBoolField("m_ClearCurrentAttack")
			.DefineStringField("m_AttackName")
			.DefineIntField("m_AttackIndex")
			.DefineIntField("m_NextAttackTime")
			.DefineFloatField("m_AttackRunDuration")
			.DefineFloatField("m_AttackRunDelay")
			.DefineFloatField("m_NextVoiceTime")
			.DefineFloatField("m_NextHurtVoiceTime")
			.DefineIntField("m_MovementType")
			.DefineBoolField("m_LockMovementType")
			.DefineIntField("m_AlertTriggerCount", MAXTF2PLAYERS)
			.DefineVectorField("m_AlertTriggerPosition", MAXTF2PLAYERS)
			.DefineEntityField("m_AlertTriggerTarget")
			.DefineFloatField("m_AlertSoundTriggerCooldown", MAXTF2PLAYERS)
			.DefineVectorField("m_AlertTriggerPositionEx")
			.DefineFloatField("m_AlertChangePositionCooldown")
			.DefineIntField("m_TauntAlertStrikes", MAXTF2PLAYERS)
			.DefineIntField("m_AutoChaseCount", MAXTF2PLAYERS)
			.DefineFloatField("m_AutoChaseAddCooldown", MAXTF2PLAYERS)
			.DefineFloatField("m_AutoChaseCooldown", MAXTF2PLAYERS)
			.DefineBoolField("m_MaintainTarget")
			.DefineBoolField("m_AlertWithBoss")
			.DefineBoolField("m_FollowedCompanionAlert")
			.DefineFloatField("m_FollowCooldownAlert")
			.DefineBoolField("m_FollowedCompanionChase")
			.DefineFloatField("m_FollowCooldownChase")
			.DefineIntField("m_SmellPlayerList")
			.DefineFloatField("m_SmellCooldown")
			.DefineBoolField("m_HasSmelled")
			.DefineFloatField("m_ProjectileCooldown")
			.DefineBoolField("m_IsReloadingProjectiles")
			.DefineIntField("m_ProjectileAmmo")
			.DefineFloatField("m_ProjectileReloadTime")
			.DefineEntityField("m_KillTarget")
			.DefineBoolField("m_HasCloaked")
			.DefineFloatField("m_CloakTime")
			.DefineBoolField("m_PlayCloakAnimation")
			.DefineIntField("m_RageIndex")
			.DefineBoolField("m_IsRaging")
			.DefineBoolField("m_IsGoingToHeal")
			.DefineBoolField("m_IsRunningAway")
			.DefineBoolField("m_IsSelfHealing")
			.DefineBoolField("m_OverrideInvincible")
			.DefineFloatField("m_TrapCooldown")
			.DefineBoolField("m_WasInBacon")
			.DefineFloatField("m_FlashlightTick")
			.DefineBoolField("m_ShouldDespawn")
			.DefineBoolField("m_GroundSpeedOverride")
			.DefineBoolField("m_QueueForAlertState")
		.EndDataMapDesc();
		g_Factory.Install();

		AddNormalSoundHook(Hook_ChaserSoundHook);

		g_OnEntityCreatedPFwd.AddFunction(null, EntityCreated);
		g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
		g_OnPlayerTakeDamagePostPFwd.AddFunction(null, OnPlayerTakeDamagePost);
		g_OnPlayerDeathPrePFwd.AddFunction(null, OnPlayerDeathPre);
		g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
		g_OnBuildingDestroyedPFwd.AddFunction(null, OnBuildingDestroyed);

		SF2_ChaserAttackAction.Initialize();
		InitializePostureRagePhase();
		InitializePostureRunningAway();
		InitializePostureWithinBounds();
		InitializePostureWithinRange();
		InitializePostureOnLook();
		InitializePostureOnAlert();
		InitializePostureOnCloak();
	}

	property SF2NPC_Chaser Controller
	{
		public get()
		{
			return view_as<SF2NPC_Chaser>(view_as<SF2_BaseBoss>(this).Controller);
		}

		public set(SF2NPC_Chaser controller)
		{
			view_as<SF2_BaseBoss>(this).Controller = controller;
		}
	}

	property bool IsAllowedToDespawn
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsAllowedToDespawn") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsAllowedToDespawn", value);
		}
	}

	property bool IsSpawning
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsSpawning") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsSpawning", value);
		}
	}

	property bool IsInAirAnimation
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsInAirAnimation") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsInAirAnimation", value);
		}
	}

	public char[] GetOverrideSpawnAnimation()
	{
		char buffer[128];
		this.GetPropString(Prop_Data, "m_OverrideSpawnAnimation", buffer, sizeof(buffer));
		return buffer;
	}

	public void SetOverrideSpawnAnimation(const char[] name, float duration = 0.0, float rate = 1.0)
	{
		this.SetPropString(Prop_Data, "m_OverrideSpawnAnimation", name);
		this.SetPropFloat(Prop_Data, "m_OverrideSpawnAnimationRate", rate);
		this.SetPropFloat(Prop_Data, "m_OverrideSpawnAnimationDuration", duration);
	}

	public bool CanBeStunned()
	{
		if (SF_IsSlaughterRunMap() && !this.Controller.GetProfileData().IsPvEBoss)
		{
			return false;
		}

		if (!this.Controller.IsValid())
		{
			return false;
		}

		if (!this.Controller.GetProfileData().GetStunBehavior().IsEnabled(this.Controller.Difficulty))
		{
			return false;
		}

		if (this.IsStunned)
		{
			return false;
		}

		if (this.MaxStunHealth <= 0.0)
		{
			return false;
		}

		if (GetGameTime() < this.NextStunTime)
		{
			return false;
		}

		if (this.IsKillingSomeone)
		{
			return false;
		}

		if (this.OverrideInvincible)
		{
			return false;
		}

		return true;
	}

	public bool CanTakeDamage(CBaseEntity attacker = view_as<CBaseEntity>(-1), CBaseEntity inflictor = view_as<CBaseEntity>(-1), float damage = 0.0)
	{
		if (SF_IsSlaughterRunMap() && !this.Controller.GetProfileData().IsPvEBoss)
		{
			return false;
		}

		if (!this.IsAttacking)
		{
			return true;
		}

		if (this.OverrideInvincible)
		{
			return false;
		}

		if (attacker.IsValid() || inflictor.IsValid())
		{
			Action action;
			Call_StartForward(g_OnBossPreTakeDamageFwd);
			Call_PushCell(this);
			Call_PushCell(attacker);
			Call_PushCell(inflictor);
			Call_PushCell(damage);
			Call_Finish(action);
			if (action == Plugin_Stop)
			{
				return false;
			}
		}

		int difficulty = this.Controller.Difficulty;

		return !this.Controller.GetProfileData().GetAttack(this.GetAttackName()).IsImmuneToDamage(difficulty);
	}

	property bool IsStunned
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsStunned") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsStunned", value);
		}
	}

	property bool WasStunned
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_WasStunned") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_WasStunned", value);
		}
	}

	property float StunHealth
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_StunHealth");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_StunHealth", value);
		}
	}

	property float MaxStunHealth
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_MaxStunHealth");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_MaxStunHealth", value);
		}
	}

	property float MaxHealth
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_MaxHealth");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_MaxHealth", value);
		}
	}

	property float NextStunTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_NextStunTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_NextStunTime", value);
		}
	}

	property bool IsInChaseInitial
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsInChaseInitial") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsInChaseInitial", value);
		}
	}

	public int GetPosture(char[] buffer, int bufferSize)
	{
		return this.GetPropString(Prop_Data, "m_Posture", buffer, bufferSize);
	}

	public void SetPosture(const char[] posture)
	{
		if (posture[0] == '\0')
		{
			return;
		}

		char currentPosture[64];
		this.GetPosture(currentPosture, sizeof(currentPosture));

		this.SetPropString(Prop_Data, "m_Posture", posture);

		if (this.Controller.IsValid() && strcmp(currentPosture, posture) != 0)
		{
			this.UpdateMovementAnimation();
		}
	}

	public int GetDefaultPosture(char[] buffer, int bufferSize)
	{
		return this.GetPropString(Prop_Data, "m_DefaultPosture", buffer, bufferSize);
	}

	public void SetDefaultPosture(const char[] posture, bool update = true)
	{
		if (posture[0] == '\0')
		{
			return;
		}

		if (strcmp(posture, SF2_PROFILE_CHASER_DEFAULT_POSTURE) != 0)
		{
			if (!this.Controller.IsValid())
			{
				return;
			}

			ChaserBossProfile data = this.Controller.GetProfileData();

			if (data.GetPosture(posture) == null)
			{
				return;
			}
		}

		char currentPosture[64];
		this.GetDefaultPosture(currentPosture, sizeof(currentPosture));

		this.SetPropString(Prop_Data, "m_DefaultPosture", posture);

		if (this.Controller.IsValid() && strcmp(currentPosture, posture) != 0 && update)
		{
			this.SetPosture(posture);
		}
	}

	public bool CanUpdatePosture()
	{
		if (this.State == STATE_DEATH)
		{
			return false;
		}

		if (this.IsAttacking)
		{
			return false;
		}

		if (this.IsStunned)
		{
			return false;
		}

		if (this.IsInChaseInitial)
		{
			return false;
		}

		return true;
	}

	property bool IsAttacking
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsAttacking") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsAttacking", value);
		}
	}

	property bool CancelAttack
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_CancelAttack") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_CancelAttack", value);
		}
	}

	property bool ClearCurrentAttack
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_ClearCurrentAttack") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_ClearCurrentAttack", value);
		}
	}

	public char[] GetAttackName()
	{
		char buffer[128];
		this.GetPropString(Prop_Data, "m_AttackName", buffer, sizeof(buffer));
		return buffer;
	}

	public void SetAttackName(const char[] name)
	{
		this.SetPropString(Prop_Data, "m_AttackName", name);
	}

	property int AttackIndex
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_AttackIndex");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_AttackIndex", value);
		}
	}

	property StringMap NextAttackTime
	{
		public get()
		{
			return view_as<StringMap>(this.GetProp(Prop_Data, "m_NextAttackTime"));
		}

		public set(StringMap value)
		{
			this.SetProp(Prop_Data, "m_NextAttackTime", value);
		}
	}

	public float GetNextAttackTime(const char[] attackName)
	{
		if (this.NextAttackTime == null)
		{
			return -1.0;
		}

		float value = -1.0;
		if (!this.NextAttackTime.GetValue(attackName, value))
		{
			return -1.0;
		}

		return value;
	}

	public void SetNextAttackTime(const char[] attackName, float time)
	{
		if (this.NextAttackTime == null)
		{
			return;
		}

		this.NextAttackTime.SetValue(attackName, time);
	}

	property float AttackRunDuration
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_AttackRunDuration");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_AttackRunDuration", value);
		}
	}

	property float AttackRunDelay
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_AttackRunDelay");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_AttackRunDelay", value);
		}
	}

	property float NextVoiceTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_NextVoiceTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_NextVoiceTime", value);
		}
	}

	property float NextHurtVoiceTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_NextHurtVoiceTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_NextHurtVoiceTime", value);
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
			bool oldValue = this.IsAttemptingToMove;
			this.SetProp(Prop_Data, "m_IsAttemptingToMove", value);

			if (oldValue != value)
			{
				this.UpdateMovementAnimation();
			}
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
			if (this.LockMovementType)
			{
				return;
			}

			SF2NPCMoveTypes oldType = this.MovementType;
			this.SetProp(Prop_Data, "m_MovementType", value);

			if (oldType != value && this.IsAttemptingToMove)
			{
				this.UpdateMovementAnimation();
			}
		}
	}

	property bool LockMovementType
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_LockMovementType") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_LockMovementType", value);
		}
	}

	public int GetAlertTriggerCount(SF2_BasePlayer player)
	{
		return this.GetProp(Prop_Data, "m_AlertTriggerCount", _, player.index);
	}

	public void SetAlertTriggerCount(SF2_BasePlayer player, int value)
	{
		this.SetProp(Prop_Data, "m_AlertTriggerCount", value, _, player.index);
	}

	public void GetAlertTriggerPosition(SF2_BasePlayer player, float buffer[3])
	{
		this.GetPropVector(Prop_Data, "m_AlertTriggerPosition", buffer, player.index);
	}

	public void SetAlertTriggerPosition(SF2_BasePlayer player, float buffer[3])
	{
		this.SetPropVector(Prop_Data, "m_AlertTriggerPosition", buffer, player.index);
	}

	public float GetAlertSoundTriggerCooldown(SF2_BasePlayer player)
	{
		return this.GetPropFloat(Prop_Data, "m_AlertSoundTriggerCooldown", player.index);
	}

	public void SetAlertSoundTriggerCooldown(SF2_BasePlayer player, float value)
	{
		this.SetPropFloat(Prop_Data, "m_AlertSoundTriggerCooldown", value, player.index);
	}

	public void GetAlertTriggerPositionEx(float buffer[3])
	{
		this.GetPropVector(Prop_Data, "m_AlertTriggerPositionEx", buffer);
	}

	public void SetAlertTriggerPositionEx(float buffer[3])
	{
		this.SetPropVector(Prop_Data, "m_AlertTriggerPositionEx", buffer);
	}

	property float AlertChangePositionCooldown
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_AlertChangePositionCooldown");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_AlertChangePositionCooldown", value);
		}
	}

	public int GetTauntAlertStrikes(SF2_BasePlayer player)
	{
		return this.GetProp(Prop_Data, "m_TauntAlertStrikes", _, player.index);
	}

	public void SetTauntAlertStrikes(SF2_BasePlayer player, int value)
	{
		this.SetProp(Prop_Data, "m_TauntAlertStrikes", value, _, player.index);
	}

	public int GetAutoChaseCount(SF2_BasePlayer player)
	{
		return this.GetProp(Prop_Data, "m_AutoChaseCount", _, player.index);
	}

	public void SetAutoChaseCount(SF2_BasePlayer player, int value)
	{
		this.SetProp(Prop_Data, "m_AutoChaseCount", value, _, player.index);
	}

	public float GetAutoChaseAddCooldown(SF2_BasePlayer player)
	{
		return this.GetPropFloat(Prop_Data, "m_AutoChaseAddCooldown", player.index);
	}

	public void SetAutoChaseAddCooldown(SF2_BasePlayer player, float value)
	{
		this.SetPropFloat(Prop_Data, "m_AutoChaseAddCooldown", value, player.index);
	}

	public float GetAutoChaseCooldown(SF2_BasePlayer player)
	{
		return this.GetPropFloat(Prop_Data, "m_AutoChaseCooldown", player.index);
	}

	public void SetAutoChaseCooldown(SF2_BasePlayer player, float value)
	{
		this.SetPropFloat(Prop_Data, "m_AutoChaseCooldown", value, player.index);
	}

	property SF2_BasePlayer AlertTriggerTarget
	{
		public get()
		{
			return SF2_BasePlayer(this.GetPropEnt(Prop_Data, "m_AlertTriggerTarget"));
		}

		public set(SF2_BasePlayer value)
		{
			this.SetPropEnt(Prop_Data, "m_AlertTriggerTarget", value.index);
		}
	}

	property bool MaintainTarget
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_MaintainTarget") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_MaintainTarget", value);
		}
	}

	property bool AlertWithBoss
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_AlertWithBoss") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_AlertWithBoss", value);
		}
	}

	property bool FollowedCompanionAlert
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_FollowedCompanionAlert") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_FollowedCompanionAlert", value);
		}
	}

	property float FollowCooldownAlert
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_FollowCooldownAlert");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_FollowCooldownAlert", value);
		}
	}

	property bool FollowedCompanionChase
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_FollowedCompanionChase") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_FollowedCompanionChase", value);
		}
	}

	property float FollowCooldownChase
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_FollowCooldownChase");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_FollowCooldownChase", value);
		}
	}

	property ArrayList SmellPlayerList
	{
		public get()
		{
			return view_as<ArrayList>(this.GetProp(Prop_Data, "m_SmellPlayerList"));
		}

		public set(ArrayList value)
		{
			this.SetProp(Prop_Data, "m_SmellPlayerList", value);
		}
	}

	property float SmellCooldown
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_SmellCooldown");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_SmellCooldown", value);
		}
	}

	property bool HasSmelled
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_HasSmelled") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_HasSmelled", value);
		}
	}

	property float ProjectileCooldown
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_ProjectileCooldown");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_ProjectileCooldown", value);
		}
	}

	property bool IsReloadingProjectiles
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsReloadingProjectiles") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsReloadingProjectiles", value);
		}
	}

	property int ProjectileAmmo
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_ProjectileAmmo");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_ProjectileAmmo", value);
		}
	}

	property float ProjectileReloadTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_ProjectileReloadTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_ProjectileReloadTime", value);
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

	property bool HasCloaked
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_HasCloaked") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_HasCloaked", value);
		}
	}

	property float CloakTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_CloakTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_CloakTime", value);
		}
	}

	property bool PlayCloakAnimation
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_PlayCloakAnimation") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_PlayCloakAnimation", value);
		}
	}

	property int RageIndex
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_RageIndex");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_RageIndex", value);
		}
	}

	property bool IsRaging
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsRaging") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsRaging", value);
		}
	}

	property bool IsGoingToHeal
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsGoingToHeal") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsGoingToHeal", value);
		}
	}

	property bool IsRunningAway
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsRunningAway") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsRunningAway", value);
		}
	}

	property bool IsSelfHealing
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsSelfHealing") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsSelfHealing", value);
		}
	}

	property bool OverrideInvincible
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_OverrideInvincible") != 0;
		}

		public set(bool value)
		{
			bool old = this.GetProp(Prop_Data, "m_OverrideInvincible") != 0;

			this.SetProp(Prop_Data, "m_OverrideInvincible", value);

			if (old != value)
			{
				if (value)
				{
					this.SetProp(Prop_Data, "m_takedamage", DAMAGE_EVENTS_ONLY);
				}
				else
				{
					this.SetProp(Prop_Data, "m_takedamage", DAMAGE_YES);
				}
			}
		}
	}

	property float TrapCooldown
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_TrapCooldown");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_TrapCooldown", value);
		}
	}

	property bool WasInBacon
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_WasInBacon") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_WasInBacon", value);
		}
	}

	property float FlashlightTick
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_FlashlightTick");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_FlashlightTick", value);
		}
	}

	property bool ShouldDespawn
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_ShouldDespawn") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_ShouldDespawn", value);
		}
	}

	property bool GroundSpeedOverride
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_GroundSpeedOverride") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_GroundSpeedOverride", value);
		}
	}

	property bool QueueForAlertState
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_QueueForAlertState") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_QueueForAlertState", value);
		}
	}

	public SF2_BasePlayer GetClosestPlayer()
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return SF2_INVALID_PLAYER;
		}
		int difficulty = controller.Difficulty;
		float myPos[3];
		this.GetAbsOrigin(myPos);
		ChaserBossProfile data = controller.GetProfileData();

		SF2_BasePlayer closest = SF2_INVALID_PLAYER;
		float range = Pow(data.GetSearchRange(difficulty), 2.0);

		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer client = SF2_BasePlayer(i);
			if (!client.IsValid || client.IsInGhostMode || client.IsProxy || !client.IsAlive || client.IsEliminated)
			{
				continue;
			}

			float clientPos[3];
			client.GetAbsOrigin(clientPos);

			float distance = GetVectorSquareMagnitude(myPos, clientPos);

			if (distance < range)
			{
				closest = client;
				range = distance;
			}
		}

		if (closest.IsValid)
		{
			return closest;
		}

		return SF2_INVALID_PLAYER;
	}

	public void UpdateMovementAnimation()
	{
		if (this.IsSelfHealing)
		{
			return;
		}

		if (!this.Controller.IsValid())
		{
			return;
		}

		if (this.MovementType == SF2NPCMoveType_Attack)
		{
			return;
		}

		char animation[64];
		strcopy(animation, sizeof(animation), g_SlenderAnimationsList[SF2BossAnimation_Idle]);

		if (this.IsAttemptingToMove)
		{
			switch (this.MovementType)
			{
				case SF2NPCMoveType_Walk:
				{
					strcopy(animation, sizeof(animation), g_SlenderAnimationsList[SF2BossAnimation_Walk]);
				}
				case SF2NPCMoveType_Run:
				{
					strcopy(animation, sizeof(animation), g_SlenderAnimationsList[SF2BossAnimation_Run]);
				}
			}
		}
		if (this.IsKillingSomeone)
		{
			strcopy(animation, sizeof(animation), g_SlenderAnimationsList[SF2BossAnimation_DeathCam]);
		}

		char posture[64];
		this.GetPosture(posture, sizeof(posture));
		this.ResetProfileAnimation(animation, .posture = posture);
	}

	public bool PerformVoice(int soundType = -1, const char[] attackName = "")
	{
		ProfileSound soundInfo;
		return this.PerformVoiceEx(soundType, attackName, soundInfo);
	}

	public bool PerformVoiceEx(int soundType = -1, const char[] attackName = "", ProfileSound soundInfo, bool isSet = false)
	{
		if (soundType == -1 && !isSet)
		{
			return false;
		}

		ChaserBossProfile data = this.Controller.GetProfileData();
		KeyMap_Array soundList;
		if (!isSet)
		{
			switch (soundType)
			{
				case SF2BossSound_Idle:
				{
					soundInfo = data.GetIdleSounds();
				}
				case SF2BossSound_Alert:
				{
					soundInfo = data.GetAlertSounds();
				}
				case SF2BossSound_Chasing:
				{
					soundInfo = data.GetChasingSounds();
				}
				case SF2BossSound_ChaseInitial:
				{
					soundInfo = data.GetChaseInitialSounds();
				}
				case SF2BossSound_Stun:
				{
					soundInfo = data.GetStunSounds();
				}
				case SF2BossSound_Death:
				{
					soundInfo = data.GetDeathSounds();
				}
				case SF2BossSound_Attack:
				{
					return this.CheckNestedSoundSection(data.GetAttackSounds(), attackName, soundInfo, soundList, "attack");
				}
				case SF2BossSound_AttackKilled:
				{
					soundInfo = data.GetAttackKilledSounds();
				}
				case SF2BossSound_TauntKill:
				{
					soundInfo = data.GetTauntKillSounds();
				}
				case SF2BossSound_Smell:
				{
					soundInfo = data.GetSmellSounds();
				}
				case SF2BossSound_AttackBegin:
				{
					return this.CheckNestedSoundSection(data.GetAttackBeginSounds(), attackName, soundInfo, soundList, "attack_begin");
				}
				case SF2BossSound_AttackEnd:
				{
					return this.CheckNestedSoundSection(data.GetAttackEndSounds(), attackName, soundInfo, soundList, "attack_end");
				}
				case SF2BossSound_SelfHeal:
				{
					soundInfo = data.GetSelfHealSounds();
				}
				case SF2BossSound_RageAll:
				{
					soundInfo = data.GetRageAllSounds();
				}
				case SF2BossSound_RageTwo:
				{
					soundInfo = data.GetRageTwoSounds();
				}
				case SF2BossSound_RageThree:
				{
					soundInfo = data.GetRageThreeSounds();
				}
				case SF2BossSound_Despawn:
				{
					soundInfo = data.GetDespawnSounds();
				}
				case SF2BossSound_Hurt:
				{
					soundInfo = data.GetHurtSounds();
				}
				case SF2BossSound_Jump:
				{
					soundInfo = data.GetJumpSounds();
				}
			}
		}

		if (soundInfo == null)
		{
			return false;
		}

		soundList = soundInfo.Paths;
		if (soundList != null && soundList.Length > 0)
		{
			return this.PerformVoiceCooldown(soundInfo, soundList);
		}
		return false;
	}

	public bool CheckNestedSoundSection(ProfileObject list, const char[] attackName, ProfileSound soundInfo, KeyMap_Array soundList, char[] section)
	{
		if (this.SearchSoundsWithSectionName(list, attackName, soundInfo, section))
		{
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				return this.PerformVoiceCooldown(soundInfo, soundList);
			}
		}
		return false;
	}

	public bool PerformVoiceCooldown(ProfileSound soundInfo, KeyMap_Array soundList)
	{
		char buffer[PLATFORM_MAX_PATH];
		float gameTime = GetGameTime();
		soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
		if (buffer[0] != '\0')
		{
			float cooldown = GetRandomFloat(soundInfo.GetCooldownMin(this.Controller.Difficulty), soundInfo.GetCooldownMax(this.Controller.Difficulty));
			this.NextVoiceTime = gameTime + cooldown;
			return soundInfo.EmitSound(_, this.index, _, _, SF_SpecialRound(SPECIALROUND_TINYBOSSES) ? 25 : 0);
		}
		return false;
	}

	public void CastAnimEvent(int index)
	{
		ChaserBossProfile data = this.Controller.GetProfileData();

		BossProfileEventData event = data.GetEvents(index);

		if (event == null)
		{
			return;
		}

		if (event.GetSounds() != null)
		{
			event.GetSounds().EmitSound(.entity = this.index);
		}

		if (event.GetEffects() != null)
		{
			SlenderSpawnEffects(event.GetEffects(), this.Controller.Index, false, .noParenting = true);
		}

		if (event.IsFootsteps && data.EarthquakeFootsteps)
		{
			float myPos[3];
			this.GetAbsOrigin(myPos);

			UTIL_ScreenShake(myPos, data.EarthquakeFootstepAmplitude,
			data.EarthquakeFootstepFrequency, data.EarthquakeFootstepDuration,
			data.EarthquakeFootstepRadius, 0, data.EarthquakeFootstepAirShake);
		}
	}

	public void CastFootstep()
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		ChaserBossProfile data = controller.GetProfileData();
		ProfileSound info = data.GetFootstepSounds();

		info.EmitSound(_, this.index);
		this.LegacyFootstepTime = this.LegacyFootstepInterval + GetGameTime();
	}

	public void UpdateAlertTriggerCount(SF2_BasePlayer player, int amount)
	{
		if (this.State != STATE_IDLE && this.State != STATE_ALERT)
		{
			return;
		}

		if (!this.Controller.IsValid())
		{
			return;
		}

		int difficulty = this.Controller.Difficulty;
		int threshold = this.Controller.GetProfileData().GetSoundSenseData().GetThreshold(difficulty);

		if (threshold <= 0)
		{
			return;
		}

		if (amount > threshold)
		{
			amount = threshold;
		}

		this.SetAlertTriggerCount(player, this.GetAlertTriggerCount(player) + amount);

		float gameTime = GetGameTime();
		if (this.GetAlertTriggerCount(player) >= threshold && this.AlertChangePositionCooldown < gameTime)
		{
			this.InterruptConditions |= COND_ALERT_TRIGGER;

			float pos[3];
			player.GetAbsOrigin(pos);

			this.SetAlertTriggerPosition(player, pos);
			this.AlertTriggerTarget = player;
			this.AlertChangePositionCooldown = gameTime + 0.3;
		}
	}

	public void UpdateAlertTriggerCountEx(float pos[3])
	{
		if (this.State != STATE_IDLE && this.State != STATE_ALERT)
		{
			return;
		}

		if (!this.Controller.IsValid())
		{
			return;
		}

		this.InterruptConditions |= COND_ALERT_TRIGGER_POS;

		this.SetAlertTriggerPositionEx(pos);
	}

	public void UpdateAutoChaseCount(SF2_BasePlayer player, int amount)
	{
		if (this.State != STATE_ALERT)
		{
			return;
		}

		if (!this.Controller.IsValid())
		{
			return;
		}

		if (this.GetAutoChaseCooldown(player) > GetGameTime())
		{
			return;
		}

		int difficulty = this.Controller.Difficulty;
		ChaserBossProfile data = this.Controller.GetProfileData();

		if (data.GetAutoChaseData().GetThreshold(difficulty) <= 0)
		{
			return;
		}

		this.SetAutoChaseCount(player, amount);

		if (this.GetAutoChaseCount(player) >= data.GetAutoChaseData().GetThreshold(difficulty))
		{
			player.SetForceChaseState(this.Controller, true);
			SetTargetMarkState(this.Controller, player, true);
			this.SetAutoChaseCount(player, 0);
		}
	}

	public NextBotAction GetAttackAction(CBaseEntity target, bool props = false)
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return NULL_ACTION;
		}
		INextBot bot = this.MyNextBotPointer();
		bool canAttack = !this.IsAttacking && !this.IsKillingSomeone;
		if (canAttack && !bot.GetLocomotionInterface().IsOnGround())
		{
			canAttack = false;
		}

		ChaserBossProfile data = controller.GetProfileData();
		ProfileObject attacks = data.GetSection("attacks");
		if (attacks == null || attacks.Size == 0)
		{
			canAttack = false;
		}

		if (!canAttack)
		{
			return NULL_ACTION;
		}

		char class[64];
		target.GetClassname(class, sizeof(class));
		float gameTime = GetGameTime();
		char attackName[64], posture[64];
		this.GetPosture(posture, sizeof(posture));
		int difficulty = controller.Difficulty;
		ArrayList arrayAttacks = new ArrayList();
		ChaserBossProfileBaseAttack attackData;
		for (int index = 0; index < data.GetAttackCount(); index++)
		{
			attackData = data.GetAttackFromIndex(index);
			if (attackData == null)
			{
				continue;
			}

			attackData.Index = index;

			if (attackData.Type == SF2BossAttackType_Invalid)
			{
				continue;
			}

			attackData.GetSectionName(attackName, sizeof(attackName));
			if (!attackData.IsEnabled(difficulty))
			{
				continue;
			}

			if (gameTime < this.GetNextAttackTime(attackName))
			{
				continue;
			}

			if (props && !attackData.CanUseAgainstProps)
			{
				continue;
			}

			if (attackData.ShouldNotInterruptChaseInitial(difficulty) && this.IsInChaseInitial)
			{
				continue;
			}

			if (!attackData.CanUseWithPosture(posture))
			{
				continue;
			}

			if (!attackData.GetStartThroughWalls(difficulty) && (this.InterruptConditions & COND_ENEMYVISIBLE_NOGLASS) == 0)
			{
				continue;
			}

			if (attackData.Type == SF2BossAttackType_Custom)
			{
				Action result = Plugin_Continue;
				Call_StartForward(g_OnChaserGetCustomAttackPossibleStatePFwd);
				Call_PushCell(this);
				Call_PushString(attackName);
				Call_PushCell(target);
				Call_Finish(result);

				if (result != Plugin_Continue)
				{
					arrayAttacks.Push(index);
				}
				continue;
			}

			if (difficulty < attackData.UseOnDifficulty)
			{
				continue;
			}

			if (difficulty >= attackData.BlockOnDifficulty)
			{
				continue;
			}

			if (!props)
			{
				// Why must tanks use a different prop data, WHY?
				float health = strcmp(class, "tank_boss", false) != 0 ? float(target.GetProp(Prop_Send, "m_iHealth")) : float(target.GetProp(Prop_Data, "m_iHealth"));
				if (attackData.CanUseOnHealth(difficulty) != -1.0 && health < attackData.CanUseOnHealth(difficulty))
				{
					continue;
				}
				if (attackData.CanBlockOnHealth(difficulty) != -1.0 && health >= attackData.CanBlockOnHealth(difficulty))
				{
					continue;
				}
			}

			arrayAttacks.Push(index);
		}

		Call_StartForward(g_OnBossPreAttackFwd);
		Call_PushCell(controller.Index);
		Call_PushCell(arrayAttacks);
		Call_Finish();

		if (arrayAttacks.Length == 0)
		{
			delete arrayAttacks;
			return NULL_ACTION;
		}

		float eyePos[3], targetPos[3], direction[3], eyeAng[3];
		this.GetAbsAngles(eyeAng);
		controller.GetEyePosition(eyePos);
		target.GetAbsOrigin(targetPos);
		SubtractVectors(targetPos, eyePos, direction);
		GetVectorAngles(direction, direction);
		direction[2] = 180.0;

		float distance = bot.GetRangeSquaredTo(target.index);
		float fov = FloatAbs(AngleDiff(direction[1], eyeAng[1]));

		arrayAttacks.Sort(Sort_Random, Sort_Integer);
		for (int i = 0; i < arrayAttacks.Length; i++)
		{
			data.GetAttackName(arrayAttacks.Get(i), attackName, sizeof(attackName));
			attackData = data.GetAttack(attackName);
			if (attackData.Type != SF2BossAttackType_Custom)
			{
				float beginRange = attackData.GetBeginRange(difficulty);
				float beginFOV = attackData.GetBeginFOV(difficulty);
				if (distance > Pow(beginRange, 2.0))
				{
					continue;
				}
				if (fov > beginFOV)
				{
					continue;
				}
			}

			attackData.GetSectionName(attackName, sizeof(attackName));

			return SF2_ChaserAttackAction(data, attackName, attackData.Index, attackData.GetDuration(difficulty));
		}

		delete arrayAttacks;
		return NULL_ACTION;
	}

	public NextBotAction GetCustomAttack(const char[] attackName, CBaseEntity target)
	{
		NextBotAction nbAction = NULL_ACTION;
		Action action = Plugin_Continue;
		ChaserBossProfileBaseAttack attackData = this.Controller.GetProfileData().GetAttack(attackName);

		Call_StartForward(g_OnBossGetCustomAttackActionFwd);
		Call_PushCell(this);
		Call_PushString(attackName);
		Call_PushCell(attackData);
		Call_PushCell(target);
		Call_PushCellRef(nbAction);
		Call_Finish(action);

		if (action != Plugin_Continue)
		{
			return nbAction;
		}

		return NULL_ACTION;
	}

	public bool IsCustomAttackPossible(const char[] attackName, CBaseEntity target)
	{
		Action action = Plugin_Continue;
		ChaserBossProfileBaseAttack attackData = this.Controller.GetProfileData().GetAttack(attackName);

		Call_StartForward(g_OnIsBossCustomAttackPossibleFwd);
		Call_PushCell(this);
		Call_PushString(attackName);
		Call_PushCell(attackData);
		Call_PushCell(target);
		Call_Finish(action);

		return action == Plugin_Continue;
	}

	public NextBotAction IsAttackTransitionPossible(const char[] attackName, bool end = false)
	{
		SF2NPC_Chaser controller = this.Controller;
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProfileBaseAttack attackData = data.GetAttack(attackName);
		char section[32];
		if (!end)
		{
			strcopy(section, sizeof(section), attackData.GetAnimations() == null ? g_SlenderAnimationsList[SF2BossAnimation_AttackBegin] : "begin");
		}
		else
		{
			strcopy(section, sizeof(section), attackData.GetAnimations() == null ? g_SlenderAnimationsList[SF2BossAnimation_AttackEnd] : "end");
		}
		ProfileMasterAnimations animations = attackData.GetAnimations();
		if (animations == null)
		{
			animations = data.GetAnimations();
		}
		if (!animations.HasAnimationSection(section))
		{
			return NULL_ACTION;
		}

		ProfileAnimation animSection = animations.GetAnimation(section, .preDefinedName = attackData.GetAnimations() == null ? attackName : "");
		if (animSection == null)
		{
			return NULL_ACTION;
		}

		return SF2_PlaySequenceAndWaitEx(section, attackName, animations);
	}

	public void DoAttackMiscConditions(const char[] attackName)
	{
		INextBot bot = this.MyNextBotPointer();
		ILocomotion loco = bot.GetLocomotionInterface();
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		ChaserBossProfileBaseAttack attackData = controller.GetProfileData().GetAttack(attackName);
		CBaseEntity target = this.Target;
		int difficulty = controller.Difficulty;

		if (target.IsValid())
		{
			bool aimAtTarget = false;

			if (attackData.ShouldAutoAim(difficulty))
			{
				aimAtTarget = true;
			}

			if (attackData.Type == SF2BossAttackType_LaserBeam || attackData.Type == SF2BossAttackType_Projectile || attackData.Type == SF2BossAttackType_Ranged)
			{
				aimAtTarget = true;
			}

			if (aimAtTarget)
			{
				float pos[3];
				target.GetAbsOrigin(pos);
				loco.FaceTowards(pos);
			}
		}
	}

	public NextBotAction GetSuspendForAction()
	{
		NextBotAction nbAction = NULL_ACTION;
		Action action = Plugin_Continue;
		Call_StartForward(g_OnChaserBossGetSuspendActionFwd);
		Call_PushCell(this);
		Call_PushCellRef(nbAction);
		Call_Finish(action);

		if (action != Plugin_Continue)
		{
			return nbAction;
		}

		return NULL_ACTION;
	}

	public void DoShockwave(const char[] attackName)
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}

		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProfileBaseAttack attackData = data.GetAttack(attackName);
		BossProfileShockwave shockwaveData = attackData.GetShockwave();

		if (shockwaveData == null)
		{
			return;
		}

		int difficulty = controller.Difficulty;
		float radius = shockwaveData.GetRadius(difficulty);
		if (radius <= 0.0)
		{
			return;
		}

		if (shockwaveData.GetEffects() != null)
		{
			SlenderSpawnEffects(shockwaveData.GetEffects(), controller.Index, false);
		}

		float force = shockwaveData.GetForce(difficulty);

		float myWorldSpace[3], myPos[3];
		this.WorldSpaceCenter(myWorldSpace);
		this.GetAbsOrigin(myPos);
		bool eliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;
		if (data.IsPvEBoss)
		{
			eliminated = true;
		}

		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);

			if (!IsTargetValidForSlender(this, player, eliminated))
			{
				continue;
			}

			float clientWorldSpace[3];
			player.WorldSpaceCenter(clientWorldSpace);

			if (GetVectorDistance(myWorldSpace, clientWorldSpace, true) > Pow(radius, 2.0))
			{
				continue;
			}

			Handle trace = TR_TraceRayFilterEx(myWorldSpace, clientWorldSpace,
			CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP, RayType_EndPoint,
			TraceRayDontHitAnyEntity, this.index);

			if (!TR_DidHit(trace) || TR_GetEntityIndex(trace) == player.index)
			{
				float targetPos[3];
				player.GetAbsOrigin(targetPos);
				if (targetPos[2] > myPos[2] + shockwaveData.GetHeight(difficulty))
				{
					delete trace;
					continue;
				}

				if (force > 0.0)
				{
					float velocity[3];
					MakeVectorFromPoints(myPos, targetPos, velocity);
					GetVectorAngles(velocity, velocity);
					velocity[0] += 30.0;
					GetAngleVectors(velocity, velocity, NULL_VECTOR, NULL_VECTOR);
					NormalizeVector(velocity, velocity);
					ScaleVector(velocity, force);
					velocity[2] += force;
					player.SetPropVector(Prop_Data, "m_vecBaseVelocity", velocity);
				}

				float amount = shockwaveData.GetBatteryDrainPercent(difficulty);
				if (!IsInfiniteFlashlightEnabled() && amount > 0.0)
				{
					player.FlashlightBatteryLife -= amount;
				}

				float sprintAmount = shockwaveData.GetStaminaDrainPercent(difficulty);
				if (!IsInfiniteSprintEnabled() && sprintAmount > 0.0)
				{
					player.Stamina -= sprintAmount;
				}

				shockwaveData.ApplyDamageEffects(player, difficulty, this);
			}

			delete trace;
		}
	}

	public bool SearchSoundsWithSectionName(ProfileObject base, const char[] name, ProfileSound& output, char[] section)
	{
		if (base == null)
		{
			return false;
		}
		ChaserBossProfile data = this.Controller.GetProfileData();
		char arrayName[64];
		FormatEx(arrayName, sizeof(arrayName), "__chaser_%s_sounds", section);
		KeyMap_Array array = data.GetArray(arrayName);
		if (array == null)
		{
			output = view_as<ProfileSound>(base);
			return true;
		}
		for (int i = 0; i < array.Length; i++)
		{
			char keyName[64];
			array.GetString(i, keyName, sizeof(keyName));
			if (keyName[0] != '\0' && strcmp(keyName, name) == 0)
			{
				output = view_as<ProfileSound>(base.GetSection(keyName));
				return true;
			}
		}
		return false;
	}

	public void RegisterProjectiles(bool &isFake = false)
	{
		if (g_RestartSessionEnabled)
		{
			return;
		}
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProjectileData projectileData = data.GetProjectiles();
		int difficulty = controller.Difficulty;
		if (!projectileData.IsEnabled(difficulty))
		{
			return;
		}

		float gameTime = GetGameTime();

		if (this.ProjectileCooldown > gameTime)
		{
			return;
		}

		if ((this.InterruptConditions & COND_ENEMYVISIBLE_NOGLASS) == 0)
		{
			return;
		}

		if (!projectileData.ProjectileClips)
		{
			if (controller.Flags & SFF_FAKE)
			{
				isFake = true;
				return;
			}

			this.ShootProjectile();
		}
		else
		{
			if (this.ProjectileAmmo > 0)
			{
				this.ProjectileAmmo--;
				this.ShootProjectile();
			}
			else
			{
				if (!this.IsReloadingProjectiles)
				{
					this.ProjectileReloadTime = gameTime + projectileData.GetReloadTime(difficulty);
					this.IsReloadingProjectiles = true;
				}
				if (this.ProjectileReloadTime <= gameTime && this.IsReloadingProjectiles)
				{
					this.ProjectileAmmo = projectileData.GetClipSize(difficulty);
					this.IsReloadingProjectiles = false;
				}
			}
		}
	}

	public void ShootProjectile()
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		float targetPos[3], myPos[3], myAng[3];
		this.GetAbsOrigin(myPos);
		this.GetAbsAngles(myAng);
		this.Target.WorldSpaceCenter(targetPos);
		int difficulty = controller.Difficulty;
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProjectileData projectileData = data.GetProjectiles();
		int randomPosMin = projectileData.MinRandomPos;
		int randomPosMax = projectileData.MaxRandomPos;

		bool attackWaiters = (controller.Flags & SFF_ATTACKWAITERS) != 0;
		if (data.IsPvEBoss)
		{
			attackWaiters = true;
		}

		float effectPos[3];

		if (randomPosMin == randomPosMax)
		{
			projectileData.GetOffset(1, effectPos);
		}
		else
		{
			projectileData.GetOffset(GetRandomInt(randomPosMin, randomPosMax), effectPos);
		}

		VectorTransform(effectPos, myPos, myAng, effectPos);

		for (int i = 0; i < projectileData.GetCount(difficulty); i++)
		{
			float direction[3], angle[3];
			SubtractVectors(targetPos, effectPos, direction);
			float deviation = projectileData.GetDeviation(difficulty) / 10.0;

			NormalizeVector(direction, direction);
			GetVectorAngles(direction, angle);
			if (deviation != 0.0)
			{
				angle[0] += GetRandomFloat(-deviation, deviation);
				angle[1] += GetRandomFloat(-deviation, deviation);
				angle[2] += GetRandomFloat(-deviation, deviation);
			}

			char sound[PLATFORM_MAX_PATH];

			switch (projectileData.Type)
			{
				case SF2BossProjectileType_Fireball:
				{
					char trail[PLATFORM_MAX_PATH];
					projectileData.GetFireballExplodeSound(sound, sizeof(sound));
					projectileData.GetFireballTrail(trail, sizeof(trail));
					SF2_ProjectileFireball.Create(this, effectPos, angle, projectileData.GetSpeed(difficulty), projectileData.GetDamage(difficulty),
						projectileData.GetRadius(difficulty), sound, trail, attackWaiters);
					projectileData.GetFireballShootSound(sound, sizeof(sound));
					if (i == 0)
					{
						EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
					}
				}
				case SF2BossProjectileType_Iceball:
				{
					char trail[PLATFORM_MAX_PATH], slow[PLATFORM_MAX_PATH];
					projectileData.GetFireballExplodeSound(sound, sizeof(sound));
					projectileData.GetIceballTrail(trail, sizeof(trail));
					projectileData.GetIceballSlowSound(slow, sizeof(slow));
					SF2_ProjectileIceball.Create(this, effectPos, angle, projectileData.GetSpeed(difficulty), projectileData.GetDamage(difficulty),
						projectileData.GetRadius(difficulty), sound, trail, projectileData.GetIceballSlowDuration(difficulty), projectileData.GetIceballSlowPercent(difficulty), slow, attackWaiters);
					projectileData.GetIceballSlowSound(sound, sizeof(sound));
					if (i == 0)
					{
						EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
					}
				}
				case SF2BossProjectileType_Rocket:
				{
					char trail[PLATFORM_MAX_PATH], particle[PLATFORM_MAX_PATH], model[PLATFORM_MAX_PATH];
					projectileData.GetRocketExplodeSound(sound, sizeof(sound));
					projectileData.GetRocketTrail(trail, sizeof(trail));
					projectileData.GetRocketExplodeParticle(particle, sizeof(particle));
					projectileData.GetRocketModel(model, sizeof(model));
					SF2_ProjectileRocket.Create(this, effectPos, angle, projectileData.GetSpeed(difficulty), projectileData.GetDamage(difficulty),
						projectileData.GetRadius(difficulty), projectileData.GetCritState(difficulty), trail, particle, sound, model, attackWaiters);
					projectileData.GetRocketShootSound(sound, sizeof(sound));
					if (i == 0)
					{
						EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
					}
				}
				case SF2BossProjectileType_SentryRocket:
				{
					projectileData.GetSentryRocketShootSound(sound, sizeof(sound));
					SF2_ProjectileSentryRocket.Create(this, effectPos, angle, projectileData.GetSpeed(difficulty), projectileData.GetDamage(difficulty),
						projectileData.GetRadius(difficulty), projectileData.GetCritState(difficulty), attackWaiters);
					if (i == 0)
					{
						EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
					}
				}
				case SF2BossProjectileType_Mangler:
				{
					projectileData.GetManglerShootSound(sound, sizeof(sound));
					SF2_ProjectileCowMangler.Create(this, effectPos, angle, projectileData.GetSpeed(difficulty), projectileData.GetDamage(difficulty),
						projectileData.GetRadius(difficulty), attackWaiters);
					if (i == 0)
					{
						EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
					}
				}
				case SF2BossProjectileType_Grenade:
				{
					projectileData.GetGrenadeShootSound(sound, sizeof(sound));
					SF2_ProjectileGrenade.Create(this, effectPos, angle, projectileData.GetSpeed(difficulty), projectileData.GetDamage(difficulty),
						projectileData.GetRadius(difficulty), projectileData.GetCritState(difficulty), "pipebombtrail_blue", ROCKET_EXPLODE_PARTICLE, ROCKET_IMPACT, "models/weapons/w_models/w_grenade_grenadelauncher.mdl", attackWaiters);
					if (i == 0)
					{
						EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
					}
				}
				case SF2BossProjectileType_Arrow:
				{
					projectileData.GetArrowShootSound(sound, sizeof(sound));
					SF2_ProjectileArrow.Create(this, effectPos, angle, projectileData.GetSpeed(difficulty), projectileData.GetDamage(difficulty),
						projectileData.GetCritState(difficulty), "effects/arrowtrail_red.vmt", "weapons/fx/rics/arrow_impact_flesh2.wav", "models/weapons/w_models/w_arrow.mdl", attackWaiters);
					if (i == 0)
					{
						EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
					}
				}
				case SF2BossProjectileType_Baseball:
				{
					projectileData.GetBaseballShootSound(sound, sizeof(sound));
					SF2_ProjectileBaseball.Create(this, effectPos, angle, projectileData.GetSpeed(difficulty), projectileData.GetDamage(difficulty),
						projectileData.GetCritState(difficulty), "models/weapons/w_models/w_baseball.mdl", attackWaiters);
					if (i == 0)
					{
						EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
					}
				}
			}
		}

		char gesture[64];
		projectileData.GetShootGesture(gesture, sizeof(gesture));
		if (gesture[0] != '\0')
		{
			int sequence = this.LookupSequence(gesture);
			if (sequence != -1)
			{
				this.RemoveAllGestures();
				this.AddGestureSequence(sequence);
			}
		}

		this.ProjectileCooldown = GetRandomFloat(projectileData.GetMinCooldown(difficulty), projectileData.GetMaxCooldown(difficulty)) + GetGameTime();
	}

	public void CheckTauntKill(SF2_BasePlayer player)
	{
		if (SF2_ChaserTauntKillAction.IsPossible(this) && player.IsValid)
		{
			this.KillTarget = player;
		}
	}

	public void ForceAlertOtherBosses()
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		int difficulty = controller.Difficulty;
		SF2NPC_BaseNPC copyMaster = controller.CopyMaster;
		SF2NPC_BaseNPC companionMaster = controller.CompanionMaster;
		ChaserBossProfile data, otherData;
		data = controller.GetProfileData();
		ChaserBossAlertOnStateData alertStateData, otherAlertStateData;
		if (data.GetAlertBehavior() == null)
		{
			return;
		}
		alertStateData = data.GetAlertBehavior().GetAlertSyncData();

		if (!alertStateData.IsEnabled(difficulty))
		{
			return;
		}

		if (!alertStateData.GetCopies(difficulty) && !alertStateData.GetCompanions(difficulty))
		{
			return;
		}

		float goalPos[3];
		if (controller.Path.IsValid())
		{
			controller.Path.GetEndPosition(goalPos);
		}
		else
		{
			this.GetAbsOrigin(goalPos);
		}

		for (int index = 0; index < MAX_BOSSES; index++)
		{
			if (index == controller.Index)
			{
				continue;
			}

			SF2NPC_BaseNPC otherController = SF2NPC_BaseNPC(index);
			if (!otherController.IsValid() || otherController.GetProfileData().Type != SF2BossType_Chaser || otherController.EntIndex == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			otherData = view_as<SF2NPC_Chaser>(otherController).GetProfileData();
			if (otherData.GetAlertBehavior() == null)
			{
				continue;
			}
			otherAlertStateData = otherData.GetAlertBehavior().GetAlertSyncData();
			SF2_ChaserEntity otherChaser = SF2_ChaserEntity(otherController.EntIndex);
			if (!otherChaser.IsValid())
			{
				continue;
			}

			if (otherChaser.State == STATE_ALERT || otherChaser.State == STATE_CHASE || otherChaser.State == STATE_STUN || otherChaser.State == STATE_DEATH || otherChaser.State == STATE_ATTACK)
			{
				continue;
			}

			SF2NPC_BaseNPC otherCopyMaster = otherController.CopyMaster;
			SF2NPC_BaseNPC otherCompanionMaster = otherController.CompanionMaster;
			bool doContinue = false;
			if (alertStateData.GetCopies(difficulty))
			{
				if (copyMaster != otherController && otherCopyMaster != copyMaster && otherCopyMaster != controller)
				{
					doContinue = true;
				}
			}

			if (alertStateData.GetCompanions(difficulty))
			{
				SF2NPC_BaseNPC tempCompanionMaster = companionMaster, tempOtherCompanionMaster = otherCompanionMaster;
				if (otherController.IsCopy)
				{
					tempOtherCompanionMaster = otherController.CopyMaster.CompanionMaster;
					if (otherController.CopyMaster == controller)
					{
						doContinue = true;
					}
				}

				if (controller.IsCopy)
				{
					tempCompanionMaster = controller.CopyMaster.CompanionMaster;
					if (controller.CopyMaster == otherController)
					{
						doContinue = true;
					}
				}

				if (!doContinue)
				{
					if ((tempCompanionMaster != otherController && tempOtherCompanionMaster != tempCompanionMaster && tempOtherCompanionMaster != controller) ||
						(!tempCompanionMaster.IsValid() && !tempOtherCompanionMaster.IsValid()))
					{
						tempOtherCompanionMaster = otherController.CopyMaster;
						if (tempOtherCompanionMaster != tempCompanionMaster)
						{
							doContinue = true;
						}
						else
						{
							doContinue = false;
						}
					}
					else
					{
						doContinue = false;
					}
				}
			}

			if (doContinue)
			{
				continue;
			}

			float distance = this.MyNextBotPointer().GetRangeSquaredTo(otherController.EntIndex);
			if (distance > Pow(otherAlertStateData.GetRadius(difficulty), 2.0))
			{
				continue;
			}

			if (otherAlertStateData.ShouldBeVisible(difficulty) && !otherChaser.IsLOSClearFromTarget(this))
			{
				continue;
			}

			otherChaser.SetForceWanderPosition(goalPos);
			otherChaser.AlertWithBoss = true;
		}
	}

	public void FollowOtherBossAlert()
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		int difficulty = controller.Difficulty;
		SF2NPC_BaseNPC copyMaster = controller.CopyMaster;
		SF2NPC_BaseNPC companionMaster = controller.CompanionMaster;
		ChaserBossProfile data, otherData;
		data = controller.GetProfileData();
		ChaserBossAlertOnStateData alertStateData, otherAlertStateData;
		if (data.GetAlertBehavior() == null)
		{
			return;
		}
		alertStateData = data.GetAlertBehavior().GetAlertSyncData();
		float gameTime = GetGameTime();

		if (!alertStateData.IsEnabled(difficulty))
		{
			return;
		}

		if (!alertStateData.GetCopies(difficulty) && !alertStateData.GetCompanions(difficulty))
		{
			return;
		}

		if (!alertStateData.ShouldFollow(difficulty) || this.FollowedCompanionAlert || gameTime < this.FollowCooldownAlert)
		{
			return;
		}

		if (this.State == STATE_ALERT || this.State == STATE_CHASE || this.State == STATE_STUN || this.State == STATE_DEATH || this.State == STATE_ATTACK)
		{
			return;
		}

		for (int index = 0; index < MAX_BOSSES; index++)
		{
			if (index == controller.Index)
			{
				continue;
			}

			SF2NPC_BaseNPC otherController = SF2NPC_BaseNPC(index);
			if (!otherController.IsValid() || otherController.GetProfileData().Type != SF2BossType_Chaser || otherController.EntIndex == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			SF2_ChaserEntity otherChaser = SF2_ChaserEntity(otherController.EntIndex);
			if (otherChaser.State != STATE_ALERT)
			{
				continue;
			}

			otherData = view_as<SF2NPC_Chaser>(otherController).GetProfileData();
			if (otherData.GetAlertBehavior() == null)
			{
				continue;
			}
			otherAlertStateData = otherData.GetAlertBehavior().GetAlertSyncData();

			if (!otherAlertStateData.GetCopies(difficulty) && !otherAlertStateData.GetCompanions(difficulty))
			{
				continue;
			}

			SF2NPC_BaseNPC otherCopyMaster = otherController.CopyMaster;
			SF2NPC_BaseNPC otherCompanionMaster = otherController.CompanionMaster;
			bool doContinue = false;
			if (alertStateData.GetCopies(difficulty))
			{
				if (copyMaster != otherController && otherCopyMaster != copyMaster && otherCopyMaster != controller)
				{
					doContinue = true;
				}
			}

			if (alertStateData.GetCompanions(difficulty))
			{
				SF2NPC_BaseNPC tempCompanionMaster = companionMaster, tempOtherCompanionMaster = otherCompanionMaster;
				if (otherController.IsCopy)
				{
					tempOtherCompanionMaster = otherController.CopyMaster.CompanionMaster;
					if (otherController.CopyMaster == controller)
					{
						doContinue = true;
					}
				}

				if (controller.IsCopy)
				{
					tempCompanionMaster = controller.CopyMaster.CompanionMaster;
					if (controller.CopyMaster == otherController)
					{
						doContinue = true;
					}
				}

				if (!doContinue)
				{
					if ((tempCompanionMaster != otherController && tempOtherCompanionMaster != tempCompanionMaster && tempOtherCompanionMaster != controller) ||
						(!tempCompanionMaster.IsValid() && !tempOtherCompanionMaster.IsValid()))
					{
						tempOtherCompanionMaster = otherController.CopyMaster;
						if (tempOtherCompanionMaster != tempCompanionMaster)
						{
							doContinue = true;
						}
						else
						{
							doContinue = false;
						}
					}
					else
					{
						doContinue = false;
					}
				}
			}

			if (doContinue)
			{
				continue;
			}

			float distance = this.MyNextBotPointer().GetRangeSquaredTo(otherController.EntIndex);
			if (distance > Pow(otherAlertStateData.GetRadius(difficulty), 2.0))
			{
				continue;
			}

			if (otherAlertStateData.ShouldBeVisible(difficulty) && !otherChaser.IsLOSClearFromTarget(this))
			{
				continue;
			}

			float goalPos[3];
			if (!otherController.Path.IsValid())
			{
				otherChaser.GetAbsOrigin(goalPos);
			}
			else
			{
				otherController.Path.GetEndPosition(goalPos);
			}
			this.SetForceWanderPosition(goalPos);
			this.FollowedCompanionAlert = true;
			otherChaser.FollowedCompanionAlert = true;
			return;
		}
	}

	public void ForceChaseOtherBosses()
	{
		CBaseEntity target = this.Target;
		if (!target.IsValid())
		{
			return;
		}

		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		int difficulty = controller.Difficulty;
		SF2NPC_BaseNPC copyMaster = controller.CopyMaster;
		SF2NPC_BaseNPC companionMaster = controller.CompanionMaster;
		ChaserBossProfile data, otherData;
		data = controller.GetProfileData();
		ChaserBossAlertOnStateData alertStateData, otherAlertStateData;
		if (data.GetChaseBehavior() == null)
		{
			return;
		}
		alertStateData = data.GetChaseBehavior().GetChaseTogetherData();

		if (!alertStateData.IsEnabled(difficulty))
		{
			return;
		}

		if (!alertStateData.GetCopies(difficulty) && !alertStateData.GetCompanions(difficulty))
		{
			return;
		}

		for (int index = 0; index < MAX_BOSSES; index++)
		{
			if (index == controller.Index)
			{
				continue;
			}

			SF2NPC_BaseNPC otherController = SF2NPC_BaseNPC(index);
			if (!otherController.IsValid() || otherController.GetProfileData().Type != SF2BossType_Chaser || otherController.EntIndex == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			otherData = view_as<SF2NPC_Chaser>(otherController).GetProfileData();
			if (otherData.GetChaseBehavior() == null)
			{
				continue;
			}
			otherAlertStateData = otherData.GetChaseBehavior().GetChaseTogetherData();
			SF2_ChaserEntity otherChaser = SF2_ChaserEntity(otherController.EntIndex);
			if (!otherChaser.IsValid())
			{
				continue;
			}

			if (otherChaser.State == STATE_CHASE || otherChaser.State == STATE_STUN || otherChaser.State == STATE_DEATH || otherChaser.State == STATE_ATTACK)
			{
				continue;
			}

			SF2NPC_BaseNPC otherCopyMaster = otherController.CopyMaster;
			SF2NPC_BaseNPC otherCompanionMaster = otherController.CompanionMaster;
			bool doContinue = false;
			if (alertStateData.GetCopies(difficulty))
			{
				if (copyMaster != otherController && otherCopyMaster != copyMaster && otherCopyMaster != controller)
				{
					doContinue = true;
				}
			}

			if (alertStateData.GetCompanions(difficulty))
			{
				SF2NPC_BaseNPC tempCompanionMaster = companionMaster, tempOtherCompanionMaster = otherCompanionMaster;
				if (otherController.IsCopy)
				{
					tempOtherCompanionMaster = otherController.CopyMaster.CompanionMaster;
					if (otherController.CopyMaster == controller)
					{
						doContinue = true;
					}
				}

				if (controller.IsCopy)
				{
					tempCompanionMaster = controller.CopyMaster.CompanionMaster;
					if (controller.CopyMaster == otherController)
					{
						doContinue = true;
					}
				}

				if (!doContinue)
				{
					if ((tempCompanionMaster != otherController && tempOtherCompanionMaster != tempCompanionMaster && tempOtherCompanionMaster != controller) ||
						(!tempCompanionMaster.IsValid() && !tempOtherCompanionMaster.IsValid()))
					{
						tempOtherCompanionMaster = otherController.CopyMaster;
						if (tempOtherCompanionMaster != tempCompanionMaster)
						{
							doContinue = true;
						}
						else
						{
							doContinue = false;
						}
					}
					else
					{
						doContinue = false;
					}
				}
			}

			if (doContinue)
			{
				continue;
			}

			float distance = this.MyNextBotPointer().GetRangeSquaredTo(otherController.EntIndex);
			if (distance > Pow(otherAlertStateData.GetRadius(difficulty), 2.0))
			{
				continue;
			}

			if (otherAlertStateData.ShouldBeVisible(difficulty) && !otherChaser.IsLOSClearFromTarget(this))
			{
				continue;
			}

			SF2_BasePlayer player = SF2_BasePlayer(target.index);
			if (player.IsValid)
			{
				player.SetForceChaseState(otherController, true);
			}
		}
	}

	public void FollowOtherBossChase()
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		int difficulty = controller.Difficulty;
		SF2NPC_BaseNPC copyMaster = controller.CopyMaster;
		SF2NPC_BaseNPC companionMaster = controller.CompanionMaster;
		ChaserBossProfile data, otherData;
		data = controller.GetProfileData();
		ChaserBossAlertOnStateData alertStateData, otherAlertStateData;
		if (data.GetChaseBehavior() == null)
		{
			return;
		}
		alertStateData = data.GetChaseBehavior().GetChaseTogetherData();
		float gameTime = GetGameTime();

		if (!alertStateData.IsEnabled(difficulty) || !alertStateData.ShouldFollow(difficulty))
		{
			return;
		}

		if (!alertStateData.GetCopies(difficulty) && !alertStateData.GetCompanions(difficulty))
		{
			return;
		}

		if (this.FollowedCompanionChase && this.State != STATE_CHASE && this.State != STATE_STUN && this.State != STATE_DEATH && this.State != STATE_ATTACK && gameTime >= this.FollowCooldownChase)
		{
			this.FollowedCompanionChase = false;
		}

		if (this.FollowedCompanionChase)
		{
			return;
		}

		for (int index = 0; index < MAX_BOSSES; index++)
		{
			if (index == controller.Index)
			{
				continue;
			}

			SF2NPC_BaseNPC otherController = SF2NPC_BaseNPC(index);
			if (!otherController.IsValid() || otherController.GetProfileData().Type != SF2BossType_Chaser || otherController.EntIndex == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			SF2_ChaserEntity otherChaser = SF2_ChaserEntity(otherController.EntIndex);
			if (otherChaser.State != STATE_CHASE && otherChaser.State != STATE_STUN && otherChaser.State != STATE_ATTACK)
			{
				continue;
			}

			otherData = view_as<SF2NPC_Chaser>(otherController).GetProfileData();
			if (otherData.GetChaseBehavior() == null)
			{
				continue;
			}
			otherAlertStateData = otherData.GetChaseBehavior().GetChaseTogetherData();

			if (!otherAlertStateData.GetCopies(difficulty) && !otherAlertStateData.GetCompanions(difficulty))
			{
				continue;
			}

			SF2NPC_BaseNPC otherCopyMaster = otherController.CopyMaster;
			SF2NPC_BaseNPC otherCompanionMaster = otherController.CompanionMaster;
			bool doContinue = false;
			if (alertStateData.GetCopies(difficulty))
			{
				if (copyMaster != otherController && otherCopyMaster != copyMaster && otherCopyMaster != controller)
				{
					doContinue = true;
				}
			}

			if (alertStateData.GetCompanions(difficulty))
			{
				SF2NPC_BaseNPC tempCompanionMaster = companionMaster, tempOtherCompanionMaster = otherCompanionMaster;
				if (otherController.IsCopy)
				{
					tempOtherCompanionMaster = otherController.CopyMaster.CompanionMaster;
					if (otherController.CopyMaster == controller)
					{
						doContinue = true;
					}
				}

				if (controller.IsCopy)
				{
					tempCompanionMaster = controller.CopyMaster.CompanionMaster;
					if (controller.CopyMaster == otherController)
					{
						doContinue = true;
					}
				}

				if (!doContinue)
				{
					if ((tempCompanionMaster != otherController && tempOtherCompanionMaster != tempCompanionMaster && tempOtherCompanionMaster != controller) ||
						(!tempCompanionMaster.IsValid() && !tempOtherCompanionMaster.IsValid()))
					{
						tempOtherCompanionMaster = otherController.CopyMaster;
						if (tempOtherCompanionMaster != tempCompanionMaster)
						{
							doContinue = true;
						}
						else
						{
							doContinue = false;
						}
					}
					else
					{
						doContinue = false;
					}
				}
			}

			if (doContinue)
			{
				continue;
			}

			float distance = this.MyNextBotPointer().GetRangeSquaredTo(otherController.EntIndex);
			if (distance > Pow(otherAlertStateData.GetRadius(difficulty), 2.0))
			{
				continue;
			}

			if (otherAlertStateData.ShouldBeVisible(difficulty) && !otherChaser.IsLOSClearFromTarget(this))
			{
				continue;
			}

			SF2_BasePlayer player = SF2_BasePlayer(otherChaser.Target.index);
			if (player.IsValid)
			{
				player.SetForceChaseState(controller, true);
				this.FollowedCompanionChase = true;
				this.Target = otherChaser.Target;
				return;
			}
		}
	}

	public void ProcessCloak(CBaseEntity target)
	{
		SF2NPC_Chaser controller = this.Controller;
		if (!controller.IsValid())
		{
			return;
		}
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProfileCloakData cloakData = data.GetCloakData();
		int difficulty = controller.Difficulty;
		float gameTime = GetGameTime();
		if (!cloakData.IsEnabled(difficulty))
		{
			return;
		}

		if (this.IsInChaseInitial)
		{
			return;
		}

		if (this.IsAttacking)
		{
			return;
		}

		if (!target.IsValid())
		{
			return;
		}

		float targetPos[3], myPos[3];
		target.GetAbsOrigin(targetPos);
		this.GetAbsOrigin(myPos);
		if (this.HasCloaked && GetVectorSquareMagnitude(targetPos, myPos) <= Pow(cloakData.GetDecloakRange(difficulty), 2.0))
		{
			this.EndCloak();
			return;
		}

		if (!this.HasCloaked && GetVectorSquareMagnitude(targetPos, myPos) > Pow(cloakData.GetCloakRange(difficulty), 2.0))
		{
			return;
		}

		if (this.CloakTime < gameTime)
		{
			if (this.HasCloaked)
			{
				this.EndCloak();
			}
			else
			{
				this.StartCloak();
			}
		}
	}

	public void StartCloak()
	{
		if (this.HasCloaked)
		{
			return;
		}

		SF2NPC_Chaser controller = this.Controller;
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProfileCloakData cloakData = data.GetCloakData();
		int difficulty = controller.Difficulty;
		if (!cloakData.IsEnabled(difficulty))
		{
			return;
		}

		this.SetRenderMode(cloakData.GetRenderMode(difficulty));
		this.SetRenderFx(cloakData.GetRenderFx(difficulty));
		int color[4];
		cloakData.GetRenderColor(color);
		this.SetRenderColor(color[0], color[1], color[2], color[3]);
		this.HasCloaked = true;
		this.CloakTime = GetGameTime() + cloakData.GetDuration(difficulty);
		float worldPos[3];
		this.WorldSpaceCenter(worldPos);
		SlenderToggleParticleEffects(this.index);
		if (cloakData.GetCloakEffects() != null)
		{
			SlenderSpawnEffects(cloakData.GetCloakEffects(), controller.Index, false);
		}
		Call_StartForward(g_OnBossCloakedFwd);
		Call_PushCell(controller.Index);
		Call_Finish();
	}

	public void EndCloak()
	{
		if (!this.HasCloaked)
		{
			return;
		}
		SF2NPC_Chaser controller = this.Controller;
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProfileCloakData cloakData = data.GetCloakData();
		int difficulty = controller.Difficulty;
		if (!cloakData.IsEnabled(difficulty))
		{
			return;
		}

		this.SetRenderMode(data.GetRenderMode(difficulty));
		this.SetRenderFx(data.GetRenderFx(difficulty));
		int color[4];
		data.GetRenderColor(difficulty, color);
		this.SetRenderColor(color[0], color[1], color[2], color[3]);
		this.HasCloaked = false;
		this.CloakTime = GetGameTime() + cloakData.GetCooldown(difficulty);
		float worldPos[3];
		this.WorldSpaceCenter(worldPos);
		SlenderToggleParticleEffects(this.index, true);
		if (cloakData.GetDecloakEffects() != null)
		{
			SlenderSpawnEffects(cloakData.GetDecloakEffects(), controller.Index, false);
		}
		Call_StartForward(g_OnBossDecloakedFwd);
		Call_PushCell(controller.Index);
		Call_Finish();
	}

	public void DropItem(bool death = false)
	{
		SF2NPC_Chaser controller = this.Controller;
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProfileStunData stunData = data.GetStunBehavior();
		ChaserBossProfileDeathData deathData = data.GetDeathBehavior();
		int difficulty = controller.Difficulty;
		bool check = !death ? stunData.CanDropItem(difficulty) : deathData.CanDropItem(difficulty);
		if (!check)
		{
			return;
		}

		int type = !death ? stunData.GetItemDropType(difficulty) : deathData.GetItemDropType(difficulty);
		char class[64];
		switch (type)
		{
			case 1:
			{
				class = "item_ammopack_small";
			}

			case 2:
			{
				class = "item_ammopack_medium";
			}

			case 3:
			{
				class = "item_ammopack_full";
			}

			case 4:
			{
				class = "item_healthkit_small";
			}

			case 5:
			{
				class = "item_healthkit_medium";
			}

			case 6:
			{
				class = "item_healthkit_full";
			}

			case 7:
			{
				class = "item_healthammokit";
			}
		}

		float myPos[3];
		this.GetAbsOrigin(myPos);
		CBaseEntity item = CBaseEntity(CreateEntityByName(class));
		item.KeyValue("OnPlayerTouch", "!self,Kill,,0,-1");
		SetVariantString("OnUser1 !self:Kill::60.0:1");
		item.AcceptInput("AddOutput");
		item.AcceptInput("FireUser1");
		item.Spawn();
		item.SetProp(Prop_Send, "m_iTeamNum", 0);
		item.Teleport(myPos, NULL_VECTOR, NULL_VECTOR);
	}

	public void ProcessTraps()
	{
		SF2NPC_Chaser controller = this.Controller;
		ChaserBossProfile data = controller.GetProfileData();
		BossProfileTrapData trapData = data.GetTrapData();
		if (trapData == null)
		{
			return;
		}

		int difficulty = controller.Difficulty;
		if (!trapData.IsEnabled(difficulty))
		{
			return;
		}

		if (!trapData.CanPlaceOnState(difficulty, this.State))
		{
			return;
		}

		float gameTime = GetGameTime();
		if (this.TrapCooldown > gameTime)
		{
			return;
		}

		float myPos[3], myAng[3];
		this.GetAbsOrigin(myPos);
		this.GetAbsAngles(myAng);
		Trap_SpawnTrap(myPos, myAng, controller);
		this.TrapCooldown = gameTime + trapData.GetSpawnCooldown(difficulty);
	}

	public static SF2_ChaserEntity Create(SF2NPC_BaseNPC controller, const float pos[3], const float ang[3])
	{
		SF2_ChaserEntity chaser = SF2_ChaserEntity(CreateEntityByName("sf2_npc_boss_chaser"));
		if (!chaser.IsValid())
		{
			return SF2_ChaserEntity(-1);
		}
		if (controller == SF2_INVALID_NPC)
		{
			return SF2_ChaserEntity(-1);
		}

		char profile[SF2_MAX_PROFILE_NAME_LENGTH];

		controller.GetProfile(profile, sizeof(profile));
		chaser.Controller = view_as<SF2NPC_Chaser>(controller);
		ChaserBossProfile data = chaser.Controller.GetProfileData();
		ChaserBossProfileStunData stunData = data.GetStunBehavior();

		char buffer[PLATFORM_MAX_PATH];

		int difficulty = g_DifficultyConVar.IntValue;

		GetSlenderModel(controller.Index, _, buffer, sizeof(buffer));
		chaser.SetModel(buffer);
		chaser.SetRenderMode(data.GetRenderMode(difficulty));
		chaser.SetRenderFx(data.GetRenderFx(difficulty));
		int color[4];
		data.GetRenderColor(difficulty, color);
		chaser.SetRenderColor(color[0], color[1], color[2], color[3]);

		chaser.SetDefaultPosture(SF2_PROFILE_CHASER_DEFAULT_POSTURE);
		chaser.SetPosture(SF2_PROFILE_CHASER_DEFAULT_POSTURE);

		if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
		{
			float scaleModel = data.ModelScale * 0.5;
			chaser.SetPropFloat(Prop_Send, "m_flModelScale", scaleModel);
		}
		else
		{
			chaser.SetPropFloat(Prop_Send, "m_flModelScale", data.ModelScale);
		}

		CBaseNPC npc = TheNPCs.FindNPCByEntIndex(chaser.index);
		CBaseNPC_Locomotion locomotion = npc.GetLocomotion();

		npc.flStepSize = 18.0;
		npc.flGravity = 800.0;
		npc.flDeathDropHeight = 99999.0;
		npc.flJumpHeight = 512.0;
		npc.flFrictionForward = data.GetForwardFriction(difficulty);
		npc.flFrictionSideways = data.GetSidewaysFriction(difficulty);

		npc.flMaxYawRate = data.TurnRate;

		float addStunHealth = 0.0;
		float classAdd;
		int count;
		if (stunData != null)
		{
			addStunHealth = stunData.GetAddHealthPerPlayer(difficulty);
			for (int i = 1; i <= MaxClients; i++)
			{
				SF2_BasePlayer player = SF2_BasePlayer(i);
				if (!player.IsValid)
				{
					continue;
				}

				if (data.IsPvEBoss && !player.IsEliminated)
				{
					continue;
				}

				if (!data.IsPvEBoss && (player.IsEliminated || player.HasEscaped))
				{
					continue;
				}
				count++;
				classAdd += stunData.GetAddHealthPerClass(difficulty, player.Class);
			}
		}

		addStunHealth *= float(count);
		chaser.StunHealth = stunData.GetHealth(difficulty) + addStunHealth + classAdd;
		chaser.MaxStunHealth = chaser.StunHealth;

		locomotion.SetCallback(LocomotionCallback_ShouldCollideWith, LocoCollideWith);
		locomotion.SetCallback(LocomotionCallback_ClimbUpToLedge, ClimbUpToLedge);
		locomotion.SetCallback(LocomotionCallback_JumpAcrossGap, JumpAcrossGap);

		float pathingMins[3], pathingMaxs[3];

		if (data.RaidHitbox)
		{
			data.GetHullMins(pathingMins);
			data.GetHullMaxs(pathingMaxs);

			chaser.SetPropVector(Prop_Send, "m_vecMins", pathingMins);
			chaser.SetPropVector(Prop_Send, "m_vecMaxs", pathingMaxs);

			chaser.SetPropVector(Prop_Send, "m_vecMinsPreScaled", pathingMins);
			chaser.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", pathingMaxs);
		}
		else
		{
			pathingMins = HULL_HUMAN_MINS;
			pathingMaxs = HULL_HUMAN_MAXS;

			chaser.SetPropVector(Prop_Send, "m_vecMins", HULL_HUMAN_MINS);
			chaser.SetPropVector(Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);

			chaser.SetPropVector(Prop_Send, "m_vecMinsPreScaled", HULL_HUMAN_MINS);
			chaser.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);
		}

		npc.SetBodyMins(pathingMins);
		npc.SetBodyMaxs(pathingMaxs);

		if (SF_IsBoxingMap() || data.IsPvEBoss)
		{
			SetEntityCollisionGroup(chaser.index, COLLISION_GROUP_DEBRIS_TRIGGER);
		}

		g_SlenderTimeUntilKill[controller.Index] = GetGameTime() + data.GetIdleLifeTime(difficulty);

		IVision vision = chaser.MyNextBotPointer().GetVisionInterface();
		vision.SetFieldOfView(data.FOV);
		vision.ForgetAllKnownEntities();

		chaser.NextAttackTime = new StringMap();

		if (data.GetTrapData() != null)
		{
			chaser.TrapCooldown = GetGameTime() + data.GetTrapData().GetSpawnCooldown(difficulty);
		}

		chaser.Teleport(pos, ang, NULL_VECTOR);

		chaser.Spawn();
		chaser.Activate();

		if (data.GetSection("events") != null)
		{
			chaser.Hook_HandleAnimEvent(HandleAnimationEvent);
		}

		return chaser;
	}

	public void InvokeOnStartAttack(const char[] attackName)
	{
		Call_StartForward(g_OnChaserBossStartAttackFwd);
		Call_PushCell(this);
		Call_PushString(attackName);
		Call_Finish();
	}

	public void InvokeOnEndAttack(const char[] attackName)
	{
		Call_StartForward(g_OnChaserBossEndAttackFwd);
		Call_PushCell(this);
		Call_PushString(attackName);
		Call_Finish();
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_ChaserBossEntity.IsValid.get", Native_GetIsValid);
		CreateNative("SF2_ChaserBossEntity.Controller.get", Native_GetController);
		CreateNative("SF2_ChaserBossEntity.IsAttemptingToMove.get", Native_GetIsAttemptingToMove);
		CreateNative("SF2_ChaserBossEntity.IsAttacking.get", Native_GetIsAttacking);
		CreateNative("SF2_ChaserBossEntity.IsStunned.get", Native_GetIsStunned);
		CreateNative("SF2_ChaserBossEntity.StunHealth.get", Native_GetStunHealth);
		CreateNative("SF2_ChaserBossEntity.MaxStunHealth.get", Native_GetMaxStunHealth);
		CreateNative("SF2_ChaserBossEntity.CanBeStunned.get", Native_GetCanBeStunned);
		CreateNative("SF2_ChaserBossEntity.CanTakeDamage.get", Native_GetCanTakeDamage);
		CreateNative("SF2_ChaserBossEntity.IsRaging.get", Native_GetIsRaging);
		CreateNative("SF2_ChaserBossEntity.IsRunningAway.get", Native_GetIsRunningAway);
		CreateNative("SF2_ChaserBossEntity.IsSelfHealing.get", Native_GetIsSelfHealing);
		CreateNative("SF2_ChaserBossEntity.ProfileData", Native_GetProfileData);
		CreateNative("SF2_ChaserBossEntity.PerformVoice", Native_PerformVoice);
		CreateNative("SF2_ChaserBossEntity.PerformCustomVoice", Native_PerformCustomVoice);
		CreateNative("SF2_ChaserBossEntity.GetDefaultPosture", Native_GetDefaultPosture);
		CreateNative("SF2_ChaserBossEntity.SetDefaultPosture", Native_SetDefaultPosture);
		CreateNative("SF2_ChaserBossEntity.GetAttackName", Native_GetAttackName);
		CreateNative("SF2_ChaserBossEntity.AttackIndex.get", Native_GetAttackIndex);
		CreateNative("SF2_ChaserBossEntity.GetNextAttackTime", Native_GetNextAttackTime);
		CreateNative("SF2_ChaserBossEntity.SetNextAttackTime", Native_SetNextAttackTime);
		CreateNative("SF2_ChaserBossEntity.DropItem", Native_DropItem);
		CreateNative("SF2_ChaserBossEntity.CreateSoundHint", Native_CreateSoundHint);
		CreateNative("SF2_ChaserBossEntity.GroundSpeedOverride.get", Native_GetGroundSpeedOverride);
		CreateNative("SF2_ChaserBossEntity.GroundSpeedOverride.set", Native_SetGroundSpeedOverride);
		CreateNative("SF2_ChaserBossEntity.MovementType.get", Native_GetMovementType);
		CreateNative("SF2_ChaserBossEntity.MovementType.set", Native_SetMovementType);
		CreateNative("SF2_ChaserBossEntity.LockMovementType.get", Native_GetLockMovementType);
		CreateNative("SF2_ChaserBossEntity.LockMovementType.set", Native_SetLockMovementType);

		SF2_ChaserAttackAction.SetupAPI();
	}
}

static void EntityCreated(CBaseEntity ent, const char[] classname)
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}
		int entity = NPCGetEntIndex(i);
		if (!entity || entity == INVALID_ENT_REFERENCE)
		{
			continue;
		}

		SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
		if (!chaser.IsValid())
		{
			continue;
		}
		SetClientForceChaseState(SF2NPC_BaseNPC(i), ent, false);
		SetTargetMarkState(SF2NPC_BaseNPC(i), ent, false);
	}
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}
		int entity = NPCGetEntIndex(i);
		if (!entity || entity == INVALID_ENT_REFERENCE)
		{
			continue;
		}

		SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
		if (!chaser.IsValid())
		{
			continue;
		}
		SF2NPC_Chaser controller = SF2NPC_Chaser(i);
		chaser.SetAlertTriggerCount(client, 0);
		chaser.SetAlertSoundTriggerCooldown(client, 0.0);
		chaser.SetAutoChaseCount(client, 0);
		chaser.SetAutoChaseCooldown(client, -1.0);
		client.SetForceChaseState(controller, false);
		SetTargetMarkState(controller, client, false);

		int index = controller.ChaseOnLookTargets.FindValue(entity);
		if (index != -1)
		{
			controller.ChaseOnLookTargets.Erase(index);
		}
	}
}

static void OnPlayerTakeDamagePost(SF2_BasePlayer client, int attacker, int inflictor, float damage, int damageType)
{
	SF2_ChaserEntity boss = SF2_ChaserEntity(inflictor);
	if (!boss.IsValid())
	{
		return;
	}

	SF2NPC_Chaser controller = boss.Controller;
	if (!controller.IsValid())
	{
		return;
	}

	Call_StartForward(g_OnClientDamagedByBossFwd);
	Call_PushCell(client.index);
	Call_PushCell(controller);
	Call_PushCell(boss.index);
	Call_PushFloat(damage);
	Call_PushCell(damageType);
	Call_Finish();

	ChaserBossProfile data = controller.GetProfileData();

	char attack[64];
	strcopy(attack, sizeof(attack), boss.GetAttackName());
	if (attack[0] != '\0')
	{
		ChaserBossProfileBaseAttack attackData = data.GetAttack(attack);

		if (attackData.GetHitEffects() != null)
		{
			SlenderSpawnEffects(attackData.GetHitEffects(), controller.Index, false, _, _, _, client.index);
		}

		if (attackData.GetHitInputs() != null)
		{
			attackData.GetHitInputs().AcceptInputs(boss, client, client);
		}
	}
}

static void OnPlayerDeathPre(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (fake)
	{
		return;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}
		int entity = NPCGetEntIndex(i);
		if (!entity || entity == INVALID_ENT_REFERENCE)
		{
			continue;
		}

		SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
		if (!chaser.IsValid())
		{
			continue;
		}
		SF2NPC_Chaser controller = SF2NPC_Chaser(i);

		int index = controller.ChaseOnLookTargets.FindValue(entity);
		if (index != -1)
		{
			controller.ChaseOnLookTargets.Erase(index);
		}
	}

	SF2_ChaserEntity boss = SF2_ChaserEntity(inflictor);
	if (!boss.IsValid())
	{
		return;
	}

	SF2NPC_Chaser controller = boss.Controller;
	if (!controller.IsValid())
	{
		return;
	}

	ChaserBossProfile data = controller.GetProfileData();

	char attack[64];
	strcopy(attack, sizeof(attack), boss.GetAttackName());
	if (attack[0] != '\0')
	{
		ChaserBossProfileBaseAttack attackData = data.GetAttack(attack);

		if (attackData.GetOnKillEffects() != null)
		{
			SlenderSpawnEffects(attackData.GetOnKillEffects(), controller.Index, false, _, _, _, client.index);
		}

		if (attackData.GetOnKillInputs() != null)
		{
			attackData.GetOnKillInputs().AcceptInputs(boss, client, client);
		}
	}
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (fake)
	{
		return;
	}
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}
		int entity = NPCGetEntIndex(i);
		if (!entity || entity == INVALID_ENT_REFERENCE)
		{
			continue;
		}

		SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
		if (!chaser.IsValid())
		{
			continue;
		}
		SF2NPC_Chaser controller = SF2NPC_Chaser(i);

		int index = controller.ChaseOnLookTargets.FindValue(entity);
		if (index != -1)
		{
			controller.ChaseOnLookTargets.Erase(index);
		}
	}

	SF2_ChaserEntity boss = SF2_ChaserEntity(inflictor);
	if (!boss.IsValid())
	{
		return;
	}

	SF2NPC_Chaser controller = boss.Controller;
	if (!controller.IsValid())
	{
		return;
	}

	boss.PerformVoice(SF2BossSound_AttackKilled);

	ChaserBossProfile data = controller.GetProfileData();
	ProfileSound info = data.GetAttackKilledClientSounds();
	info.EmitSound(true, client.index);

	info = data.GetAttackKilledAllSounds();
	info.EmitToAllPlayers();

	bool played = false;
	TFClassType class = client.Class;

	if (data.GetLocalKillSounds() != null)
	{
		info = data.GetLocalKillSounds().GetKilledClassSounds(class);
		if (!info.EmitSound(_, boss.index))
		{
			info = data.GetLocalKillSounds().GetKilledAllSounds();
			info.EmitSound(_, boss.index);
		}
	}

	if (data.GetGlobalKillSounds() != null)
	{
		info = data.GetGlobalKillSounds().GetKilledClassSounds(class);
		played = info.EmitToAllPlayers();
		if (!played)
		{
			info = data.GetGlobalKillSounds().GetKilledAllSounds();
			info.EmitToAllPlayers();
		}
	}

	if (data.GetClientKillSounds() != null)
	{
		info = data.GetClientKillSounds().GetKilledClassSounds(class);
		if (!info.EmitSound(true, client.index))
		{
			info = data.GetClientKillSounds().GetKilledAllSounds();
			info.EmitSound(true, client.index);
		}
	}
}

static void OnBuildingDestroyed(CBaseEntity building, CBaseEntity killer)
{
	SF2_ChaserEntity boss = SF2_ChaserEntity(killer.index);
	if (!boss.IsValid())
	{
		return;
	}

	SF2NPC_Chaser controller = boss.Controller;
	if (!controller.IsValid())
	{
		return;
	}

	ChaserBossProfile data = controller.GetProfileData();
	ProfileSound info = null;

	if (data.GetLocalKillSounds() != null)
	{
		info = data.GetLocalKillSounds().GetKilledBuildingSounds();
		info.EmitSound(_, boss.index);
	}

	if (data.GetGlobalKillSounds() != null)
	{
		info = data.GetGlobalKillSounds().GetKilledBuildingSounds();
		info.EmitToAllPlayers();
	}
}

static void OnCreate(SF2_ChaserEntity ent)
{
	ent.AttackIndex = -1;
	ent.Target = CBaseEntity(-1);
	ent.OldTarget = CBaseEntity(-1);
	ent.IsAllowedToDespawn = true;
	SDKHook(ent.index, SDKHook_Think, Think);
	SDKHook(ent.index, SDKHook_ThinkPost, ThinkPost);
	SDKHook(ent.index, SDKHook_SpawnPost, SpawnPost);
	SDKHook(ent.index, SDKHook_OnTakeDamage, OnTakeDamage);
	SDKHook(ent.index, SDKHook_OnTakeDamageAlivePost, OnTakeDamageAlivePost);
	SDKHook(ent.index, SDKHook_TraceAttack, TraceOnHit);
	SetEntityTransmitState(ent.index, FL_EDICT_FULLCHECK);
	g_DHookShouldTransmit.HookEntity(Hook_Pre, ent.index, ShouldTransmit);
	g_DHookUpdateTransmitState.HookEntity(Hook_Pre, ent.index, UpdateTransmitState);
}

static void OnRemove(SF2_ChaserEntity ent)
{
	if (ent.SmellPlayerList != null)
	{
		delete ent.SmellPlayerList;
	}
	delete ent.NextAttackTime;

	KillPvEBoss(ent.index);
}

static Action Think(int entIndex)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(entIndex);
	int interruptConditions = 0;
	CBaseEntity target = ProcessVision(chaser, interruptConditions);
	chaser.InterruptConditions |= interruptConditions;
	chaser.Target = target;

	float gameTime = GetGameTime();
	if (chaser.LegacyFootstepInterval > 0.0 && chaser.LegacyFootstepTime < gameTime)
	{
		chaser.CastFootstep();
	}

	//chaser.CheckVelocityCancel();

	return Plugin_Continue;
}

static void ThinkPost(int entIndex)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(entIndex);
	SF2NPC_Chaser controller = chaser.Controller;
	ChaserBossProfile data = controller.GetProfileData();

	ProcessSpeed(chaser);

	ProcessBody(chaser);

	if (data.GetOutlineData() != null && data.GetOutlineData().GetRainbowState(controller.Difficulty))
	{
		chaser.ProcessRainbowOutline();
	}

	chaser.InterruptConditions = 0;
	chaser.SetNextThink(GetGameTime() + data.TickRate);

	if (!chaser.MyNextBotPointer().GetLocomotionInterface().IsOnGround() && (chaser.State == STATE_IDLE || chaser.State == STATE_ALERT || chaser.State == STATE_CHASE))
	{
		chaser.AirTime -= GetGameFrameTime();
		if (chaser.AirTime > -1.0 && chaser.AirTime <= 0.0 && chaser.ResetProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Air]))
		{
			chaser.AirTime = -1.0;
			chaser.IsInAirAnimation = true;
		}
	}

	#if defined DEBUG
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(chaser.index);
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid || (g_PlayerDebugFlags[player.index] & DEBUG_BOSS_HITBOX) == 0)
		{
			continue;
		}

		float mins[3], maxs[3], origin[3];
		chaser.GetAbsOrigin(origin);
		npc.GetBodyMins(mins);
		npc.GetBodyMaxs(maxs);
		TE_DrawBox(player.index, origin, origin, mins, maxs, 0.1, g_ShockwaveBeam, { 0, 255, 0, 255 });
	}
	#endif
}

static void SpawnPost(int entIndex)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(entIndex);
	SF2NPC_Chaser controller = chaser.Controller;
	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileDeathData deathData = data.GetDeathBehavior();
	int difficulty = controller.Difficulty;
	if (!deathData.IsEnabled(difficulty))
	{
		chaser.SetProp(Prop_Data, "m_iHealth", 2000000000);
		chaser.SetProp(Prop_Data, "m_takedamage", DAMAGE_EVENTS_ONLY);
	}
	else
	{
		float addDeathHealth = deathData.GetAddHealthPerPlayer(difficulty);
		int count;
		float add = 0.0;
		float result = controller.GetDeathHealth(difficulty);
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!player.IsValid)
			{
				continue;
			}
			if (g_Enabled)
			{
				if (data.IsPvEBoss)
				{
					if (!player.IsEliminated)
					{
						continue;
					}
				}
				else
				{
					if (player.IsEliminated || !player.IsAlive || player.HasEscaped)
					{
						continue;
					}
				}
			}
			else
			{
				if (player.Team != TFTeam_Red && player.Team != TFTeam_Blue)
				{
					continue;
				}
			}
			count++;
			add += deathData.GetAddHealthPerClass(difficulty, player.Class);
		}
		addDeathHealth *= float(count);
		result += addDeathHealth + add;

		chaser.SetProp(Prop_Data, "m_iHealth", RoundToFloor(result));
		chaser.SetProp(Prop_Data, "m_takedamage", DAMAGE_YES);
	}
	chaser.MaxHealth = float(chaser.GetProp(Prop_Data, "m_iHealth"));
	if (SF2_ChaserSmellAction.IsPossible(chaser))
	{
		chaser.SmellPlayerList = new ArrayList();
	}
	else
	{
		chaser.SmellPlayerList = null;
	}
	chaser.RageIndex = -1;

	if (data.Healthbar)
	{
		controller.Flags |= SFF_NOTELEPORT;
		CreateTimer(0.1, Timer_UpdateHealthBar, controller.UniqueID, TIMER_FLAG_NO_MAPCHANGE);
	}
}

static Action Timer_UpdateHealthBar(Handle timer, any id)
{
	int bossIndex = NPCGetFromUniqueID(id);
	if (bossIndex == -1)
	{
		return Plugin_Continue;
	}

	UpdateHealthBar(bossIndex);

	return Plugin_Stop;
}

static Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damageType, int &weapon, float damageForce[3], float damagePosition[3], int damageCustom)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(victim);
	SF2_BasePlayer player = SF2_BasePlayer(attacker);
	ChaserBossProfile data = chaser.Controller.GetProfileData();
	float gameTime = GetGameTime();
	int difficulty = chaser.Controller.Difficulty;

	if (player.IsValid && player.IsProxy)
	{
		return Plugin_Handled;
	}

	if (!chaser.CanTakeDamage(CBaseEntity(attacker), CBaseEntity(inflictor), damage))
	{
		return Plugin_Handled;
	}

	if (player.IsValid || g_Buildings.FindValue(EntIndexToEntRef(inflictor)) != -1)
	{
		if (CBaseEntity(inflictor).IsValid() && CBaseEntity(inflictor).GetProp(Prop_Data, "m_iTeamNum") == chaser.Team && (chaser.Controller.Flags & SFF_ATTACKWAITERS) == 0)
		{
			return Plugin_Handled;
		}

		if (data.IsPvEBoss && player.IsValid && !player.IsInPvE)
		{
			SDKHooks_TakeDamage(inflictor, chaser.index, chaser.index, CBaseEntity(inflictor).GetProp(Prop_Data, "m_iHealth") * 4.0, .bypassHooks = false);
			return Plugin_Handled;
		}
	}

	bool changed = false;

	if (data.GetResistances() != null)
	{
		ChaserBossResistanceData resistanceData;
		for (int i = 0; i < data.GetResistances().Size; i++)
		{
			char name[64];
			data.GetResistances().GetSectionNameFromIndex(i, name, sizeof(name));
			resistanceData = view_as<ChaserBossResistanceData>(data.GetResistances().GetSection(name));
			if (resistanceData.GetDamageTypes() == null)
			{
				continue;
			}

			for (int i2 = 0; i2 < resistanceData.GetDamageTypes().Size; i++)
			{
				resistanceData.GetDamageTypes().GetKeyNameFromIndex(i2, name, sizeof(name));
				int type = resistanceData.GetDamageTypes().GetInt(name);
				if (damageType & type || damageType == type)
				{
					damage *= resistanceData.GetMultiplier(difficulty);
					changed = true;
					break;
				}
			}

			if (changed)
			{
				break;
			}
		}
	}

	if (player.IsValid)
	{
		CBaseEntity activeWeapon = CBaseEntity(player.GetPropEnt(Prop_Send, "m_hActiveWeapon"));
		if (activeWeapon.IsValid() && data.GetResistances() != null)
		{
			ChaserBossResistanceData resistanceData;
			int itemIndex = activeWeapon.GetProp(Prop_Send, "m_iItemDefinitionIndex");
			for (int i = 0; i < data.GetResistances().Size; i++)
			{
				char name[64];
				data.GetResistances().GetSectionNameFromIndex(i, name, sizeof(name));
				resistanceData = view_as<ChaserBossResistanceData>(data.GetResistances().GetSection(name));
				if (resistanceData.GetWeapons() == null)
				{
					continue;
				}

				char itemIndexString[8];
				IntToString(itemIndex, itemIndexString, sizeof(itemIndexString));
				if (!resistanceData.GetWeapons().ContainsString(itemIndexString))
				{
					continue;
				}

				damage *= resistanceData.GetMultiplier(difficulty);
				changed = true;
				break;
			}
		}

		float myEyePos[3], clientEyePos[3], buffer[3], myAng[3];
		player.GetEyePosition(clientEyePos);
		chaser.Controller.GetEyePosition(myEyePos);
		SubtractVectors(clientEyePos, myEyePos, buffer);
		GetVectorAngles(buffer, buffer);
		chaser.GetAbsAngles(myAng);

		CBaseEntity weaponEnt = CBaseEntity(player.GetWeaponSlot(TFWeaponSlot_Melee));
		if (weaponEnt.IsValid() && weaponEnt.index == player.GetPropEnt(Prop_Send, "m_hActiveWeapon") && weapon == weaponEnt.index)
		{
			switch (weaponEnt.GetProp(Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 447, 426, 1181: // Whip + Eviction Notice + Hot Hand
				{
					player.ChangeCondition(TFCond_SpeedBuffAlly, _, 4.0);
				}

				case 416: // Market Gardener
				{
					float zVelocity[3];
					player.GetPropVector(Prop_Data, "m_vecVelocity", zVelocity);
					if (zVelocity[2] < 0.0) // A soldier has the market gardener and is currently falling down, like Minecraft with its critical hits.
					{
						damageType |= DMG_CRIT;
						damage *= 0.667;

						changed = true;
					}
				}
			}

			if (player.Class == TFClass_Spy && (data.IsPvEBoss || SF_IsBoxingMap() || SF_IsRaidMap()) && chaser.State != STATE_DEATH)
			{
				if (FloatAbs(AngleDiff(myAng[1], buffer[1])) >= 75.0 && data.BackstabDamageScale > 0.0)
				{
					damageType = DMG_CRIT;
					EmitSoundToClient(player.index, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);
					weaponEnt.SetPropFloat(Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + 2.0);
					player.SetPropFloat(Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
					player.SetPropFloat(Prop_Send, "m_flStealthNextChangeTime", GetGameTime() + 2.0);
					CBaseAnimating model = CBaseAnimating(player.GetPropEnt(Prop_Send, "m_hViewModel"));
					if (model.IsValid() && model.index > MaxClients)
					{
						int sequence = 0;
						switch (weaponEnt.GetProp(Prop_Send, "m_iItemDefinitionIndex"))
						{
							case 4, 194, 665, 727, 794, 803, 883, 892, 901, 910, 959, 968: // Butterfly knives
							{
								sequence = 42;
							}
							case 225, 356, 461, 574, 649: // Non-butterfly knives
							{
								sequence = 16;
							}
							case 423, 1071, 30758: // Multi-class knives
							{
								sequence = 21;
							}
							case 638: // Sharp Dresser
							{
								sequence = 32;
							}
						}
						model.SetProp(Prop_Send, "m_nSequence", sequence);
					}

					damage = chaser.MaxHealth * data.BackstabDamageScale;
					if (!data.GetDeathBehavior().IsEnabled(difficulty))
					{
						damage = chaser.MaxStunHealth * data.BackstabDamageScale;
					}
					switch (weaponEnt.GetProp(Prop_Send, "m_iItemDefinitionIndex"))
					{
						case 356: // Kunai
						{
							int health = player.Health + 100;
							if (health > 210)
							{
								health = 210;
							}
							SetEntityHealth(player.index, health);
						}

						case 461: // Big Earner
						{
							player.ChangeCondition(TFCond_SpeedBuffAlly, _, 4.0);
						}
					}

					player.SetProp(Prop_Send, "m_iRevengeCrits", player.GetProp(Prop_Send, "m_iRevengeCrits") + 1);

					changed = true;
				}
			}
		}

		weaponEnt = CBaseEntity(player.GetWeaponSlot(TFWeaponSlot_Primary));
		if (weaponEnt.IsValid() && weaponEnt.index == player.GetPropEnt(Prop_Send, "m_hActiveWeapon") && weapon == weaponEnt.index)
		{
			switch (weaponEnt.GetProp(Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 15, 202, 41, 298, 312, 424, 654, 793, 802, 811, 832, 850, 882, 891, 900, 909, 958, 967: // Miniguns
				{
					damage *= 0.65;
					changed = true;
				}

				case 40, 1146: // Backburner
				{
					if (FloatAbs(AngleDiff(myAng[1], buffer[1])) >= 60.0 && data.BackstabDamageScale > 0.0)
					{
						damageType |= DMG_CRIT;
						changed = true;
					}
				}
			}
		}
	}

	if (damage > 0.0 && chaser.GetProp(Prop_Data, "m_iHealth") > damage && data.GetHurtSounds() != null && gameTime >= chaser.NextHurtVoiceTime)
	{
		chaser.NextHurtVoiceTime = gameTime + GetRandomFloat(data.GetHurtSounds().GetHurtCooldownMin(difficulty), data.GetHurtSounds().GetHurtCooldownMax(difficulty));
		chaser.PerformVoice(SF2BossSound_Hurt);
	}

	return changed ? Plugin_Changed : Plugin_Continue;
}

static void OnTakeDamageAlivePost(int victim, int attacker, int inflictor, float damage, int damageType, int weaponEntIndex, const float vecDamageForce[3], const float vecDamagePosition[3])
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(victim);
	SF2_BasePlayer player = SF2_BasePlayer(attacker);
	ChaserBossProfile data = chaser.Controller.GetProfileData();

	bool broadcastDamage = false;

	if (!chaser.CanTakeDamage(CBaseEntity(attacker), CBaseEntity(inflictor), damage))
	{
		damage = 0.0;
		return;
	}

	if (player.IsValid)
	{
		CBaseEntity weapon = CBaseEntity(player.GetWeaponSlot(TFWeaponSlot_Primary));
		if (weapon.IsValid())
		{
			int index = weapon.GetProp(Prop_Send, "m_iItemDefinitionIndex");
			switch (index)
			{
				case 594: // Phlog
				{
					bool isInRage = player.GetProp(Prop_Send, "m_bRageDraining") != 0;
					if (!isInRage)
					{
						float rage = player.GetPropFloat(Prop_Send, "m_flRageMeter");
						rage += (damage / 10.0);
						if (rage > 100.0)
						{
							rage = 100.0;
						}
						player.SetPropFloat(Prop_Send, "m_flRageMeter", rage);
					}
				}
			}

			if (weapon.index == player.GetPropEnt(Prop_Send, "m_hActiveWeapon") && weapon.index == weaponEntIndex)
			{
				switch (index)
				{
					case 527: // Widowmaker
					{
						GivePlayerAmmo(player.index, RoundToNearest(damage), 3, true);
					}

					case 228, 1085: // Black Box
					{
						int health = player.Health;
						int maxHealth = player.GetProp(Prop_Data, "m_iMaxHealth");
						float regen = FloatClamp(damage / 90.0, 0.0, 1.0);
						int newHealth = health + RoundToNearest(20.0 * regen);
						if (newHealth <= maxHealth)
						{
							SetEntityHealth(player.index, newHealth);
						}
						else
						{
							SetEntityHealth(player.index, maxHealth);
						}
						ShowHealthRegen(player.index, RoundToNearest(20.0 * regen), index);
					}

					case 448: // Soda Popper
					{
						if (!player.InCondition(TFCond_CritHype))
						{
							float hype = player.GetPropFloat(Prop_Send, "m_flHypeMeter");
							float add = (damage / 350.0) * 100.0;
							float result = FloatClamp(hype + add, 0.0, 100.0);
							player.SetPropFloat(Prop_Send, "m_flHypeMeter", result);
						}
					}

					case 772: // Baby Face's Blaster
					{
						float hype = player.GetPropFloat(Prop_Send, "m_flHypeMeter");
						float add = (damage / 100.0) * 100.0;
						float result = FloatClamp(hype + add, 0.0, 100.0);
						player.SetPropFloat(Prop_Send, "m_flHypeMeter", result);
						result /= 100.0;
						player.SetPropFloat(Prop_Send, "m_flMaxspeed", 360.0 + (160.0 * result));
					}
				}
			}
		}

		weapon = CBaseEntity(player.GetWeaponSlot(TFWeaponSlot_Secondary));
		if (weapon.IsValid())
		{
			int index = weapon.GetProp(Prop_Send, "m_iItemDefinitionIndex");
			switch (index)
			{
				case 129, 1001, 226, 354: // Banners
				{
					float requiredRage = 6.0;
					if (index == 354)
					{
						requiredRage = 4.8;
					}

					if (player.GetProp(Prop_Send, "m_bRageDraining") == 0)
					{
						float rage = player.GetPropFloat(Prop_Send, "m_flRageMeter");
						rage += (damage / requiredRage);
						if (rage > 100.0)
						{
							rage = 100.0;
						}
						player.SetPropFloat(Prop_Send, "m_flRageMeter", rage);
					}
				}
			}

			if (weapon.index == player.GetPropEnt(Prop_Send, "m_hActiveWeapon") && weapon.index == weaponEntIndex)
			{
				switch (index)
				{
					case 773: // Pocket pistol
					{
						ShowHealthRegen(player.index, 3, index);
						int health = player.Health;
						int maxHealth = player.GetProp(Prop_Data, "m_iMaxHealth");
						int newHealth = health + 3;
						if (newHealth <= maxHealth)
						{
							SetEntityHealth(player.index, newHealth);
						}
						else
						{
							SetEntityHealth(player.index, maxHealth);
						}
					}
				}
			}
		}

		weapon = CBaseEntity(player.GetWeaponSlot(TFWeaponSlot_Melee));
		if (weapon.IsValid() && weapon.index == player.GetPropEnt(Prop_Send, "m_hActiveWeapon") && weapon.index == weaponEntIndex)
		{
			switch (weapon.GetProp(Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 37: // Ubersaw
				{
					CBaseEntity secondary = CBaseEntity(player.GetWeaponSlot(TFWeaponSlot_Secondary));
					if (secondary.IsValid())
					{
						secondary.SetPropFloat(Prop_Send, "m_flChargeLevel", secondary.GetPropFloat(Prop_Send, "m_flChargeLevel") + 0.25);
						if (secondary.GetPropFloat(Prop_Send, "m_flChargeLevel") > 1.0)
						{
							secondary.SetPropFloat(Prop_Send, "m_flChargeLevel", 1.0);
						}
					}
				}
			}
		}
	}

	if (damage > 0.0)
	{
		if (!player.IsValid || !player.IsProxy)
		{
			if (chaser.CanBeStunned())
			{
				broadcastDamage = true;
			}
			if (chaser.GetProp(Prop_Data, "m_takedamage") == DAMAGE_YES)
			{
				broadcastDamage = true;
			}
		}
		else
		{
			damage = 0.0;
		}
	}

	if (damage > 0.0 && player.IsValid && player.InCondition(TFCond_RegenBuffed) && (SF_IsBoxingMap() || data.IsPvEBoss || SF_IsRaidMap()))
	{
		int health = player.Health;
		int maxHealth = player.GetProp(Prop_Data, "m_iMaxHealth");
		float mult = damage * 0.475;
		int newHealth = health + RoundToCeil(mult);
		if (newHealth <= maxHealth)
		{
			SetEntityHealth(player.index, newHealth);
		}
		else
		{
			SetEntityHealth(player.index, maxHealth);
		}
		ShowHealthRegen(player.index, RoundToCeil(mult));
	}

	if (broadcastDamage)
	{
		bool miniCrit = false;

		Event event = CreateEvent("npc_hurt");
		if (event)
		{
			event.SetInt("entindex", chaser.index);
			event.SetInt("health", chaser.GetProp(Prop_Data, "m_iHealth"));
			event.SetInt("damageamount", RoundToFloor(damage));
			event.SetBool("crit", (damageType & DMG_CRIT) ? true : false);

			if (player.IsValid)
			{
				event.SetInt("attacker_player", player.UserID);
				event.SetInt("weaponid", 0);
			}
			else
			{
				event.SetInt("attacker_player", 0);
				event.SetInt("weaponid", 0);
			}

			event.Fire();
		}

		if (player.IsValid)
		{
			miniCrit = player.IsMiniCritBoosted() && !player.IsCritBoosted();

			if ((damageType & DMG_CRIT) != 0)
			{
				float myEyePos[3];
				chaser.GetAbsOrigin(myEyePos);
				float myEyePosEx[3];
				chaser.GetPropVector(Prop_Send, "m_vecMaxs", myEyePosEx);
				myEyePos[2] += myEyePosEx[2];

				if (!miniCrit)
				{
					TE_Particle(g_Particles[CriticalHit], myEyePos, myEyePos);
					TE_SendToClient(player.index);

					EmitSoundToClient(player.index, CRIT_SOUND, _, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				else
				{
					TE_Particle(g_Particles[MiniCritHit], myEyePos, myEyePos);
					TE_SendToClient(player.index);

					EmitSoundToClient(player.index, MINICRIT_SOUND, _, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
			}
		}
	}

	if (data.Healthbar)
	{
		UpdateHealthBar(chaser.Controller.Index);
		if (chaser.IsGoingToHeal)
		{
			SetHealthBarColor(true);
		}
	}
}

static Action TraceOnHit(int victim, int& attacker, int& inflictor, float& damage, int& damagetype, int& ammotype, int hitbox, int hitgroup)
{
	bool changed = false;

	if (IsValidClient(attacker))
	{
		if ((damagetype & DMG_USE_HITLOCATIONS) && hitgroup == 1)
		{
			damagetype = damagetype | DMG_CRIT;
			changed = true;
		}
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(victim);
	SF2NPC_Chaser controller = chaser.Controller;
	if (!controller.IsValid())
	{
		return changed ? Plugin_Changed : Plugin_Continue;
	}

	int difficulty = controller.Difficulty;

	ChaserBossProfile data = controller.GetProfileData();
	if (data.GetResistances() != null)
	{
		ChaserBossResistanceData resistanceData;
		for (int i = 0; i < data.GetResistances().Size; i++)
		{
			char name[64];
			data.GetResistances().GetSectionNameFromIndex(i, name, sizeof(name));
			resistanceData = view_as<ChaserBossResistanceData>(data.GetResistances().GetSection(name));
			if (resistanceData.GetHitboxes() == null)
			{
				continue;
			}

			char hitgroupString[8];
			IntToString(hitgroup, hitgroupString, sizeof(hitgroupString));
			if (!resistanceData.GetHitboxes().ContainsString(hitgroupString))
			{
				continue;
			}

			damage *= resistanceData.GetMultiplier(difficulty);
			changed = true;
			break;
		}
	}
	return changed ? Plugin_Changed : Plugin_Continue;
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

static MRESReturn HandleAnimationEvent(int entIndex, DHookParam params)
{
	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entIndex);
	if (!bossEntity.IsValid() || !bossEntity.Controller.IsValid())
	{
		return MRES_Ignored;
	}

	ChaserBossProfile data = bossEntity.Controller.GetProfileData();

	int index = params.GetObjectVar(1, 0, ObjectValueType_Int);
	BossProfileEventData event = data.GetEvents(index);
	if (event == null)
	{
		return MRES_Ignored;
	}

	bossEntity.CastAnimEvent(index);

	return MRES_Ignored;
}

static void JumpAcrossGap(CBaseNPC_Locomotion loco, const float landingGoal[3], const float landingForward[3])
{
	INextBot bot = loco.GetBot();
	SF2_ChaserEntity boss = SF2_ChaserEntity(bot.GetEntity());
	if (boss.IsValid())
	{
		boss.IsJumping = true;
	}
}

static bool ClimbUpToLedge(CBaseNPC_Locomotion loco, const float goal[3], const float fwd[3], int entity)
{
	INextBot bot = loco.GetBot();
	SF2_ChaserEntity boss = SF2_ChaserEntity(bot.GetEntity());

	if (boss.IsValid())
	{
		boss.IsJumping = true;
	}
	return loco.CallBaseFunction(goal, fwd, entity);
}

static CBaseEntity ProcessVision(SF2_ChaserEntity chaser, int &interruptConditions = 0)
{
	interruptConditions = 0;
	IVision vision = chaser.MyNextBotPointer().GetVisionInterface();
	SF2NPC_Chaser controller = chaser.Controller;
	if (!controller.IsValid())
	{
		return CBaseEntity(-1);
	}
	bool attackEliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;
	ChaserBossProfile data = controller.GetProfileData();
	if (data.IsPvEBoss)
	{
		attackEliminated = data.IsPvEBoss;
	}
	float gameTime = GetGameTime();

	int difficulty = controller.Difficulty;

	float playerDists[2049];
	int playerInterruptFlags[2049];

	float traceMins[3] = { -16.0, ... };
	traceMins[2] = 0.0;
	float traceMaxs[3] = { 16.0, ... };
	traceMaxs[2] = 0.0;
	float buffer[3], myEyeAng[3];
	chaser.GetAbsAngles(myEyeAng);
	float traceStartPos[3], traceEndPos[3], myPos[3], targetPos[3];
	controller.GetEyePosition(traceStartPos);
	chaser.GetAbsOrigin(myPos);

	int state = chaser.State;

	if (data.GetEyes().Type == 1)
	{
		if (chaser.EyeBoneIndex <= 0)
		{
			char bone[128];
			data.GetEyes().GetBone(bone, sizeof(bone));
			chaser.EyeBoneIndex = LookupBone(chaser.index, bone);
		}
		GetBonePosition(chaser.index, chaser.EyeBoneIndex, traceStartPos, myEyeAng);
		float offset[3], angOffset[3];
		data.GetEyes().GetOffsetPos(offset);
		data.GetEyes().GetOffsetAng(angOffset);
		AddVectors(angOffset, myEyeAng, myEyeAng);
		VectorTransform(offset, traceStartPos, myEyeAng, traceStartPos);
	}

	int oldTarget = chaser.OldTarget.index;
	if (!data.IsPvEBoss && !IsTargetValidForSlender(chaser, CBaseEntity(oldTarget), attackEliminated))
	{
		chaser.OldTarget = CBaseEntity(INVALID_ENT_REFERENCE);
		oldTarget = INVALID_ENT_REFERENCE;
	}
	if (data.IsPvEBoss && !IsPvETargetValid(CBaseEntity(oldTarget)))
	{
		chaser.OldTarget = CBaseEntity(INVALID_ENT_REFERENCE);
		oldTarget = INVALID_ENT_REFERENCE;
	}

	// The m_iState is extra hacky and has the potential to be eliviated by Red Tape Recorders, but who cares
	if (IsValidEntity(oldTarget) && g_Buildings.FindValue(EntIndexToEntRef(oldTarget)) != -1 && (GetEntProp(oldTarget, Prop_Send, "m_bCarried") || GetEntProp(oldTarget, Prop_Send, "m_iState") == 0))
	{
		int owner = GetEntPropEnt(oldTarget, Prop_Send, "m_hBuilder");
		if (IsValidEntity(owner) && IsPlayerAlive(owner))
		{
			chaser.OldTarget = CBaseEntity(owner);
			oldTarget = owner;
		}
		else
		{
			chaser.OldTarget = CBaseEntity(INVALID_ENT_REFERENCE);
			oldTarget = INVALID_ENT_REFERENCE;
		}
	}

	int bestNewTarget = oldTarget;
	float searchRange = data.GetSearchRange(difficulty);
	float bestNewTargetDist = 1999999999.0;
	if (IsValidEntity(bestNewTarget))
	{
		CBaseEntity(bestNewTarget).GetAbsOrigin(targetPos);
		bestNewTargetDist = GetVectorSquareMagnitude(myPos, targetPos);
	}

	if (chaser.SmellPlayerList != null)
	{
		chaser.SmellPlayerList.Clear();
	}

	ArrayList valids = new ArrayList();
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);

		if (!data.IsPvEBoss && !IsTargetValidForSlender(chaser, client, attackEliminated))
		{
			continue;
		}
		if (data.IsPvEBoss && !IsPvETargetValid(client))
		{
			continue;
		}

		valids.Push(EntIndexToEntRef(client.index));
	}

	if (!g_Enabled || data.IsPvEBoss || SF_IsRaidMap())
	{
		for (int i = 0; i < g_Buildings.Length; i++)
		{
			CBaseEntity entity = CBaseEntity(EntRefToEntIndex(g_Buildings.Get(i)));
			if (!data.IsPvEBoss && !IsTargetValidForSlender(chaser, entity, attackEliminated))
			{
				continue;
			}
			if (data.IsPvEBoss && !IsPvETargetValid(entity))
			{
				continue;
			}

			valids.Push(EntIndexToEntRef(entity.index));
		}

		for (int i = 0; i < g_WhitelistedEntities.Length; i++)
		{
			CBaseEntity entity = CBaseEntity(EntRefToEntIndex(g_WhitelistedEntities.Get(i)));
			if (!data.IsPvEBoss && !IsTargetValidForSlender(chaser, entity, attackEliminated))
			{
				continue;
			}
			if (data.IsPvEBoss && !IsPvETargetValid(entity))
			{
				continue;
			}

			valids.Push(EntIndexToEntRef(entity.index));
		}
	}

	for (int i = 0; i < valids.Length; i++)
	{
		CBaseEntity entity = CBaseEntity(EntRefToEntIndex(valids.Get(i)));
		if (!entity.IsValid())
		{
			continue;
		}
		SF2_BasePlayer player = SF2_BasePlayer(entity.index);

		#if defined DEBUG
		if (player.IsValid && g_PlayerDebugFlags[player.index] & DEBUG_BOSS_EYES)
		{
			float end[3];
			end[0] = 1000.0;
			VectorTransform(end, traceStartPos, myEyeAng, end);
			int color[4] = { 0, 255, 0, 255 };
			TE_SetupBeamPoints(traceStartPos, end, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, 0.1, 5.0, 5.0, 5, 0.0, color, 1);
			TE_SendToClient(player.index);
		}
		#endif

		chaser.SetIsVisible(entity, false);
		chaser.SetInFOV(entity, false);
		chaser.SetIsNear(entity, false);

		if (player.IsValid)
		{
			player.GetEyePosition(traceEndPos);
		}
		else
		{
			entity.WorldSpaceCenter(traceEndPos);
		}

		entity.GetAbsOrigin(targetPos);

		bool isVisible, isTraceVisible, isGlasslessVisible, isGlasslessTraceVisible;
		int traceHitEntity, glasslesTraceHitEntity;
		Handle trace = TR_TraceHullFilterEx(traceStartPos,
		traceEndPos,
		traceMins,
		traceMaxs,
		CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP,
		TraceRayBossVisibility,
		chaser.index);

		isVisible = !TR_DidHit(trace);
		traceHitEntity = TR_GetEntityIndex(trace);
		delete trace;

		trace = TR_TraceHullFilterEx(traceStartPos,
		traceEndPos,
		traceMins,
		traceMaxs,
		CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP | CONTENTS_GRATE | CONTENTS_WINDOW,
		TraceRayBossVisibility,
		chaser.index);

		isGlasslessVisible = !TR_DidHit(trace);
		glasslesTraceHitEntity = TR_GetEntityIndex(trace);
		delete trace;

		if (!isVisible && traceHitEntity == entity.index)
		{
			isVisible = true;
			isTraceVisible = true;
		}

		if (!isGlasslessVisible && glasslesTraceHitEntity == entity.index)
		{
			isGlasslessVisible = true;
			isGlasslessTraceVisible = true;
		}

		if (isVisible)
		{
			isVisible = NPCShouldSeeEntity(controller.Index, entity.index);
		}

		float dist = GetVectorSquareMagnitude(myPos, targetPos);
		float flashlightDist = -1.0;

		if (player.IsValid && g_PlayerFogCtrlOffset != -1 && g_FogCtrlEnableOffset != -1 && g_FogCtrlEndOffset != -1)
		{
			int fogEntity = player.GetDataEnt(g_PlayerFogCtrlOffset);
			if (IsValidEdict(fogEntity))
			{
				if (GetEntData(fogEntity, g_FogCtrlEnableOffset) &&
					dist >= SquareFloat(GetEntDataFloat(fogEntity, g_FogCtrlEndOffset)))
				{
					isVisible = false;
					isTraceVisible = false;
				}
			}
		}

		if (dist > Pow(data.GetSearchRange(difficulty), 2.0))
		{
			isVisible = false;
		}

		float priorityValue;

		chaser.SetIsVisible(entity, isVisible);

		// Near radius check.
		if (chaser.GetIsVisible(entity) &&
			dist <= SquareFloat(data.GetWakeRadius(difficulty)))
		{
			chaser.SetIsNear(entity, true);
			playerInterruptFlags[entity.index] |= COND_ENEMYNEAR;
		}
		if (!data.IsPvEBoss && player.IsValid && chaser.GetIsVisible(player) && SF_SpecialRound(SPECIALROUND_BOO) && GetVectorSquareMagnitude(traceEndPos, traceStartPos) < SquareFloat(SPECIALROUND_BOO_DISTANCE))
		{
			TF2_StunPlayer(player.index, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
		}

		if (!data.IsPvEBoss && player.IsValid && chaser.State < STATE_ALERT && player.InCondition(TFCond_Taunting) && !controller.HasAttribute(SF2Attribute_IgnoreNonMarkedForChase) && GetVectorSquareMagnitude(traceEndPos, traceStartPos) < SquareFloat(data.GetTauntAlertRange(difficulty)))
		{
			if (chaser.GetTauntAlertStrikes(player) < 3)
			{
				chaser.SetTauntAlertStrikes(player, chaser.GetTauntAlertStrikes(player) + 1);

				chaser.InterruptConditions |= COND_ALERT_TRIGGER;

				float pos[3];
				player.GetAbsOrigin(pos);

				chaser.SetAlertTriggerPosition(player, pos);
				chaser.AlertTriggerTarget = player;
			}
			else
			{
				chaser.SetTauntAlertStrikes(player, 0);
				player.SetForceChaseState(controller, true);
			}
		}

		// FOV check.
		SubtractVectors(traceEndPos, traceStartPos, buffer);
		GetVectorAngles(buffer, buffer);

		if (FloatAbs(AngleDiff(myEyeAng[1], buffer[1])) <= (vision.GetFieldOfView() * 0.5))
		{
			chaser.SetInFOV(entity, true);
		}

		if ((state == STATE_IDLE || state == STATE_ALERT || state == STATE_CHASE) && data.GetVisionSenseData().CanSeeFlashlights(difficulty) && player.IsValid && player.UsingFlashlight)
		{
			SF2PointSpotlightEntity flashlight = SF2PointSpotlightEntity(ClientGetFlashlightEntity(player.index));
			float flashlightPos[3], fov[3];
			flashlight.End.GetAbsOrigin(flashlightPos);
			flashlightDist = controller.GetDistanceFrom(flashlight.End.index);
			if (flashlight.IsValid() && flashlightDist <= Pow(data.GetSearchRange(difficulty), 2.0))
			{
				trace = TR_TraceRayFilterEx(traceStartPos,
				flashlightPos,
				CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP,
				RayType_EndPoint,
				TraceRayBossVisibility,
				chaser.index);

				SubtractVectors(flashlightPos, traceStartPos, fov);
				GetVectorAngles(fov, fov);

				if (!TR_DidHit(trace) && FloatAbs(AngleDiff(myEyeAng[1], fov[1])) <= (vision.GetFieldOfView() * 0.5))
				{
					chaser.SetIsVisible(player, true);
					chaser.SetInFOV(player, true);
				}
				delete trace;
			}
		}

		if (chaser.GetIsVisible(entity))
		{
			if (chaser.GetInFOV(entity))
			{
				playerInterruptFlags[entity.index] |= COND_SAWENEMY;
			}
		}

		if (isTraceVisible)
		{
			playerInterruptFlags[entity.index] |= COND_ENEMYVISIBLE;
		}

		if (isGlasslessTraceVisible)
		{
			playerInterruptFlags[entity.index] |= COND_ENEMYVISIBLE_NOGLASS;
		}

		playerDists[entity.index] = dist;

		if (chaser.SmellPlayerList != null && data.GetSmellData() != null && data.GetSmellData().IsEnabled(difficulty))
		{
			if (player.IsValid && dist < Pow(data.GetSmellData().GetRequiredPlayerRange(difficulty), 2.0))
			{
				chaser.SmellPlayerList.Push(player.index);
			}
		}

		if (player.IsValid && (player.IsTrapped || (player.IsReallySprinting && data.GetAutoChaseData().ShouldChaseSprinters(difficulty) && chaser.GetAutoChaseCooldown(player) < gameTime))
			&& (chaser.State == STATE_IDLE || chaser.State == STATE_ALERT) && dist <= SquareFloat(searchRange))
		{
			player.SetForceChaseState(controller, true);
			SetTargetMarkState(controller, player, true);
		}

		if (data.GetChaseOnLookData().IsEnabled(difficulty) && isTraceVisible && player.IsValid && controller.ChaseOnLookTargets.FindValue(player.index) == -1)
		{
			bool shouldCalculate = false;
			if (data.GetChaseOnLookData().GetRequiredFOV(difficulty) <= 0.0)
			{
				shouldCalculate = chaser.GetInFOV(player);
			}
			else
			{
				shouldCalculate = FloatAbs(AngleDiff(myEyeAng[1], buffer[1])) <= (data.GetChaseOnLookData().GetRequiredFOV(difficulty) * 0.5);
			}
			if (shouldCalculate)
			{
				float eyeAng[3], expectedAng[3], lookPos[3];
				player.GetEyeAngles(eyeAng);
				chaser.GetAbsOrigin(myPos);
				data.GetChaseOnLookData().GetRequiredLookPosition(lookPos);
				VectorTransform(lookPos, myPos, myEyeAng, lookPos);
				SubtractVectors(lookPos, traceEndPos, expectedAng);
				GetVectorAngles(expectedAng, expectedAng);
				float minimumXAng = data.GetChaseOnLookData().GetMinXAngle(difficulty) * 0.5;
				float maximumXAng = data.GetChaseOnLookData().GetMaxXAngle(difficulty) * 0.5;
				float minimumYAng = data.GetChaseOnLookData().GetMinYAngle(difficulty) * 0.5;
				float maximumYAng = data.GetChaseOnLookData().GetMaxYAngle(difficulty) * 0.5;
				float xAng, yAng;
				xAng = AngleDiff(eyeAng[0], expectedAng[0]);
				yAng = FloatAbs(AngleDiff(eyeAng[1], expectedAng[1]));
				if ((xAng >= minimumXAng && xAng < maximumXAng) && (yAng >= minimumYAng && yAng < maximumYAng) &&
					((data.GetChaseOnLookData().ShouldAddTargets(difficulty)) || (!data.GetChaseOnLookData().ShouldAddTargets(difficulty) && controller.ChaseOnLookTargets.Length == 0)))
				{
					controller.ChaseOnLookTargets.Push(player.index);
					data.GetScareSounds().EmitSound(true, player.index);
					player.ChangeCondition(TFCond_MarkedForDeathSilent);
					player.SetForceChaseState(controller, true);
					SetTargetMarkState(controller, player, true);
				}
			}
		}

		if (ShouldClientBeForceChased(controller, entity))
		{
			bestNewTarget = entity.index;
			playerInterruptFlags[entity.index] |= COND_ENEMYRECHASE;
		}

		if (entity.index != oldTarget)
		{
			playerInterruptFlags[entity.index] |= COND_NEWENEMY;
		}

		if (controller.HasAttribute(SF2Attribute_IgnoreNonMarkedForChase))
		{
			if (!IsTargetMarked(controller, entity) && controller.ChaseOnLookTargets.FindValue(entity) == -1)
			{
				playerInterruptFlags[entity.index] = 0;
				continue;
			}
		}

		if (player.IsValid && !SF_IsRaidMap() && !SF_BossesChaseEndlessly() && !SF_IsProxyMap() && !SF_IsBoxingMap() && !SF_IsSlaughterRunMap() && !data.ChasesEndlessly && !g_RenevantBossesChaseEndlessly)
		{
			priorityValue = g_PageMax > 0 ? ((float(player.PageCount) / float(g_PageMax)) / 4.0) : 0.0;
		}

		if (player.IsValid)
		{
			TFClassType classType = player.Class;
			int classToInt = view_as<int>(classType);
			if (!IsClassConfigsValid())
			{
				if ((classType == TFClass_Medic || player.HasRegenItem) && !SF_IsBoxingMap())
				{
					priorityValue += 0.2;
				}

				if (classType == TFClass_Spy)
				{
					priorityValue += 0.1;
				}
			}
			else
			{
				if (!SF_IsBoxingMap() && player.HasRegenItem)
				{
					priorityValue += 0.2;
				}
				priorityValue += g_ClassBossPriorityMultiplier[classToInt];
			}
		}

		if (chaser.GetIsNear(entity) || (chaser.GetIsVisible(entity) && chaser.GetInFOV(entity)))
		{
			if (dist <= SquareFloat(searchRange) || (flashlightDist > 0.0 && flashlightDist <= SquareFloat(searchRange)))
			{
				// Subtract distance to increase priority.
				dist -= ((dist * priorityValue));

				if (dist < bestNewTargetDist)
				{
					bestNewTarget = entity.index;
					bestNewTargetDist = dist;
					playerInterruptFlags[entity.index] |= COND_SAWENEMY;
				}
			}
		}
	}

	delete valids;

	CNavArea myArea = chaser.GetLastKnownArea();

	if (!data.IsPvEBoss && myArea != NULL_AREA && (SF_IsRaidMap() || SF_BossesChaseEndlessly() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsSlaughterRunMap() || data.ChasesEndlessly || g_RenevantBossesChaseEndlessly))
	{
		if (!IsTargetValidForSlender(chaser, CBaseEntity(bestNewTarget), attackEliminated))
		{
			if (state != STATE_CHASE)
			{
				ArrayList arrayRaidTargets = new ArrayList();

				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsTargetValidForSlender(chaser, CBaseEntity(i), false))
					{
						continue;
					}

					arrayRaidTargets.Push(EntIndexToEntRef(i));
				}

				if (!g_Enabled)
				{
					for (int i = 0; i < g_Buildings.Length; i++)
					{
						CBaseEntity building = CBaseEntity(EntRefToEntIndex(g_Buildings.Get(i)));
						if (!IsTargetValidForSlender(chaser, building, false))
						{
							continue;
						}

						// Do not go looking for buildings that are carried or are in an inactive state
						if (building.GetProp(Prop_Send, "m_bCarried") || building.GetProp(Prop_Send, "m_iState") == 0)
						{
							continue;
						}

						arrayRaidTargets.Push(g_Buildings.Get(i));
					}

					for (int i = 0; i < g_WhitelistedEntities.Length; i++)
					{
						if (!IsTargetValidForSlender(chaser, CBaseEntity(EntRefToEntIndex(g_WhitelistedEntities.Get(i))), false))
						{
							continue;
						}

						arrayRaidTargets.Push(g_WhitelistedEntities.Get(i));
					}
				}

				if (arrayRaidTargets.Length > 0)
				{
					int raidTarget = EntRefToEntIndex(arrayRaidTargets.Get(GetRandomInt(0, arrayRaidTargets.Length - 1)));
					bestNewTarget = raidTarget;
					SetClientForceChaseState(controller, CBaseEntity(bestNewTarget), true);
				}
				delete arrayRaidTargets;
			}
		}
		chaser.CurrentChaseDuration = data.GetChaseBehavior().GetMaxChaseDuration(difficulty) + GetGameTime();
	}

	if (data.IsPvEBoss)
	{
		if (!IsPvETargetValid(SF2_BasePlayer(bestNewTarget)))
		{
			if (state != STATE_CHASE)
			{
				ArrayList arrayRaidTargets = new ArrayList();

				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsPvETargetValid(CBaseEntity(i)))
					{
						continue;
					}
					arrayRaidTargets.Push(EntIndexToEntRef(i));
				}

				if (arrayRaidTargets.Length > 0)
				{
					int raidTarget = EntRefToEntIndex(arrayRaidTargets.Get(GetRandomInt(0, arrayRaidTargets.Length - 1)));
					if (IsValidClient(raidTarget) && IsClientInPvE(raidTarget))
					{
						bestNewTarget = raidTarget;
						SetClientForceChaseState(controller, CBaseEntity(bestNewTarget), true);
					}
				}
				delete arrayRaidTargets;
			}
		}
		chaser.CurrentChaseDuration = data.GetChaseBehavior().GetMaxChaseDuration(difficulty) + GetGameTime();
	}

	if (bestNewTarget != INVALID_ENT_REFERENCE)
	{
		interruptConditions = playerInterruptFlags[bestNewTarget];
		if (bestNewTarget != oldTarget)
		{
			chaser.Teleporters.Clear();
		}
		chaser.OldTarget = CBaseEntity(bestNewTarget);
	}

	return CBaseEntity(bestNewTarget);
}

static void ProcessSpeed(SF2_ChaserEntity chaser)
{
	SF2NPC_Chaser controller = chaser.Controller;
	if (!controller.IsValid())
	{
		return;
	}
	SF2NPC_BaseNPC baseController = view_as<SF2NPC_BaseNPC>(controller);
	int difficulty = controller.Difficulty;
	SF2NPCMoveTypes moveType = chaser.MovementType;
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(chaser.index);
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	controller.GetProfile(profile, sizeof(profile));
	ChaserBossProfile profileData = controller.GetProfileData();

	float gameTime = GetGameTime();
	ChaserBossProfile data = controller.GetProfileData();

	char posture[64];
	if (data.GetSection("postures") != null)
	{
		chaser.GetPosture(posture, sizeof(posture));
	}

	float speed, acceleration;

	acceleration = profileData.GetAcceleration(difficulty);
	if (!IsNullString(posture) && data.GetPosture(posture) != null)
	{
		acceleration = data.GetPostureAcceleration(posture, difficulty);
	}

	if (controller.HasAttribute(SF2Attribute_ReducedAccelerationOnLook) && controller.CanBeSeen(_, true))
	{
		acceleration *= controller.GetAttributeValue(SF2Attribute_ReducedAccelerationOnLook);
	}
	acceleration += controller.GetAddAcceleration();
	acceleration += controller.GetPersistentAddAcceleration();

	Action action = Plugin_Continue;
	float forwardSpeed;
	switch (moveType)
	{
		case SF2NPCMoveType_Walk:
		{
			speed = profileData.GetWalkSpeed(difficulty);
			if (!IsNullString(posture) && data.GetPosture(posture) != null)
			{
				speed = data.GetPostureWalkSpeed(posture, difficulty);
			}

			if (controller.HasAttribute(SF2Attribute_ReducedWalkSpeedOnLook) && controller.CanBeSeen(_, true))
			{
				speed *= controller.GetAttributeValue(SF2Attribute_ReducedWalkSpeedOnLook);
			}

			speed += baseController.GetPersistentAddWalkSpeed();
			forwardSpeed = speed;
			Call_StartForward(g_OnBossGetWalkSpeedFwd);
			Call_PushCell(controller.Index);
			Call_PushFloatRef(forwardSpeed);
			Call_Finish(action);
			if (action == Plugin_Changed)
			{
				speed = forwardSpeed;
			}
		}
		case SF2NPCMoveType_Run:
		{
			speed = profileData.GetRunSpeed(difficulty);
			if (!IsNullString(posture) && data.GetPosture(posture) != null)
			{
				speed = data.GetPostureRunSpeed(posture, difficulty);
			}

			if (controller.HasAttribute(SF2Attribute_ReducedSpeedOnLook) && controller.CanBeSeen(_, true))
			{
				speed *= controller.GetAttributeValue(SF2Attribute_ReducedSpeedOnLook);
			}

			speed += baseController.GetAddSpeed();
			speed += baseController.GetPersistentAddSpeed();
			forwardSpeed = speed;

			Call_StartForward(g_OnBossGetSpeedFwd);
			Call_PushCell(controller.Index);
			Call_PushFloatRef(forwardSpeed);
			Call_Finish(action);
			if (action == Plugin_Changed)
			{
				speed = forwardSpeed;
			}
		}
		case SF2NPCMoveType_Attack:
		{
			ChaserBossProfileBaseAttack attackData = data.GetAttack(chaser.GetAttackName());
			float attackSpeed = attackData.GetRunSpeed(difficulty);
			if (attackData.GetRunDelay(difficulty) > 0.0 && chaser.AttackRunDelay > gameTime)
			{
				attackSpeed = 0.0;
			}
			if (attackData.GetRunDuration(difficulty) > 0.0 && chaser.AttackRunDuration < gameTime)
			{
				attackSpeed = 0.0;
			}
			if (attackData.GetGroundSpeedOverride(difficulty))
			{
				chaser.GroundSpeedOverride = true;
			}
			speed = attackSpeed;
			acceleration = attackData.GetAcceleration(difficulty);
		}
	}

	if (g_InProxySurvivalRageMode)
	{
		speed *= 1.25;
	}

	if (difficulty > Difficulty_Normal)
	{
		speed = (speed + (speed * GetDifficultyModifier(difficulty)) / 15.0);
		acceleration = (acceleration + (acceleration * GetDifficultyModifier(difficulty)) / 15.0);
	}

	if (moveType == SF2NPCMoveType_Run)
	{
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
			if (!data.GetSlaughterRunData().ShouldUseCustomMinSpeed(difficulty) && speed < slaughterSpeed)
			{
				speed = slaughterSpeed;
			}
			acceleration += 10000.0;
		}
	}

	if ((!data.IsPvEBoss && IsBeatBoxBeating(2)) || chaser.IsKillingSomeone)
	{
		speed = 0.0;
	}

	if (!chaser.GroundSpeedOverride)
	{
		npc.flWalkSpeed = speed * 0.9;
		npc.flRunSpeed = speed;
		npc.flAcceleration = acceleration;
	}
	else
	{
		float vel[3], myPos[3], res[3], matrix[3][4], ang[3];
		float cycle = chaser.GetPropFloat(Prop_Data, "m_flCycle");
		if (cycle < 1.0)
		{
			CBaseNPC_Locomotion loco = npc.GetLocomotion();
			Address poseParams = GetEntityAddress(chaser.index) + view_as<Address>(FindSendPropInfo("CBaseAnimating", "m_flPoseParameter"));
			int sequence = chaser.GetProp(Prop_Send, "m_nSequence");

			CBaseAnimating_GetSequenceVelocity(chaser.GetModelPtr(), sequence, cycle, poseParams, vel);
			chaser.GetAbsOrigin(myPos);
			chaser.GetLocalAngles(ang);
			AngleMatrix(ang, matrix);
			VectorRotate(vel, matrix, res);
			AddVectors(res, myPos, res);
			if (moveType != SF2NPCMoveType_Attack)
			{
				speed = GetVectorLength(vel) * chaser.GetPropFloat(Prop_Send, "m_flPlaybackRate") * 0.9 * chaser.GetPropFloat(Prop_Send, "m_flModelScale");
			}
			else
			{
				speed *= GetVectorLength(vel) * chaser.GetPropFloat(Prop_Send, "m_flPlaybackRate") * 0.9 * chaser.GetPropFloat(Prop_Send, "m_flModelScale");
			}
			npc.flAcceleration = speed * 10.0;
			npc.flWalkSpeed = speed;
			npc.flRunSpeed = speed;
			loco.Run();
			if (moveType != SF2NPCMoveType_Attack)
			{
				loco.Approach(res, 999999.9);
			}
		}
	}
}

static void ProcessBody(SF2_ChaserEntity chaser)
{
	SF2NPC_Chaser controller = chaser.Controller;
	if (!controller.IsValid())
	{
		return;
	}

	ChaserBossProfile data = controller.GetProfileData();

	if (data.GetSection("postures") != null && chaser.CanUpdatePosture())
	{
		char posture[64], resultPosture[64];
		chaser.GetDefaultPosture(posture, sizeof(posture));
		strcopy(resultPosture, sizeof(resultPosture), posture);
		Action result = Plugin_Continue;
		Call_StartForward(g_OnChaserUpdatePosturePFwd);
		Call_PushCell(controller);
		Call_PushStringEx(resultPosture, sizeof(resultPosture), 0, SM_PARAM_COPYBACK);
		Call_PushCell(sizeof(resultPosture));
		Call_Finish(result);

		if (result == Plugin_Changed)
		{
			strcopy(posture, sizeof(posture), resultPosture);
		}

		chaser.SetPosture(posture);
	}

	INextBot bot = chaser.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(chaser.index);

	float speed = loco.GetGroundSpeed();

	if (speed < 0.01)
	{
		if (chaser.MoveXParameter != -1)
		{
			chaser.SetPoseParameter(chaser.MoveXParameter, 0.0);
		}

		if (chaser.MoveYParameter != -1)
		{
			chaser.SetPoseParameter(chaser.MoveYParameter, 0.0);
		}

		if (chaser.MoveScaleParameter != -1)
		{
			chaser.SetPoseParameter(chaser.MoveScaleParameter, 0.0);
		}

		if (chaser.ShouldAnimationSyncWithGround)
		{
			chaser.SetPropFloat(Prop_Send, "m_flPlaybackRate", 0.0);
		}
		return;
	}

	if (!chaser.IsAttemptingToMove)
	{
		return;
	}

	if (chaser.ShouldAnimationSyncWithGround)
	{
		float velocity, returnFloat, groundSpeed;
		velocity = loco.GetGroundSpeed();
		groundSpeed = chaser.GetPropFloat(Prop_Data, "m_flGroundSpeed");
		if (groundSpeed != 0.0 && groundSpeed > 10.0)
		{
			returnFloat = (velocity / groundSpeed) * chaser.AnimationPlaybackRate;

			if (loco.IsOnGround() && chaser.IsAttemptingToMove)
			{
				if (returnFloat > 12.0)
				{
					returnFloat = 12.0;
				}
				if (returnFloat < -4.0)
				{
					returnFloat = -4.0;
				}
				chaser.SetPropFloat(Prop_Send, "m_flPlaybackRate", returnFloat);
			}
		}
		else
		{
			float syncSpeed = chaser.GroundSyncSpeed;
			if (syncSpeed <= 0.0)
			{
				syncSpeed = npc.flRunSpeed;
			}
			velocity = (velocity + ((syncSpeed * GetDifficultyModifier(controller.Difficulty)) / 15.0)) / syncSpeed;

			if (loco.IsOnGround() && chaser.IsAttemptingToMove)
			{
				float playbackSpeed = velocity * chaser.AnimationPlaybackRate;
				if (playbackSpeed > 12.0)
				{
					playbackSpeed = 12.0;
				}
				if (playbackSpeed < -4.0)
				{
					playbackSpeed = -4.0;
				}
				chaser.SetPropFloat(Prop_Send, "m_flPlaybackRate", playbackSpeed);
			}
		}
	}

	switch (chaser.MoveParameterType)
	{
		case SF2NPCMoveParameter_XY:
		{
			float forwardVector[3], rightVector[3], upVector[3], motionVector[3];
			chaser.GetVectors(forwardVector, rightVector, upVector);
			loco.GetGroundMotionVector(motionVector);

			chaser.SetPoseParameter(chaser.MoveXParameter, GetVectorDotProduct(motionVector, forwardVector));
			chaser.SetPoseParameter(chaser.MoveYParameter, GetVectorDotProduct(motionVector, rightVector));

			float groundSpeed = chaser.GetPropFloat(Prop_Data, "m_flGroundSpeed");
			if (groundSpeed != 0.0 && loco.IsOnGround() && chaser.State != STATE_ATTACK)
			{
				float rate = (speed / groundSpeed);
				if (rate < 0.0)
				{
					rate = 0.0;
				}
				if (rate > 12.0)
				{
					rate = 12.0;
				}

				chaser.SetPropFloat(Prop_Send, "m_flPlaybackRate", rate);
			}
		}
		case SF2NPCMoveParameter_Yaw:
		{
			float fwd[3], right[3], up[3];
			chaser.GetVectors(fwd, right, up);

			float motion[3];
			loco.GetGroundMotionVector(motion);

			float deltaTime = GetGameFrameTime();
			if (deltaTime > 0.0)
			{
				float myAng[3], normalAngle, estimateYaw;
				estimateYaw = chaser.EstimatedYaw;
				chaser.GetLocalAngles(myAng);

				if (motion[0] == 0.0 && motion[1] == 0.0)
				{
					float yawDelta = myAng[1] - estimateYaw;
					yawDelta = AngleNormalize(yawDelta);

					if (deltaTime < 0.25)
					{
						yawDelta *= (deltaTime * 4.0);
					}
					else
					{
						yawDelta *= deltaTime;
					}

					estimateYaw += yawDelta;
					estimateYaw = AngleNormalize(estimateYaw);
				}
				else
				{
					estimateYaw = (ArcTangent2(motion[1], motion[0]) * 180.0 / 3.14159);
					estimateYaw = FloatClamp(estimateYaw, -180.0, 180.0);
				}
				normalAngle = AngleNormalize(myAng[1]);
				chaser.EstimatedYaw = estimateYaw;
				float actualYaw = normalAngle - estimateYaw;
				actualYaw = AngleNormalize(-actualYaw);

				chaser.SetPoseParameter(chaser.MoveYawParameter, actualYaw);
			}
		}
	}

	if (chaser.MoveScaleParameter != -1)
	{
		float scale = npc.flRunSpeed / speed;
		chaser.SetPoseParameter(chaser.MoveScaleParameter, scale);
	}
}

static bool LocoCollideWith(CBaseNPC_Locomotion loco, int other)
{
	if (SF2_ChaserEntity(other).IsValid() || SF2_StatueEntity(other).IsValid())
	{
		return false;
	}

	if (IsValidEntity(other))
	{
		SF2_BasePlayer player = SF2_BasePlayer(other);
		INextBot bot = loco.GetBot();
		SF2_ChaserEntity chaser = SF2_ChaserEntity(bot.GetEntity());

		if (chaser.Controller.IsValid() && (chaser.Controller.Flags & SFF_MARKEDASFAKE) != 0)
		{
			return false;
		}

		if (chaser.State == STATE_DEATH)
		{
			return false;
		}

		char class[64];
		GetEntityClassname(other, class, sizeof(class));
		if (player.IsValid)
		{
			if (player.IsInGhostMode)
			{
				return false;
			}

			if (chaser.IsValid() && chaser.Controller.IsValid())
			{
				SF2NPC_BaseNPC controller = view_as<SF2NPC_BaseNPC>(chaser.Controller);
				BaseBossProfile data = controller.GetProfileData();
				if ((data.IsPvEBoss && player.IsInPvE) || (controller.Flags & SFF_ATTACKWAITERS) != 0)
				{
					return true;
				}
			}

			if (g_Enabled && !SF_IsBoxingMap() && !player.IsProxy && !player.IsInGhostMode && player.Team != TFTeam_Blue && !player.IsInDeathCam)
			{
				return true;
			}

			if (!g_Enabled && player.Team != chaser.Team)
			{
				return true;
			}
		}

		if (chaser.IsValid() && chaser.Controller.IsValid())
		{
			ChaserBossProfile data = chaser.Controller.GetProfileData();
			if (data.IsPvEBoss && SF2_ChaserEntity(other).IsValid())
			{
				return false;
			}

			if (strcmp(class, "obj_sentrygun", false) || strcmp(class, "obj_dispenser", false) || strcmp(class, "obj_teleporter", false))
			{
				if (chaser.Team != CBaseEntity(other).GetProp(Prop_Data, "m_iTeamNum"))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		if (strcmp(class, "tank_boss", false) == 0)
		{
			return true;
		}
	}
	return loco.CallBaseFunction(other);
}

static Action Hook_ChaserSoundHook(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer client = SF2_BasePlayer(entity);
	if (!client.IsValid || !client.IsAlive || client.IsEliminated || client.HasEscaped)
	{
		return Plugin_Continue;
	}

	switch (channel)
	{
		case SNDCHAN_VOICE:
		{
			if (StrContains(sample, "vo/halloween_scream") != -1)
			{
				return Plugin_Continue;
			}

			OnPlayerEmitSound(client, SoundType_Voice);
		}
		case SNDCHAN_BODY:
		{
			if (!(client.GetFlags() & FL_ONGROUND))
			{
				return Plugin_Continue;
			}

			if (StrContains(sample, "player/footsteps", false) == -1 && StrContains(sample, "step", false) == -1)
			{
				return Plugin_Continue;
			}

			bool isLoudStep = false, isCrouchStep = false;
			if (client.IsSprinting && !(client.GetProp(Prop_Send, "m_bDucking") || client.GetProp(Prop_Send, "m_bDucked")))
			{
				isLoudStep = true;
			}
			else if (client.GetProp(Prop_Send, "m_bDucking") || client.GetProp(Prop_Send, "m_bDucked"))
			{
				isCrouchStep = true;
			}

			SoundType soundType = SoundType_Footstep;
			if (isLoudStep)
			{
				soundType = SoundType_LoudFootstep;
			}
			else if (isCrouchStep)
			{
				soundType = SoundType_QuietFootstep;
			}

			OnPlayerEmitSound(client, soundType);
		}
		case SNDCHAN_ITEM, SNDCHAN_WEAPON, SNDCHAN_STATIC:
		{
			static char matchSoundStrings[][] = {
					"tf",
					"flashlight",
					"impact",
					"hit",
					"swing",
					"slice",
					"crit",
					"shot",
					"shoot",
					"fire",
					"doom",
					"single",
					"tf2",
					"heal",
					"break",
					"diamond",
					"start",
					"loop",
					"minigun",
					"reload",
					"woosh",
					"eviction",
					"holy",
					"cbar",
					"jingle_bells_nm",
					"happy_birthday_tf"
				};

			bool isWeaponSound = false;

			for (int i = 0; !isWeaponSound && i < sizeof(matchSoundStrings); i++)
			{
				if (StrContains(sample, matchSoundStrings[i], false) != -1)
				{
					isWeaponSound = true;
				}
			}

			bool voice = false;
			if (StrContains(sample, "flashlight", false) != -1 || StrContains(sample, "happy_birthday_tf", false) != -1 ||
				StrContains(sample, "jingle_bells_nm", false) != -1)
			{
				voice = true;
			}

			if (isWeaponSound)
			{
				OnPlayerEmitSound(client, voice ? SoundType_Flashlight : SoundType_Weapon);
			}
		}
	}

	return Plugin_Continue;
}

static void OnPlayerEmitSound(SF2_BasePlayer client, SoundType soundType)
{
	float gameTime = GetGameTime();
	for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
	{
		if (NPCGetUniqueID(bossIndex) == -1)
		{
			continue;
		}

		if (!NPCShouldHearEntity(bossIndex, client.index, soundType))
		{
			continue;
		}

		int entity = NPCGetEntIndex(bossIndex);
		if (!entity || entity == INVALID_ENT_REFERENCE)
		{
			continue;
		}

		SF2_ChaserEntity chaser = SF2_ChaserEntity(entity);
		SF2NPC_Chaser controller = chaser.Controller;
		if (!controller.IsValid())
		{
			continue;
		}

		if (chaser.State != STATE_IDLE && chaser.State != STATE_ALERT)
		{
			continue;
		}

		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossSoundSenseData senseData = data.GetSoundSenseData();
		ChaserBossAutoChaseData autoChaseData = data.GetAutoChaseData();

		TFClassType class = client.Class;
		int classToInt = view_as<int>(class);

		float myPos[3], hisPos[3];
		chaser.GetAbsOrigin(myPos);
		client.GetAbsOrigin(hisPos);

		int difficulty = controller.Difficulty;

		float hearRadius = data.GetHearingRange(difficulty);
		if (hearRadius <= 0.0)
		{
			continue;
		}

		float distance = GetVectorSquareMagnitude(hisPos, myPos);

		Handle trace = null;
		bool hit = false;

		float myEyePos[3];
		controller.GetEyePosition(myEyePos);

		float cooldown = 0.0;
		int addThreshold = 0;

		switch (soundType)
		{
			case SoundType_Footstep, SoundType_LoudFootstep, SoundType_QuietFootstep:
			{
				if (!(client.GetFlags() & FL_ONGROUND))
				{
					continue;
				}

				if (soundType == SoundType_QuietFootstep)
				{
					addThreshold = senseData.GetQuietFootstepAdd(difficulty);
					if (addThreshold <= 0)
					{
						continue;
					}
					cooldown = senseData.GetQuietFootstepCooldown(difficulty);
					distance *= 1.85;
				}
				else if (soundType == SoundType_LoudFootstep)
				{
					addThreshold = senseData.GetLoudFootstepAdd(difficulty);
					if (addThreshold <= 0)
					{
						continue;
					}
					cooldown = senseData.GetLoudFootstepCooldown(difficulty);
					distance *= 0.66;
				}
				else
				{
					addThreshold = senseData.GetFootstepAdd(difficulty);
					if (addThreshold <= 0)
					{
						continue;
					}
					cooldown = senseData.GetFootstepCooldown(difficulty);
				}

				trace = TR_TraceRayFilterEx(myPos, hisPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_WINDOW, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, chaser.index);
				hit = TR_DidHit(trace);
				delete trace;
			}
			case SoundType_Voice, SoundType_Flashlight:
			{
				float hisEyePos[3];
				client.GetEyePosition(hisEyePos);

				trace = TR_TraceRayFilterEx(myEyePos, hisEyePos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_WINDOW, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, chaser.index);
				hit = TR_DidHit(trace);
				delete trace;

				if (!IsClassConfigsValid() || soundType == SoundType_Voice)
				{
					distance *= 0.5;
				}
				else if (IsClassConfigsValid() && soundType == SoundType_Flashlight)
				{
					distance *= g_ClassFlashlightSoundRadius[classToInt];
				}

				if (soundType == SoundType_Voice)
				{
					addThreshold = senseData.GetVoiceAdd(difficulty);
					if (addThreshold <= 0)
					{
						continue;
					}
					cooldown = senseData.GetVoiceCooldown(difficulty);
				}
				else if (soundType == SoundType_Flashlight)
				{
					addThreshold = senseData.GetFlashlightAdd(difficulty);
					if (addThreshold <= 0)
					{
						continue;
					}
					cooldown = senseData.GetFlashlightCooldown(difficulty);
				}
			}
			case SoundType_Weapon:
			{
				addThreshold = senseData.GetWeaponAdd(difficulty);
				if (addThreshold <= 0)
				{
					continue;
				}

				float hisMins[3], hisMaxs[3];
				client.GetPropVector(Prop_Send, "m_vecMins", hisMins);
				client.GetPropVector(Prop_Send, "m_vecMaxs", hisMaxs);

				float middle[3];
				for (int i = 0; i < 2; i++)
				{
					middle[i] = (hisMins[i] + hisMaxs[i]) / 2.0;
				}

				float endPos[3];
				endPos = hisPos;
				AddVectors(hisPos, middle, endPos);

				trace = TR_TraceRayFilterEx(myEyePos, endPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_WINDOW, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, chaser.index);
				hit = TR_DidHit(trace);
				delete trace;

				distance *= 0.66;

				cooldown = senseData.GetWeaponCooldown(difficulty);
			}
		}

		if (hit)
		{
			distance *= 1.66;
		}

		if (!IsClassConfigsValid())
		{
			if (class == TFClass_Spy)
			{
				distance *= 1.3;
			}

			if (class == TFClass_Scout)
			{
				distance *= 0.8;
			}
		}
		else
		{
			distance *= g_ClassBossHearingSensitivity[classToInt];
		}

		if (distance > SquareFloat(hearRadius))
		{
			continue;
		}

		if (!data.ShouldIgnoreHearingPathChecking(difficulty))
		{
			CNavArea myArea = chaser.GetLastKnownArea();
			CNavArea theirArea = client.GetLastKnownArea();
			if (myArea != NULL_AREA && theirArea != NULL_AREA && myArea != theirArea)
			{
				CNavArea closestArea = NULL_AREA;
				TheNavMesh.BuildPath(myArea, NULL_AREA, hisPos, .closestArea = closestArea, .maxPathLength = hearRadius * 1.5);
				if (closestArea != theirArea)
				{
					continue;
				}
			}
		}

		if (gameTime > chaser.GetAlertSoundTriggerCooldown(client))
		{
			chaser.SetAlertSoundTriggerCooldown(client, gameTime + cooldown);
			chaser.UpdateAlertTriggerCount(client, addThreshold);
		}

		if (autoChaseData.IsEnabled(difficulty) && chaser.GetAutoChaseAddCooldown(client) < gameTime)
		{
			int count = 0;
			switch (soundType)
			{
				case SoundType_Footstep:
				{
					count = autoChaseData.GetAddFootsteps(difficulty);
				}
				case SoundType_QuietFootstep:
				{
					count = autoChaseData.GetAddQuietFootsteps(difficulty);
				}
				case SoundType_LoudFootstep:
				{
					count = autoChaseData.GetAddLoudFootsteps(difficulty);
				}
				case SoundType_Voice:
				{
					count = autoChaseData.GetAddVoice(difficulty);
				}
				case SoundType_Flashlight, SoundType_Weapon:
				{
					count = autoChaseData.GetAddWeapon(difficulty);
				}
			}
			if (count > 0)
			{
				chaser.SetAutoChaseAddCooldown(client, gameTime + 0.3);
				chaser.UpdateAutoChaseCount(client, chaser.GetAutoChaseCount(client) + count);
			}
		}
	}
}

static any Native_GetIsValid(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	return bossEntity.IsValid();
}

static any Native_GetController(Handle plugin, int numParams)
{
	int ent = GetNativeCell(1);
	if (!IsValidEntity(ent))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", ent);
	}

	SF2_ChaserEntity boss = SF2_ChaserEntity(ent);
	if (!boss.Controller.IsValid())
	{
		return -1;
	}
	return boss.Controller;
}

static any Native_GetIsAttemptingToMove(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.IsAttemptingToMove;
}

static any Native_GetIsAttacking(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.IsAttacking;
}

static any Native_GetIsStunned(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.IsStunned;
}

static any Native_GetStunHealth(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.StunHealth;
}

static any Native_GetMaxStunHealth(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.MaxStunHealth;
}

static any Native_GetCanBeStunned(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.CanBeStunned();
}

static any Native_GetCanTakeDamage(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.CanTakeDamage();
}

static any Native_GetIsRaging(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.IsRaging;
}

static any Native_GetIsRunningAway(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.IsRunningAway;
}

static any Native_GetIsSelfHealing(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.IsSelfHealing;
}

static any Native_GetProfileData(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.Controller.GetProfileData();
}

static any Native_PerformVoice(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	char attackName[64];
	GetNativeString(3, attackName, sizeof(attackName));
	return bossEntity.PerformVoice(GetNativeCell(2), attackName);
}

static any Native_PerformCustomVoice(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	ProfileSound soundInfo = GetNativeCell(2);
	return bossEntity.PerformVoiceCooldown(soundInfo, soundInfo.Paths);
}

static any Native_GetDefaultPosture(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	int bufferSize = GetNativeCell(3);
	char[] posture = new char[bufferSize];
	int result = bossEntity.GetDefaultPosture(posture, bufferSize);
	SetNativeString(2, posture, bufferSize);

	return result;
}

static any Native_SetDefaultPosture(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	int bufferSize;
	GetNativeStringLength(2, bufferSize);
	bufferSize++;
	char[] buffer = new char[bufferSize];
	GetNativeString(2, buffer, bufferSize);
	bossEntity.SetDefaultPosture(buffer, GetNativeCell(3));

	return 0;
}

static any Native_GetAttackName(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	int bufferSize = GetNativeCell(3);
	char[] attack = new char[bufferSize];
	int result = strcopy(attack, bufferSize, bossEntity.GetAttackName());
	SetNativeString(2, attack, bufferSize);

	return result;
}

static any Native_GetAttackIndex(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	return bossEntity.AttackIndex;
}

static any Native_GetNextAttackTime(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	int bufferSize;
	GetNativeStringLength(2, bufferSize);
	bufferSize++;
	char[] buffer = new char[bufferSize];
	GetNativeString(2, buffer, bufferSize);

	return bossEntity.GetNextAttackTime(buffer);
}

static any Native_SetNextAttackTime(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	int bufferSize;
	GetNativeStringLength(2, bufferSize);
	bufferSize++;
	char[] buffer = new char[bufferSize];
	GetNativeString(2, buffer, bufferSize);

	float time = GetNativeCell(3);

	bossEntity.SetNextAttackTime(buffer, time);
	return 0;
}

static any Native_DropItem(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	bossEntity.DropItem(GetNativeCell(2));

	return 0;
}

static any Native_CreateSoundHint(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);

	float position[3];
	GetNativeArray(2, position, 3);
	bossEntity.UpdateAlertTriggerCountEx(position);

	return 0;
}

static any Native_GetGroundSpeedOverride(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	return bossEntity.GroundSpeedOverride;
}

static any Native_SetGroundSpeedOverride(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	bossEntity.GroundSpeedOverride = GetNativeCell(2);
	return 0;
}

static any Native_GetMovementType(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	return bossEntity.MovementType;
}

static any Native_SetMovementType(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	bool old = bossEntity.LockMovementType;
	bossEntity.LockMovementType = false;
	bossEntity.MovementType = GetNativeCell(2);
	bossEntity.LockMovementType = old;
	return 0;
}

static any Native_GetLockMovementType(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	return bossEntity.LockMovementType;
}

static any Native_SetLockMovementType(Handle plugin, int numParams)
{
	int entity = GetNativeCell(1);
	if (!IsValidEntity(entity))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid entity index %d", entity);
	}

	SF2_ChaserEntity bossEntity = SF2_ChaserEntity(entity);
	bossEntity.LockMovementType = GetNativeCell(2);
	return 0;
}
