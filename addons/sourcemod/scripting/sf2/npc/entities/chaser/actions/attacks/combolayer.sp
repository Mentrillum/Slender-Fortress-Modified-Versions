#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_ComboLayer < NextBotAction
{
	public SF2_ChaserAttackAction_ComboLayer(const char[] attackName, ChaserBossProfileComboAttack data)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackComboLayer");
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.BeginDataMapDesc()
				.DefineStringField("m_AttackName")
				.DefineIntField("m_ProfileData")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_ComboLayer action = view_as<SF2_ChaserAttackAction_ComboLayer>(g_Factory.Create());

		action.SetAttackName(attackName);
		action.ProfileData = data;

		return action;
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
}

static int Update(SF2_ChaserAttackAction_ComboLayer action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION)
	{
		return action.Done("No more combo attacks");
	}

	if (actor.CancelAttack)
	{
		return action.Done();
	}

	if (actor.ClearCurrentAttack)
	{
		actor.ClearCurrentAttack = false;
		SF2_ChaserAttackAction_Combo parent = view_as<SF2_ChaserAttackAction_Combo>(action.Parent);
		ChaserBossProfileBaseAttack attackData = parent.SelectedData;
		if (attackData == null)
		{
			return action.Done();
		}
		float gameTime = GetGameTime();
		int difficulty = actor.Controller.Difficulty;

		switch (attackData.Type)
		{
			case SF2BossAttackType_Melee:
			{
				return action.SuspendFor(SF2_ChaserAttackAction_Melee(action.GetAttackName(), attackData, attackData.GetDelay(difficulty) + gameTime));
			}

			case SF2BossAttackType_Ranged:
			{
				return action.SuspendFor(SF2_ChaserAttackAction_Bullet(action.GetAttackName(), view_as<ChaserBossProfileBulletAttack>(attackData), attackData.GetDelay(difficulty) + gameTime));
			}

			case SF2BossAttackType_Projectile:
			{
				return action.SuspendFor(SF2_ChaserAttackAction_Projectile(action.GetAttackName(), view_as<ChaserBossProfileProjectileAttack>(attackData), attackData.GetDelay(difficulty) + gameTime));
			}

			case SF2BossAttackType_ExplosiveDance:
			{
				return action.SuspendFor(SF2_ChaserAttackAction_ExplosiveDance(action.GetAttackName(), view_as<ChaserBossProfileExplosiveDanceAttack>(attackData), attackData.GetDelay(difficulty) + gameTime));
			}

			case SF2BossAttackType_LaserBeam:
			{
				return action.SuspendFor(SF2_ChaserAttackAction_Laser(action.GetAttackName(), view_as<ChaserBossProfileLaserAttack>(attackData), attackData.GetDelay(difficulty) + gameTime, view_as<ChaserBossProfileLaserAttack>(attackData).GetLaserDuration(difficulty) + gameTime + attackData.GetDelay(difficulty)));
			}

			case SF2BossAttackType_Custom:
			{
				NextBotAction customAction = NULL_ACTION;
				Action retAction = Plugin_Continue;
				Call_StartForward(g_OnBossGetCustomAttackActionFwd);
				Call_PushCell(actor);
				Call_PushString(action.GetAttackName());
				Call_PushCell(attackData);
				Call_PushCell(actor.Target);
				Call_PushCellRef(customAction);
				Call_Finish(retAction);

				if (retAction != Plugin_Continue)
				{
					return action.SuspendFor(customAction);
				}
			}

			case SF2BossAttackType_Tongue:
			{
				return action.SuspendFor(SF2_ChaserAttackAction_Tongue(action.GetAttackName(), view_as<ChaserBossProfileTongueAttack>(attackData), attackData.GetDelay(difficulty) + gameTime));
			}
		}
	}

	return action.Continue();
}