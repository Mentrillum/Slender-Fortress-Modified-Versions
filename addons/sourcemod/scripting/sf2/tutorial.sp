//Cvars
//Handle g_hCvarEnableTutorial;

//Detours
//static Handle g_SDKGamerulesIsInTraining;

//Timer data
static Handle g_TimerTutorialMessage;
static Handle g_TimerHideTutorialMessage;

//Client data
static bool g_ClientTutorialEnabled[MAXPLAYERS + 1] =  {false, ...};

public void Tutorial_Initialize()
{
	//g_hCvarEnableTutorial = CreateConVar("sf2_enable_tutorial", "1", "Enable the tutorial interface for new players");
}


/*
 * Tutorial clients handling.
 */
public void Tutorial_HandleClient(int client)
{
	if (GetRoundState() != SF2RoundState_Active && !g_PlayerEliminated[client] && !g_ClientTutorialEnabled[client])
	{
		CPrintToChat(client, "{aqua}Sorry you can't use the tutorial command right now!");
		return;
	}
	g_ClientTutorialEnabled[client] = !g_ClientTutorialEnabled[client];
	if (g_ClientTutorialEnabled[client])
	{
		CPrintToChat(client, "{aqua}SF2 Tutorial enabled!");
		if (GetRoundState() == SF2RoundState_Active && !g_PlayerEliminated[client])
		{
			Tutorial_PrintMessageToClient(client, "Welcome!", "Welcome on Slender Fortress 2! This mod was coded by Benoist3012 & Kit o Rifty. Grace period is active you can change your class.\n To collect a page press %+attack%.\n To use your flashlight %+attack2%.\n To sprint press %+attack3% or %+sprint%.");
		}
	}
	else
	{
		CPrintToChat(client, "{aqua}SF2 Tutorial disabled!");
	}
}

/*
 * Messages logic
 */

public void Tutorial_OnRoundStateChange(SF2RoundState oldRoundState, SF2RoundState newRoundState)
{
	
	g_TimerTutorialMessage = null;
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
			g_TimerTutorialMessage = CreateTimer(9.0, Timer_TutorialGraceEnd2ndMessage, _, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action Timer_TutorialGraceEnd2ndMessage(Handle timer)
{
	if (g_TimerTutorialMessage != timer)
	{
		return Plugin_Stop;
	}
	
	g_TimerTutorialMessage = null;
	
	Tutorial_PrintMessage("The boss is near help!", "If you can hear the monster, don't move or use voice commands, the monster can hear you! If you really need to move, move slowly, the monster is only attracted by suspicious sounds!", 7.0);
	
	g_TimerTutorialMessage = CreateTimer(8.0, Timer_TutorialGraceEnd3rdMessage, _, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_TutorialGraceEnd3rdMessage(Handle timer)
{
	if (g_TimerTutorialMessage != timer)
	{
		return Plugin_Stop;
	}
	
	g_TimerTutorialMessage = null;
	
	Tutorial_PrintMessage("Playing in a group?", "While you are looking for the objectives, don't stay in a group, try to go where your team doesn't, you will increase everyone's chance of surviving!", 7.0);

	return Plugin_Stop;
}


/*
 * Messages functions
 */

void Tutorial_PrintMessage(const char[] sTitle, const char[] sMessage, const float flLifeTime=5.0)
{
	g_TimerHideTutorialMessage = null;
	
	PrintToChatAll("called1");
	//Tell the client, to print the training message.
	GameRules_SetProp("m_bIsInTraining", true, 1, _, true);
	GameRules_SetProp("m_bIsTrainingHUDVisible", true, 1, _, true);
	
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client) && !g_PlayerEliminated[client] && g_ClientTutorialEnabled[client])
		{
			Handle message = StartMessageOne("TrainingObjective", client);
			BfWriteString(message, sTitle);
			delete message;
			EndMessage();
			
			message = StartMessageOne("TrainingMsg", client);
			BfWriteString(message, sMessage);
			delete message;
			EndMessage();
		}
	}
	g_TimerHideTutorialMessage = CreateTimer(flLifeTime, Timer_TutorialHideMessage, _, TIMER_FLAG_NO_MAPCHANGE);
}

void Tutorial_PrintMessageToClient(int client, const char[] sTitle, const char[] sMessage)
{
	//Tell the client, to print the training message.
	GameRules_SetProp("m_bIsTrainingHUDVisible", true, 1, _, true);
	Handle message = StartMessageOne("TrainingObjective", client);
	BfWriteString(message, sTitle);
	delete message;
	EndMessage();
	
	message = StartMessageOne("TrainingMsg", client);
	BfWriteString(message, sMessage);
	delete message;
	EndMessage();
}

public Action Timer_TutorialHideMessage(Handle timer)
{
	if (g_TimerHideTutorialMessage != timer)
	{
		return Plugin_Stop;
	}
	
	//Tell the client to hide the message
	GameRules_SetProp("m_bIsTrainingHUDVisible", false, 1, _, true);
	
	g_TimerHideTutorialMessage = null;

	return Plugin_Stop;
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
	g_SDKGamerulesIsInTraining = DHookCreate(iOffset, HookType_GameRules, ReturnType_Bool, ThisPointer_Address, CTFGameRules_IsInTraining);
	if (g_SDKGamerulesIsInTraining == null) SetFailState("Failed to create hook for CTFGameRules::IsInTraining!");
	
	iOffset = GameConfGetOffset(hConfig, "CTFGameRules::GetGameType"); 
	g_SDKGamerulesIsInTraining = DHookCreate(iOffset, HookType_GameRules, ReturnType_Int, ThisPointer_Address, CTFGameRules_GetGameType);
	if (g_SDKGamerulesIsInTraining == null) SetFailState("Failed to create hook for CTFGameRules::GetGameType!");
}

void Tutorial_EnableHooks()
{
	DHookGamerules(g_SDKGamerulesIsInTraining, false);
	DHookGamerules(g_SDKGamerulesIsInTraining, true);
}
*/
/*
 * Detour functions
 */

public MRESReturn CTFGameRules_IsInTraining(Address pThis, DHookReturn returnHandle)
{
	//Trick the client into thinking the training mode is enabled.
	DHookSetReturn(returnHandle, false);
	returnHandle.Value = false;
	return MRES_Supercede;
}

public MRESReturn CTFGameRules_GetGameType(Address pThis, DHookReturn returnHandle)
{
	int gameType = returnHandle.Value;
	PrintToChatAll("%i", gameType);
	return MRES_Supercede;
}
