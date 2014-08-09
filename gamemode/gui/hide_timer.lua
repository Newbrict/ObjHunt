-- the font I will use for info
surface.CreateFont( "HideFont",
{
	font = "Helvetica",
	size = 256,
	weight = 1000,
	antialias = false,
	outline = false
})

local function hideTimerHUD()
	if( LocalPlayer():Team() != TEAM_HUNTERS ) then return end
	if( !LocalPlayer():Alive() ) then return end
	if( !round.startTime ) then return end

	local textToDraw = round.startTime + round.timePad + OBJHUNT_HIDE_TIME - CurTime()
	textToDraw = math.Round( textToDraw, 0 )

	if( textToDraw < 0 ) then return end

	surface.SetFont( "HideFont" )
	-- Determine some useful coordinates
	local width, height = surface.GetTextSize( textToDraw )
	local startX = ScrW()/2 - width/2
	local startY = ScrH()/2 - height/2

	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos(startX, startY)
	surface.DrawText( textToDraw )
end

hook.Add( "HUDPaint", "Hide Timer", hideTimerHUD )
