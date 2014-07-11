hook.Add("CalcView", "ObjHunt CalcView", function( ply, pos, angles, fov )
	local view = {}
	view.angles = angles
	view.fov = fov
	view.drawviewer = ply.wantThirdPerson

	if( ply.wantThirdPerson ) then
		local trace = {}
		local addToPlayer = Vector(0, 0, ply.propHeight)
		local viewDist = 100
		
		trace.start = ply:GetPos() + addToPlayer
		trace.endpos = trace.start + view.angles:Forward() * -viewDist
		trace.mask = MASK_SOLID_BRUSHONLY
		tr = util.TraceLine(trace)
		
		-- efficient check when not hitting walls
		if(tr.Fraction < 1) then
			viewDist = viewDist * tr.Fraction
		end
		
		view.origin = trace.start + view.angles:Forward() * -viewDist
		ply.viewOrigin = view.origin
		return view
	elseif( ply:Team() == TEAM_PROPS ) then
		view.origin = ply:GetPos() + Vector(0,0,ply.propHeight)
		ply.viewOrigin = view.origin
		return view
	end
end )