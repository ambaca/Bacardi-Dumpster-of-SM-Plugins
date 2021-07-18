


/*
Server is hibernating
Dropped Mann Co. from server (Punting bot, server is hibernating)
*/


#include <dhooks>

ConVar sm_hibernate_when_empty;
float seconds;


public Plugin myinfo = 
{
	name = "Delay or disable server hibernate",
	author = "Bacardi",
	description = "Prevent server go to hibernate mode or delayed it",
	version = "13.3.2021",
	url = "http://www.sourcemod.net/"
};

public void OnPluginStart()
{
	GameData temp = new GameData("SetHibernating.games");

	if(temp == null) SetFailState("Why you no has gamedata?");

	Handle hSetHibernating = DHookCreateFromConf(temp, "DHook_SetHibernating");
	
	if(hSetHibernating == null) SetFailState("Failed to DHookCreateFromConf - 'DHook_SetHibernating' ");

	delete temp;

	// Fail when DHooks function builded wrong or Signature not work
	if (!DHookEnableDetour(hSetHibernating, false, Detour_SetHibernatingCallback))
		SetFailState("Failed to detour hSetHibernating. Fix gamedata file!");

	delete hSetHibernating;

	sm_hibernate_when_empty = CreateConVar("sm_hibernate_when_empty", "60", "How many seconds we wait before hibernate mode. -1 never hibernate");
	sm_hibernate_when_empty.AddChangeHook(convarchanged);
	seconds = sm_hibernate_when_empty.FloatValue;
}

public void convarchanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	seconds = convar.FloatValue;
}

Handle mytimer;

public MRESReturn Detour_SetHibernatingCallback(DHookParam hParams)
{
	static bool oldvalue;

	if(!hParams.Get(1) && mytimer != null) // server waking up and timer running
	{
		delete mytimer;
		mytimer = null;
	}
	else if(mytimer != null) // timer is running
	{
		hParams.Set(1, 0);
		return MRES_ChangedHandled;
	}



	
	// Server going to hibernate (last human player disconnect or else)
	if(hParams.Get(1) && !oldvalue)
	{

		// any another negative value than -1.0, do nothing
		if(seconds != -1.0 && seconds <= 0.0)
		{
			oldvalue = hParams.Get(1);
			return MRES_Ignored;
		}


		// create timer
		if(seconds != -1.0 && mytimer == null)
		{
			oldvalue = hParams.Get(1);
			mytimer = CreateTimer(seconds, delay);
		}

		// or block forever -1.0
		hParams.Set(1, 0);
		return MRES_ChangedHandled;
	}


	// update
	oldvalue = hParams.Get(1);

	return MRES_Ignored;
}

public Action delay(Handle timer)
{
	// there should not be more than one timer...
	mytimer = null;
}

