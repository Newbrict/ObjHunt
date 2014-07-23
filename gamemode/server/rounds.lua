--[[ Rounds are handled here, obviously ]]--

-----------------------------------
-- THE HOOKS THAT THIS CALLS ARE --
-- OBJHUNT_RoundStart            --
-- OBJHUNT_RoundEnd_Props        --
-- OBJHUNT_RoundEnd_Hunters      --
-- OBJHUNT_RoundLimit            --
-----------------------------------

-- time to wait initially before starting in seconds
local ROUND_WAIT  = 0
local ROUND_START = 1
local ROUND_IN    = 2
local ROUND_END   = 3
local roundState = ROUND_WAIT


local curRound = 0
local roundStartTime = 0
local roundEndTime = 0

local function SendRoundUpdate( sendMethod )
	net.Start( "Round Update" )
		net.WriteUInt(roundState, 8)
		net.WriteUInt(curRound, 8)
		net.WriteUInt(roundStartTime, 32)
		net.WriteUInt(CurTime(), 32)
	sendMethod()
end

local function GetLivingPlayers( onTeam )
	local allPly = team.GetPlayers( onTeam )
	local livingPly = {}
	for _, v in pairs(allPly) do
		if( IsValid(v) && v:Alive() ) then
			livingPly[#livingPly + 1] = v
		end
	end
	return livingPly
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

	for _, v in pairs( hunters ) do
		v:Spawn()
	end
	for _, v in pairs( props ) do
		v:Spawn()
	end

	roundState = ROUND_START
end

local function StartRound()
	curRound = curRound + 1
	roundStartTime = CurTime()
	hook.Call( "OBJHUNT_RoundStart" )
	roundState = ROUND_IN
end

local function InRound()
	local roundTime = CurTime() - roundStartTime
	-- make sure we have not gone over time
	if( roundTime >= OBJHUNT_ROUND_TIME ) then
		roundState = ROUND_END
		roundEndTime = CurTime()
		hook.Call( "OBJHUNT_RoundEnd_Props" )
	end

	-- make sure there is at least one living player left per team
	local hunters = GetLivingPlayers(TEAM_HUNTERS)
	local props = GetLivingPlayers(TEAM_PROPS)

	if( #hunters == 0 ) then
		roundState = ROUND_END
		roundEndTime = CurTime()
		hook.Call( "OBJHUNT_RoundEnd_Props" )
	end

	if( #props == 0 ) then
		roundState = ROUND_END
		roundEndTime = CurTime()
		hook.Call( "OBJHUNT_RoundEnd_Hunters" )
	end

end

local function EndRound()
	-- if we've played enough times on this map
	if( curRound >= OBJHUNT_ROUNDS ) then
		hook.Call( "OBJHUNT_RoundLimit" )
		return
	end

	-- make sure we have at least one player on each team
	local hunters = team.GetPlayers(TEAM_HUNTERS)
	local props = team.GetPlayers(TEAM_PROPS)
	if( #props == 0 || #hunters == 0 ) then return end

	-- start the round after we've waiting long enough
	local waitTime = CurTime() - roundEndTime
	if( waitTime >= OBJHUNT_POST_ROUND_TIME ) then
		-- reset the map
		game.CleanUpMap()
		-- swap teams, respawn everyone
		SwapTeams()
		roundState = ROUND_START
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
		roundHandler[roundState]()
	end )
end )

hook.Add( "OBJHUNT_RoundStart", "Round start stuff", function()
	print( "Round "..curRound.." is Starting" )

	-- send data to clients
	SendRoundUpdate( function() return net.Broadcast() end )
end )

hook.Add( "OBJHUNT_RoundEnd_Props", "Handle props winning", function()
	print( "Props win" )
	-- tell all the props that they won, good job props
	SendRoundUpdate( function() return net.Broadcast() end )
	for _, v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTCENTER, "Props Win!" )
	end
end )

hook.Add( "OBJHUNT_RoundEnd_Hunters", "Handle hunters winning", function()
	print( "Hunters win" )
	-- tell all the hunters that they won, good job huners
	SendRoundUpdate( function() return net.Broadcast() end )
	for _, v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTCENTER, "Hunters Win!" )
	end
end )

hook.Add( "OBJHUNT_RoundLimit", "Start map voting", function()
	-- no longer need the round orchestrator
	hook.Remove( "Tick", "Round orchestrator" )

	print( "Map voting should start now" )
end )

hook.Add( "PlayerInitialSpawn", "Send Round data to client", function( ply )
	-- sent to only the player, one time per join thing
	SendRoundUpdate( function() return net.Send( ply ) end )
end)