concommand.Add( "chooseTeam", function( ply, _, class )
	player_manager.SetPlayerClass( ply, class[1] )
	RemoveProp( ply )
	ply:KillSilent()
	if( class[1] == "player_hunter" ) then
		ply:SetTeam( TEAM_HUNTERS )--set team to hunters
	elseif( class[1] == "player_prop" ) then
		ply:SetTeam( TEAM_PROPS ) --set team to props
	else
		ply:SetTeam( TEAM_SPECTATOR ) --set team to spectator
	end
	ply:Spawn()

end )