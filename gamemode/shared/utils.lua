function GetLivingPlayers( onTeam )
	local allPly = team.GetPlayers( onTeam )
	local livingPly = {}
	for _, v in pairs(allPly) do
		if( IsValid(v) && v:Alive() ) then
			livingPly[#livingPly + 1] = v
		end
	end
	return livingPly
end

-- now realised there is a flag to ignore ws, don't use this it's not done....
function isStuck( ply )
	local pos = ply:GetPos()
	local ws = game.GetWorld()
	local td = {}
	td.start = pos
	td.endpos = pos
	td.filter = { ply, ply.chosenProp, ws }
	td.mins, td.maxs = ply:GetHitBoxBounds(0,0)

	local trace = util.TraceHull( td )

	ent = trace.Entity
	-- should never be stuck in world
	--if ent && (ent:IsWorld() || ent:IsValid()) then

	if( ent && ent:IsValid() ) then
		return true
	end

	return false
end

function WouldBeStuck( ply, prop )
	local pos = ply:GetPos()
	local td = {}
	td.start = pos
	td.endpos = pos
	td.filter = { ply, ply:GetProp() }
	local hbMin, hbMax = prop:GetHitBoxBounds( 0, 0 )
	if( !hbMin || !hbMax ) then return true end
	local hbMin = Vector( math.Round(hbMin.x),math.Round(hbMin.y),math.Round(hbMin.z) )
	local hbMax = Vector( math.Round(hbMax.x),math.Round(hbMax.y),math.Round(hbMax.z) )
	-- Adjust height
	hbMax = Vector(hbMax.x,hbMax.y,hbMax.z + hbMax.z)
	hbMin = Vector(hbMin.x,hbMin.y,0)

	td.mins = hbMin
	td.maxs = hbMax
	local trace = util.TraceHull( td )

	ent = trace.Entity
	if ent && (ent:IsWorld() || ent:IsValid()) then
		return true
	end

	return false
end

function LerpColor(frac,from,to)
	return Color(
		Lerp(frac,from.r,to.r),
		Lerp(frac,from.g,to.g),
		Lerp(frac,from.b,to.b),
		Lerp(frac,from.a,to.a)
	)
end

function TeamString(teamID)
	if(teamID == TEAM_HUNTERS) then
		return "Hunters"
	elseif(teamID == TEAM_PROPS) then
		return "Props"
	elseif(teamID == TEAM_SPECTATOR) then
		return "Spectators"
	else
		return "UNKNOWN"
	end
end


--[[
Ordered table iterator, allow to iterate on the natural order of the keys of a
table.

Example:
]]

function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end