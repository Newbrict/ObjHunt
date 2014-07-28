local function GetSpecEnts( ply )
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
	return tempPlayers
end

function GM:PlayerDeathThink( ply )
	local players = GetSpecEnts( ply )

	-- default settings
	if( !ply.spectateIndex ) then
		ply.spectateIndex = 1
		if( #players > 0 ) then
			ply.spectateMode = OBS_MODE_CHASE
			ply:SpectateEntity( players[ ply.spectateIndex ] )
		else
			ply.spectateMode = OBS_MODE_ROAMING
			ply:SpectateEntity( nil )
		end
		ply:Spectate( ply.spectateMode )
	end


	if( #players > 0 ) then
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
	end

	-- this prevents respawning
	return false
end

hook.Add( "PlayerSpawn", "Clear Spectator State", function( ply )
	ply.spectateIndex = nil
	ply.spectateMode = nil
end )