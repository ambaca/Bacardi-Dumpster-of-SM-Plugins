



public Plugin myinfo =
{
	name = "CSGO Healthshot KillCount",
	author = "Bacardi",
	description = "Grant healthshots after n kills",
	version = "1.0",
	url = "https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins"
};




enum struct PlayerInfo
{
	int userid;
	int kills;
}

#include <cstrike>
#include <sdktools>

ConVar mp_teammates_are_enemies;
ConVar sm_healthshot_killcount;

public void OnPluginStart()
{
	mp_teammates_are_enemies = FindConVar("mp_teammates_are_enemies");

	sm_healthshot_killcount = CreateConVar("sm_healthshot_killcount", "4", "Grant healthshots after n kills", _, true, 0.0);

	HookEvent("player_death", player_death);
}

public void OnMapStart()
{
	for(int x = 1; x < MAXPLAYERS+1; x++)
	{
		MedshotProgress(x, x, x, x);
	}
}

public void player_death(Event event, const char[] name, bool dontBroadcast)
{
/*
Server event "player_death", Tick 10177:
- "userid" = "5"
- "attacker" = "2"
- "assister" = "0"
- "assistedflash" = "0"
- "weapon" = "mac10"
- "weapon_itemid" = "0"
- "weapon_fauxitemid" = "17293822569102704657"
- "weapon_originalowner_xuid" = "0"
- "headshot" = "0"
- "dominated" = "0"
- "revenge" = "0"
- "wipe" = "0"
- "penetrated" = "0"
- "noreplay" = "1"
- "noscope" = "0"
- "thrusmoke" = "0"
- "attackerblind" = "0"
- "distance" = "14.74"
*/
	if(!sm_healthshot_killcount.IntValue)
		return;

	int userid = event.GetInt("userid");
	int attackerid = event.GetInt("attacker");

	int victim = GetClientOfUserId(userid);
	int attacker = GetClientOfUserId(attackerid);

	MedshotProgress(userid, attackerid, victim, attacker);
}

public void MedshotProgress(int victimid, int attackerid, int victim, int attacker)
{
	static PlayerInfo playerinfo[MAXPLAYERS+1];

	playerinfo[victim].userid = victimid;
	playerinfo[victim].kills = 0;

	if(!attacker || victim == attacker)
		return;


	if(playerinfo[attacker].userid != attackerid)
	{
		playerinfo[attacker].userid = attackerid;
		playerinfo[attacker].kills = 0;
	}


	if(GetClientTeam(attacker) == GetClientTeam(victim))
	{
		if(mp_teammates_are_enemies != null && !mp_teammates_are_enemies.BoolValue)
		{
			playerinfo[attacker].kills = 0;
			return;
		}
	}



	playerinfo[attacker].kills++;

	// If player carry weapon_healthshot, reset kills
	if(GetPlayerWeaponSlot(attacker, CS_SLOT_BOOST) != -1)
		playerinfo[attacker].kills = 0;


	if(playerinfo[attacker].kills < sm_healthshot_killcount.IntValue)
		return;

	playerinfo[attacker].kills = 0;

	CreateTimer(1.0, delay, attackerid);
}


public Action delay(Handle timer, any userid)
{
	int attacker = GetClientOfUserId(userid);

	if(!attacker || !IsClientInGame(attacker) || !IsPlayerAlive(attacker) || GetClientTeam(attacker) < 2)
		return Plugin_Continue

	if(GetPlayerWeaponSlot(attacker, CS_SLOT_BOOST) != -1)
		return Plugin_Continue;

	GivePlayerItem(attacker, "weapon_healthshot");

	return Plugin_Continue
}





















