[CS:S] Cashbonus Edit
- Edit some game cashbonus rewards. Windows/Linux

https://forums.alliedmods.net/showthread.php?t=345034

``
This is function tool for plugin developers.
With this you can edit Counter-Strike: Source cash bonus rewards.
Here is preview of example plugin:
``
```c
// PLAYER KILLED
"CASHBONUSEDIT_TEAMKILL"                  "-3300"
"CASHBONUSEDIT_VIPKILL"                   "2500"
"CASHBONUSEDIT_ENEMYKILL"                 "300"

//hostage ontakedamage alive
"CASHBONUSEDIT_HOSTAGEHURT"               "-20"    // multiplier dmg x N

//event hostage_killed
"CASHBONUSEDIT_HOSTAGEKILLED"             "-20"    // multiplier dmg x N

//HostageRescueZoneTouch
"CASHBONUSEDIT_RESCUERCASHBONUS"          "1000"

// BOMB ROUND END CHECK
"CASHBONUSEDIT_TARGETBOMBED"              "3500"
"CASHBONUSEDIT_BOMBDEFUSED"               "3250"
"CASHBONUSEDIT_BOMBDEFUSEDPLANTINGBONUS"  "800"

// TEAM EXTERMINATION
"CASHBONUSEDIT_CTWINBOMBMAP"              "3250"
"CASHBONUSEDIT_CTWIN"                     "3000"
"CASHBONUSEDIT_TWINBOMBMAP"               "3250"
"CASHBONUSEDIT_TWIN"                      "3000"

// VIP ROUNDEND CHECK
"CASHBONUSEDIT_VIPESCAPED"                "3500"
"CASHBONUSEDIT_VIPKILLED"                 "3250"

// CHECK ROUNDTIME EXPIRED
"CASHBONUSEDIT_TARGETSAVED"               "3250"
"CASHBONUSEDIT_HOSTAGESNOTRESCUED"        "3250"
"CASHBONUSEDIT_VIPNOTESCAPED"             "3250"

//HostageRescueRoundEndCheck
"CASHBONUSEDIT_HOSTAGERESCUEDALL"         "2500"

//Give CT use bonus
"CASHBONUSEDIT_GIVECTUSEBONUS"            "100"
"CASHBONUSEDIT_GIVERESCUERUSEBONUS"       "150"

//Restart round
"CASHBONUSEDIT_HOSTAGEBONUS"              "150"
"CASHBONUSEDIT_MAXHOSTAGEBONUS"           "1999"    // OS Windows it is 2000...
"CASHBONUSEDIT_HOSTAGESRESCUEDBONUS"      "750"
"CASHBONUSEDIT_DEFAULTLOSERBONUS_TWIN"    "1500"
"CASHBONUSEDIT_DEFAULTLOSERBONUS_CTWIN"   "1500"
"CASHBONUSEDIT_MAXLOSERBONUS_T"           "2999"    // OS Windows it is 3000...
"CASHBONUSEDIT_MAXLOSERBONUS_CT"          "2999"    // OS Windows it is 3000...
"CASHBONUSEDIT_LOSERBONUS"                "500"
"CASHBONUSEDIT_FIRSTLOSERBONUS"           "1400"  
```
``This function tool look those "hardcoded" bonus money values from game memory and then change it with given value. (Poking code from memory!).
This include also example plugin css_cashbonusedit.smx, you can try change setting per map.``

```
SourcePawn Compiler 1.11.0.6911
Copyright (c) 1997-2006 ITB CompuPhase
Copyright (c) 2004-2021 AlliedModders LLC

Code size:         7408 bytes
Data size:         3740 bytes
Stack/heap size:      17248 bytes
Total requirements:   28396 bytes

```