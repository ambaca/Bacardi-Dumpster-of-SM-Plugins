[CSGO] Stop restart match when empty

```
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
```
	
```
SourcePawn Compiler 1.10.0.6478
Copyright (c) 1997-2006 ITB CompuPhase
Copyright (c) 2004-2018 AlliedModders LLC

Code size:             3756 bytes
Data size:             2564 bytes
Stack/heap size:      16384 bytes
Total requirements:   22704 bytes
```