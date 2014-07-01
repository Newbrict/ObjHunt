include( "shared.lua" )
include("gui/class_selection.lua")
include("gui/taunt_selection.lua")
include("gui/show_team.lua")
include("gui/scoreboard.lua")

--intial startup gui probably should be in another file but not farmiliar enough with lua to do that

--attempt to bind taunts and eventually menus also
hook.Add("PlayerStartTaunt", "",test )--why doesnt this work???
local function test()
	print("here")
end
	

-- third person stuff
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
	
	View.origin = Trace.start + View.angles:Forward() * -Distance * 0.95
	return View
end

hook.Add("CalcView", "Thirdperson CalcView", ThirdPersonCalcView)
hook.Add("ShouldDrawLocalPlayer", "Draw Local Player For Thirdperson", function(ply)
	return player_manager.GetPlayerClass( ply ) == "player_prop"
end )
