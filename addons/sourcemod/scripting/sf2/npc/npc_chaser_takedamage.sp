#if defined _sf2_npc_chaser_takedamage_included
 #endinput
#endif

#define _sf2_npc_chaser_takedamage_included

//death_enable
//death_health
//death_duration
//death_cooldown
//death_disappear
//death_remove
//death_health_per_
//"add death health on death"
/*
	"death"
    {
        "1"
        {
            "animation_death"            "diebackward"
            "animation_death_playbackrate"        "1.0"
        }
    }
*/

public void Hook_SlenderOnTakeDamage(int victim, int attacker, int inflictor, float damage, int damagetype)
{
	if (!IsValidEntity(victim))
	{
		//Theres no boss, what?
		SDKUnhook(victim, SDKHook_OnTakeDamageAlive, Hook_HitboxOnTakeDamage);
		return;
	}

	float flMyPos[3], flMyEyeAng[3], flClientPos[3], flBuffer[3], flTraceStartPos[3], flTraceEndPos[3];
	GetEntPropVector(victim, Prop_Data, "m_vecAbsOrigin", flMyPos);

	int iBossIndex = NPCGetFromEntIndex(g_iSlenderHitboxOwner[victim]);
	if (iBossIndex == -1)
	{
		//Theres still no boss, how did this happen?
		SDKUnhook(victim, SDKHook_OnTakeDamageAlive, Hook_HitboxOnTakeDamage);
		return;
	}
	int slender = g_iSlenderHitboxOwner[victim];
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	NPCGetEyePosition(iBossIndex, flTraceStartPos);

	bool bMiniCrit = false;
	if (IsValidClient(attacker))
	{
		GetClientAbsOrigin(attacker, flClientPos);
		GetClientEyePosition(attacker, flTraceEndPos);
	}
	float flShootDist = GetVectorSquareMagnitude(flClientPos, flMyPos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flMyEyeAng);

	AddVectors(flMyEyeAng, g_flSlenderEyeAngOffset[iBossIndex], flMyEyeAng);

	if (IsValidClient(attacker) && SF_IsBoxingMap() && (TF2_IsPlayerInCondition(attacker, TFCond_RegenBuffed)) && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
	{
		int iHealth = GetClientHealth(attacker);
		float flDamage = damage;
		flDamage *= 0.475;
		int iNewHealth = iHealth + RoundToCeil(flDamage);
		if(iNewHealth<=GetEntProp(attacker, Prop_Data, "m_iMaxHealth"))
		{
			SetEntityHealth(attacker, iNewHealth);
		}
		else
		{
			int iMaxHealth = GetEntProp(attacker, Prop_Data, "m_iMaxHealth");
			SetEntityHealth(attacker, iMaxHealth);
		}
	}

	if(IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Scout)
	{
		int iStick = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if(IsValidEntity(iStick) && GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 349 && iStick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_bSlenderIsBurning[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			damagetype = DMG_CRIT;
			damage *= 3.0;
		}
		if(IsValidEntity(iStick) && (GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 325 || GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 452) && iStick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_hSlenderBleedTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_flSlenderStopBleeding[iBossIndex] = GetGameTime() + 5.0;
		}
		if(IsValidEntity(iStick) && GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 355 && iStick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_hSlenderMarkedTimer[iBossIndex] = CreateTimer(15.0, Timer_BossMarked, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
			g_bSlenderIsMarked[iBossIndex] = true;
		}
		if(IsValidEntity(iStick) && GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 648 && iStick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && flShootDist > SquareFloat(72.0) && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_hSlenderBleedTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_flSlenderStopBleeding[iBossIndex] = GetGameTime() + 5.0;
		}
	}
	if(IsValidClient(attacker) && TF2_GetPlayerClass(attacker) == TFClass_Pyro)
	{
		//Probably the only time where buffing the phlog is a good thing.
		int iPhlog = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Primary);
		int iFragment = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if(IsValidEntity(iPhlog) && GetEntProp(iPhlog, Prop_Send, "m_iItemDefinitionIndex") == TF_WEAPON_PHLOGISTINATOR && GetEntPropFloat(attacker, Prop_Send, "m_flNextRageEarnTime") <= GetGameTime() && !view_as<bool>(GetEntProp(attacker, Prop_Send, "m_bRageDraining")))
		{
			float fRage = GetEntPropFloat(attacker, Prop_Send, "m_flRageMeter");
			fRage += (damage / 30.00);
			if (fRage > 100.0) fRage = 100.0;
			SetEntPropFloat(attacker, Prop_Send, "m_flRageMeter", fRage);
		}
		if(IsValidEntity(iFragment) && SF_IsBoxingMap() && GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 348 && iFragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_hSlenderBurnTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBurn, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_flSlenderStopBurning[iBossIndex] = GetGameTime() + 15.0;
			g_bSlenderIsBurning[iBossIndex] = true;
		}
		if(IsValidEntity(iFragment) && SF_IsBoxingMap() && (GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 38 || GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 457 || GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 1000) && iFragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_bSlenderIsBurning[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_hSlenderBurnTimer[iBossIndex] = null;
			g_flSlenderStopBurning[iBossIndex] = GetGameTime();
			g_bSlenderIsBurning[iBossIndex] = false;
			bMiniCrit = true;
			damage *= 1.35;
		}
		if(IsValidEntity(iFragment) && GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 1181 && iFragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
		{
			TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
		}
		if(IsValidEntity(iFragment) && SF_IsBoxingMap() && (GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 813 || GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 834) && iFragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && (g_bSlenderIsMarked[iBossIndex]))
		{
			damagetype = DMG_CRIT;
			damage *= 3.0;
		}
	}
	if(IsValidClient(attacker) && TF2_GetPlayerClass(attacker) == TFClass_Soldier)
	{
		int iWhip = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if(IsValidEntity(iWhip) && GetEntProp(iWhip, Prop_Send, "m_iItemDefinitionIndex") == 447 && iWhip == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
		{
			TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
		}
	}
	if(IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Heavy)
	{
		int iGloves = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if(IsValidEntity(iGloves) && GetEntProp(iGloves, Prop_Send, "m_iItemDefinitionIndex") == 426 && iGloves == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
		{
			TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
		}
		if(IsValidEntity(iGloves) && GetEntProp(iGloves, Prop_Send, "m_iItemDefinitionIndex") == 43 && iGloves == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && !IsClientCritBoosted(attacker) && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_iPlayerHitsToCrits[attacker]++;
			if (g_iPlayerHitsToCrits[attacker] == 5)
			{
				TF2_AddCondition(attacker, TFCond_CritOnFlagCapture, 5.0);
				g_iPlayerHitsToCrits[attacker] = 0;
			}
		}
	}
	if(IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Engineer)
	{
		int iWrench = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if(IsValidEntity(iWrench) && GetEntProp(iWrench, Prop_Send, "m_iItemDefinitionIndex") == 155 && iWrench == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_hSlenderBleedTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_flSlenderStopBleeding[iBossIndex] = GetGameTime() + 5.0;
		}
	}
	if(IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Sniper)
	{
		int iSharpy = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if(IsValidEntity(iSharpy) && GetEntProp(iSharpy, Prop_Send, "m_iItemDefinitionIndex") == 171 && iSharpy == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_hSlenderBleedTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_flSlenderStopBleeding[iBossIndex] = GetGameTime() + 6.0;
		}
		if(IsValidEntity(iSharpy) && GetEntProp(iSharpy, Prop_Send, "m_iItemDefinitionIndex") == 232 && iSharpy == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_bSlenderIsMarked[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			damagetype = DMG_CRIT;
			damage *= 3.0;
			bMiniCrit = false;
		}
	}
	if(IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_DemoMan)
	{
		int iSword = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if(IsValidEntity(iSword) && (GetEntProp(iSword, Prop_Send, "m_iItemDefinitionIndex") == 132 || GetEntProp(iSword, Prop_Send, "m_iItemDefinitionIndex") == 266 || GetEntProp(iSword, Prop_Send, "m_iItemDefinitionIndex") == 482 || GetEntProp(iSword, Prop_Send, "m_iItemDefinitionIndex") == 1082) && iSword == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			g_iPlayerHitsToHeads[attacker]++;
			if (g_iPlayerHitsToHeads[attacker] == 5)
			{
				if(!TF2_IsPlayerInCondition(attacker, TFCond_DemoBuff))
				{
					TF2_AddCondition(attacker, TFCond_DemoBuff, -1.0);
				}
				int iDecapitations = GetEntProp(attacker, Prop_Send, "m_iDecapitations");
				int iHealth = GetClientHealth(attacker);
				SetEntProp(attacker, Prop_Send, "m_iDecapitations", iDecapitations+1);
				SetEntityHealth(attacker, iHealth+15);
				TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 0.01);
				g_iPlayerHitsToHeads[attacker] = 0;
			}
		}
	}
	if(IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Spy)
	{
		int iStabbingTime = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		char sWeaponClass[64];
		GetEdictClassname(iStabbingTime, sWeaponClass, sizeof(sWeaponClass));
		if (IsValidEntity(iStabbingTime) && iStabbingTime == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && (strcmp(sWeaponClass, "tf_weapon_knife", false) == 0 || (TF2_GetPlayerClass(attacker) == TFClass_Spy && strcmp(sWeaponClass, "saxxy", false) == 0)) && SF_IsBoxingMap())
		{
			SubtractVectors(flTraceEndPos, flTraceStartPos, flBuffer);
			GetVectorAngles(flBuffer, flBuffer);

			if (FloatAbs(AngleDiff(flMyEyeAng[1], flBuffer[1])) >= (NPCGetBackstabFOV(iBossIndex) * 0.5) && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && GetProfileFloat(sProfile, "backstab_damage_scale", 0.05) > 0.0)
			{
				damagetype = DMG_CRIT;
				EmitSoundToClient(attacker, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);
				SetEntPropFloat(iStabbingTime, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + 2.0);
				SetEntPropFloat(attacker, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
				SetEntPropFloat(attacker, Prop_Send, "m_flStealthNextChangeTime", GetGameTime() + 2.0);
				int vm = GetEntPropEnt(attacker, Prop_Send, "m_hViewModel");
				if (vm > MaxClients)
				{
					int iMeleeIndex = GetEntProp(iStabbingTime, Prop_Send, "m_iItemDefinitionIndex");
					int anim = 41;
					switch (iMeleeIndex)
					{
						case 4, 194, 225, 356, 461, 574, 649, 665, 794, 803, 883, 892, 901, 910, 959, 968: anim = 15;
						case 638: anim = 31;
					}
					SetEntProp(vm, Prop_Send, "m_nSequence", anim);
					damage = NPCChaserGetStunInitialHealth(iBossIndex) * GetProfileFloat(sProfile, "backstab_damage_scale", 0.05);
					NPCSetAddSpeed(iBossIndex, 12.5);
					NPCSetAddMaxSpeed(iBossIndex, 25.0);
					NPCSetAddAcceleration(iBossIndex, 100.0);

					if (iMeleeIndex == 356) //Kunai
					{
						int iHealth = GetClientHealth(attacker) + 100;
						if(iHealth > 210)
						{
							iHealth = 210;
						}
						SetEntityHealth(attacker, iHealth);
					}
					switch (iMeleeIndex)
					{
						case 356: //Kunai
						{
							int iHealth = GetClientHealth(attacker) + 100;
							if(iHealth > 210)
							{
								iHealth = 210;
							}
							SetEntityHealth(attacker, iHealth);
						}
						case 461: //Big Earner
						{
							TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
						}
					}
				}
			}
		}
	}

	if(IsValidClient(attacker) && TF2_IsMiniCritBuffed(attacker))//Mini crit boosted
		bMiniCrit = true;

	if ((g_bSlenderIsMarked[iBossIndex]) && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
	{
		bMiniCrit = true;
		damage *= 1.35;
	}
	if (IsValidClient(attacker) && ((SF_IsBoxingMap() && GetClientTeam(attacker) == TFTeam_Blue) || (g_bPlayerProxy[attacker])))
	{
		damage = 0.0;
	}
	if (!IsValidClient(attacker)) damage = 0.0;
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);

	if (SF_IsBoxingMap() && IsValidClient(attacker) && !bAttackEliminated && (GetClientTeam(attacker) == TFTeam_Blue))
	{
		damage = 0.0;
	}

	if (NPCGetType(iBossIndex) == SF2BossType_Chaser && damage > 0.0)
	{
		int iState = g_iSlenderState[iBossIndex];
			
		if (NPCChaserIsStunEnabled(iBossIndex) && !g_bSlenderSpawning[iBossIndex])
		{
			if (g_flSlenderNextStunTime[iBossIndex] <= GetGameTime() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bSlenderInDeathcam[iBossIndex] && !g_bRestartSessionEnabled)
			{
				NPCChaserAddStunHealth(iBossIndex, -damage);
				if (NPCChaserGetStunHealth(iBossIndex) <= 0.0 && iState != STATE_STUN)
				{
					NPCBossTriggerStun(iBossIndex, slender, sProfile, flMyPos);
					Call_StartForward(fOnBossStunned);
					Call_PushCell(iBossIndex);
					Call_PushCell(attacker);
					Call_Finish();
					if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA))
					{
						int iMaxHealth = SDKCall(g_hSDKGetMaxHealth, attacker);
						float flHealthToRecover = float(iMaxHealth)/7.5;
						int iHealthToRecover = RoundToNearest(flHealthToRecover) + GetEntProp(attacker, Prop_Send, "m_iHealth");
						SetEntityHealth(attacker, iHealthToRecover);
					}
				}
			}
				
			//(Experimental)
			if (g_flSlenderNextStunTime[iBossIndex] <= GetGameTime() && NPCGetHealthbarState(iBossIndex) && iState != STATE_STUN && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bSlenderInDeathcam[iBossIndex] && !g_bRestartSessionEnabled)
			{
				UpdateHealthBar(iBossIndex);
			}
		}
		if ((damagetype & DMG_CRIT) && !bMiniCrit)
		{
			float flMyEyePos[3];
			SlenderGetAbsOrigin(iBossIndex, flMyEyePos);
			float flMyEyePosEx[3];
			GetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMaxs", flMyEyePosEx);
			flMyEyePos[2]+=flMyEyePosEx[2];
				
			TE_Particle(g_iParticle[CriticalHit], flMyEyePos, flMyEyePos);
			TE_SendToAll();
				
			EmitSoundToAll(CRIT_SOUND, g_iSlenderHitbox[iBossIndex], SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		else if(bMiniCrit)
		{
			float flMyEyePos[3];
			SlenderGetAbsOrigin(iBossIndex, flMyEyePos);
			float flMyEyePosEx[3];
			GetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMaxs", flMyEyePosEx);
			flMyEyePos[2]+=flMyEyePosEx[2];
				
			TE_Particle(g_iParticle[MiniCritHit], flMyEyePos, flMyEyePos);
			TE_SendToAll();
				
			EmitSoundToAll(MINICRIT_SOUND, g_iSlenderHitbox[iBossIndex], SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
	}

	return;
}

void UpdateHealthBar(int iBossIndex)
{
	float fMaxHealth = NPCChaserGetStunInitialHealth(iBossIndex);
	float fHealth = NPCChaserGetStunHealth(iBossIndex);
	if (g_ihealthBar == -1)
	{
		return;
	}
	int healthPercent;
	SetEntProp(g_ihealthBar, Prop_Send, "m_iBossState", 0);
	healthPercent=RoundToCeil((fHealth/fMaxHealth)*float(255));
	if(healthPercent>255)
	{
		healthPercent=255;
	}
	else if(healthPercent<=0)
	{
		healthPercent=0;
	}
	SetEntProp(g_ihealthBar, Prop_Send, "m_iBossHealthPercentageByte", healthPercent);
}

public void NPCBossTriggerStun(int iBossIndex, int victim, char sProfile[SF2_MAX_PROFILE_NAME_LENGTH], float[3] position)
{
	if (iBossIndex == -1) return;
	if (!victim || victim == INVALID_ENT_REFERENCE) return;
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(victim);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	CBaseCombatCharacter overlay = CBaseCombatCharacter(victim);
	npc.flWalkSpeed = 0.0;
	npc.flRunSpeed = 0.0;
	int iState = g_iSlenderState[iBossIndex];
	bool bDoChasePersistencyInit = false;
	overlay.RemoveAllGestures();
	CBaseNPC_RemoveAllLayers(victim);
	if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
	loco.ClearStuckStatus();
	g_iSlenderState[iBossIndex] = STATE_STUN;
	if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
	if (NPCChaseHasKeyDrop(iBossIndex))
	{
		if (SF_IsBoxingMap())
		{
			g_iSlenderBoxingBossKilled += 1;
			if ((g_iSlenderBoxingBossKilled == g_iSlenderBoxingBossCount) && !g_bSlenderBoxingBossIsKilled[iBossIndex]) NPC_DropKey(iBossIndex);
			g_bSlenderBoxingBossIsKilled[iBossIndex] = true;
		}
		else NPC_DropKey(iBossIndex);
	}

	if (NPCChaserCanDropItemOnStun(iBossIndex))
	{
		switch (NPCChaserItemDropTypeStun(iBossIndex))
		{
			case 1:
			{
				int smallammo = CreateEntityByName("item_ammopack_small");
				DispatchKeyValue(smallammo, "OnPlayerTouch", "!self,Kill,,0,-1");
				if (DispatchSpawn(smallammo))
				{
					SetEntProp(smallammo, Prop_Send, "m_iTeamNum", 0);
					TeleportEntity(smallammo, position, NULL_VECTOR, NULL_VECTOR);
				}
			}
			case 2:
			{
				int medammo = CreateEntityByName("item_ammopack_medium");
				DispatchKeyValue(medammo, "OnPlayerTouch", "!self,Kill,,0,-1");
				if (DispatchSpawn(medammo))
				{
					SetEntProp(medammo, Prop_Send, "m_iTeamNum", 0);
					TeleportEntity(medammo, position, NULL_VECTOR, NULL_VECTOR);
				}
			}
			case 3:
			{
				int fullammo = CreateEntityByName("item_ammopack_full");
				DispatchKeyValue(fullammo, "OnPlayerTouch", "!self,Kill,,0,-1");
				if (DispatchSpawn(fullammo))
				{
					SetEntProp(fullammo, Prop_Send, "m_iTeamNum", 0);
					TeleportEntity(fullammo, position, NULL_VECTOR, NULL_VECTOR);
				}
			}
			case 4:
			{
				int smallhp = CreateEntityByName("item_healthkit_small");
				DispatchKeyValue(smallhp, "OnPlayerTouch", "!self,Kill,,0,-1");
				if (DispatchSpawn(smallhp))
				{
					SetEntProp(smallhp, Prop_Send, "m_iTeamNum", 0);
					TeleportEntity(smallhp, position, NULL_VECTOR, NULL_VECTOR);
				}
			}
			case 5:
			{
				int medhp = CreateEntityByName("item_healthkit_medium");
				DispatchKeyValue(medhp, "OnPlayerTouch", "!self,Kill,,0,-1");
				if (DispatchSpawn(medhp))
				{
					SetEntProp(medhp, Prop_Send, "m_iTeamNum", 0);
					TeleportEntity(medhp, position, NULL_VECTOR, NULL_VECTOR);
				}
			}
			case 6:
			{
				int fullhp = CreateEntityByName("item_healthkit_full");
				DispatchKeyValue(fullhp, "OnPlayerTouch", "!self,Kill,,0,-1");
				if (DispatchSpawn(fullhp))
				{
					SetEntProp(fullhp, Prop_Send, "m_iTeamNum", 0);
					TeleportEntity(fullhp, position, NULL_VECTOR, NULL_VECTOR);
				}
			}
			case 7:
			{
				int smallammohp = CreateEntityByName("item_healthammokit");
				DispatchKeyValue(smallammohp, "OnPlayerTouch", "!self,Kill,,0,-1");
				if (DispatchSpawn(smallammohp))
				{
					SetEntProp(smallammohp, Prop_Send, "m_iTeamNum", 0);
					TeleportEntity(smallammohp, position, NULL_VECTOR, NULL_VECTOR);
				}
			}
		}
	}
	if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
	g_bNPCUsesHealAnimation[iBossIndex] = false;
	g_bNPCUseStartFleeAnimation[iBossIndex] = false;
	g_bNPCHealing[iBossIndex] = false;
	g_bNPCRunningToHeal[iBossIndex] = false;
	g_hSlenderHealDelayTimer[iBossIndex] = null;
	g_hSlenderHealTimer[iBossIndex] = null;
	g_hSlenderStartFleeTimer[iBossIndex] = null;
	g_iNPCSelfHealStage[iBossIndex] = 12;
	if (SF_IsBoxingMap() && NPCChaserIsBoxingBoss(iBossIndex))
	{
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
			{
				char sPlayer[32];
				FormatEx(sPlayer, sizeof(sPlayer), "%N", client);
				char sBossName[SF2_MAX_NAME_LENGTH];
				NPCGetBossName(iBossIndex, sBossName, sizeof(sBossName));
				if (sBossName[0] == '\0') strcopy(sBossName, sizeof(sBossName), sProfile);
				CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Boxing Win Message", sPlayer, sBossName);
			}
		}
	}
	if (iState != STATE_CHASE && iState != STATE_ATTACK)
	{
		bDoChasePersistencyInit = true;
	}
	if (g_bSlenderAttacking[iBossIndex])
	{
		// Cancel attacking.
		g_bSlenderAttacking[iBossIndex] = false;
		g_bNPCStealingLife[iBossIndex] = false;
		g_hSlenderAttackTimer[iBossIndex] = null;
		g_hNPCLifeStealTimer[iBossIndex] = null;
		g_hSlenderBackupAtkTimer[iBossIndex] = null;
		g_bNPCAlreadyAttacked[iBossIndex] = false;
		g_bNPCUseFireAnimation[iBossIndex] = false;
	}

	if (g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
	{
		SetEntityRenderMode(victim, RENDER_NORMAL);
		SetEntityRenderColor(victim, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], 0);

		g_bNPCHasCloaked[iBossIndex] = false;
		SlenderToggleParticleEffects(victim, true);
		GetProfileString(sProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
		if (sCloakParticle[0] == '\0')
		{
			sCloakParticle = "drg_cow_explosioncore_charged_blue";
		}
		SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
		EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], victim, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		g_flSlenderNextCloakTime[iBossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
		Call_StartForward(fOnBossDecloaked);
		Call_PushCell(iBossIndex);
		Call_Finish();
	}
				
	if (!bDoChasePersistencyInit)
	{
		float flPersistencyTime = GetProfileFloat(sProfile, "search_chase_persistency_time_init_stun", -1.0);
		if (flPersistencyTime >= 0.0)
		{
			g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
		}
						
		flPersistencyTime = GetProfileFloat(sProfile, "search_chase_persistency_time_add_stun", 2.0);
		if (flPersistencyTime >= 0.0)
		{
			if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime())g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
			g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
		}
	}
	else
	{
		float flPersistencyTime = GetProfileFloat(sProfile, "search_chase_persistency_time_init", 5.0);
		if (flPersistencyTime >= 0.0)
		{
			g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
		}
	}
						
	g_flSlenderTimeUntilRecover[iBossIndex] = GetGameTime() + NPCChaserGetStunDuration(iBossIndex);
						
	// Sound handling. Ignore time check.
	SlenderPerformVoice(iBossIndex, "sound_stun");
	if (NPCChaserNormalSoundHookEnabled(iBossIndex))
	{
		char sStunSoundPath[PLATFORM_MAX_PATH];
		GetRandomStringFromProfile(sProfile, "sound_stun", sStunSoundPath, sizeof(sStunSoundPath));
		if (sStunSoundPath[0] != '\0')
		{
			ClientStopAllSlenderSounds(victim, sProfile, "sound_alertofenemy", SNDCHAN_AUTO);
			ClientStopAllSlenderSounds(victim, sProfile, "sound_chasingenemy", SNDCHAN_AUTO);
			if (NPCChaserHasMultiAttackSounds(iBossIndex))
			{
				for (int i = 0; i < NPCChaserGetAttackCount(iBossIndex); i++)
				{
					if (i == 0) ClientStopAllSlenderSounds(victim, sProfile, "sound_attackenemy", SNDCHAN_AUTO);
					else
					{
						char sAttackString[PLATFORM_MAX_PATH];
						FormatEx(sAttackString, sizeof(sAttackString), "sound_attackenemy_%i", i+1);
						ClientStopAllSlenderSounds(victim, sProfile, sAttackString, SNDCHAN_AUTO);
					}
				}
			}
			else
			{
				ClientStopAllSlenderSounds(victim, sProfile, "sound_attackenemy", SNDCHAN_AUTO);
			}
			ClientStopAllSlenderSounds(victim, sProfile, "sound_idle", SNDCHAN_AUTO);
			ClientStopAllSlenderSounds(victim, sProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
		}
	}

	NPCChaserUpdateBossAnimation(iBossIndex, victim, g_iSlenderState[iBossIndex]);
}

public Action Hook_HitboxOnTakeDamage(int hitbox,int &attacker,int &inflictor,float &damage,int &damagetype)
{
	if (!g_bEnabled) return Plugin_Continue;

	int iBossIndex = NPCGetFromEntIndex(g_iSlenderHitboxOwner[hitbox]);
	if(iBossIndex != -1 && NPCGetUniqueID(iBossIndex) != -1 && NPCChaserGetState(iBossIndex) == STATE_STUN)
		damage = 0.0;
	if (!IsValidClient(attacker)) damage = 0.0;
	Hook_SlenderOnTakeDamage(hitbox, attacker, inflictor, damage, damagetype);
	int iBossHealth = GetEntProp(hitbox, Prop_Data, "m_iHealth");

	if(damage >= float(iBossHealth))
	{	
		RemoveSlender(iBossIndex);
	}
	
	return Plugin_Changed;
}

public Action Hook_SlenderOnTakeDamageOriginal(int slender,int &attacker,int &inflictor,float &damage,int &damagetype)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Continue;
	if(IsValidEntity(attacker) && IsValidEntity(g_iSlenderHitbox[iBossIndex]))
	{
		if(attacker <= MaxClients && !IsValidClient(attacker)) return Plugin_Continue;
		SDKHooks_TakeDamage(g_iSlenderHitbox[iBossIndex], attacker, attacker, damage, damagetype);
		Hook_SlenderOnTakeDamage(slender, attacker, inflictor, damage, damagetype);
	}
	return Plugin_Changed;
}