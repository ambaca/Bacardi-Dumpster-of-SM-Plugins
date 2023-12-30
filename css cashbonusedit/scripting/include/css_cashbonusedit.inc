
// css_cashbonusedit.inc
// Bacardi 29.12.2023

#if defined _css_cashbonusedit_included
 #endinput
#endif
#define _css_cashbonusedit_included


// uncomment below line, compile plugin, you see output msg on server console
//#define _DEBUG


enum
{
	// NOPE
	CASHBONUSEDIT_TEAMKILL = 1, CASHBONUSEDIT_VIPKILL, CASHBONUSEDIT_ENEMYKILL,
	CASHBONUSEDIT_HOSTAGEHURT, CASHBONUSEDIT_HOSTAGEKILLED, CASHBONUSEDIT_RESCUERCASHBONUS,
	CASHBONUSEDIT_TARGETBOMBED, CASHBONUSEDIT_BOMBDEFUSED, CASHBONUSEDIT_BOMBDEFUSEDPLANTINGBONUS,
	CASHBONUSEDIT_CTWINBOMBMAP, CASHBONUSEDIT_CTWIN, CASHBONUSEDIT_TWINBOMBMAP, CASHBONUSEDIT_TWIN,
	CASHBONUSEDIT_VIPESCAPED, CASHBONUSEDIT_VIPKILLED,
	CASHBONUSEDIT_TARGETSAVED, CASHBONUSEDIT_HOSTAGESNOTRESCUED,
	CASHBONUSEDIT_VIPNOTESCAPED,
	CASHBONUSEDIT_HOSTAGERESCUEDALL,
	CASHBONUSEDIT_GIVECTUSEBONUS, CASHBONUSEDIT_GIVERESCUERUSEBONUS,
	CASHBONUSEDIT_HOSTAGEBONUS, CASHBONUSEDIT_MAXHOSTAGEBONUS, CASHBONUSEDIT_HOSTAGESRESCUEDBONUS,
	CASHBONUSEDIT_DEFAULTLOSERBONUS_TWIN, CASHBONUSEDIT_DEFAULTLOSERBONUS_CTWIN,
	CASHBONUSEDIT_MAXLOSERBONUS_T, CASHBONUSEDIT_MAXLOSERBONUS_CT,
	CASHBONUSEDIT_LOSERBONUS, CASHBONUSEDIT_FIRSTLOSERBONUS,
	CASHBONUSEDIT_SIZE
};

/*
*int aSkip[] = {		//		OS Windows... nah. I'm using gamedata file now (css_cashbonusedit.games.txt aSkip)
*	0x0,			//NOPE
*	0x1, 0x1, 0x1,	//"CASHBONUSEDIT_TEAMKILL", "CASHBONUSEDIT_VIPKILL", "CASHBONUSEDIT_ENEMYKILL",
*	0x0, 0x0, 0x1,	//"CASHBONUSEDIT_HOSTAGEHURT", "CASHBONUSEDIT_HOSTAGEKILLED", "CASHBONUSEDIT_RESCUERCASHBONUS",
*	0x6, 0x6, 0x6,	//"CASHBONUSEDIT_TARGETBOMBED", "CASHBONUSEDIT_BOMBDEFUSED", "CASHBONUSEDIT_BOMBDEFUSEDPLANTINGBONUS",
*	0x6, 0x6, 0x6, 0x6,	//"CASHBONUSEDIT_CTWINBOMBMAP", "CASHBONUSEDIT_CTWIN", "CASHBONUSEDIT_TWINBOMBMAP", "CASHBONUSEDIT_TWIN",
*	0x6, 0x6,		//"CASHBONUSEDIT_VIPESCAPED", "CASHBONUSEDIT_VIPKILLED",
*	0x6, 0x6,		//"CASHBONUSEDIT_TARGETSAVED", "CASHBONUSEDIT_HOSTAGESNOTRESCUED",
*	0x6,			//"CASHBONUSEDIT_VIPNOTESCAPED",
*	0x6,			//"CASHBONUSEDIT_HOSTAGERESCUEDALL",
*	0x6, 0x1,		//"CASHBONUSEDIT_GIVECTUSEBONUS", "CASHBONUSEDIT_GIVERESCUERUSEBONUS",
*	0x2, 0x2, 0x6,	//"CASHBONUSEDIT_HOSTAGEBONUS", "CASHBONUSEDIT_MAXHOSTAGEBONUS", "CASHBONUSEDIT_HOSTAGESRESCUEDBONUS",
*	0x6, 0x6,		//"CASHBONUSEDIT_DEFAULTLOSERBONUS_TWIN", "CASHBONUSEDIT_DEFAULTLOSERBONUS_CTWIN",
*	0x1, 0x1,		//"CASHBONUSEDIT_MAXLOSERBONUS_T", "CASHBONUSEDIT_MAXLOSERBONUS_CT",
*	0x1, 0x6		//"CASHBONUSEDIT_LOSERBONUS", "CASHBONUSEDIT_FIRSTLOSERBONUS"
*};
*/

static const char sCASHBONUSEDIT[][] = {
	"NOPE",
	"CASHBONUSEDIT_TEAMKILL", "CASHBONUSEDIT_VIPKILL", "CASHBONUSEDIT_ENEMYKILL",
	"CASHBONUSEDIT_HOSTAGEHURT", "CASHBONUSEDIT_HOSTAGEKILLED", "CASHBONUSEDIT_RESCUERCASHBONUS",
	"CASHBONUSEDIT_TARGETBOMBED", "CASHBONUSEDIT_BOMBDEFUSED", "CASHBONUSEDIT_BOMBDEFUSEDPLANTINGBONUS",
	"CASHBONUSEDIT_CTWINBOMBMAP", "CASHBONUSEDIT_CTWIN", "CASHBONUSEDIT_TWINBOMBMAP", "CASHBONUSEDIT_TWIN",
	"CASHBONUSEDIT_VIPESCAPED", "CASHBONUSEDIT_VIPKILLED",
	"CASHBONUSEDIT_TARGETSAVED", "CASHBONUSEDIT_HOSTAGESNOTRESCUED",
	"CASHBONUSEDIT_VIPNOTESCAPED",
	"CASHBONUSEDIT_HOSTAGERESCUEDALL",
	"CASHBONUSEDIT_GIVECTUSEBONUS", "CASHBONUSEDIT_GIVERESCUERUSEBONUS",
	"CASHBONUSEDIT_HOSTAGEBONUS", "CASHBONUSEDIT_MAXHOSTAGEBONUS", "CASHBONUSEDIT_HOSTAGESRESCUEDBONUS",
	"CASHBONUSEDIT_DEFAULTLOSERBONUS_TWIN", "CASHBONUSEDIT_DEFAULTLOSERBONUS_CTWIN",
	"CASHBONUSEDIT_MAXLOSERBONUS_T", "CASHBONUSEDIT_MAXLOSERBONUS_CT",
	"CASHBONUSEDIT_LOSERBONUS", "CASHBONUSEDIT_FIRSTLOSERBONUS"
};



/*
*	"mp_startmoney" = "800" min. 800.000000 max. 16000.000000
*	 game notify replicated
*	 - amount of money each player gets when they reset
*/








/**
 * Get index of cash bonus type name
 *
 * @param buffer       Bonus type name
 * @return             Return Index of given bonus name, otherwise -1 for error
 */
stock int cashbonuseditIndex(const char[] buffer)
{
	int index = -1;

	for(int x = 0; x < sizeof(sCASHBONUSEDIT); x++ )
	{
		if(!StrEqual(sCASHBONUSEDIT[x], buffer, false))
			continue;

		index = x;
		break;
	}

	return index;
}


/**
 * Get index of cash bonus name
 *
 * @param Bonustype    Bonus index for get or set value
 * @param value	       Set declarated variable for get value or set value. Don't set number straight as parameter
 * @param set	       False to get value, True to set value
 * @return             Return Index of given bonus name, otherwise -1 for error
 */
stock bool cashbonusedit(int Bonustype, int &value = 0, bool set = false)
{
	GameData gameconf = new GameData("css_cashbonusedit.games");

	if(gameconf == null) SetFailState("GameData failed");

	Address address = gameconf.GetAddress(sCASHBONUSEDIT[Bonustype]);

	if(address == view_as<Address>(0))
	{
		LogError("Failed to find address for %s", sCASHBONUSEDIT[Bonustype]);
		delete gameconf;
		return false;
	}

	char aSkip[CASHBONUSEDIT_SIZE+1];

	if(!gameconf.GetKeyValue("aSkip", aSkip, sizeof(aSkip)))
	{
		LogError("Failed to get Key aSkip");
		delete gameconf;
		return false;
	}

#if defined (_DEBUG)
	int num = view_as<int>(aSkip[Bonustype]);
	PrintToServer("%X +aSkip %d", address, num);
#endif


	NumberType numbertype = NumberType_Int32;


	// Need done code differently
	if(Bonustype == CASHBONUSEDIT_HOSTAGEHURT || Bonustype == CASHBONUSEDIT_HOSTAGEKILLED)
	{
		char buffer[] = "machinton";

		if(!gameconf.GetKeyValue("OS", buffer, sizeof(buffer)))
		{
			LogError("Failed to find Keyvalue OS for %s", sCASHBONUSEDIT[Bonustype]);
			delete gameconf;
			return false;
		}

		if(StrEqual(buffer, "linux", false))
		{
			if(set)
			{
				int value2 = value & 0x000000FF;

				numbertype = NumberType_Int8;
				StoreToAddress(address+view_as<Address>(0x2), value2, numbertype, true);

				if(Bonustype == CASHBONUSEDIT_HOSTAGEKILLED)
				{
					StoreToAddress(address+view_as<Address>(0x3), 0x90, numbertype, true);

					numbertype = NumberType_Int32;
					StoreToAddress(address+view_as<Address>(0x4), 0x90909090, numbertype, true);
				}
			}


#if defined (_DEBUG)
				PrintToServer("%X %s 0x%X", address, sCASHBONUSEDIT[Bonustype], value);
#endif

			delete gameconf;
			return true;
		}
		else if(StrEqual(buffer, "windows", false))
		{
			if(set)
			{
				// code for CASHBONUSEDIT_HOSTAGEHURT
				int multicode = 0x90ecc96b; //imul ecx,ecx,-14
										  //nop


				if(Bonustype == CASHBONUSEDIT_HOSTAGEKILLED)
					multicode = 0x90ecc06b; //imul eax,eax,-14
										  //nop


				multicode = multicode & 0xFF00FFFF;	// clear 3rd byte

				int value2 = value & 0x000000FF;	// Get value 1st byte
				value2 *= 0x10000;				// Set right place
				
				multicode = multicode + value2;

				StoreToAddress(address, multicode, numbertype, true);

				
				if(Bonustype == CASHBONUSEDIT_HOSTAGEKILLED)
					StoreToAddress(address+view_as<Address>(0x4), 0x9090ce8b, numbertype, true);	// remember set or will crash - mov ecx,esi
				else
					StoreToAddress(address+view_as<Address>(0x4), 0x90909090, numbertype, true);	// code for CASHBONUSEDIT_HOSTAGEHURT

				numbertype = NumberType_Int16;
				StoreToAddress(address+view_as<Address>(0x8), 0x9090, numbertype, true);

#if defined (_DEBUG)
				PrintToServer("%X %s multicode = 0x%010X", address, sCASHBONUSEDIT[Bonustype], multicode);
#endif

			}

			delete gameconf;
			return true;
		}

		delete gameconf;
		return false;
	}

	address += view_as<Address>(view_as<int>(aSkip[Bonustype]));



	// differ from rest
	if(Bonustype == CASHBONUSEDIT_GIVECTUSEBONUS)
		numbertype = NumberType_Int8;

	if(set)
	{
		StoreToAddress(address, value, numbertype, true);
		delete gameconf;
		return true;
	}

	value = LoadFromAddress(address, numbertype);

#if defined (_DEBUG)
	PrintToServer("%X %s %d", address, sCASHBONUSEDIT[Bonustype], value);
#endif



	delete gameconf;
	return true;

}

