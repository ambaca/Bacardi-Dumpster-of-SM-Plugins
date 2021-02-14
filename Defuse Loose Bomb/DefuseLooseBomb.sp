
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

#define WEAPON_NOT_CARRIED 0


enum struct CCSPlayer
{
	bool IsDefusing;
	bool HasDefuser;
	int LooseBombRef;
	float ProgressBarStartTime;

	Handle hDefusingTimer;

	void Clear()
	{
		this.IsDefusing = false;
		this.LooseBombRef = -1;
		this.hDefusingTimer = null;
		this.ProgressBarStartTime = 0.0;
		this.HasDefuser = false;
	}
}

CCSPlayer player[MAXPLAYERS+1];
bool IsRoundEnd;


ConVar DefDropBomb_Enable;
ConVar DefDropBomb_Duration;
ConVar DefDropBomb_DurationKit;

public void OnPluginStart()
{

	DefDropBomb_Enable = CreateConVar("DefDropBomb_Enable", "0.0", "Enable plugin", _, true, 0.0, true, 1.0);
	DefDropBomb_Duration = CreateConVar("DefDropBomb_Duration", "0.0", "How long bomb defuse takes. 0 = disable", _, true, 0.0, true, 60.0);
	DefDropBomb_DurationKit = CreateConVar("DefDropBomb_DurationKit", "10.0", "How long bomb defuse takes with kit. 0 = disable", _, true, 0.0, true, 60.0);

	HookEvent("round_start", bomb_dropped);
	HookEvent("round_end", bomb_dropped);
	HookEvent("bomb_dropped", bomb_dropped);
	//RegConsoleCmd("sm_test", test);
}

public Action test(int client, int args)
{
	//PrintToServer("abc %i %i", abc, EntRefToEntIndex(abc));
	return Plugin_Handled;
}


public void bomb_dropped(Event event, const char[] name, bool dontBroadcast)
{
	// Collect carried weapon_c4's
	static ArrayList m_hCC4;

	if(!DefDropBomb_Enable.BoolValue) return;



	if(m_hCC4 == null) m_hCC4 = new ArrayList();

	if(StrEqual(name, "round_end", false))
	{
		IsRoundEnd = true;
		return;
	}
	else if(StrEqual(name, "round_start", false))
	{
		IsRoundEnd = false;

		for(int i = 0; i <= MaxClients; i++) player[i].Clear();

		m_hCC4.Clear();
		return;
	}

	// Look all weapon_c4, which players carrying, when this event happen. (Normally there is one c4)

	int ent = -1;

	while((ent = FindEntityByClassname(ent, "weapon_c4")) != -1)
	{
		if(m_hCC4.FindValue(ent) != -1) continue;

		if(GetEntProp(ent, Prop_Send, "m_iState") == WEAPON_NOT_CARRIED) continue;

		if(!SDKHookEx(ent, SDKHook_UsePost, UsePost)) continue;

		m_hCC4.Push(ent);
	}
}

public void UsePost(int entity, int activator, int caller, UseType type, float value)
{
	//PrintToServer("UsePost");

	// If player repeat "+use" command, create new timer
	player[activator].hDefusingTimer = null;

	// Clear progressbar
	ProgressBar(activator, false);


	if(!DefDropBomb_Enable.BoolValue) return;

	// Player far
	if(!IsClose(entity, activator)) return;


	if(GetClientTeam(activator) != CS_TEAM_CT)
	{
		PrintToChat(activator, "[SM] Only CT can defuse loose bomb");
		return;
	}

	int entref = EntIndexToEntRef(entity);

	for(int i = 1; i <= MaxClients; i++)
	{
		if(activator == i || !IsClientInGame(i) || !IsPlayerAlive(i) || GetClientTeam(i) != CS_TEAM_CT) continue;
	
		if(entref != player[i].LooseBombRef) continue;
		
		PrintToChat(activator, "[SM] %N is defusing this loose bomb", i);
		return;
	}



	
	player[activator].HasDefuser = view_as<bool>(GetEntProp(activator, Prop_Send, "m_bHasDefuser"));
	
	if(!player[activator].HasDefuser && DefDropBomb_Duration.IntValue == 0)
	{
		PrintToChat(activator, "[SM] You need defusekit to start defuse loose bomb.");
		return;
	}
	
	if(player[activator].HasDefuser && DefDropBomb_DurationKit.IntValue == 0)
	{
		PrintToChat(activator, "[SM] ...not allowed defuse loose bomb with kit. :/");
		return;
	}

	// float pos1[3], pos2[3];
	//PrintToServer("UsePost %i %i %i %f", entity, activator, caller, GetVectorDistance(pos1, pos2));

	player[activator].LooseBombRef = entref;

	player[activator].hDefusingTimer = CreateTimer(1.0, DefusingLooseBomb, activator, TIMER_REPEAT);
	TriggerTimer(player[activator].hDefusingTimer);
}


public Action DefusingLooseBomb(Handle timer, int activator)
{
	//PrintToServer("DefusingLooseBomb");

	// Wrong timer, stop.
	if(player[activator].hDefusingTimer != timer) return Plugin_Stop;

	// Player not in game, stop
	if(!IsClientInGame(activator)) return Plugin_Stop;


	if(!DefDropBomb_Enable.BoolValue)
	{
		ProgressBar(activator, false);
		return Plugin_Stop;
	}


	// Player dead, stop
	if(!IsPlayerAlive(activator))
	{
		ProgressBar(activator, false);
		return Plugin_Stop;
	}

	// Player released button, stop
	if(!(GetClientButtons(activator) & IN_USE))
	{
		ProgressBar(activator, false);
		return Plugin_Stop;
	}

	int entity = player[activator].LooseBombRef;
	entity = EntRefToEntIndex(entity);

	// entity gone, stop
	if(entity == -1)
	{
		ProgressBar(activator, false);
		return Plugin_Stop;
	}

	// Player far, stop
	if(!IsClose(entity, activator))
	{
		ProgressBar(activator, false);
		return Plugin_Stop;
	}

	//PrintToServer("%d DefusingLooseBomb %N %i", timer, activator, entity);

	// Show progressbar
	if(!player[activator].IsDefusing)
	{
		ClientCommand(activator, "playgamesound \"c4.disarmstart\"");
		ProgressBar(activator, true);
	}

	int duration = player[activator].HasDefuser ? DefDropBomb_DurationKit.IntValue:DefDropBomb_Duration.IntValue;

	if(player[activator].ProgressBarStartTime + float(duration) >= GetGameTime()) return Plugin_Continue;


	ProgressBar(activator, false);
	
	if(IsRoundEnd) return Plugin_Stop;
	

	AcceptEntityInput(entity, "Kill");

	//PrintToServer("Bomb Defused!");
	
	CS_TerminateRound(6.0, CSRoundEnd_BombDefused);

	return Plugin_Stop;
}

bool IsClose(int entity, int activator)
{
	//PrintToServer("IsClose");

	float pos1[3], pos2[3];
	GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos1);
	GetClientAbsOrigin(activator, pos2);

	return (GetVectorDistance(pos1, pos2) <= 50.0);
}

void ProgressBar(int activator, bool start)
{
	//PrintToServer("ProgressBar");

	if(!start)
	{
		player[activator].IsDefusing = false;
		player[activator].LooseBombRef = -1;
		SetEntProp(activator, Prop_Send, "m_iProgressBarDuration", 0);
		SetEntProp(activator, Prop_Send, "m_bIsDefusing", 0);
		return;
	}

	player[activator].IsDefusing = true;

	int duration = player[activator].HasDefuser ? DefDropBomb_DurationKit.IntValue:DefDropBomb_Duration.IntValue;
	
	// Progressbar animation is 10 sec length.
	float starttime = GetGameTime();

	player[activator].ProgressBarStartTime = starttime; // save original timestamp

	int overtime = duration - 10;
	
	if(overtime > 0)
	{
		starttime += float(overtime);
		duration = 10;
	}

	SetEntPropFloat(activator, Prop_Send, "m_flProgressBarStartTime", starttime);
	SetEntProp(activator, Prop_Send, "m_iProgressBarDuration", duration);
	SetEntProp(activator, Prop_Send, "m_bIsDefusing", 1);
}