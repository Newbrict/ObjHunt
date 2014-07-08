function isStuck( ply, ignore )
	local pos = ply:GetPos()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos
	tracedata.filter = ply
	tracedata.mins = ply:OBBMins()
	tracedata.maxs = ply:OBBMaxs()
	local trace = util.TraceHull( tracedata )
	
	ent = trace.Entity
	if ent && (ent:IsWorld() || ent:IsValid()) && ent != ignore then
		return true
	end
	return false
end

function WouldBeStuck( ply, prop )
	local pos = ply:GetPos()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos
	tracedata.filter = {ply, ply.chosenProp}
	local hbMin, hbMax = prop:GetHitBoxBounds( 0, 0 )
	local hbMin = Vector( math.Round(hbMin.x),math.Round(hbMin.y),math.Round(hbMin.z) )
	local hbMax = Vector( math.Round(hbMax.x),math.Round(hbMax.y),math.Round(hbMax.z) )
	tracedata.mins = hbMin
	tracedata.maxs = hbMax
	local trace = util.TraceHull( tracedata )
	
	ent = trace.Entity
	if ent && (ent:IsWorld() || ent:IsValid()) then
		return true
	end

	return false
end