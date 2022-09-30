bool g_PlayerHints[MAXPLAYERS + 1][PlayerHint_MaxNum];

// Hint data.
enum
{
	PlayerHint_Sprint = 0,
	PlayerHint_Flashlight,
	PlayerHint_MainMenu,
	PlayerHint_Blink,
	PlayerHint_Trap,
	PlayerHint_MaxNum
};


void ClientResetHints(int client)
{
    #if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetHints(%d)", client);
	}
    #endif

	for (int i = 0; i < PlayerHint_MaxNum; i++)
	{
		g_PlayerHints[client][i] = false;
	}

    #if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetHints(%d)", client);
	}
    #endif
}

void ClientShowHint(int client,int hint)
{
	g_PlayerHints[client][hint] = true;

	switch (hint)
	{
		case PlayerHint_Sprint:
		{
			PrintHintText(client, "%T", "SF2 Hint Sprint", client);
		}
		case PlayerHint_Flashlight:
		{
			PrintHintText(client, "%T", "SF2 Hint Flashlight", client);
		}
		case PlayerHint_Blink:
		{
			PrintHintText(client, "%T", "SF2 Hint Blink", client);
		}
		case PlayerHint_MainMenu:
		{
			PrintHintText(client, "%T", "SF2 Hint Main Menu", client);
		}
		case PlayerHint_Trap:
		{
			PrintHintText(client, "%T", "SF2 Hint Trap", client);
		}
	}
}
