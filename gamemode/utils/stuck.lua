function isStuck( ply )
	local pos = ply:GetPos()
	local ws = game.GetWorld()
	local td = {}
	td.start = pos
	td.endpos = pos
	td.filter = { ply, ply.chosenProp, ws }
	td.mins, td.maxs = ply:GetHitBoxBounds(0,0)

	local trace = util.TraceHull( td )
	
	local ent = trace.Entity 
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
	td.filter = {ply, ply.chosenProp}

	local hbMin, hbMax = prop:GetHitBoxBounds( 0, 0 )
	if( !hbMin || !hbMax ) then return true end

	local hbMin = Vector( math.Round(hbMin.x),math.Round(hbMin.y),math.Round(hbMin.z) )
	local hbMax = Vector( math.Round(hbMax.x),math.Round(hbMax.y),math.Round(hbMax.z) )
	td.mins = hbMin
	td.maxs = hbMax
	local trace = util.TraceHull( td )
	
	local ent = trace.Entity
	if ent && (ent:IsWorld() || ent:IsValid()) then
		return true
	end

	return false
end