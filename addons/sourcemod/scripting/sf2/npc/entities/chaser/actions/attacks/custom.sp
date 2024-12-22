#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossProfileCustomAttack < ChaserBossProfileBaseAttack
{
	public void GetSubType(char[] buffer, int bufferSize)
	{
		this.GetString("subtype", buffer, bufferSize);
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_ChaserBossProfileCustomAttack.GetSubType", Native_GetSubType);
		CreateNative("SF2_ChaserBossProfileCustomAttack.IsSubType", Native_GetIsSubType);
	}
}

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

	ChaserBossProfile data = chaser.Controller.GetProfileDataEx();
	ChaserBossProfileCustomAttack attackData = view_as<ChaserBossProfileCustomAttack>(data.GetAttack(attackName));

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

static any Native_GetSubType(Handle plugin, int numParams)
{
	ChaserBossProfileCustomAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int bufferSize = GetNativeCell(3);
	char[] buffer = new char[bufferSize];
	attackData.GetSubType(buffer, bufferSize);
	SetNativeString(2, buffer, bufferSize);
	return 0;
}

static any Native_GetIsSubType(Handle plugin, int numParams)
{
	ChaserBossProfileCustomAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int subTypeSize;
	GetNativeStringLength(2, subTypeSize);
	subTypeSize++;
	char[] subType = new char[subTypeSize];
	GetNativeString(2, subType, subTypeSize);

	char attackSubType[128];
	attackData.GetSubType(attackSubType, sizeof(attackSubType));

	return strcmp(subType, attackSubType) == 0;
}
