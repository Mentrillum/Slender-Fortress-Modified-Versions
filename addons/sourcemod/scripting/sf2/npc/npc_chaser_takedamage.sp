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

	float myPos[3], myEyeAng[3], clientPos[3], buffer[3], traceStartPos[3], traceEndPos[3];
	GetEntPropVector(victim, Prop_Data, "m_vecAbsOrigin", myPos);

	int bossIndex = NPCGetFromEntIndex(g_SlenderHitboxOwner[victim]);
	if (bossIndex == -1)
	{
		//Theres still no boss, how did this happen?
		SDKUnhook(victim, SDKHook_OnTakeDamageAlive, Hook_HitboxOnTakeDamage);
		return;
	}
	int slender = g_SlenderHitboxOwner[victim];
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	NPCGetEyePosition(bossIndex, traceStartPos);

	bool miniCrit = false;
	if (IsValidClient(attacker))
	{
		GetClientAbsOrigin(attacker, clientPos);
		GetClientEyePosition(attacker, traceEndPos);
	}
	float shootDist = GetVectorSquareMagnitude(clientPos, myPos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", myEyeAng);

	AddVectors(myEyeAng, g_SlenderEyeAngOffset[bossIndex], myEyeAng);

	if (IsValidClient(attacker) && SF_IsBoxingMap() && (TF2_IsPlayerInCondition(attacker, TFCond_RegenBuffed)) && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
	{
		int health = GetClientHealth(attacker);
		float multipliedDamage = damage;
		multipliedDamage *= 0.475;
		int newHealth = health + RoundToCeil(multipliedDamage);
		if (newHealth<=GetEntProp(attacker, Prop_Data, "m_iMaxHealth"))
		{
			SetEntityHealth(attacker, newHealth);
		}
		else
		{
			int maxHealth = GetEntProp(attacker, Prop_Data, "m_iMaxHealth");
			SetEntityHealth(attacker, maxHealth);
		}
	}

	if (IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Scout)
	{
		int stick = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if (IsValidEntity(stick) && GetEntProp(stick, Prop_Send, "m_iItemDefinitionIndex") == 349 && stick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_SlenderIsBurning[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			damagetype = DMG_CRIT;
			damage *= 3.0;
		}
		if (IsValidEntity(stick) && (GetEntProp(stick, Prop_Send, "m_iItemDefinitionIndex") == 325 || GetEntProp(stick, Prop_Send, "m_iItemDefinitionIndex") == 452) && stick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_SlenderBleedTimer[bossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_SlenderStopBleedingTimer[bossIndex] = GetGameTime() + 5.0;
		}
		if (IsValidEntity(stick) && GetEntProp(stick, Prop_Send, "m_iItemDefinitionIndex") == 355 && stick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_SlenderMarkedTimer[bossIndex] = CreateTimer(15.0, Timer_BossMarked, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
			g_SlenderIsMarked[bossIndex] = true;
		}
		if (IsValidEntity(stick) && GetEntProp(stick, Prop_Send, "m_iItemDefinitionIndex") == 648 && stick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && shootDist > SquareFloat(72.0) && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_SlenderBleedTimer[bossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_SlenderStopBleedingTimer[bossIndex] = GetGameTime() + 5.0;
		}
	}
	if (IsValidClient(attacker) && TF2_GetPlayerClass(attacker) == TFClass_Pyro)
	{
		//Probably the only time where buffing the phlog is a good thing.
		int phlog = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Primary);
		int fragment = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if (IsValidEntity(phlog) && GetEntProp(phlog, Prop_Send, "m_iItemDefinitionIndex") == TF_WEAPON_PHLOGISTINATOR && GetEntPropFloat(attacker, Prop_Send, "m_flNextRageEarnTime") <= GetGameTime() && !view_as<bool>(GetEntProp(attacker, Prop_Send, "m_bRageDraining")))
		{
			float rage = GetEntPropFloat(attacker, Prop_Send, "m_flRageMeter");
			rage += (damage / 30.00);
			if (rage > 100.0)
			{
				rage = 100.0;
			}
			SetEntPropFloat(attacker, Prop_Send, "m_flRageMeter", rage);
		}
		if (IsValidEntity(fragment) && SF_IsBoxingMap() && GetEntProp(fragment, Prop_Send, "m_iItemDefinitionIndex") == 348 && fragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_SlenderBurnTimer[bossIndex] = CreateTimer(0.5, Timer_BossBurn, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_SlenderStopBurningTimer[bossIndex] = GetGameTime() + 15.0;
			g_SlenderIsBurning[bossIndex] = true;
		}
		if (IsValidEntity(fragment) && SF_IsBoxingMap() && (GetEntProp(fragment, Prop_Send, "m_iItemDefinitionIndex") == 38 || GetEntProp(fragment, Prop_Send, "m_iItemDefinitionIndex") == 457 || GetEntProp(fragment, Prop_Send, "m_iItemDefinitionIndex") == 1000) && fragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_SlenderIsBurning[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_SlenderBurnTimer[bossIndex] = null;
			g_SlenderStopBurningTimer[bossIndex] = GetGameTime();
			g_SlenderIsBurning[bossIndex] = false;
			miniCrit = true;
			damage *= 1.35;
		}
		if (IsValidEntity(fragment) && GetEntProp(fragment, Prop_Send, "m_iItemDefinitionIndex") == 1181 && fragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
		{
			TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
		}
		if (IsValidEntity(fragment) && SF_IsBoxingMap() && (GetEntProp(fragment, Prop_Send, "m_iItemDefinitionIndex") == 813 || GetEntProp(fragment, Prop_Send, "m_iItemDefinitionIndex") == 834) && fragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && (g_SlenderIsMarked[bossIndex]))
		{
			damagetype = DMG_CRIT;
			damage *= 3.0;
		}
	}
	if (IsValidClient(attacker) && TF2_GetPlayerClass(attacker) == TFClass_Soldier)
	{
		int whip = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if (IsValidEntity(whip) && GetEntProp(whip, Prop_Send, "m_iItemDefinitionIndex") == 447 && whip == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
		{
			TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
		}
	}
	if (IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Heavy)
	{
		int gloves = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if (IsValidEntity(gloves) && GetEntProp(gloves, Prop_Send, "m_iItemDefinitionIndex") == 426 && gloves == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
		{
			TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
		}
		if (IsValidEntity(gloves) && GetEntProp(gloves, Prop_Send, "m_iItemDefinitionIndex") == 43 && gloves == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && !IsClientCritBoosted(attacker) && SF_IsBoxingMap() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_PlayerHitsToCrits[attacker]++;
			if (g_PlayerHitsToCrits[attacker] == 5)
			{
				TF2_AddCondition(attacker, TFCond_CritOnFlagCapture, 5.0);
				g_PlayerHitsToCrits[attacker] = 0;
			}
		}
	}
	if (IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Engineer)
	{
		int wrench = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if (IsValidEntity(wrench) && GetEntProp(wrench, Prop_Send, "m_iItemDefinitionIndex") == 155 && wrench == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_SlenderBleedTimer[bossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_SlenderStopBleedingTimer[bossIndex] = GetGameTime() + 5.0;
		}
	}
	if (IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Sniper)
	{
		int sharpy = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if (IsValidEntity(sharpy) && GetEntProp(sharpy, Prop_Send, "m_iItemDefinitionIndex") == 171 && sharpy == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_SlenderBleedTimer[bossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_SlenderStopBleedingTimer[bossIndex] = GetGameTime() + 6.0;
		}
		if (IsValidEntity(sharpy) && GetEntProp(sharpy, Prop_Send, "m_iItemDefinitionIndex") == 232 && sharpy == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_SlenderIsMarked[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			damagetype = DMG_CRIT;
			damage *= 3.0;
			miniCrit = false;
		}
	}
	if (IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_DemoMan)
	{
		int sword = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if (IsValidEntity(sword) && (GetEntProp(sword, Prop_Send, "m_iItemDefinitionIndex") == 132 || GetEntProp(sword, Prop_Send, "m_iItemDefinitionIndex") == 266 || GetEntProp(sword, Prop_Send, "m_iItemDefinitionIndex") == 482 || GetEntProp(sword, Prop_Send, "m_iItemDefinitionIndex") == 1082) && sword == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			g_PlayerHitsToHeads[attacker]++;
			if (g_PlayerHitsToHeads[attacker] == 5)
			{
				if (!TF2_IsPlayerInCondition(attacker, TFCond_DemoBuff))
				{
					TF2_AddCondition(attacker, TFCond_DemoBuff, -1.0);
				}
				int decapitations = GetEntProp(attacker, Prop_Send, "m_iDecapitations");
				int health = GetClientHealth(attacker);
				SetEntProp(attacker, Prop_Send, "m_iDecapitations", decapitations+1);
				SetEntityHealth(attacker, health+15);
				TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 0.01);
				g_PlayerHitsToHeads[attacker] = 0;
			}
		}
	}
	if (IsValidClient(attacker) && SF_IsBoxingMap() && TF2_GetPlayerClass(attacker) == TFClass_Spy)
	{
		int stabbingTime = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		char weaponClass[64];
		GetEdictClassname(stabbingTime, weaponClass, sizeof(weaponClass));
		if (IsValidEntity(stabbingTime) && stabbingTime == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && (strcmp(weaponClass, "tf_weapon_knife", false) == 0 || (TF2_GetPlayerClass(attacker) == TFClass_Spy && strcmp(weaponClass, "saxxy", false) == 0)) && SF_IsBoxingMap())
		{
			SubtractVectors(traceEndPos, traceStartPos, buffer);
			GetVectorAngles(buffer, buffer);

			if (FloatAbs(AngleDiff(myEyeAng[1], buffer[1])) >= (NPCGetBackstabFOV(bossIndex) * 0.5) && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && GetProfileFloat(profile, "backstab_damage_scale", 0.05) > 0.0)
			{
				damagetype = DMG_CRIT;
				EmitSoundToClient(attacker, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);
				SetEntPropFloat(stabbingTime, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + 2.0);
				SetEntPropFloat(attacker, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
				SetEntPropFloat(attacker, Prop_Send, "m_flStealthNextChangeTime", GetGameTime() + 2.0);
				int vm = GetEntPropEnt(attacker, Prop_Send, "m_hViewModel");
				if (vm > MaxClients)
				{
					int meleeIndex = GetEntProp(stabbingTime, Prop_Send, "m_iItemDefinitionIndex");
					int anim = 41;
					switch (meleeIndex)
					{
						case 4, 194, 225, 356, 461, 574, 649, 665, 794, 803, 883, 892, 901, 910, 959, 968:
						{
							anim = 15;
						}
						case 638:
						{
							anim = 31;
						}
					}
					SetEntProp(vm, Prop_Send, "m_nSequence", anim);
					damage = NPCChaserGetStunInitialHealth(bossIndex) * GetProfileFloat(profile, "backstab_damage_scale", 0.05);
					NPCSetAddSpeed(bossIndex, 12.5);
					NPCSetAddMaxSpeed(bossIndex, 25.0);
					NPCSetAddAcceleration(bossIndex, 100.0);

					if (meleeIndex == 356) //Kunai
					{
						int health = GetClientHealth(attacker) + 100;
						if (health > 210)
						{
							health = 210;
						}
						SetEntityHealth(attacker, health);
					}
					switch (meleeIndex)
					{
						case 356: //Kunai
						{
							int health = GetClientHealth(attacker) + 100;
							if (health > 210)
							{
								health = 210;
							}
							SetEntityHealth(attacker, health);
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

	if (IsValidClient(attacker) && TF2_IsMiniCritBuffed(attacker))//Mini crit boosted
	{
		miniCrit = true;
	}

	if ((g_SlenderIsMarked[bossIndex]) && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
	{
		miniCrit = true;
		damage *= 1.35;
	}
	if (IsValidClient(attacker) && ((SF_IsBoxingMap() && GetClientTeam(attacker) == TFTeam_Blue) || (g_PlayerProxy[attacker])))
	{
		damage = 0.0;
	}
	if (!IsValidClient(attacker))
	{
		damage = 0.0;
	}
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

	if (SF_IsBoxingMap() && IsValidClient(attacker) && !bAttackEliminated && (GetClientTeam(attacker) == TFTeam_Blue))
	{
		damage = 0.0;
	}

	if (NPCGetType(bossIndex) == SF2BossType_Chaser && damage > 0.0)
	{
		int state = g_SlenderState[bossIndex];
			
		if (NPCChaserIsStunEnabled(bossIndex) && !g_SlenderSpawning[bossIndex])
		{
			if (g_SlenderNextStunTime[bossIndex] <= GetGameTime() && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_SlenderInDeathcam[bossIndex] && !g_RestartSessionEnabled)
			{
				NPCChaserAddStunHealth(bossIndex, -damage);
				if (NPCChaserGetStunHealth(bossIndex) <= 0.0 && state != STATE_STUN)
				{
					NPCBossTriggerStun(bossIndex, slender, profile, myPos);
					Call_StartForward(g_OnBossStunnedFwd);
					Call_PushCell(bossIndex);
					Call_PushCell(attacker);
					Call_Finish();
					if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA))
					{
						int maxHealth = SDKCall(g_SDKGetMaxHealth, attacker);
						float healthToRecover = float(maxHealth)/7.5;
						int _healthToRecover = RoundToNearest(healthToRecover) + GetEntProp(attacker, Prop_Send, "m_iHealth");
						SetEntityHealth(attacker, _healthToRecover);
					}
				}
			}
				
			//(Experimental)
			if (g_SlenderNextStunTime[bossIndex] <= GetGameTime() && NPCGetHealthbarState(bossIndex) && state != STATE_STUN && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_SlenderInDeathcam[bossIndex] && !g_RestartSessionEnabled)
			{
				UpdateHealthBar(bossIndex);
			}
		}
		if ((damagetype & DMG_CRIT) && !miniCrit)
		{
			float myEyePos[3];
			SlenderGetAbsOrigin(bossIndex, myEyePos);
			float myEyePosEx[3];
			GetEntPropVector(g_SlenderHitbox[bossIndex], Prop_Send, "m_vecMaxs", myEyePosEx);
			myEyePos[2] += myEyePosEx[2];
				
			TE_Particle(g_Particles[CriticalHit], myEyePos, myEyePos);
			TE_SendToAll();
				
			EmitSoundToAll(CRIT_SOUND, g_SlenderHitbox[bossIndex], SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		else if (miniCrit)
		{
			float myEyePos[3];
			SlenderGetAbsOrigin(bossIndex, myEyePos);
			float myEyePosEx[3];
			GetEntPropVector(g_SlenderHitbox[bossIndex], Prop_Send, "m_vecMaxs", myEyePosEx);
			myEyePos[2]+=myEyePosEx[2];
				
			TE_Particle(g_Particles[MiniCritHit], myEyePos, myEyePos);
			TE_SendToAll();
				
			EmitSoundToAll(MINICRIT_SOUND, g_SlenderHitbox[bossIndex], SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
	}

	return;
}

void UpdateHealthBar(int bossIndex)
{
	float maxHealth = NPCChaserGetStunInitialHealth(bossIndex);
	float health = NPCChaserGetStunHealth(bossIndex);
	if (g_HealthBar == -1)
	{
		return;
	}
	int healthPercent;
	SetEntProp(g_HealthBar, Prop_Send, "m_iBossState", 0);
	healthPercent = RoundToCeil((health/maxHealth)*float(255));
	if (healthPercent>255)
	{
		healthPercent=255;
	}
	else if (healthPercent<=0)
	{
		healthPercent=0;
	}
	SetEntProp(g_HealthBar, Prop_Send, "m_iBossHealthPercentageByte", healthPercent);
}

public void NPCBossTriggerStun(int bossIndex, int victim, char profile[SF2_MAX_PROFILE_NAME_LENGTH], float position[3])
{
	if (bossIndex == -1)
	{
		return;
	}
	if (!victim || victim == INVALID_ENT_REFERENCE)
	{
		return;
	}
	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(victim);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	CBaseCombatCharacter overlay = CBaseCombatCharacter(victim);
	npc.flWalkSpeed = 0.0;
	npc.flRunSpeed = 0.0;
	int state = g_SlenderState[bossIndex];
	bool doChasePersistencyInit = false;
	overlay.RemoveAllGestures();
	CBaseNPC_RemoveAllLayers(victim);
	if (g_LastStuckTime[bossIndex] != 0.0)
	{
		g_LastStuckTime[bossIndex] = GetGameTime();
	}
	loco.ClearStuckStatus();
	g_SlenderState[bossIndex] = STATE_STUN;
	if (g_SlenderChaseInitialTimer[bossIndex] != null)
	{
		TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
	}
	if (NPCChaseHasKeyDrop(bossIndex))
	{
		if (SF_IsBoxingMap())
		{
			g_SlenderBoxingBossKilled += 1;
			if ((g_SlenderBoxingBossKilled == g_SlenderBoxingBossCount) && !g_SlenderBoxingBossIsKilled[bossIndex])
			{
				NPC_DropKey(bossIndex);
			}
			g_SlenderBoxingBossIsKilled[bossIndex] = true;
		}
		else NPC_DropKey(bossIndex);
	}

	if (NPCChaserCanDropItemOnStun(bossIndex))
	{
		switch (NPCChaserItemDropTypeStun(bossIndex))
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
	if (g_SlenderChaseInitialTimer[bossIndex] != null)
	{
		TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
	}
	g_NpcUsesHealAnimation[bossIndex] = false;
	g_NpcUseStartFleeAnimation[bossIndex] = false;
	g_NpcIsHealing[bossIndex] = false;
	g_NpcIsRunningToHeal[bossIndex] = false;
	g_SlenderHealDelayTimer[bossIndex] = null;
	g_SlenderHealTimer[bossIndex] = null;
	g_SlenderStartFleeTimer[bossIndex] = null;
	g_NpcSelfHealStage[bossIndex] = 12;
	if (SF_IsBoxingMap() && NPCChaserIsBoxingBoss(bossIndex))
	{
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
			{
				char player[32];
				FormatEx(player, sizeof(player), "%N", client);
				char bossName[SF2_MAX_NAME_LENGTH];
				NPCGetBossName(bossIndex, bossName, sizeof(bossName));
				if (bossName[0] == '\0')
				{
					strcopy(bossName, sizeof(bossName), profile);
				}
				CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Boxing Win Message", player, bossName);
			}
		}
	}
	if (state != STATE_CHASE && state != STATE_ATTACK)
	{
		doChasePersistencyInit = true;
	}
	if (g_IsSlenderAttacking[bossIndex])
	{
		// Cancel attacking.
		g_IsSlenderAttacking[bossIndex] = false;
		g_NpcStealingLife[bossIndex] = false;
		g_SlenderAttackTimer[bossIndex] = null;
		g_NpcLifeStealTimer[bossIndex] = null;
		g_SlenderBackupAtkTimer[bossIndex] = null;
		g_NpcAlreadyAttacked[bossIndex] = false;
		g_NpcUseFireAnimation[bossIndex] = false;
	}

	if (g_NpcHasCloaked[bossIndex] && NPCChaserIsCloakEnabled(bossIndex))
	{
		SetEntityRenderMode(victim, RENDER_NORMAL);
		SetEntityRenderColor(victim, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);

		g_NpcHasCloaked[bossIndex] = false;
		SlenderToggleParticleEffects(victim, true);
		GetProfileString(profile, "cloak_particle", cloakParticle, sizeof(cloakParticle));
		if (cloakParticle[0] == '\0')
		{
			cloakParticle = "drg_cow_explosioncore_charged_blue";
		}
		SlenderCreateParticle(bossIndex, cloakParticle, 35.0);
		EmitSoundToAll(g_SlenderCloakOffSound[bossIndex], victim, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		g_SlenderNextCloakTime[bossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(bossIndex, difficulty);
		Call_StartForward(g_OnBossDecloakedFwd);
		Call_PushCell(bossIndex);
		Call_Finish();
	}
				
	if (!doChasePersistencyInit)
	{
		float persistencyTime = GetProfileFloat(profile, "search_chase_persistency_time_init_stun", -1.0);
		if (persistencyTime >= 0.0)
		{
			g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + persistencyTime;
		}
						
		persistencyTime = GetProfileFloat(profile, "search_chase_persistency_time_add_stun", 2.0);
		if (persistencyTime >= 0.0)
		{
			if (g_SlenderTimeUntilNoPersistence[bossIndex] < GetGameTime())
			{
				g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime();
			}
			g_SlenderTimeUntilNoPersistence[bossIndex] += persistencyTime;
		}
	}
	else
	{
		float persistencyTime = GetProfileFloat(profile, "search_chase_persistency_time_init", 5.0);
		if (persistencyTime >= 0.0)
		{
			g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + persistencyTime;
		}
	}
						
	g_SlenderTimeUntilRecover[bossIndex] = GetGameTime() + NPCChaserGetStunDuration(bossIndex);
						
	// Sound handling. Ignore time check.
	SlenderPerformVoice(bossIndex, "sound_stun", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
	if (NPCChaserNormalSoundHookEnabled(bossIndex))
	{
		char stunSoundPath[PLATFORM_MAX_PATH];
		GetRandomStringFromProfile(profile, "sound_stun", stunSoundPath, sizeof(stunSoundPath));
		if (stunSoundPath[0] != '\0')
		{
			ClientStopAllSlenderSounds(victim, profile, "sound_alertofenemy", SNDCHAN_AUTO);
			ClientStopAllSlenderSounds(victim, profile, "sound_chasingenemy", SNDCHAN_AUTO);
			if (NPCChaserHasMultiAttackSounds(bossIndex))
			{
				for (int i = 0; i < NPCChaserGetAttackCount(bossIndex); i++)
				{
					if (i == 0)
					{
						ClientStopAllSlenderSounds(victim, profile, "sound_attackenemy", SNDCHAN_AUTO);
					}
					else
					{
						char attackString[PLATFORM_MAX_PATH];
						FormatEx(attackString, sizeof(attackString), "sound_attackenemy_%i", i+1);
						ClientStopAllSlenderSounds(victim, profile, attackString, SNDCHAN_AUTO);
					}
				}
			}
			else
			{
				ClientStopAllSlenderSounds(victim, profile, "sound_attackenemy", SNDCHAN_AUTO);
			}
			ClientStopAllSlenderSounds(victim, profile, "sound_idle", SNDCHAN_AUTO);
			ClientStopAllSlenderSounds(victim, profile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
		}
	}

	NPCChaserUpdateBossAnimation(bossIndex, victim, g_SlenderState[bossIndex]);
}

public Action Hook_HitboxOnTakeDamage(int hitbox,int &attacker,int &inflictor,float &damage,int &damagetype)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int bossIndex = NPCGetFromEntIndex(g_SlenderHitboxOwner[hitbox]);
	if (bossIndex != -1 && NPCGetUniqueID(bossIndex) != -1 && NPCChaserGetState(bossIndex) == STATE_STUN)
	{
		damage = 0.0;
	}
	if (!IsValidClient(attacker))
	{
		damage = 0.0;
	}
	Hook_SlenderOnTakeDamage(hitbox, attacker, inflictor, damage, damagetype);
	int iBossHealth = GetEntProp(hitbox, Prop_Data, "m_iHealth");

	if (damage >= float(iBossHealth))
	{	
		RemoveSlender(bossIndex);
	}
	
	return Plugin_Changed;
}

public Action Hook_SlenderOnTakeDamageOriginal(int slender,int &attacker,int &inflictor,float &damage,int &damagetype)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	
	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Continue;
	}
	if (IsValidEntity(attacker) && IsValidEntity(g_SlenderHitbox[bossIndex]))
	{
		if (attacker <= MaxClients && !IsValidClient(attacker))
		{
			return Plugin_Continue;
		}
		SDKHooks_TakeDamage(g_SlenderHitbox[bossIndex], attacker, attacker, damage, damagetype);
		Hook_SlenderOnTakeDamage(slender, attacker, inflictor, damage, damagetype);
	}
	return Plugin_Changed;
}