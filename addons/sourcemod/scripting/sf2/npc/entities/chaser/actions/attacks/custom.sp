#pragma semicolon 1

methodmap SF2_ChaserAttackAction_Custom < NextBotAction
{
	public static void Initialize()
	{
		g_OnChaserGetAttackActionPFwd.AddFunction(null, OnChaserGetAttackAction);
		g_OnChaserGetCustomAttackPossibleStatePFwd.AddFunction(null, OnChaserGetCustomAttackPossibleState);
	}
}

static Action OnChaserGetAttackAction(SF2_ChaserEntity chaser, const char[] attackName, NextBotAction &result)
{
	if (result != NULL_ACTION)
	{
		return Plugin_Continue;
	}

	SF2ChaserBossProfileData data;
	data = chaser.Controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(attackName, attackData);

	if (attackData.Type != SF2BossAttackType_Custom)
	{
		return Plugin_Continue;
	}

	result = chaser.GetCustomAttack(attackName, chaser.Target);
	return Plugin_Changed;
}

static Action OnChaserGetCustomAttackPossibleState(SF2_ChaserEntity chaser, const char[] attackName, CBaseEntity target)
{
	if (!chaser.IsCustomAttackPossible(attackName, target))
	{
		return Plugin_Continue;
	}

	return Plugin_Handled;
}