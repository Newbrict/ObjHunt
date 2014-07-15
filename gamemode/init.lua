AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )


function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_spectator" )
end

function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
    umsg.Start( "class_selection", ply ) -- Sending a message to the client.
    umsg.End()
end	

function GM:CreateTeams( )
	team.SetUp( TEAM_PROPS , "Props" , Color( 255, 0, 0 ), true )
	team.SetUp( TEAM_HUNTERS , "Hunters" , Color( 0, 255, 0 ), true  )
	team.SetUp( TEAM_SPECTATOR , "Spectators" , Color( 127, 127, 127 ), true  )
	team.SetClass( TEAM_PROPS, {"player_prop"})
	team.SetClass( TEAM_HUNTERS, {"player_hunter"})
	team.SetClass( TEAM_SPECTATOR, {"player_spectator"})
	team.SetSpawnPoint( TEAM_PROPS, {"info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_allies"} )
	team.SetSpawnPoint( TEAM_HUNTERS, {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"} )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"} )

end

--[[ All network strings should be precached HERE ]]--
hook.Add( "Initialize", "Precache all network strings", function()
	util.AddNetworkString( "Map Time" )
	util.AddNetworkString( "Prop Update" )
	util.AddNetworkString( "Reset Prop" )
	util.AddNetworkString( "round Time" )
	util.AddNetworkString( "Selected Prop" )
	util.AddNetworkString( "Prop Angle Lock" )
	util.AddNetworkString( "Prop Angle Lock BROADCAST" )
	util.AddNetworkString( "Prop Angle Snap" )
	util.AddNetworkString( "Prop Angle Snap BROADCAST" )
end )
