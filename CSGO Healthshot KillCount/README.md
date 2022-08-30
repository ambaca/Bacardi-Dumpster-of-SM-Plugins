CSGO Healthshot KillCount

```
Grant healthshots after n kills

- Kill count reset when:
player died
player have already healthshot
Teamkill when mp_teammates_are_enemies 0
Map start.

*.sp is source file.
*.smx is compiled, ready to use plugin.

Convar:
sm_healthshot_killcount 4
```


**Note!\
This plugin create lot of ConVar Handles, taking some memory and those cannot close.\
So, it is recommend to use this plugin few times for testing purpose, remove it from server and restart server.\
Don't leave this plugin active in public server.**





```
SourcePawn Compiler 1.11.0.6911
Copyright (c) 1997-2006 ITB CompuPhase
Copyright (c) 2004-2021 AlliedModders LLC

Code size:         5636 bytes
Data size:         3468 bytes
Stack/heap size:      16548 bytes
Total requirements:   25652 bytes


```