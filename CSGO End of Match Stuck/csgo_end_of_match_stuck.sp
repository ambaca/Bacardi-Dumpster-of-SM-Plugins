


/*

end of vote
Server event "nextlevel_changed", Tick 3509:
- "nextlevel" = "coop_mission_rush"
- "mapgroup" = "mg_my_list"
- "skirmishmode" = ""


	stuck
	workshop map ? -authkey ? No  Steam Web API Authorization Key ?


Server event "server_spawn", Tick 65:
- "hostname" = "Counter-Strike: Global Offensive"
- "address" = ""
- "port" = "0"
- "game" = "F:\server\counter-strike global offensive\csgo"
- "mapname" = "cs_office"
- "maxplayers" = "64"
- "os" = "WIN32"
- "dedicated" = "1"
- "official" = "0"
- "password" = "0"



	* 18.07.2021 -This version 1.1 will load de_dust2 map when next workshop map fail.
	* 12.04.2020 -Plugin added in GitHub

	(CS:GO) End of Match - Stuck!
	Sometimes next map not start load and you are literally stuck, at end of match.
	- Could happens when you try load workshop map but some reason you have no -authkey set on server or some error with that. (I have tested plugin this way only).

	This plugin help you load same map gain.

	No commands, no cvars. Just add plugin in server.

	
	https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins





	https://www.sourcemod.net/
	https://forums.alliedmods.net/
	https://github.com/alliedmodders/sourcemod

*/



public Plugin myinfo = 
{
	name = "[CSGO] End of Match - Stuck!",
	author = "Bacardi",
	description = "Match have ended, but server would not load next map. You are stuck. I help you to load de_dust2.",
	version = "1.1",
	url = "http://www.sourcemod.net/"
};



public void OnPluginStart()
{
	HookEventEx("nextlevel_changed",	nextlevel_changed);
	//HookEventEx("server_spawn", 		nextlevel_changed);
}


public void nextlevel_changed(Event event, const char[] name, bool dontBroadcast)
{
	if(StrEqual(name, "server_spawn", false))
	{
		// I maybe need this later.
		return;
	}


	char buffer[100];
	event.GetString("nextlevel", buffer, sizeof(buffer));

	Format(buffer, sizeof(buffer), "nextlevel %s", buffer);

	DataPack pack;
	CreateDataTimer(7.0, delay, pack, TIMER_FLAG_NO_MAPCHANGE);

	pack.WriteCell(strlen(buffer));
	pack.WriteString(buffer);
	pack.Reset();
	
	PrintToChatAll("[SM] If you manage read this message to the end. '%s' may not start load... We are going to load de_dust2 map. Sorry.", buffer);
}

public Action delay(Handle timer, DataPack pack)
{
	int siz = pack.ReadCell();

	char[] buffer = new char[siz];
	pack.ReadString(buffer, siz);


	//char samemap[100];
	//GetCurrentMap(samemap, sizeof(samemap));


	LogError(" End Of Match - Stuck! Error %s. Next map not load! I will changelevel de_dust2 map", buffer);

	ServerCommand("changelevel de_dust2");

	return Plugin_Continue;
}