#pragma semicolon 1

//Peeking Data
bool g_PlayerPeeking[MAXTF2PLAYERS] = { false, ... };

/**
  *	Handles thirdperson peeking
  */
bool ClientStartPeeking(int client)
{
	if (!g_PlayerPeeking[client] && g_AllowPlayerPeekingConVar.BoolValue && !TF2_IsPlayerInCondition(client, TFCond_Dazed) && GetClientButtons(client) & IN_DUCK)
	{
		SetVariantInt(1);
		AcceptEntityInput(client, "SetForcedTauntCam");
		g_PlayerPeeking[client] = true;
		return true;
	}
	return false;
}

void ClientEndPeeking(int client)
{
	if (g_PlayerPeeking[client])
	{
		SetVariantInt(0);
		AcceptEntityInput(client, "SetForcedTauntCam");
		TF2_RemoveCondition(client, TFCond_Dazed);
		g_PlayerPeeking[client] = false;
	}
}
