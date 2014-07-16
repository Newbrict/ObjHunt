AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )



function GM:PlayerInitialSpawn( ply )
	ply:SetTeam( TEAM_SPECTATOR )
end

function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
	local theTeam = TEAM_PROPS
	ply:SetTeam( theTeam )
	ply:KillSilent()
	ply:Spawn()
end	
function GM:PlayerSelectSpawn( Player )
    if ( Player:Team( )==TEAM_SPECTATOR ) then return; end
end

function GM:PlayerSpawn( Player )
	if ( Player:Team( )==TEAM_SPECTATOR ) then return; end
end
