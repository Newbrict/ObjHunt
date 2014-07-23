function StartSpectate( ply )
	ply.spectateIndex = 1
	ply.spectateMode = OBS_MODE_ROAMING
	ply:Spectate( ply.spectateMode )
end

function GM:PlayerDeathThink( ply )
	if( !ply.spectateIndex ) then
		ply.spectateIndex = 1
	end

	if( !ply.spectateMode ) then
		ply.spectateMode = OBS_MODE_ROAMING
		ply:Spectate( ply.spectateMode )
	end
	
	local t = ply:Team()
	local players = {}

	-- if we're not on hunters, add props
	if( t != TEAM_HUNTERS ) then
		table.Add( players, team.GetPlayers( TEAM_PROPS ) )
	end

	-- if we're not on props, add hunters
	if( t != TEAM_PROPS ) then
		table.Add( players, team.GetPlayers( TEAM_HUNTERS ) )
	end

	-- remove dead players
	local tempPlayers = {}
	for _, v in pairs( players ) do
		if( v:Alive() ) then
			tempPlayers[#tempPlayers + 1] = v
		end
	end
	players = tempPlayers


	if ply:KeyPressed( IN_JUMP ) then
		ply.spectateMode = (ply.spectateMode % 3) + 4
		ply:Spectate( ply.spectateMode )
	elseif ply:KeyPressed( IN_ATTACK ) then
		ply.spectateIndex = (ply.spectateIndex % #players) + 1
		ply:SpectateEntity( players[ ply.spectateIndex ] )
	elseif ply:KeyPressed( IN_ATTACK2 ) then
		ply.spectateIndex = #players - (#players - ply.spectateIndex % #players) + 1
		ply:SpectateEntity( players[ ply.spectateIndex ] )
	end
	return false
end