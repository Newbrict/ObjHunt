function ThirdPersonCalcView(ply, pos, angles, fov)
	local class = player_manager.GetPlayerClass( ply )
	if( class != "player_prop" ) then
		return
	end
	local View = {}
	local Trace = {}
	local AddToPlayer = Vector(0, 0, 60)
	View.angles = angles + Angle( 0, 0, 0 )
	View.fov = fov
	
	Distance = 150
	
	Trace.start = ply:GetPos() + AddToPlayer
	
	Trace.endpos = Trace.start + View.angles:Forward() * -Distance
	Trace.mask = MASK_SOLID_BRUSHONLY
	tr = util.TraceLine(Trace)
	
	if(tr.Fraction < 1) then
		Distance = Distance * tr.Fraction
	end
	
	View.origin = Trace.start + View.angles:Forward() * -Distance * 0.4
	return View
end

hook.Add("CalcView", "Thirdperson CalcView", ThirdPersonCalcView)
hook.Add("ShouldDrawLocalPlayer", "Draw Local Player For Thirdperson", function(ply)
	return player_manager.GetPlayerClass( ply ) == "player_prop"
end )