#if defined _sf2_logging_included
 #endinput
#endif
#define _sf2_logging_included

static char g_strLogFilePath[512] = "";

void InitializeLogging()
{
	char sDateSuffix[256];
	FormatTime(sDateSuffix, sizeof(sDateSuffix), "sf2-%Y-%m-%d.log", GetTime());
	
	BuildPath(Path_SM, g_strLogFilePath, sizeof(g_strLogFilePath), "logs/%s", sDateSuffix);
	
	char sMap[64];
	GetCurrentMap(sMap, sizeof(sMap));
	
	LogSF2Message("-------- Mapchange to %s -------", sMap);
}

stock void LogSF2Message(const char[] sMessage, any ...)
{
	char sLogMessage[1024], sTemp[1024];
	VFormat(sTemp, sizeof(sTemp), sMessage, 2);
	Format(sLogMessage, sizeof(sLogMessage), "%s", sTemp);
	LogToFile(g_strLogFilePath, sLogMessage);
}