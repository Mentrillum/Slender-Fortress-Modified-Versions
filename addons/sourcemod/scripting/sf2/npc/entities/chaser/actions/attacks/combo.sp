#pragma semicolon 1
#pragma newdecls required

#include "combolayer.sp"

methodmap ChaserBossProfileComboAttack < ChaserBossProfileBaseAttack
{
	public ProfileObject GetAttacks()
	{
		return this.GetSection("attacks");
	}

	public KeyMap_Array GetPossibleCombos(int difficulty)
	{
		return this.GetDifficultyArray("combos", difficulty);
	}

	public ChaserBossProfileBaseAttack GetAttack(const char[] name)
	{
		ProfileObject array = this.GetAttacks();
		if (array != null)
		{
			return view_as<ChaserBossProfileBaseAttack>(array.GetSection(name));
		}
		return null;
	}

	public ChaserBossProfileBaseAttack GetAttackFromIndex(int index)
	{
		ProfileObject array = this.GetAttacks();
		if (array != null)
		{
			if (index >= array.SectionLength)
			{
				return null;
			}
			char name[64];
			array.GetSectionNameFromIndex(index, name, sizeof(name));
			return view_as<ChaserBossProfileBaseAttack>(array.GetSection(name));
		}
		return null;
	}

	public bool GetAttackFromComboList(int difficulty, int index, int subIndex, char[] buffer, int bufferSize)
	{
		KeyMap_Array combos = this.GetPossibleCombos(difficulty);
		if (index >= combos.Length)
		{
			return false;
		}

		char value[2048];
		combos.GetString(index, value, sizeof(value));
		char attacks[128][64];
		int length = ExplodeString(value, " ", attacks, sizeof(attacks), sizeof(attacks[]));
		if (subIndex >= length)
		{
			return false;
		}

		strcopy(buffer, bufferSize, attacks[subIndex]);
		return true;
	}

	public void Precache()
	{
		this.ConvertDifficultyValuesSectionToArray("combos");

		if (this.GetAttacks() != null)
		{
			for (int i = 0; i < this.GetAttacks().SectionLength; i++)
			{
				ChaserBossProfileBaseAttack attack = this.GetAttackFromIndex(i);
				if (attack != null)
				{
					attack.Precache();
				}
			}
		}

	}
}

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Combo < NextBotAction
{
	public SF2_ChaserAttackAction_Combo(const char[] attackName, ChaserBossProfileComboAttack data)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackCombo");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.BeginDataMapDesc()
				.DefineStringField("m_AttackName")
				.DefineIntField("m_ProfileData")
				.DefineIntField("m_SelectedData")
				.DefineIntField("m_Index")
				.DefineIntField("m_PrimaryIndex")
				.DefineIntField("m_CurrentDifficulty")
				.DefineFloatField("m_EndTime")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_Combo action = view_as<SF2_ChaserAttackAction_Combo>(g_Factory.Create());

		action.SetAttackName(attackName);
		action.ProfileData = data;
		action.Index = -1;

		return action;
	}

	public static void Initialize()
	{
		g_OnChaserGetAttackActionPFwd.AddFunction(null, OnChaserGetAttackAction);
	}

	public char[] GetAttackName()
	{
		char name[128];
		this.GetDataString("m_AttackName", name, sizeof(name));
		return name;
	}

	public void SetAttackName(const char[] name)
	{
		this.SetDataString("m_AttackName", name);
	}

	property ChaserBossProfileComboAttack ProfileData
	{
		public get()
		{
			return this.GetData("m_ProfileData");
		}

		public set(ChaserBossProfileComboAttack value)
		{
			this.SetData("m_ProfileData", value);
		}
	}

	property ChaserBossProfileBaseAttack SelectedData
	{
		public get()
		{
			return this.GetData("m_SelectedData");
		}

		public set(ChaserBossProfileBaseAttack value)
		{
			this.SetData("m_SelectedData", value);
		}
	}

	property int Index
	{
		public get()
		{
			return this.GetData("m_Index");
		}

		public set(int value)
		{
			this.SetData("m_Index", value);
		}
	}

	property int PrimaryIndex
	{
		public get()
		{
			return this.GetData("m_PrimaryIndex");
		}

		public set(int value)
		{
			this.SetData("m_PrimaryIndex", value);
		}
	}

	property int CurrentDifficulty
	{
		public get()
		{
			return this.GetData("m_CurrentDifficulty");
		}

		public set(int value)
		{
			this.SetData("m_CurrentDifficulty", value);
		}
	}

	property float EndTime
	{
		public get()
		{
			return this.GetDataFloat("m_EndTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_EndTime", value);
		}
	}
}

static Action OnChaserGetAttackAction(SF2_ChaserEntity chaser, const char[] attackName, NextBotAction &result)
{
	if (result != NULL_ACTION)
	{
		return Plugin_Continue;
	}

	ChaserBossProfile data = chaser.Controller.GetProfileData();
	ChaserBossProfileComboAttack attackData = view_as<ChaserBossProfileComboAttack>(data.GetAttack(attackName));

	if (attackData.Type != SF2BossAttackType_Combo)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Combo(attackName, attackData);
	return Plugin_Changed;
}

static NextBotAction InitialContainedAction(SF2_ChaserAttackAction_Combo action, SF2_ChaserEntity actor)
{
	return SF2_ChaserAttackAction_ComboLayer(action.GetAttackName(), action.ProfileData);
}

static int OnStart(SF2_ChaserAttackAction_Combo action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2_ChaserAttackAction attackAction = view_as<SF2_ChaserAttackAction>(action.Parent);
	attackAction.EndTime = -1.0;
	action.PrimaryIndex = -1;
	action.CurrentDifficulty = actor.Controller.Difficulty;
	if (action.ProfileData.GetPossibleCombos(action.CurrentDifficulty) != null)
	{
		action.PrimaryIndex = GetRandomInt(0, action.ProfileData.GetPossibleCombos(action.CurrentDifficulty).Length - 1);
	}
	return action.Continue();
}

static int Update(SF2_ChaserAttackAction_Combo action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION)
	{
		return action.Done("No more combo attacks");
	}

	if (action.ActiveChild == NULL_ACTION)
	{
		return action.Done("No more combo attacks");
	}

	if (actor.CancelAttack)
	{
		return action.Done();
	}

	float gameTime = GetGameTime();
	if (action.EndTime <= gameTime)
	{
		action.Index++;
		ChaserBossProfileBaseAttack attackData = null;
		if (action.ProfileData.GetPossibleCombos(action.CurrentDifficulty) != null)
		{
			char name[64];
			action.ProfileData.GetAttackFromComboList(action.CurrentDifficulty, action.PrimaryIndex, action.Index, name, sizeof(name));
			attackData = action.ProfileData.GetAttack(name);
		}
		else
		{
			attackData = action.ProfileData.GetAttackFromIndex(action.Index);
		}
		if (attackData == null)
		{
			return action.Done();
		}
		int difficulty = actor.Controller.Difficulty;
		action.EndTime = gameTime + attackData.GetDuration(difficulty);
		if (attackData.GetStartSounds() != null)
		{
			actor.PerformVoiceCooldown(attackData.GetStartSounds(), attackData.GetStartSounds().Paths);
		}

		if (attackData.GetAnimations() != null)
		{
			actor.ResetProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Attack], .animations = attackData.GetAnimations());
		}
		action.SelectedData = attackData;
		actor.ClearCurrentAttack = true;
	}

	return action.Continue();
}