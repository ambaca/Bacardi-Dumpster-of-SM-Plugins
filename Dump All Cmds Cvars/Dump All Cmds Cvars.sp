

/*
5.5.2020
	+ TXT file name now include mod folder name.
	example: List_Cmds_hl2_Engine_SDK2013_2020-05-05.txt, List_ConVars_hl2_Engine_SDK2013_2020-05-05.txt


27.03.2020
	+ TXT files name now include engine version and date.
	for example: List_ConVars_Engine_CSGO_2020-03-27.txt, List_Cmds_Engine_CSGO_2020-03-27.txt

27.03.2020
Dump All Cmds Cvars.smx
	Plugin dump all commands and console variables in txt files, located addons/sourcemod/data folder.
	- Use server command: sm_dump_cmdscvars
	
	- This plugin create lot of ConVar Handles and cannot be close.
		So do not leave plugin in your public popular server. Only for testing purpose.

	https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins





	https://www.sourcemod.net/
	https://forums.alliedmods.net/
	https://github.com/alliedmodders/sourcemod
*/

char s_flags[][] = {
	//"FCVAR_NONE",
	"FCVAR_UNREGISTERED", "FCVAR_DEVELOPMENTONLY", "FCVAR_GAMEDLL", "FCVAR_CLIENTDLL",
	//"FCVAR_MATERIAL_SYSTEM",
	"FCVAR_HIDDEN", "FCVAR_PROTECTED", "FCVAR_SPONLY", "FCVAR_ARCHIVE", "FCVAR_NOTIFY",
	"FCVAR_USERINFO", "FCVAR_PRINTABLEONLY", "FCVAR_UNLOGGED", "FCVAR_NEVER_AS_STRING",
	"FCVAR_REPLICATED", "FCVAR_CHEAT", "FCVAR_SS", "FCVAR_DEMO", "FCVAR_DONTRECORD",
	"FCVAR_SS_ADDED", "FCVAR_RELEASE", "FCVAR_RELOAD_MATERIALS", "FCVAR_RELOAD_TEXTURES",
	"FCVAR_NOT_CONNECTED", "FCVAR_MATERIAL_SYSTEM_THREAD",
	//"FCVAR_ARCHIVE_XBOX",
	"FCVAR_ARCHIVE_GAMECONSOLE", "FCVAR_ACCESSIBLE_FROM_THREADS", "", "", "FCVAR_SERVER_CAN_EXECUTE",
	"FCVAR_SERVER_CANNOT_QUERY", "FCVAR_CLIENTCMD_CAN_EXECUTE"
};

char s_engines[][] = {
	"Engine_Unknown", "Engine_Original", "Engine_SourceSDK2006",
	"Engine_SourceSDK2007", "Engine_Left4Dead", "Engine_DarkMessiah",
	"", "Engine_Left4Dead2", "Engine_AlienSwarm", "Engine_BloodyGoodTime",
	"Engine_EYE", "Engine_Portal2", "Engine_CSGO", "Engine_CSS", "Engine_DOTA",
	"Engine_HL2DM", "Engine_DODS", "Engine_TF2", "Engine_NuclearDawn", "Engine_SDK2013",
	"Engine_Blade", "Engine_Insurgency", "Engine_Contagion", "Engine_BlackMesa",
	"Engine_DOI"
};


public void OnPluginStart()
{
	RegServerCmd("sm_dump_cmdscvars", dump, "Will dump all commands and cvars in txt files, /addons/sourcemod/data/ folder");
}

public Action dump(int args)
{
	PrintToServer("[SM] Dumping all commands and cvars in txt files, /addons/sourcemod/data/ folder");

	char path[PLATFORM_MAX_PATH];
	char date[MAX_NAME_LENGTH];
	char gamefolder[MAX_NAME_LENGTH];
	
	FormatTime(date, sizeof(date), "%F");
	
	EngineVersion engine = GetEngineVersion();
	GetGameFolderName(gamefolder, sizeof(gamefolder))

	BuildPath(Path_SM, path, sizeof(path), "data/List_ConVars_%s_%s_%s.txt", gamefolder, s_engines[engine], date);
	File MyFileCvars = OpenFile(path, "w", false, NULL_STRING);

	if(MyFileCvars == null) SetFailState("Failed to open file");

	BuildPath(Path_SM, path, sizeof(path), "data/List_Cmds_%s_%s_%s.txt", gamefolder, s_engines[engine], date);
	File MyFileCmds = OpenFile(path, "w", false, NULL_STRING);

	if(MyFileCmds == null) SetFailState("Failed to open file");


	char buffer[PLATFORM_MAX_PATH];
	char description[PLATFORM_MAX_PATH];
	char output[PLATFORM_MAX_PATH*2];
	bool isCommand;
	int flags

	Handle SearchConCommand = FindFirstConCommand(buffer, sizeof(buffer), isCommand, flags, description, sizeof(description));

	if(SearchConCommand == null)
	{
		MyFileCmds.Close();
		MyFileCvars.Close();
		LogError("Something went wrong. 'FindFirstConCommand' returned as INVALID_HANDLE");
		return;
	}
	
	MakeTextOutput(output, sizeof(output), buffer, isCommand, flags, description);
	
	if(isCommand)
	{
		MyFileCmds.WriteLine("%s", output);
	}
	else
	{
		MyFileCvars.WriteLine("%s", output);
	}


	while(FindNextConCommand(SearchConCommand, buffer, sizeof(buffer), isCommand, flags, description, sizeof(description)))
	{

		output = NULL_STRING;
		MakeTextOutput(output, sizeof(output), buffer, isCommand, flags, description);

		if(isCommand)
		{
			MyFileCmds.WriteLine("%s", output);
		}
		else
		{
			MyFileCvars.WriteLine("%s", output);
		}
	}

	CloseHandle(SearchConCommand);
	MyFileCmds.Close();
	MyFileCvars.Close();

}

void MakeTextOutput(char[] output, const int outputmax, const char[] buffer, const bool &isCommand, const int &flags, const char[] description)
{
	Format(output, outputmax, "\"%s\"", buffer);

	if(!isCommand)
	{
		ConVar cvar = FindConVar(buffer);
		
		if(cvar == null) return;
		
		char value[100];
		char defaultvalue[100];
		
		cvar.GetString(value, sizeof(value));
		cvar.GetDefault(defaultvalue, sizeof(defaultvalue));
		
		if(StrEqual(defaultvalue, value, true))
		{
			Format(output, outputmax, "%s = \"%s\"", output, value);
		}
		else
		{
			Format(output, outputmax, "%s = \"%s\" ( def. \"%s\" )", output, value, defaultvalue);
		}
		
		float min, max;
		
		if(cvar.GetBounds(ConVarBound_Lower, min))
			Format(output, outputmax, "%s min. %f", output, min);
		
		if(cvar.GetBounds(ConVarBound_Upper, max))
			Format(output, outputmax, "%s max. %f", output, max);
			
	}

	//if(!(flags & FCVAR_HIDDEN)) return;

	Format(output, outputmax, "%s\n", output);

	if(flags == 0)
	{
		Format(output, outputmax, "%sFCVAR_NONE", output);
	}
	else
	{
		for(int x = 0; x < sizeof(s_flags); x++)
		{
			if(flags & 1 << x)
			{
				Format(output, outputmax, "%s%s ", output, s_flags[x]);
			}
		}
	}

	if(strlen(description) > 0)
		Format(output, outputmax, "%s\n- %s", output, description);

	Format(output, outputmax, "%s\n", output);
}