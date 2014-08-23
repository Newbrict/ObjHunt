surface.CreateFont( "HideFont",
{
	font = "Helvetica",
	size = 256,
	weight = 1000,
	antialias = true,
	outline = false
})

-- the font I will use for info
surface.CreateFont( "InfoFont",
{
	font = "Helvetica",
	size = 16,
	weight = 500,
	antialias = false,
	outline = true
})


local function hideTimerHUD()
	if( !LocalPlayer():Alive() ) then return end
	if( round.state != ROUND_IN ) then return end
	if( !round.startTime ) then return end

	local textToDraw = round.startTime + round.timePad + OBJHUNT_HIDE_TIME - CurTime()
	textToDraw = math.Round( textToDraw, 0 )

	if( textToDraw < 0 ) then return end

	if( LocalPlayer():Team() == TEAM_HUNTERS ) then
		surface.SetFont( "HideFont" )

		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )

		-- Determine some useful coordinates
		local width, height = surface.GetTextSize( textToDraw )
		local startX = ScrW()/2 - width/2
		local startY = ScrH()/2 - height/2

		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos(startX, startY)
		surface.DrawText( textToDraw )
	elseif( LocalPlayer():Team() == TEAM_PROPS ) then
		textToDraw = "Hunters Released in "..textToDraw
		surface.SetFont( "InfoFont" )
		-- Determine some useful coordinates
		local width = surface.GetTextSize( textToDraw )
		local height = 16
		local padding = 5
		local startX = ScrW()/2 - width/2
		local startY = 2*padding

		surface.SetDrawColor( 127, 127, 127, 200 )
		surface.DrawRect(
			startX - padding,
			startY - padding,
			width + 2*padding,
			height + 2*padding
		)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect(
			startX - padding,
			startY - padding,
			width + 2*padding,
			height + 2*padding
		)
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos(startX, startY)
		surface.DrawText( textToDraw )
	end
end

hook.Add( "HUDPaintBackground", "Hide Timer", hideTimerHUD )



