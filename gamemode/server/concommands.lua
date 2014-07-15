concommand.Add( "chooseTeam", function( ply, _, class )
	player_manager.SetPlayerClass( ply, class[1] )
	RemovePlayerProp( ply )
	ply:KillSilent()
	if( class[1] == "player_hunter" ) then
		ply:SetTeam( TEAM_HUNTERS )
	elseif( class[1] == "player_prop" ) then
		ply:SetTeam( TEAM_PROPS )
	else
		ply:SetTeam( TEAM_SPECTATORS )
	end
	ply:Spawn()
	hook.Call("PlayerChangeTeam", ObjHunt, ply, class[1])
end )

-- for testing purposes

concommand.Add( "pain", function( ply,_,amt )
	ply:SetHealth( ply:Health() - amt[1] )
	print( "ply's hp is:".. ply:Health() )
end )

concommand.Add( "stuck", function( ply,_,amt )
	local ss = isStuck(ply)
	print ( ss )
end )
