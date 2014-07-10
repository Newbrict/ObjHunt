function ThirdPersonCalcView(ply, pos, angles, fov)
	if( ply.wantThirdPerson ) then
		local View = {}
		local Trace = {}
		local AddToPlayer = Vector(0, 0, ply.propHeight)
		View.angles = angles
		View.fov = fov
		
		Distance = 100
		
		Trace.start = ply:GetPos() + AddToPlayer
		
		Trace.endpos = Trace.start + View.angles:Forward() * -Distance
		Trace.mask = MASK_SOLID_BRUSHONLY
		tr = util.TraceLine(Trace)
		
		if(tr.Fraction < 1) then
			Distance = Distance * tr.Fraction
		end
		
		View.origin = Trace.start + View.angles:Forward() * -Distance
		ply.viewOrigin = View.origin
		return View
	elseif( ply:Team() == TEAM_PROPS ) then
		local View = {}
		View.angles = angles
		View.fov = fov
		View.origin = ply:GetPos() + Vector(0,0,ply.propHeight)
		ply.viewOrigin = View.origin
		return View
	end
end

hook.Add("CalcView", "Thirdperson CalcView", ThirdPersonCalcView)
hook.Add("ShouldDrawLocalPlayer", "Draw Local Player For Thirdperson", function(ply)
	return ply.wantThirdPerson
end )