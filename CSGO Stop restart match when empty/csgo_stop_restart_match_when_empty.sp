
/*

[CSGO] Stop restart match when empty

	26.04.2020
	- I noticed, when first human player connect to empty server, server use command:
	map currentmapname reserved
	...and restart map, you start beginning of match, everytime.
	
	Of course, you need also set these so match not restart:
	sv_hibernate_when_empty 0
	bot_join_after_player 0

	This plugin block this specific server command, when there is no human players in game already.
	It works, when very first player connect to empty server (don't count bots).

https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins
https://forums.alliedmods.net/

SourceMod: Half-Life 2 Scripting
www.sourcemod.net
	
	
	
SourcePawn Compiler 1.10.0.6478
Copyright (c) 1997-2006 ITB CompuPhase
Copyright (c) 2004-2018 AlliedModders LLC

Code size:             3756 bytes
Data size:             2564 bytes
Stack/heap size:      16384 bytes
Total requirements:   22704 bytes

*/

public Plugin myinfo = 
{
	name = "[CSGO] Stop restart match when empty",
	author = "Bacardi",
	description = "Block server command 'map xxx reserved' when first human player connect to server",
	version = "1.0",
	url = "https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins"
};

public void OnPluginStart()
{
	AddCommandListener(listen, "map");
}

public Action listen(int client, const char[] command, int args)
{
	// console
	if(client == 0)
	{
		// I know, we can do this more simple code than what is ahead.

		char buffer[PLATFORM_MAX_PATH];
		char reserved[] = " reserved";

		int argument_len = GetCmdArgString(buffer, sizeof(buffer));
		int reserved_len = strlen(reserved);
		int offset = argument_len - reserved_len;

		// map mapname reserved
		if(offset > 0 && StrContains(buffer[offset], reserved, true) >= 0)
		{
			bool IsHumanInGame = false;

			for(int i = 1; i <= MaxClients; i++)
			{
				if(!IsClientInGame(i) || IsFakeClient(i)) continue;

				IsHumanInGame = true;
			}
			
			if(!IsHumanInGame)
			{
				PrintToServer(" - BLOCK map '%s'", buffer);
				LogAction(-1, -1, " Plugin block command 'map %s'", buffer);

				return Plugin_Handled
			}
		}
	}

	return Plugin_Continue;
}
