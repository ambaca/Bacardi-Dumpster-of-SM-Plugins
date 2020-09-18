



/*

18.09.2020
Grant Public Admins
	Plugin automatically grant public players to admin.

	- However, you need set specific admin group(s) to get it work.
		There is three separate "public" admin groups:
		"public SourceTV" 	= SourceTV and Replays
		"public bots"		= bots players
		"public players"	= human players

	- You not need set all three groups, set those which you want affect.
	- addons/sourcemod/configs/admin_groups.cfg


	https://github.com/ambaca/Bacardi-Dumpster-of-SM-Plugins




	https://wiki.alliedmods.net/Adding_Groups_(SourceMod)

	https://www.sourcemod.net/
	https://forums.alliedmods.net/
	https://github.com/alliedmodders/sourcemod
*/

public Plugin myinfo = {
	name = "Grant Public Admins",
	author = "Bacardi",
	description = "Automatically grant public players to admin",
	version = "18.9.2020",
	url = "http://"
};


public void OnClientPostAdminCheck(int client)
{
	AdminId adminID = GetUserAdmin(client);

	// client already in admcache
	if(adminID != INVALID_ADMIN_ID) return;

	GroupId groupID;

	// separate SourceTV, bots and human players

	if(IsClientSourceTV(client) || IsClientReplay(client))
	{
		groupID = FindAdmGroup("public SourceTV");
	}
	else if(IsFakeClient(client))
	{
		groupID = FindAdmGroup("public bots");
	}
	else
	{
		groupID = FindAdmGroup("public players");
	}


	// "public *****" admin group does not exist (you need set it up by yourself admin_groups.cfg)
	if(groupID == INVALID_GROUP_ID) return;


	// create temporary admin and grant into admin group
	adminID = CreateAdmin();
	SetUserAdmin(client, adminID, true);
	
	if(!AdminInheritGroup(adminID, groupID))
	{
		LogError("AdminInheritGroup() false on invalid input or duplicate membership");
	}
}