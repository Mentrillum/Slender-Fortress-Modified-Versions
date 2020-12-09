//Cvars
//Handle g_hCvarEnableTutorial;

//Detours
//static Handle g_hSDKGamerulesIsInTraining;

//Timer data
static Handle g_hTimerTutorialMessage;
static Handle g_hTimerHideTutorialMessage;

//Client data
static bool g_bClientTutorialEnabled[MAXPLAYERS + 1] =  {false, ...};

public void Tutorial_Initialize()
{
	//g_hCvarEnableTutorial = CreateConVar("sf2_enable_tutorial", "1", "Enable the tutorial interface for new players");
}


/*
 * Tutorial clients handling.
 */
public void Tutorial_HandleClient(int iClient)
{
	if (GetRoundState() != SF2RoundState_Active && !g_bPlayerEliminated[iClient] && !g_bClientTutorialEnabled[iClient])
	{
		CPrintToChat(iClient, "{aqua}Sorry you can't use the tutorial command right now!");
		return;
	}
	g_bClientTutorialEnabled[iClient] = !g_bClientTutorialEnabled[iClient];
	if (g_bClientTutorialEnabled[iClient])
	{
		CPrintToChat(iClient, "{aqua}SF2 Tutorial enabled!");
		if (GetRoundState() == SF2RoundState_Active && !g_bPlayerEliminated[iClient])
		{
			Tutorial_PrintMessageToClient(iClient, "Welcome!", "Welcome on Slender Fortress 2! This mod was coded by Benoist3012 & Kit o Rifty. Grace period is active you can change your class.\n To collect a page press %+attack%.\n To use your flashlight %+attack2%.\n To sprint press %+attack3% or %+sprint%.");
		}
	}
	else
		CPrintToChat(iClient, "{aqua}SF2 Tutorial disabled!");
}

/*
 * Messages logic
 */

public void Tutorial_OnRoundStateChange(SF2RoundState oldRoundState, SF2RoundState newRoundState)
{
	
	g_hTimerTutorialMessage = INVALID_HANDLE;
	switch (newRoundState)
	{
		case SF2RoundState_Active:
		{
			Tutorial_PrintMessage("Welcome!", "Welcome on Slender Fortress 2! This mod was coded by Benoist3012 & Kit o Rifty. Grace period is active you can change your class.\n To collect a page press %+attack%.\n To use your flashlight %+attack2%.\n To sprint press %+attack3% or %+sprint%.", 9999.0);
		}
		case SF2RoundState_Escape:
		{
			if (SF_IsSurvivalMap())
			{
				Tutorial_PrintMessage("Survive!", "Your team collected all the objectives, now It's time to survive! Try not to stay in the same spot otherwise you will be an easy target for the monster, try to move around the map sneakly, if the monster finds you, try to bring it away from your team, your death can save a lot of lives!", 7.0);
			}
			if (SF_IsRaidMap())
			{
				Tutorial_PrintMessage("Kill bosses!", "Your team must kill the main boss in order to escape, or survive until the escape opens itself. Sometimes the main boss can bring in companions that aren't needed to be killed, but can save lives. Its very essential to keep yourself alive for as long as possible, you only have one life!", 7.0);
			}
		}
	}
	switch (oldRoundState)
	{
		case SF2RoundState_Active:
		{
			Tutorial_PrintMessage("Page Finding?", "The grace period ended, now starts the serious things! While you were in grace period the monster couldn't spawn on the map, but now he can! In order to survive you have to collect the objective (pages, gas cans,ect...)", 8.0);
			g_hTimerTutorialMessage = CreateTimer(9.0, Timer_TutorialGraceEnd2ndMessage);
		}
	}
}

public Action Timer_TutorialGraceEnd2ndMessage(Handle timer)
{
	if (g_hTimerTutorialMessage != timer)return;
	
	g_hTimerTutorialMessage = INVALID_HANDLE;
	
	Tutorial_PrintMessage("The boss is near help!", "If you can hear the monster, don't move or use voice commands, the monster can hear you! If you really need to move, move slowly, the monster is only attracted by suspicious sounds!", 7.0);
	
	g_hTimerTutorialMessage = CreateTimer(8.0, Timer_TutorialGraceEnd3rdMessage);
	
}

public Action Timer_TutorialGraceEnd3rdMessage(Handle timer)
{
	if (g_hTimerTutorialMessage != timer)return;
	
	g_hTimerTutorialMessage = INVALID_HANDLE;
	
	Tutorial_PrintMessage("Playing in a group?", "While you are looking for the objectives, don't stay in a group, try to go where your team doesn't, you will increase everyone's chance of surviving!", 7.0);
}


/*
 * Messages functions
 */

void Tutorial_PrintMessage(const char[] sTitle, const char[] sMessage, const float flLifeTime=5.0)
{
	g_hTimerHideTutorialMessage = INVALID_HANDLE;
	
	PrintToChatAll("called1");
	//Tell the client, to print the training message.
	GameRules_SetProp("m_bIsInTraining", true, 1, _, true);
	GameRules_SetProp("m_bIsTrainingHUDVisible", true, 1, _, true);
	
	for (int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if (IsClientInGame(iClient) && !g_bPlayerEliminated[iClient] && g_bClientTutorialEnabled[iClient])
		{
			Handle hMessage = StartMessageOne("TrainingObjective", iClient);
			BfWriteString(hMessage, sTitle);
			delete hMessage;
			EndMessage();
			
			hMessage = StartMessageOne("TrainingMsg", iClient);
			BfWriteString(hMessage, sMessage);
			delete hMessage;
			EndMessage();
		}
	}
	g_hTimerHideTutorialMessage = CreateTimer(flLifeTime, Timer_TutorialHideMessage);
}

void Tutorial_PrintMessageToClient(int iClient, const char[] sTitle, const char[] sMessage)
{
	//Tell the client, to print the training message.
	GameRules_SetProp("m_bIsTrainingHUDVisible", true, 1, _, true);
	Handle hMessage = StartMessageOne("TrainingObjective", iClient);
	BfWriteString(hMessage, sTitle);
	delete hMessage;
	EndMessage();
	
	hMessage = StartMessageOne("TrainingMsg", iClient);
	BfWriteString(hMessage, sMessage);
	delete hMessage;
	EndMessage();
}

public Action Timer_TutorialHideMessage(Handle timer)
{
	if (g_hTimerHideTutorialMessage != timer) return;
	
	//Tell the client to hide the message
	GameRules_SetProp("m_bIsTrainingHUDVisible", false, 1, _, true);
	
	g_hTimerHideTutorialMessage = INVALID_HANDLE;
}

/*
 * On Map End
 */
void Tutorial_OnMapEnd()
{
}

/*
 * SDK Calls detours
 */
/*
void Tutorial_SetupSDK(Handle hConfig)
{
	int iOffset = GameConfGetOffset(hConfig, "CTFGameRules::IsInTraining"); 
	g_hSDKGamerulesIsInTraining = DHookCreate(iOffset, HookType_GameRules, ReturnType_Bool, ThisPointer_Address, CTFGameRules_IsInTraining);
	if (g_hSDKGamerulesIsInTraining == null) SetFailState("Failed to create hook for CTFGameRules::IsInTraining!");
	
	iOffset = GameConfGetOffset(hConfig, "CTFGameRules::GetGameType"); 
	g_hSDKGamerulesIsInTraining = DHookCreate(iOffset, HookType_GameRules, ReturnType_Int, ThisPointer_Address, CTFGameRules_GetGameType);
	if (g_hSDKGamerulesIsInTraining == null) SetFailState("Failed to create hook for CTFGameRules::GetGameType!");
}

void Tutorial_EnableHooks()
{
	DHookGamerules(g_hSDKGamerulesIsInTraining, false);
	DHookGamerules(g_hSDKGamerulesIsInTraining, true);
}
*/
/*
 * Detour functions
 */

public MRESReturn CTFGameRules_IsInTraining(Address pThis, Handle hReturn)
{
	//Trick the client into thinking the training mode is enabled.
	DHookSetReturn(hReturn, false);
	return MRES_Supercede;
}

public MRESReturn CTFGameRules_GetGameType(Address pThis, Handle hReturn)
{
	int iGameType = DHookGetReturn(hReturn);
	PrintToChatAll("%i", iGameType);
	return MRES_Supercede;
}
