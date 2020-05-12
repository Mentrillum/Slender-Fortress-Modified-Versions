#if defined _sf2_profiles_chaser
 #endinput
#endif

#define _sf2_profiles_chaser

#define SF2_CHASER_BOSS_MAX_ATTACKS 8

Handle g_hChaserProfileNames;
Handle g_hChaserProfileData;

enum
{
	SF2BossAttackType_Invalid = -1,
	SF2BossAttackType_Melee = 0,
	SF2BossAttackType_Ranged,
	SF2BossAttackType_Projectile,
	SF2BossAttackType_Custom
};

enum
{
	ChaserProfileData_StepSize,
	ChaserProfileData_WalkSpeedEasy,
	ChaserProfileData_WalkSpeedNormal,
	ChaserProfileData_WalkSpeedHard,
	ChaserProfileData_WalkSpeedInsane,
	
	ChaserProfileData_AirSpeedEasy,
	ChaserProfileData_AirSpeedNormal,
	ChaserProfileData_AirSpeedHard,
	ChaserProfileData_AirSpeedInsane,
	
	ChaserProfileData_MaxWalkSpeedEasy,
	ChaserProfileData_MaxWalkSpeedNormal,
	ChaserProfileData_MaxWalkSpeedHard,
	ChaserProfileData_MaxWalkSpeedInsane,
	
	ChaserProfileData_MaxAirSpeedEasy,
	ChaserProfileData_MaxAirSpeedNormal,
	ChaserProfileData_MaxAirSpeedHard,
	ChaserProfileData_MaxAirSpeedInsane,
	
	ChaserProfileData_WakeRadius,
	
	ChaserProfileData_Attacks,		// array that contains data about attacks
	
	ChaserProfileData_CanBeStunned,
	ChaserProfileData_StunDuration,
	ChaserProfileData_StunCooldown,
	ChaserProfileData_StunHealth,
	ChaserProfileData_StunHealthPerPlayer,
	ChaserProfileData_CanBeStunnedByFlashlight,
	ChaserProfileData_StunFlashlightDamage,
	
	ChaserProfileData_KeyDrop,
	
	ChaserProfileData_MemoryLifeTime,
	
	ChaserProfileData_AwarenessIncreaseRateEasy,
	ChaserProfileData_AwarenessIncreaseRateNormal,
	ChaserProfileData_AwarenessIncreaseRateHard,
	ChaserProfileData_AwarenessIncreaseRateInsane,
	ChaserProfileData_AwarenessDecreaseRateEasy,
	ChaserProfileData_AwarenessDecreaseRateNormal,
	ChaserProfileData_AwarenessDecreaseRateHard,
	ChaserProfileData_AwarenessDecreaseRateInsane,
	
	ChaserProfileData_MaxStats
};

enum
{
	ChaserProfileAttackData_Type = 0,
	ChaserProfileAttackData_CanUseAgainstProps,
	ChaserProfileAttackData_Damage,
	ChaserProfileAttackData_DamageVsProps,
	ChaserProfileAttackData_DamageForce,
	ChaserProfileAttackData_DamageType,
	ChaserProfileAttackData_DamageDelay,
	ChaserProfileAttackData_Range,
	ChaserProfileAttackData_Duration,
	ChaserProfileAttackData_Spread,
	ChaserProfileAttackData_BeginRange,
	ChaserProfileAttackData_BeginFOV,
	ChaserProfileAttackData_Cooldown,
	ChaserProfileAttackData_MaxStats
};

enum 
{
	ChaserAnimationType_Idle = 0,
	ChaserAnimationType_IdlePlaybackRate,
	ChaserAnimationType_Walk = 0,
	ChaserAnimationType_WalkPlaybackRate,
	ChaserAnimationType_Run = 0,
	ChaserAnimationType_RunPlaybackRate,
	ChaserAnimationType_Attack = 0,
	ChaserAnimationType_AttackPlaybackRate,
	ChaserAnimationType_Stunned = 0,
	ChaserAnimationType_StunnedPlaybackRate,
	ChaserAnimationType_Death = 0,
	ChaserAnimationType_DeathPlaybackRate
};

enum
{
	ChaserAnimation_IdleAnimations = 0, //Array that contains all the idle animations
	ChaserAnimation_WalkAnimations, //Array that contains all the walk animations
	ChaserAnimation_AttackAnimations, //Array that contains all the attack animations (working on attack index)
	ChaserAnimation_RunAnimations, //Array that contains all the run animations
	ChaserAnimation_StunAnimations, //Array that contains all the stun animations
	ChaserAnimation_DeathAnimations, //Array that contains all the death animations
	ChaserAnimation_JumpAnimations, //Array that contains all the jump animations
	ChaserAnimation_MaxAnimations
};

void InitializeChaserProfiles()
{
	g_hChaserProfileNames = CreateTrie();
	g_hChaserProfileData = CreateArray(ChaserProfileData_MaxStats);
}

/**
 *	Clears all data and memory currently in use by chaser profiles.
 */
void ClearChaserProfiles()
{
	for (int i = 0, iSize = GetArraySize(g_hChaserProfileData); i < iSize; i++)
	{
		Handle hHandle = view_as<Handle>(GetArrayCell(g_hChaserProfileData, i, ChaserProfileData_Attacks));
		if (hHandle != INVALID_HANDLE)
		{
			delete hHandle;
		}
	}
	
	ClearTrie(g_hChaserProfileNames);
	ClearArray(g_hChaserProfileData);
}

/**
 *	Parses and stores the unique values of a chaser profile from the current position in the profiles config.
 *	Returns true if loading was successful, false if not.
 */
bool LoadChaserBossProfile(Handle kv, const char[] sProfile,int &iUniqueProfileIndex, char[] sLoadFailReasonBuffer,int iLoadFailReasonBufferLen)
{
	strcopy(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "");
	
	iUniqueProfileIndex = PushArrayCell(g_hChaserProfileData, -1);
	SetTrieValue(g_hChaserProfileNames, sProfile, iUniqueProfileIndex);
	
	float flBossStepSize = KvGetFloat(kv, "stepsize", 18.0);
	
	float flBossDefaultWalkSpeed = KvGetFloat(kv, "walkspeed", 30.0);
	float flBossWalkSpeedEasy = KvGetFloat(kv, "walkspeed_easy", flBossDefaultWalkSpeed);
	float flBossWalkSpeedHard = KvGetFloat(kv, "walkspeed_hard", flBossDefaultWalkSpeed);
	float flBossWalkSpeedInsane = KvGetFloat(kv, "walkspeed_insane", flBossDefaultWalkSpeed);
	
	float flBossDefaultAirSpeed = KvGetFloat(kv, "airspeed", 50.0);
	float flBossAirSpeedEasy = KvGetFloat(kv, "airspeed_easy", flBossDefaultAirSpeed);
	float flBossAirSpeedHard = KvGetFloat(kv, "airspeed_hard", flBossDefaultAirSpeed);
	float flBossAirSpeedInsane = KvGetFloat(kv, "airspeed_insane", flBossDefaultAirSpeed);
	
	float flBossDefaultMaxWalkSpeed = KvGetFloat(kv, "walkspeed_max", 30.0);
	float flBossMaxWalkSpeedEasy = KvGetFloat(kv, "walkspeed_max_easy", flBossDefaultMaxWalkSpeed);
	float flBossMaxWalkSpeedHard = KvGetFloat(kv, "walkspeed_max_hard", flBossDefaultMaxWalkSpeed);
	float flBossMaxWalkSpeedInsane = KvGetFloat(kv, "walkspeed_max_insane", flBossDefaultMaxWalkSpeed);
	
	float flBossDefaultMaxAirSpeed = KvGetFloat(kv, "airspeed_max", 50.0);
	float flBossMaxAirSpeedEasy = KvGetFloat(kv, "airspeed_max_easy", flBossDefaultMaxAirSpeed);
	float flBossMaxAirSpeedHard = KvGetFloat(kv, "airspeed_max_hard", flBossDefaultMaxAirSpeed);
	float flBossMaxAirSpeedInsane = KvGetFloat(kv, "airspeed_max_insane", flBossDefaultMaxAirSpeed);
	
	float flWakeRange = KvGetFloat(kv, "wake_radius");
	if (flWakeRange < 0.0) flWakeRange = 0.0;
	
	bool bCanBeStunned = view_as<bool>(KvGetNum(kv, "stun_enabled"));
	
	float flStunDuration = KvGetFloat(kv, "stun_duration");
	if (flStunDuration < 0.0) flStunDuration = 0.0;
	
	float flStunCooldown = KvGetFloat(kv, "stun_cooldown", 5.0);
	if (flStunCooldown < 0.0) flStunCooldown = 0.0;
	
	float flStunHealth = KvGetFloat(kv, "stun_health");
	if (flStunHealth < 0.0) flStunHealth = 0.0;
	float flStunHealthPerPlayer = KvGetFloat(kv, "stun_health_per_player");
	if (flStunHealthPerPlayer < 0.0) flStunHealthPerPlayer = 0.0;
	
	bool bStunTakeDamageFromFlashlight = view_as<bool>(KvGetNum(kv, "stun_damage_flashlight_enabled"));
	
	float flStunFlashlightDamage = KvGetFloat(kv, "stun_damage_flashlight");
	
	bool bKeyDrop = view_as<bool>(KvGetNum(kv, "keydrop_enabled"));
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossStepSize, ChaserProfileData_StepSize);
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossDefaultWalkSpeed, ChaserProfileData_WalkSpeedNormal);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossWalkSpeedEasy, ChaserProfileData_WalkSpeedEasy);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossWalkSpeedHard, ChaserProfileData_WalkSpeedHard);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossWalkSpeedInsane, ChaserProfileData_WalkSpeedInsane);
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossDefaultAirSpeed, ChaserProfileData_AirSpeedNormal);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossAirSpeedEasy, ChaserProfileData_AirSpeedEasy);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossAirSpeedHard, ChaserProfileData_AirSpeedHard);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossAirSpeedInsane, ChaserProfileData_AirSpeedInsane);
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossDefaultMaxWalkSpeed, ChaserProfileData_MaxWalkSpeedNormal);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossMaxWalkSpeedEasy, ChaserProfileData_MaxWalkSpeedEasy);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossMaxWalkSpeedHard, ChaserProfileData_MaxWalkSpeedHard);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossMaxWalkSpeedInsane, ChaserProfileData_MaxWalkSpeedInsane);
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossDefaultMaxAirSpeed, ChaserProfileData_MaxAirSpeedNormal);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossMaxAirSpeedEasy, ChaserProfileData_MaxAirSpeedEasy);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossMaxAirSpeedHard, ChaserProfileData_MaxAirSpeedHard);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flBossMaxAirSpeedInsane, ChaserProfileData_MaxAirSpeedInsane);
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flWakeRange, ChaserProfileData_WakeRadius);
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, bCanBeStunned, ChaserProfileData_CanBeStunned);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flStunDuration, ChaserProfileData_StunDuration);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flStunCooldown, ChaserProfileData_StunCooldown);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flStunHealth, ChaserProfileData_StunHealth);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flStunHealthPerPlayer, ChaserProfileData_StunHealthPerPlayer);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, bStunTakeDamageFromFlashlight, ChaserProfileData_CanBeStunnedByFlashlight);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flStunFlashlightDamage, ChaserProfileData_StunFlashlightDamage);
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, bKeyDrop, ChaserProfileData_KeyDrop);
	
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, KvGetFloat(kv, "memory_lifetime", 10.0), ChaserProfileData_MemoryLifeTime);
	
	float flDefaultAwarenessIncreaseRate = KvGetFloat(kv, "awareness_rate_increase", 75.0);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, KvGetFloat(kv, "awareness_rate_increase_easy", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateEasy);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flDefaultAwarenessIncreaseRate, ChaserProfileData_AwarenessIncreaseRateNormal);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, KvGetFloat(kv, "awareness_rate_increase_hard", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateHard);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, KvGetFloat(kv, "awareness_rate_increase_insane", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateInsane);
	
	float flDefaultAwarenessDecreaseRate = KvGetFloat(kv, "awareness_rate_decrease", 150.0);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, KvGetFloat(kv, "awareness_rate_decrease_easy", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateEasy);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, flDefaultAwarenessDecreaseRate, ChaserProfileData_AwarenessDecreaseRateNormal);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, KvGetFloat(kv, "awareness_rate_decrease_hard", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateHard);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, KvGetFloat(kv, "awareness_rate_decrease_insane", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateInsane);
	
	ParseChaserProfileAttacks(kv, iUniqueProfileIndex);
	
	return true;
}

static int ParseChaserProfileAttacks(Handle kv,int iUniqueProfileIndex)
{
	
	// Create the array.
	Handle hAttacks = CreateArray(ChaserProfileAttackData_MaxStats);
	SetArrayCell(g_hChaserProfileData, iUniqueProfileIndex, hAttacks, ChaserProfileData_Attacks);
	
	int iMaxAttacks = -1;
	if (KvJumpToKey(kv, "attacks"))
	{
		iMaxAttacks = 0;
		char sNum[3];
		for (int i = 1; i <= SF2_CHASER_BOSS_MAX_ATTACKS; i++)
		{
			IntToString(i, sNum, sizeof(sNum));
			if (KvJumpToKey(kv, sNum))
			{
				iMaxAttacks++;
				KvGoBack(kv);
			}
		}
		if (iMaxAttacks == 0)
		{
			LogSF2Message("[SF2 PROFILES PARSER] Critical error, found \"attacks\" section with no attacks inside of it!");
		}
	}
	for (int iAttackNum = -1; iAttackNum <=iMaxAttacks; iAttackNum++)
	{
		if (iAttackNum < 1) iAttackNum = 1;
		if (iMaxAttacks > 0) //Backward compatibility
		{
			char sNum[3];
			IntToString(iAttackNum, sNum, sizeof(sNum));
			KvJumpToKey(kv, sNum);
		}
		int iAttackType = KvGetNum(kv, "attack_type", SF2BossAttackType_Melee);
		//int iAttackType = SF2BossAttackType_Melee;
		
		float flAttackRange = KvGetFloat(kv, "attack_range");
		if (flAttackRange < 0.0) flAttackRange = 0.0;
		
		float flAttackDamage = KvGetFloat(kv, "attack_damage");
		float flAttackDamageVsProps = KvGetFloat(kv, "attack_damage_vs_props", flAttackDamage);
		float flAttackDamageForce = KvGetFloat(kv, "attack_damageforce");
		
		int iAttackDamageType = KvGetNum(kv, "attack_damagetype");
		if (iAttackDamageType < 0) iAttackDamageType = 0;
		
		float flAttackDamageDelay = KvGetFloat(kv, "attack_delay");
		if (flAttackDamageDelay < 0.0) flAttackDamageDelay = 0.0;
		
		float flAttackDuration = KvGetFloat(kv, "attack_duration", 0.0);
		if (flAttackDuration <= 0.0)//Backward compatibility
		{
			if (flAttackDuration < 0.0) flAttackDuration = 0.0;
			flAttackDuration = flAttackDamageDelay+KvGetFloat(kv, "attack_endafter", 0.0);
		}
		
		bool bAttackProps = view_as<bool>(KvGetNum(kv, "attack_props", 0));
		
		float flAttackSpreadOld = KvGetFloat(kv, "attack_fov", 45.0);
		float flAttackSpread = KvGetFloat(kv, "attack_spread", flAttackSpreadOld);
		
		if (flAttackSpread < 0.0) flAttackSpread = 0.0;
		else if (flAttackSpread > 360.0) flAttackSpread = 360.0;
		
		float flAttackBeginRange = KvGetFloat(kv, "attack_begin_range", flAttackRange);
		if (flAttackBeginRange < 0.0) flAttackBeginRange = 0.0;
		
		float flAttackBeginFOV = KvGetFloat(kv, "attack_begin_fov", flAttackSpread);
		if (flAttackBeginFOV < 0.0) flAttackBeginFOV = 0.0;
		else if (flAttackBeginFOV > 360.0) flAttackBeginFOV = 360.0;
		
		float flAttackCooldown = KvGetFloat(kv, "attack_cooldown");
		if (flAttackCooldown < 0.0) flAttackCooldown = 0.0;
		
		int iAttackIndex = PushArrayCell(hAttacks, -1);
		
		SetArrayCell(hAttacks, iAttackIndex, iAttackType, ChaserProfileAttackData_Type);
		SetArrayCell(hAttacks, iAttackIndex, bAttackProps, ChaserProfileAttackData_CanUseAgainstProps);
		SetArrayCell(hAttacks, iAttackIndex, flAttackRange, ChaserProfileAttackData_Range);
		SetArrayCell(hAttacks, iAttackIndex, flAttackDamage, ChaserProfileAttackData_Damage);
		SetArrayCell(hAttacks, iAttackIndex, flAttackDamageVsProps, ChaserProfileAttackData_DamageVsProps);
		SetArrayCell(hAttacks, iAttackIndex, flAttackDamageForce, ChaserProfileAttackData_DamageForce);
		SetArrayCell(hAttacks, iAttackIndex, iAttackDamageType, ChaserProfileAttackData_DamageType);
		SetArrayCell(hAttacks, iAttackIndex, flAttackDamageDelay, ChaserProfileAttackData_DamageDelay);
		SetArrayCell(hAttacks, iAttackIndex, flAttackDuration, ChaserProfileAttackData_Duration);
		SetArrayCell(hAttacks, iAttackIndex, flAttackSpread, ChaserProfileAttackData_Spread);
		SetArrayCell(hAttacks, iAttackIndex, flAttackBeginRange, ChaserProfileAttackData_BeginRange);
		SetArrayCell(hAttacks, iAttackIndex, flAttackBeginFOV, ChaserProfileAttackData_BeginFOV);
		SetArrayCell(hAttacks, iAttackIndex, flAttackCooldown, ChaserProfileAttackData_Cooldown);
		
		if (iMaxAttacks > 0)//Backward compatibility
		{
			KvGoBack(kv);
		}
		else
			break;
	}
	if (iMaxAttacks > 0)
		KvGoBack(kv);
	return iMaxAttacks;
}

float GetChaserProfileStepSize(int iChaserProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_StepSize));
}

float GetChaserProfileWalkSpeed(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_WalkSpeedEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_WalkSpeedHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_WalkSpeedInsane));
	}
	
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_WalkSpeedNormal));
}

float GetChaserProfileAirSpeed(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AirSpeedEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AirSpeedHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AirSpeedInsane));
	}
	
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AirSpeedNormal));
}

float GetChaserProfileMaxWalkSpeed(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedInsane));
	}
	
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedNormal));
}

float GetChaserProfileMaxAirSpeed(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_MaxAirSpeedEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_MaxAirSpeedHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_MaxAirSpeedInsane));
	}
	
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_MaxAirSpeedNormal));
}

Handle GetChaserProfileAnimationsData(int iChaserProfileIndex)
{
	return view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Animations));
}

float GetChaserProfileWakeRadius(int iChaserProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_WakeRadius));
}

int GetChaserProfileAttackCount(int iChaserProfileIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));
	
	return GetArraySize(hAttacks);
}

int GetChaserProfileAttackType(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));
	
	return GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_Type);
}

float GetChaserProfileAttackDamage(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));
	
	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_Damage));
}

float GetChaserProfileAttackDamageVsProps(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_DamageVsProps));
}

float GetChaserProfileAttackDamageForce(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_DamageForce));
}

int GetChaserProfileAttackDamageType(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_DamageType);
}

float GetChaserProfileAttackDamageDelay(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_DamageDelay));
}

float GetChaserProfileAttackRange(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_Range));
}

float GetChaserProfileAttackDuration(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_Duration));
}

float GetChaserProfileAttackSpread(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_Spread));
}

float GetChaserProfileAttackBeginRange(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_BeginRange));
}

float GetChaserProfileAttackBeginFOV(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));

	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_BeginFOV));
}

float GetChaserProfileAttackCooldown(int iChaserProfileIndex,int  iAttackIndex)
{
	Handle hAttacks = view_as<Handle>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_Attacks));
	
	return view_as<float>(GetArrayCell(hAttacks, iAttackIndex, ChaserProfileAttackData_Cooldown));
}

bool GetChaserProfileStunState(int iChaserProfileIndex)
{
	return view_as<bool>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_CanBeStunned));
}

float GetChaserProfileStunDuration(int iChaserProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_StunDuration));
}

float GetChaserProfileStunCooldown(int iChaserProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_StunCooldown));
}

bool GetChaserProfileStunFlashlightState(int iChaserProfileIndex)
{
	return view_as<bool>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_CanBeStunnedByFlashlight));
}

float GetChaserProfileStunFlashlightDamage(int iChaserProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_StunFlashlightDamage));
}

float GetChaserProfileStunHealth(int iChaserProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_StunHealth));
}

float GetChaserProfileStunHealthPerPlayer(int iChaserProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_StunHealthPerPlayer));
}

bool GetChaserProfileKeyDrop(int iChaserProfileIndex)
{
	return view_as<bool>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_KeyDrop));
}

stock float GetChaserProfileAwarenessIncreaseRate(int iChaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateInsane));
	}
	
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateNormal));
}

stock float GetChaserProfileAwarenessDecreaseRate(int iChaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateInsane));
	}
	
	return view_as<float>(GetArrayCell(g_hChaserProfileData, iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateNormal));
}

stock bool GetProfileAnimation(const char[] sProfile, int iAnimationSection, char[] sAnimation, int iLenght, float &flPlaybackRate, int iAnimationIndex = -1)
{
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	char sAnimationSection[20], sKeyAnimationName[50], sKeyAnimationPlayBackRate[65];
	if (iAnimationSection == ChaserAnimation_IdleAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "idle");
		strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_idle");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_idle_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_WalkAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "walk");
		strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walk");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walk_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_AttackAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "attack");
		strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_attack");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_attack_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_RunAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "run");
		strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_run");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_run_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_StunAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "stun");
		strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_stun");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_stun_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_DeathAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "death");
		strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_death");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_death_playbackrate");
	}
	else if (iAnimationIndex == ChaserAnimation_JumpAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "jump");
		strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_jump");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_jump_playbackrate");
	}
	
	if (KvJumpToKey(g_hConfig, "animations"))
	{
		if (KvJumpToKey(g_hConfig, sAnimationSection))
		{
			char sNum[3];
			if (iAnimationIndex == -1)
			{
				int iTotalAnimation;
				for (iAnimationIndex = 1; iAnimationIndex <= SF2_CHASER_BOSS_MAX_ATTACKS; iAnimationIndex++)
				{
					IntToString(iAnimationIndex, sNum, sizeof(sNum));
					if (KvJumpToKey(g_hConfig, sNum))
					{
						iTotalAnimation++;
						KvGoBack(g_hConfig);
					}
				}
				iAnimationIndex = GetRandomInt(1, iTotalAnimation);
			}
			IntToString(iAnimationIndex, sNum, sizeof(sNum));
			if (!KvJumpToKey(g_hConfig, sNum))
			{
				return false;
			}
		}
		else
			return false;
	}
	KvGetString(g_hConfig, sKeyAnimationName, sAnimation, iLenght);
	flPlaybackRate = KvGetFloat(g_hConfig, sKeyAnimationPlayBackRate, 1.0);
	return true;
}

stock bool GetProfileBlendAnimationSpeed(const char[] sProfile, int iAnimationSection, float &flPlaybackRate, int iAnimationIndex = -1)
{
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	char sAnimationSection[20], sKeyAnimationPlayBackRate[65];
	if (iAnimationSection == ChaserAnimation_IdleAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "idle");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_idle_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_WalkAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "walk");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_walk_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_AttackAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "attack");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_attack_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_RunAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "run");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_run_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_StunAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "stun");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_stun_playbackrate");
	}
	else if (iAnimationSection == ChaserAnimation_DeathAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "death");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_death_playbackrate");
	}
	else if (iAnimationIndex == ChaserAnimation_JumpAnimations)
	{
		strcopy(sAnimationSection, sizeof(sAnimationSection), "jump");
		strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_jump_playbackrate");
	}
	
	if (KvJumpToKey(g_hConfig, "animations"))
	{
		if (KvJumpToKey(g_hConfig, sAnimationSection))
		{
			char sNum[3];
			if (iAnimationIndex == -1)
			{
				int iTotalAnimation;
				for (iAnimationIndex = 1; iAnimationIndex <= SF2_CHASER_BOSS_MAX_ATTACKS; iAnimationIndex++)
				{
					IntToString(iAnimationIndex, sNum, sizeof(sNum));
					if (KvJumpToKey(g_hConfig, sNum))
					{
						iTotalAnimation++;
						KvGoBack(g_hConfig);
					}
				}
				iAnimationIndex = GetRandomInt(1, iTotalAnimation);
			}
			IntToString(iAnimationIndex, sNum, sizeof(sNum));
			if (!KvJumpToKey(g_hConfig, sNum))
			{
				return false;
			}
		}
		else
			return false;
	}
	flPlaybackRate = KvGetFloat(g_hConfig, sKeyAnimationPlayBackRate, 1.0);
	return true;
}

stock int GetProfileAttackNum(const char[] sProfile, const char[] keyValue,int defaultValue=0, const int iAttackIndex)
{
	if (!IsProfileValid(sProfile)) return defaultValue;
	
	char sKey[4];
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	KvJumpToKey(g_hConfig, "attacks");
	IntToString(iAttackIndex, sKey, sizeof(sKey));
	KvJumpToKey(g_hConfig, sKey);
	return KvGetNum(g_hConfig, keyValue, defaultValue);
}

stock bool GetProfileAttackString(const char[] sProfile, const char[] keyValue, char[] sBuffer, int iLenght, const char[] sDefaultValue = "", const int iAttackIndex)
{
	if (!IsProfileValid(sProfile)) return false;
	
	char sKey[4];
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	KvJumpToKey(g_hConfig, "attacks");
	IntToString(iAttackIndex, sKey, sizeof(sKey));
	KvJumpToKey(g_hConfig, sKey);
	KvGetString(g_hConfig, keyValue, sBuffer, iLenght, sDefaultValue);
	return true;
}

stock bool GetProfileAttackVector(const char[] sProfile, const char[] keyValue, float buffer[3], const float defaultValue[3]=NULL_VECTOR, const int iAttackIndex)
{
	for (int i = 0; i < 3; i++) buffer[i] = defaultValue[i];
	
	if (!IsProfileValid(sProfile)) return false;
	
	char sKey[4];
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	KvJumpToKey(g_hConfig, "attacks");
	IntToString(iAttackIndex, sKey, sizeof(sKey));
	KvJumpToKey(g_hConfig, sKey);
	KvGetVector(g_hConfig, keyValue, buffer, defaultValue);
	return true;
}