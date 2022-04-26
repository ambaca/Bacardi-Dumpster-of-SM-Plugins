

/*
26.04.2022
	+ Cvars and Commands are now listed alphabetical order in output file.
	+ Output file name contain now, is dump list generated from SRCDS or Listen server (client)
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
	PrintToServer("[SM] Collecting Cvars and Cmds, please wait...");

	RequestFrame(FrameLoop, 1);

	return Plugin_Handled;
}

public void FrameLoop(any data)
{
	static char buffer[256];
	static bool IsCommand;
	static int flags;
	static char description[256];
	static Handle ConCommandBaseSearch;

	buffer[0] = '\0';
	IsCommand = false;
	flags = 0;
	description[0] = '\0';

	// First loop after command callback
	if(ConCommandBaseSearch == null && data == 1)
	{
		ConCommandBaseSearch = FindFirstConCommand(buffer, sizeof(buffer), IsCommand, flags, description, sizeof(description));
		
		if(ConCommandBaseSearch == null)
			return;
	}
	else if(ConCommandBaseSearch == null)
	{
		RequestFrame(FinaleOutput, 0);
		return;
	}

	int counter;
	bool FoundNextCmd;
	//PrintToServer(" ");

	do
	{
		if(buffer[0] != '\0')
			CollectCmdBaseSearch(buffer, IsCommand, flags, description);

		counter++;
	}
	while(counter < 10 && (FoundNextCmd = FindNextConCommand(ConCommandBaseSearch, buffer, sizeof(buffer), IsCommand, flags, description, sizeof(description))) )

	if(!FoundNextCmd)
		delete ConCommandBaseSearch;

	RequestFrame(FrameLoop, 0);
}

ArrayList ListConsoleCvarsNames;
ArrayList ListConsoleCmdsNames;

StringMap ListConsoleCvarsData;
StringMap ListConsoleCmdsData;

void CollectCmdBaseSearch(const char[] buffer, bool IsCommand, int flags, const char[] description)
{

	if(ListConsoleCvarsNames == null)
		ListConsoleCvarsNames = new ArrayList(ByteCountToCells(65));

	if(ListConsoleCmdsNames == null)
		ListConsoleCmdsNames = new ArrayList(ByteCountToCells(65));

	if(ListConsoleCvarsData == null)
		ListConsoleCvarsData = new StringMap();

	if(ListConsoleCmdsData == null)
		ListConsoleCmdsData = new StringMap();


	char output[1024];


	if(!IsCommand)
	{
		ListConsoleCvarsNames.PushString(buffer);
		
		MakeTextOutput(output, sizeof(output), buffer, IsCommand, flags, description);
		ListConsoleCvarsData.SetString(buffer, output);
	}
	else
	{
		ListConsoleCmdsNames.PushString(buffer);

		MakeTextOutput(output, sizeof(output), buffer, IsCommand, flags, description);
		ListConsoleCmdsData.SetString(buffer, output);
	}
}


void MakeTextOutput(char[] output, const int outputmax, const char[] buffer, const bool &IsCommand, const int &flags, const char[] description)
{
	Format(output, outputmax, "\"%s\"", buffer);

	if(!IsCommand)
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





public void FinaleOutput(any data)
{
	PrintToServer("[SM] Dumping all commands and cvars in txt files, /addons/sourcemod/data/ folder");

	char path[PLATFORM_MAX_PATH];
	char date[MAX_NAME_LENGTH];
	char gamefolder[MAX_NAME_LENGTH];
	
	FormatTime(date, sizeof(date), "%F");
	
	EngineVersion engine = GetEngineVersion();
	GetGameFolderName(gamefolder, sizeof(gamefolder))

	BuildPath(Path_SM, path, sizeof(path), "data/List_ConVars_%s_%s_%s_%s.txt",
											gamefolder,
											s_engines[engine],
											IsDedicatedServer() ? "SRCDS":"ListenServer",
											date);

	File MyFileCvars = OpenFile(path, "w", false, NULL_STRING);

	if(MyFileCvars == null) SetFailState("Failed to open file");

	MyFileCvars.WriteLine("\n\n\n// File generated with\n// https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins/tree/master/Dump%20All%20Cmds%20Cvars");
	MyFileCvars.WriteLine("// %s\n\n\n", path);


	BuildPath(Path_SM, path, sizeof(path), "data/List_Cmds_%s_%s_%s_%s.txt",
											gamefolder,
											s_engines[engine],
											IsDedicatedServer() ? "SRCDS":"ListenServer",
											date);

	File MyFileCmds = OpenFile(path, "w", false, NULL_STRING);

	if(MyFileCmds == null) SetFailState("Failed to open file");

	MyFileCmds.WriteLine("\n\n\n// File generated with\n// https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins/tree/master/Dump%20All%20Cmds%20Cvars");
	MyFileCmds.WriteLine("// %s\n\n\n", path);






	ListConsoleCvarsNames.Sort(Sort_Ascending, Sort_String);
	ListConsoleCmdsNames.Sort(Sort_Ascending, Sort_String);

	char buffer[65];
	char output[1024];

	for(int x = 0; x < ListConsoleCvarsNames.Length; x++)
	{
		ListConsoleCvarsNames.GetString(x, buffer, sizeof(buffer));
		ListConsoleCvarsData.GetString(buffer, output, sizeof(output));
		//PrintToServer("%s", output);

		MyFileCvars.WriteLine("%s", output);

	}

	for(int x = 0; x < ListConsoleCmdsNames.Length; x++)
	{
		ListConsoleCmdsNames.GetString(x, buffer, sizeof(buffer));
		ListConsoleCmdsData.GetString(buffer, output, sizeof(output));
		//PrintToServer("%s", output);

		MyFileCmds.WriteLine("%s", output);

	}





	delete MyFileCmds;
	delete MyFileCvars;

	delete ListConsoleCvarsData;
	delete ListConsoleCmdsData;

	delete ListConsoleCvarsNames;
	delete ListConsoleCmdsNames;
}

