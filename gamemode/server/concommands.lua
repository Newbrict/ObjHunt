concommand.Add( "chooseTeam", function( ply, _, class )
	player_manager.SetPlayerClass( ply, class[1] )
	RemoveProp( ply )
	ply:KillSilent()
	if( class[1] == "player_hunter" ) then
		ply:SetTeam( TEAM_HUNTERS )
	elseif( class[1] == "player_prop" ) then
		ply:SetTeam( TEAM_PROPS )
	else
		ply:SetTeam( TEAM_SPECTATOR )
	end
	ply:Spawn()
	hook.Call("PlayerChangeTeam", ObjHunt, ply, class[1])
end )

