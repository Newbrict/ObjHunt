AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )



function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_spectator" )
end

util.AddNetworkString("team selection")

function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
	net.Start("team selection")
	net.Send( ply )
end	

net.Receive("team selection", function( len, ply )
	theTeam = net.ReadUInt(32)
	ply:KillSilent()
	print( theTeam )
	ply:SetTeam( theTeam )

	if( theTeam == TEAM_PROPS ) then
		player_manager.SetPlayerClass( ply, "player_prop" )
	elseif( theTeam == TEAM_HUNTERS ) then
		player_manager.SetPlayerClass( ply, "player_hunter" )
	else
		player_manager.SetPlayerClass( ply, "player_spectator" )
	end

	ply:Spawn()
end )