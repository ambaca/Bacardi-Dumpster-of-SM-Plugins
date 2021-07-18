[any] Delay or disable server hibernate

```
	13.03.2021
	- Prevent server go to hibernate mode or delayed it.

	- When last human player disconnect from server, server goes immediately into hibernate mode,
	kicking all bots from server and map start over again.

	This plugin will either delayed this action or disable it.

	sm_hibernate_when_empty -1 // This disable hibernate mode
	sm_hibernate_when_empty 60 // Server goes in hibernate mode in 60 seconds, Default value.
	// Value 0 and any another negative value than -1, plugin doesn't do anything.

		Require extension:
		DHooks 2 https://github.com/peace-maker/DHooks2/releases
		post #589 https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589


	For Games:
	Counter-Strike:Source, Team Fortress 2, (Day Of Defeat: Source ?)


https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins
https://forums.alliedmods.net/

SourceMod: Half-Life 2 Scripting
www.sourcemod.net
```
	
```
SourcePawn Compiler 1.10.0.6510
Copyright (c) 1997-2006 ITB CompuPhase
Copyright (c) 2004-2018 AlliedModders LLC

Code size:             4320 bytes
Data size:             2816 bytes
Stack/heap size:      16384 bytes
Total requirements:   23520 bytes
```