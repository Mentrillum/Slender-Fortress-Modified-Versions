#pragma semicolon 1

//Peeking Data
static bool g_PlayerPeeking[MAXTF2PLAYERS] = { false, ... };

/**
  *	Handles thirdperson peeking
  */
bool ClientStartPeeking(int client)
{
	if (!g_PlayerPeeking[client] && g_AllowPlayerPeekingConVar.BoolValue && !TF2_IsPlayerInCondition(client, TFCond_Dazed) && GetClientButtons(client) & IN_DUCK)
	{
		TF2_StunPlayer(client, -1.0, 1.0, TF_STUNFLAGS_LOSERSTATE);
		g_PlayerPeeking[client] = true;
		return true;
	}
	return false;
}

void ClientEndPeeking(int client)
{
	if (g_PlayerPeeking[client])
	{
		TF2_RemoveCondition(client, TFCond_Dazed);
		g_PlayerPeeking[client] = false;
	}
}
