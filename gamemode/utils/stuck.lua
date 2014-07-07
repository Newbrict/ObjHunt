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