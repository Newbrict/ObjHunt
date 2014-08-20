--[[ Rounds are handled here, obviously ]]--

-----------------------------------
-- THE HOOKS THAT THIS CALLS ARE --
-- OBJHUNT_RoundStart            --
-- OBJHUNT_RoundEnd_Props        --
-- OBJHUNT_RoundEnd_Hunters      --
-- OBJHUNT_RoundLimit            --
-----------------------------------

-- this var is used outside of this file
round = {}
round.state     = ROUND_WAIT
round.current   = 0
round.startTime = 0
round.endTime   = 0
round.winner    = "Newbrict"

local function SendRoundUpdate( sendMethod )
	net.Start( "Round Update" )
		net.WriteUInt(round.state, 8)
		net.WriteUInt(round.current, 8)
		net.WriteUInt(round.startTime, 32)
		net.WriteUInt(CurTime(), 32)
	sendMethod()
end

local function SwapTeams()
	local hunters = team.GetPlayers(TEAM_HUNTERS)
	local props = team.GetPlayers(TEAM_PROPS)

	for _, v in pairs(hunters) do
		if( IsValid(v) ) then
			RemovePlayerProp( v )
			v:SetTeam( TEAM_PROPS )
			player_manager.SetPlayerClass( v, "player_prop" )
			v:KillSilent()
			v:Spawn()
		end
	end

	for _, v in pairs(props) do
		if( IsValid(v) ) then
			RemovePlayerProp( v )
			v:SetTeam( TEAM_HUNTERS )
			player_manager.SetPlayerClass( v, "player_hunter" )
			v:KillSilent()
			v:Spawn()
		end
	end
end

local function WaitRound()
	-- wait for everyone to connect and what not
	local mapTime = os.time() - mapStartTime
	if( mapTime < OBJHUNT_PRE_ROUND_TIME ) then return end

	-- make sure we have at least one player on each team
	local hunters = team.GetPlayers(TEAM_HUNTERS)
	local props = team.GetPlayers(TEAM_PROPS)
	if( #props == 0 || #hunters == 0 ) then return end

	round.state = ROUND_START
end

local function StartRound()
	round.current = round.current + 1
	round.startTime = CurTime()
	-- reset the map
	game.CleanUpMap(false, {"player_prop_ent"})
	-- swap teams, respawn everyone
	SwapTeams()
	round.state = ROUND_IN
	hook.Call( "OBJHUNT_RoundStart" )
end

local function InRound()
	local roundTime = CurTime() - round.startTime
	-- make sure we have not gone over time
	if( roundTime >= OBJHUNT_ROUND_TIME ) then
		round.state = ROUND_END
		round.endTime = CurTime()
		round.winner = "Props"
		hook.Call( "OBJHUNT_RoundEnd" )
		return
	end

	-- make sure there is at least one living player left per team
	local hunters = GetLivingPlayers(TEAM_HUNTERS)
	local props = GetLivingPlayers(TEAM_PROPS)

	if( #props == 0 ) then
		round.state = ROUND_END
		round.endTime = CurTime()
		round.winner = "Hunters"
		hook.Call( "OBJHUNT_RoundEnd" )
		return
	end

	if( #hunters == 0 ) then
		round.state = ROUND_END
		round.endTime = CurTime()
		round.winner = "Props"
		hook.Call( "OBJHUNT_RoundEnd" )
		return
	end

	-- unfreeze the hunters after their time is up
	if( roundTime > OBJHUNT_HIDE_TIME && hunters[1]:IsFrozen() ) then
		for _, v in pairs(hunters) do
			v:Freeze( false )
		end
	end

end

local function EndRound()
	-- if we've played enough times on this map
	if( round.current >= OBJHUNT_ROUNDS ) then
		hook.Call( "OBJHUNT_RoundLimit" )
		return
	end

	-- make sure we have at least one player on each team
	local hunters = team.GetPlayers(TEAM_HUNTERS)
	local props = team.GetPlayers(TEAM_PROPS)
	if( #props == 0 || #hunters == 0 ) then return end

	-- start the round after we've waiting long enough
	local waitTime = CurTime() - round.endTime
	if( waitTime >= OBJHUNT_POST_ROUND_TIME ) then
		round.state = ROUND_START
	end

end

local roundHandler = {}
roundHandler[ROUND_WAIT]  = WaitRound
roundHandler[ROUND_START] = StartRound
roundHandler[ROUND_IN]    = InRound
roundHandler[ROUND_END]   = EndRound


-- start the round orchestrator when the game has initialized
hook.Add( "Initialize", "Begin round functions", function()
	hook.Add( "Tick", "Round orchestrator", function()
		roundHandler[round.state]()
	end )
end )

hook.Add( "OBJHUNT_RoundStart", "Round start stuff", function()
	print( "Round "..round.current.." is Starting" )

	-- send data to clients
	SendRoundUpdate( function() return net.Broadcast() end )
	-- reset previous round data
	net.Start( "Clear Round State" )
	net.Broadcast()

	for _, v in pairs( player.GetAll() ) do
		-- remove god mode from everyone
		v:GodDisable()
		-- freeze all the hunters
		if( v:Team() == TEAM_HUNTERS ) then
			v:Freeze( true )
		end
	end
end )

hook.Add( "OBJHUNT_RoundEnd", "Handle props winning", function()
	print( "Props win" )
	-- tell all the props that they won, good job props
	SendRoundUpdate( function() return net.Broadcast() end )
	for _, v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTCENTER, round.winner.." Win!" )
		-- give everyone god mode until round starts again
	    v:GodEnable()
	end
end )

hook.Add( "OBJHUNT_RoundLimit", "Start map voting", function()
	-- no longer need the round orchestrator
	hook.Remove( "Tick", "Round orchestrator" )
	MapVote.Start(30, false, 50, {"cs_", "ph_"})

	print( "Map voting should start now" )
end )

hook.Add( "PlayerInitialSpawn", "Send Round data to client", function( ply )
	-- sent to only the player, one time per join thing
	SendRoundUpdate( function() return net.Send( ply ) end )
end)