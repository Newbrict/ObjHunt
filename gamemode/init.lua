AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )


function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_spectator" )
end

function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
    umsg.Start( "class_selection", ply ) -- Sending a message to the client.
    umsg.End()
end	

function GM:ShowSpare1( ply ) -- This hook is called everytime F2 is pressed.
    umsg.Start( "taunt_selection", ply ) -- Sending a message to the client.
    umsg.End()
end	

function GM:PlayerSetModel( ply )
	class = player_manager.GetPlayerClass( ply )
	if( class == "player_hunter" ) then
		ply:SetModel( "models/player/Combine_Super_Soldier.mdl" )
	elseif( class == "player_prop" ) then
		ply:SetModel( "models/error.mdl" )
	else
		return
	end
end

function GM:CreateTeams( )
	TEAM_PROPS = 1
	TEAM_HUNTERS = 2

	team:SetUp( TEAM_PROPS , "Props" , Color( 255, 0, 0 ), true )
	team:SetUp( TEAM_HUNTERS , "Hunters" , Color( 0, 255, 0 ), true  )
	team:SetClass( TEAM_PROPS, {"player_prop"})
	team:SetClass( TEAM_HUNTERS, {"player_hunter"})

end

--[[ All network strings should be precached HERE ]]--
hook.Add( "Initialize", "Precache all network strings", function()
	util.AddNetworkString( "Map Time" )
end )

--[[ Map Time ]]--
hook.Add( "Initialize", "Set Map Time", function() mapStartTime = os.time() end )
hook.Add( "PlayerInitialSpawn", "Send Map Time To New Player", function( ply )
	net.Start( "Map Time" )
	local toSend = ( mapStartTime || os.time() )
	net.WriteUInt( toSend, 32 )
	net.Send( ply )
end )

include( "shared.lua" )