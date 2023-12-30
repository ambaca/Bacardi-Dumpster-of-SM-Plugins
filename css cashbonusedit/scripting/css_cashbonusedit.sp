
// css_cashbonusedit.sp
// Bacardi 29.12.2023

public Plugin myinfo =
{
	name = "[CS:S] Cashbonus Edit (example)",
	author = "Bacardi",
	description = "Edit some game cashbonus rewards",
	version = "29.12.2023",
	url = "http://www.sourcemod.net/"
};

#include <css_cashbonusedit>


public void OnConfigsExecuted()
{
	char map[PLATFORM_MAX_PATH];
	Format(map, sizeof(map), "reset");

	GetCurrentMap(map, sizeof(map));

	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/cashbonusedit/");

	Format(map, sizeof(map), "%s%s.txt", path, map);

	if(!FileExists(map))
	{
		Format(map, sizeof(map), "%sreset.txt", path);
		
		if(!FileExists(map))
			return;
	}

	//PrintToServer("map '%s'", map);

	// map file or reset file found.

	SMCParser smc = new SMCParser();
	smc.OnKeyValue = ReadKeyValue;

	SMCError smcerror = smc.ParseFile(map);

	if(smcerror != SMCError_Okay)
	{
		char error[PLATFORM_MAX_PATH];
		smc.GetErrorString(smcerror, error, sizeof(error));
	}

	delete smc;
}

public SMCResult ReadKeyValue(SMCParser smc, const char[] key, const char[] value, bool key_quotes, bool value_quotes)
{
	int index = cashbonuseditIndex(key);

	//PrintToServer("%s %s index %d", key, value, index);

	int num = StringToInt(value);

	cashbonusedit(index, num, true);

	return SMCParse_Continue;
}


/*
	cashbonusedit(CASHBONUSEDIT_TEAMKILL);
	cashbonusedit(CASHBONUSEDIT_VIPKILL);
	cashbonusedit(CASHBONUSEDIT_ENEMYKILL);
	cashbonusedit(CASHBONUSEDIT_HOSTAGEHURT);
	cashbonusedit(CASHBONUSEDIT_HOSTAGEKILLED);
	cashbonusedit(CASHBONUSEDIT_RESCUERCASHBONUS);
	cashbonusedit(CASHBONUSEDIT_TARGETBOMBED);
	cashbonusedit(CASHBONUSEDIT_BOMBDEFUSED);
	cashbonusedit(CASHBONUSEDIT_BOMBDEFUSEDPLANTINGBONUS);
	cashbonusedit(CASHBONUSEDIT_CTWINBOMBMAP);
	cashbonusedit(CASHBONUSEDIT_CTWIN);
	cashbonusedit(CASHBONUSEDIT_TWINBOMBMAP);
	cashbonusedit(CASHBONUSEDIT_TWIN);
	cashbonusedit(CASHBONUSEDIT_VIPESCAPED);
	cashbonusedit(CASHBONUSEDIT_VIPKILLED);
	cashbonusedit(CASHBONUSEDIT_TARGETSAVED);
	cashbonusedit(CASHBONUSEDIT_HOSTAGESNOTRESCUED);
	cashbonusedit(CASHBONUSEDIT_VIPNOTESCAPED);
	cashbonusedit(CASHBONUSEDIT_HOSTAGERESCUEDALL);
	cashbonusedit(CASHBONUSEDIT_GIVECTUSEBONUS);
	cashbonusedit(CASHBONUSEDIT_GIVERESCUERUSEBONUS);
	cashbonusedit(CASHBONUSEDIT_HOSTAGEBONUS);
	cashbonusedit(CASHBONUSEDIT_MAXHOSTAGEBONUS);
	cashbonusedit(CASHBONUSEDIT_HOSTAGESRESCUEDBONUS);
	cashbonusedit(CASHBONUSEDIT_DEFAULTLOSERBONUS_TWIN);
	cashbonusedit(CASHBONUSEDIT_DEFAULTLOSERBONUS_CTWIN);
	cashbonusedit(CASHBONUSEDIT_MAXLOSERBONUS_T);
	cashbonusedit(CASHBONUSEDIT_MAXLOSERBONUS_CT);
	cashbonusedit(CASHBONUSEDIT_LOSERBONUS);
	cashbonusedit(CASHBONUSEDIT_FIRSTLOSERBONUS);
*/