-- the font I will use for info
surface.CreateFont( "InfoFont",
{
	font = "Helvetica",
	size = 16,
	weight = 500,
	antialias = false,
	outline = true
})


--draw round timer in top left corner
local function roundTimerHUD()
	
	-- make sure we don't blow it if var is undefined
	local textToDraw = "Time left until next round: "
	--still trying to figure out way to specify if round has started or not but right now this timer restes ti self every 60 seconds
	local time = roundWaitTime - ( (os.time() - mapStartTime) % roundWaitTime )
	local textToDraw = textToDraw..time
	surface.SetFont( "InfoFont" )
	-- Determine some useful coordinates
	local width = surface.GetTextSize( textToDraw )
	local height = 16 
	local padding = 5
	local startX = 2*padding 
	local startY = 2*padding 

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
	--if(time == 0) then
	--	roundGoing = roundGoing*-1
	--end


end


-- get the net message for map time, then load the hud element
net.Receive( "round Time", function( len )
	mapStartTime = net.ReadUInt(32)
	roundWaitTime = net.ReadUInt(32)
	roundsPlayed = net.ReadUInt(32)
	--roundGoing = net.ReadUInt(32)

	hook.Add( "HUDPaint", "round Timer HUD element", roundTimerHUD )
end )