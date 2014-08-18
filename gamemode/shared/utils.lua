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
	td.mins = hbMin
	td.maxs = hbMax
	local trace = util.TraceHull( td )

	ent = trace.Entity
	if ent && (ent:IsWorld() || ent:IsValid()) then
		return true
	end

	return false
end