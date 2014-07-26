include( "shared.lua" )

hook.Add( "Initialize", "set defaults", function()
	LocalPlayer().lastPropChange = 0
	LocalPlayer().wantAngleLock = false
	LocalPlayer().wantThirdPerson = true
end )

--[ Prop Updates ]--
net.Receive( "Prop update", function( length )
	if( !LocalPlayer().chosenProp ) then
		-- initialize stuff here
		LocalPlayer().wantThirdPerson = true
	end
	LocalPlayer().chosenProp = LocalPlayer():GetDTEntity(0)
	local tHitboxMax = net.ReadVector()
	local tHitboxMin = net.ReadVector()
	LocalPlayer():SetHull( tHitboxMin, tHitboxMax )
	LocalPlayer():SetHullDuck( tHitboxMin, tHitboxMax )
	LocalPlayer().lastPropChange = os.time()
	local propHeight = tHitboxMax.z - tHitboxMin.z
	LocalPlayer().propHeight = propHeight

end )

net.Receive( "Reset Prop", function( length )
	LocalPlayer():ResetHull()
	LocalPlayer().chosenProp      = nil
	LocalPlayer().chosenPropIndex = nil
	LocalPlayer().wantThirdPerson = false
	LocalPlayer().wantAngleLock   = nil
end )

net.Receive( "Prop Angle Lock BROADCAST", function( length )
	local prop = net.ReadEntity()
	local lockStatus = net.ReadBit()
	local propAngle = net.ReadAngle()

	if( !IsValid( prop ) ) then return end

	if( lockStatus == 1 ) then
		prop.angleLock = true
	else
		prop.angleLock = false
	end
	prop:SetAngles( propAngle )
end )

net.Receive( "Prop Angle Snap BROADCAST", function( length )
	local prop = net.ReadEntity()
	local snapStatus = net.ReadBit()

	if( !IsValid( prop ) ) then return end

	if( snapStatus == 1 ) then
		prop.angleSnap = true
	else
		prop.angleSnap = false
	end
end )

round = {}
net.Receive( "Round Update", function()
	round.state     = net.ReadInt(8)
	round.current   = net.ReadInt(8)
	round.startTime = net.ReadInt(32)
	-- pad the local clock so that the time is accurate
	round.timePad   = net.ReadInt(32) - CurTime()

end )

-- disable default hud elements here
function GM:HUDShouldDraw( name )
	if ( name == "CHudHealth" or name == "CHudBattery" ) then
		return false
	end
	return true
end