// 1E6BCAEF - C6 05 D8E71B69 01     - mov byte ptr [server.dll+45E7D8],01 { (0),1 }

//	const CMultiplayRules::`vftable'
//	"windows" "150"
//	"linux" "149"

//	Signature for CMultiplayRules__ChangeLevell_sub_10180A50:
//	55 8B EC 8B 15 ? ? ? ? 83 EC 64 
//	\x55\x8B\xEC\x8B\x15\x2A\x2A\x2A\x2A\x83\xEC\x64




// DOD:S delay between double ChangeLevel() is 0.015625 seconds. RequestFrame() is too fast.

public Plugin myinfo = 
{
	name = "[DOD:S] Fix ChangeLevel() Spam",
	author = "Bacardi",
	description = "Plugin block extra level change functions",
	version = "15.12.2024",
	url = "http://www.sourcemod.net/"
};


//#include <sdktools>
#include <dhooks>

DynamicHook DHookChangeLevel;
bool bChangelevelDone = false;
GameData DODGameData;

//Handle ChangeLevel;

//Address g_fGameOver;

public void OnPluginStart()
{
	//RegConsoleCmd("sm_test", test);
	//char signature[] = "\x55\x8B\xEC\x8B\x15\x2A\x2A\x2A\x2A\x83\xEC\x64";
	//
	//StartPrepSDKCall(SDKCall_GameRules);
	//PrepSDKCall_SetSignature(SDKLibrary_Server, signature, strlen(signature));
	//PrepSDKCall_SetVirtual(150);
	//ChangeLevel = EndPrepSDKCall();

	DODGameData = new GameData("dodsfixchangelevel.games");

	if(DODGameData == null)
		SetFailState("Failed to load gamedata");

	int offset = DODGameData.GetOffset("ChangeLevelOffset");
	
	if(offset == -1)
		SetFailState("Failed to get offset value from gamedata");

	DHookChangeLevel = new DynamicHook(offset, HookType_GameRules, ReturnType_Void, ThisPointer_Ignore);

	//g_fGameOver = ChangeLevelAddress.GetAddress("ChangeLevel");
	//
	//if(g_fGameOver == Address_Null)
	//	SetFailState( " ChangeLevel Address Null");
	//
	//if(LoadFromAddress(g_fGameOver, NumberType_Int16) != 0x05C6)
	//	SetFailState("1. Wrong address or game code changed");
	//
	//if(LoadFromAddress(g_fGameOver + view_as<Address>(0x6), NumberType_Int8) != 0x01)
	//	SetFailState("2. Wrong address or game code changed");
	//
	//g_fGameOver = LoadFromAddress(g_fGameOver + view_as<Address>(0x2), NumberType_Int32);
	//
	//PrintToServer(" g_fGameOver %i", LoadFromAddress(g_fGameOver, NumberType_Int8))
}

public void OnConfigsExecuted()
{
	if(DHookChangeLevel.HookGamerules(Hook_Pre, DHookChangeLevelCB) == INVALID_HOOK_ID)
		LogError("Error: DHooks HookGamerules returned INVALID_HOOK_ID");
}

public MRESReturn DHookChangeLevelCB()
{
	//LoadFromAddress(g_fGameOver, NumberType_Int8);

	if(bChangelevelDone)
		return MRES_Supercede;


	// ChangeLevel() function is now fired once, block other ChangeLevel() spam in this 0.1 second time.
	bChangelevelDone = true;

	CreateTimer(0.1, RemoveBlock);

	return MRES_Ignored;
}

public Action RemoveBlock(Handle timer)
{
	bChangelevelDone = false;

	return Plugin_Continue;
}


//public Action test(int client, int args)
//{
//	if(ChangeLevel != null)
//	{
//		PrintToServer("Yeah! ChangeLevel!");
//		SDKCall(ChangeLevel);
//	}
//	return Plugin_Handled;
//}