surface.CreateFont( "AutoTauntFont",
{
	font = "coolvetica",
	size = 30,
	weight = 1000,
	antialias = true,
	outline = false
})

local opacity = .5 * 255
local brightBlue = Color(14, 54, 100, 100)
local brightYellow = Color(150, 54, 100, 100)
local brightRed = Color(255, 54, 100, 100)
local lightGray = Color(80, 80, 80, opacity)
local brightWhite = Color(255, 255, 255, 255)

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function loadExtraHuds()

    --Loads the auto-taunt HUD
    autotauntHud()

    --Loads the allied players HUD
--    alliedPlayersHUD()

end

function validateProp(ply)
    return (ply:IsValid() && ply:Alive() && ply:Team() == TEAM_PROPS )
end

function autotauntHud()

	local ply = LocalPlayer()
	local padding = 60
    local paddingL = 100

    -- Check if the player is valid, alive, and is a prop
	if ( !validateProp(ply) ) then return end

    local radius = 50
    local timer = 30.00
    local timerRadius = 0

	if ply.lastTaunt != nil then
        local tDiff = CurTime() - ply.lastTaunt
		timer = math.Round(ply.autoTauntInterval - tDiff, 0)
        timerRadius = (tDiff/ply.autoTauntInterval) * 50
	end

    local x = surface.ScreenWidth() - paddingL
    local y = surface.ScreenHeight() - padding

    --Set the text Position and Text
    local timertext = tostring(timer)
    if timer <= 0 then
        timertext = "!"
    end
	draw.SimpleText(timertext, "ObjHUDFont", x, y, brightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Auto-Taunt", "AutoTauntFont", x, y - radius, brightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- This is the outer circle
    surface.SetDrawColor(lightGray)
    draw.NoTexture()
    draw.Circle( x, y, radius, radius)

    -- This is the growing inner circle
    local color = nil
    local percentage = timerRadius/radius
    if (percentage > .8) then
        color = brightRed
    elseif (percentage > .6) then
        color = brightYellow
    else
        color = brightBlue
    end
    surface.SetDrawColor(color)
    draw.NoTexture()
    draw.Circle( x, y, timerRadius , radius)

end

local function getViewEnt(ply)
	-- this needs to be here otherwise some people get errors for some unknown reason
	if( ply.viewOrigin == nil || ply.wantThirdPerson == nil ) then return end

	local trace = {}
	trace.mask = MASK_SHOT_HULL
	trace.start = ply.viewOrigin
	if( ply.wantThirdPerson ) then
		trace.endpos = trace.start + ply:GetAngles():Forward() * (THIRDPERSON_DISTANCE+PROP_SELECT_DISTANCE)
	else
		trace.endpos = trace.start + ply:GetAngles():Forward() * (PROP_SELECT_DISTANCE)
	end
	trace.filter = { ply:GetProp() }
	tr = util.TraceLine(trace)
	return tr.Entity
end

function alliedPlayersHUD()

    local ply = LocalPlayer()

    -- Check if the player is valid and alive
    if( !ply:IsValid() || !ply:Alive() ) then return end

    -- Get this player's allies
    local allies = team.GetPlayers(ply:Team())

    -- Loop through all of the allies
    for _,ally in pairs(allies) do
		halo.Add({getViewEnt(ally)}, brightBlue, 1, 1, 2, false, true)
	end
end

hook.Add("HUDPaint", "Load Additional HUDS", loadExtraHuds )
hook.Add("AutoTauntHUDRerender", "Re-render Auto Taunt HUD", autotauntHud )