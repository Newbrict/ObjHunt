AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )



function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_spectator" )
	ply:SetTeam( TEAM_SPECTATOR )
end

function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
	local theTeam = TEAM_PROPS
	ply:KillSilent()
	ply:SetTeam( theTeam )
	if( theTeam == TEAM_PROPS ) then
		player_manager.SetPlayerClass( ply, "player_prop" )
	elseif( theTeam == TEAM_HUNTERS ) then
		player_manager.SetPlayerClass( ply, "player_hunter" )
	else
		player_manager.SetPlayerClass( ply, "player_spectator" )
	end
	ply:Spawn()
end	
