[DOD:S] Fix ChangeLevel() Spam

```
	*update 16.12.2024 - Updated gamedata, tested on Windows and Linux.

There is a bug 🪳 inside game code which execute twice ChangeLevel() function when match end (two map changes at once).
```
CHANGE LEVEL: dod_colmar
CHANGE LEVEL: dod_palermo
---- Host_Changelevel ----
L 12/14/2024 - 21:16:36: -------- Mapchange to dod_colmar --------
ConVarRef sk_suitcharger doesn't point to an existing ConVar
Executing dedicated server config file server.cfg
Error reading weapon data file for: weapon_ifm_steadycam
Set motd from file 'cfg/motd_default.txt'.  ('cfg/motd.txt' was not found.)
'cfg/motd_text.txt' not found; not loaded
SV_ActivateServer: setting tickrate to 66.7
'dod_colmar.cfg' not present; not executing.
---- Host_Changelevel ----
L 12/14/2024 - 21:16:38: -------- Mapchange to dod_palermo --------
ConVarRef sk_suitcharger doesn't point to an existing ConVar
````

- In vanilla server setup, this bug will skip next map over in map cycle.
- SM version 1.12.0.7028 and before, is able to keep map change correct.
- SM version 1.12.0.7029 and later, bug appears again. There has been update in SM core #1545

This plugin gonna fix 🛠️ that DOD:S bug.
```

```
SourcePawn Compiler 1.12.0.7172
Copyright (c) 1997-2006 ITB CompuPhase
Copyright (c) 2004-2024 AlliedModders LLC

Code size:         4068 bytes
Data size:         2688 bytes
Stack/heap size:      16468 bytes
Total requirements:   23224 bytes


```