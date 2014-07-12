-- the font I will use for info
surface.CreateFont( "InfoFont",
{
	font = "Helvetica",
	size = 16,
	weight = 500,
	antialias = false,
	outline = true
})



local function mapTimerHUD()
	local textToDraw = "Time On Map: "
	-- make sure we don't blow it if var is undefined
	textToDraw = textToDraw..os.time() - mapStartTime
	surface.SetFont( "InfoFont" )
	-- Determine some useful coordinates
	local width = surface.GetTextSize( textToDraw )
	local height = 16 
	local padding = 5
	local startX = ScrW() - (width + 2*padding)
	local startY = 1*padding 

	surface.SetDrawColor( 127, 127, 127, 200 )
	surface.DrawRect(
		startX - padding,
		startY - padding,
		width + 2*padding,
		height + 2*padding
	)
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos(startX, startY)
	surface.DrawText( textToDraw )

end




-- get the net message for map time, then load the hud element
net.Receive( "Map Time", function( len )
	mapStartTime = net.ReadUInt(32)

	hook.Add( "HUDPaint", "Map Timer HUD element", mapTimerHUD )
end )

