local function mapTimerHUD()
	-- Read the initial map time from the server
	net.Receive( "Map Time", function( len )
		mapStartTime = net.ReadUInt(32)
	end )

	-- Set up the initial label with filler text
	timerLabel = vgui.Create( "DLabel", DFrame )
	timerLabel:SetText( "Time Spend On Map: Waiting" )
	timerLabel:SizeToContents()
	xOffset = timerLabel:GetWide()
	timerLabel:SetPos( ScrW() - xOffset, 0)
end

local function updateMapTimerHUD()
	timerLabel:SizeToContents()
	timerLabel:SetText( "Time Spend On Map: " .. os.time()-mapStartTime )
	xOffset = timerLabel:GetWide()
	timerLabel:SetPos( ScrW() - xOffset, 0)
end

hook.Add( "Initialize", "Map Timer HUD element", mapTimerHUD )
timer.Create( "Map Timer Update", 1, 0, updateMapTimerHUD )
