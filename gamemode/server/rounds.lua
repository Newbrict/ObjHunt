--[[ Rounds are handled here, obviously ]]--


-- time to wait initially before starting in seconds
local ROUND_WAIT  = 0
local ROUND_START = 1
local ROUND_IN    = 2
local ROUND_END   = 3
local roundState = ROUND_WAIT


local curRound = 0
local roundStartTime = 0
local roundEndTime = 0

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

local function WaitRound()
	-- wait for everyone to connect and what not
	local mapTime = os.time() - mapStartTime
	if( mapTime < OBJHUNT_PRE_ROUND_TIME ) then return end

	-- make sure we have at least one player on each team
	local hunters = team.GetPlayers(TEAM_HUNTERS)
	local props = team.GetPlayers(TEAM_PROPS)
	if( #props == 0 || #hunters == 0 ) then return end

	roundState = ROUND_START
end

local function StartRound()
	curRound = curRound + 1
	roundStartTime = os.time()
	-- send round data to players
	roundState = ROUND_IN
end

local function InRound()
	local roundTime = os.time() - roundStartTime
	-- make sure we have not gone over time
	if( roundTime >= OBJHUNT_ROUND_TIME ) then
		roundState = ROUND_END
		roundEndTime = os.time()
	end

	-- make sure there is at least one living player left per team
	local hunters = GetLivingPlayers(TEAM_HUNTERS)
	local props = GetLivingPlayers(TEAM_PROPS)

	if( #hunters == 0 ) then
		roundState = ROUND_END
		roundEndTime = os.time()
	end

	if( #props == 0 ) then
		roundState = ROUND_END
		roundEndTime = os.time()
	end

end

local function EndRound()
	-- if we've played enough times on this map
	if( curRound >= OBJHUNT_ROUNDS ) then
		-- no longer need the round orchestrator
		hook.Remove( "Tick", "Round orchestrator" )
		-- start callvote stuff here
	end

	-- make sure we have at least one player on each team
	local hunters = team.GetPlayers(TEAM_HUNTERS)
	local props = team.GetPlayers(TEAM_PROPS)
	if( #props == 0 || #hunters == 0 ) then return end

	-- start the round after we've waiting long enough
	local waitTime = os.time() - roundEndTime
	if( waitTime >= OBJHUNT_POST_ROUND_TIME ) then
		roundState = ROUND_START
		-- respawn players here
	end

end

local roundHandler = {}
roundHandler[ROUND_WAIT]  = function() return WaitRound() end 
roundHandler[ROUND_START] = function() return StartRound() end
roundHandler[ROUND_IN] = function() return InRound() end
roundHandler[ROUND_END] = function() return EndRound() end


hook.Add( "Initialize", "Begin round functions", function()
	hook.Add( "Tick", "Round orchestrator", function()
		roundHandler[roundState]()
	end )
end )
