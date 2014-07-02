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
	if( mapStartTime ) then
		textToDraw = textToDraw..os.time() - mapStartTime
	else
		textToDraw = textToDraw.."..."
	end
	local startX = ScrW() - 200
	local startY = 10
	local padding = 5
	local width = 150 
	local height = 20

	surface.SetDrawColor( 127, 127, 127, 200 )
	surface.DrawRect( startX - padding, startY - padding, width + padding, height + padding )
	surface.SetFont( "InfoFont" )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos(startX, startY)

	surface.DrawText( textToDraw )
end

-- get the net message for map time
hook.Add( "Initialize", "Map Timer HUD element", function()
	net.Receive( "Map Time", function( len )
		mapStartTime = net.ReadUInt(32)
	end )
end )

hook.Add( "HUDPaint", "Map Timer HUD element", mapTimerHUD )
