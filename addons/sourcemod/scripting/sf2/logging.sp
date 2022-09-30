#if defined _sf2_logging_included
 #endinput
#endif
#define _sf2_logging_included

#pragma semicolon 1

static char g_LogFilePath[512] = "";

void InitializeLogging()
{
	BuildPath(Path_SM, g_LogFilePath, sizeof(g_LogFilePath), "logs/sf2");
	if (!DirExists(g_LogFilePath))
	{
		CreateDirectory(g_LogFilePath, FPERM_U_READ|FPERM_U_WRITE|FPERM_U_EXEC);
	}
	
	char dateSuffix[256];
	FormatTime(dateSuffix, sizeof(dateSuffix), "%Y-%m-%d.log", GetTime());
	BuildPath(Path_SM, g_LogFilePath, sizeof(g_LogFilePath), "logs/sf2/%s", dateSuffix);
	
	char map[64];
	GetCurrentMap(map, sizeof(map));
	
	LogSF2Message("-------- Mapchange to %s -------", map);
}

stock void LogSF2Message(const char[] message, any ...)
{
	char logMessage[1024], temp[1024];
	VFormat(temp, sizeof(temp), message, 2);
	FormatEx(logMessage, sizeof(logMessage), "%s", temp);
	LogToFile(g_LogFilePath, logMessage);
}