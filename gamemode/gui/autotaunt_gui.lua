surface.CreateFont("MyFonts", {
	font = "Arial", 
	size = 13, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false, 
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

function autoTauntHUD(ply)
    if ply == nil then
	    ply = LocalPlayer()
    else
        print( "Not Nil!" )
    end
	local padding = 200

	if( !ply:IsValid() ) then return end

	if (ply:Alive() && ply:Team() == TEAM_PROPS) then
        local radius = 50
        local timer = 30.00
        local timerRadius = 0
        local players = team.GetPlayers(TEAM_PROPS)
--	    for _,ply in pairs(players) do
--            print( "Setting the timer", CurTime(), ply:GetName(), ply.lastTauntTime)
--	    end
	    if ply.lastTauntTime != nil then
		    timer = math.Round(ply.autoTauntInterval - (CurTime() - ply.lastTauntTime), 0)
            timerRadius = ((CurTime() - ply.lastTauntTime)/ply.autoTauntInterval) * 50
	    end

        local x = surface.ScreenWidth() - padding
        local y = surface.ScreenHeight() - padding

        --Set the text Position and Text
	    draw.SimpleText(timer, "ObjHUDFont", x, y, brightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
--        draw.Text(timer, "ObjHUDFont", {x,y}, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, brightWhite)

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
end
hook.Add("HUDPaint", "Auto Taunt HUD", autoTauntHUD )
hook.Add("AutoTauntHUDRerender", "Re-render Auto Taunt HUD", autoTauntHUD )