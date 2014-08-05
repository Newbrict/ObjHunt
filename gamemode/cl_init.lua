include( "shared.lua" )

--[ Prop Updates ]--
net.Receive( "Prop update", function( length )
	-- set up the hitbox
	local tHitboxMax = net.ReadVector()
	local tHitboxMin = net.ReadVector()
	LocalPlayer():SetHull( tHitboxMin, tHitboxMax )
	LocalPlayer():SetHullDuck( tHitboxMin, tHitboxMax )

	-- prop height for views, change time for cooldown
	local propHeight = tHitboxMax.z - tHitboxMin.z
	LocalPlayer().propHeight = propHeight
	LocalPlayer().lastPropChange = CurTime()

	-- initialize stuff here
	if( LocalPlayer().firstProp ) then
		LocalPlayer().wantThirdPerson = true
		LocalPlayer().wantAngleLock = false
		LocalPlayer().wantAngleSnap = false
		LocalPlayer().lastPropChange = 0
		LocalPlayer().nextTaunt = 0
		LocalPlayer().lastTaunt = 0
		LocalPlayer().lastTauntDuration = 1
		LocalPlayer().lastTauntPitch = 100
		LocalPlayer().firstProp = false
	end

end )

net.Receive( "Reset Prop", function( length )
	LocalPlayer():ResetHull()
	LocalPlayer().firstProp       = true
	LocalPlayer().wantThirdPerson = false
	LocalPlayer().wantAngleLock   = nil
end )

net.Receive( "Prop Angle Lock BROADCAST", function( length )
	local ply = net.ReadEntity()
	local lockStatus = net.ReadBit()
	ply.lockedAngle = net.ReadAngle()

	if( lockStatus == 1 ) then
		ply.wantAngleLock = true
	else
		ply.wantAngleLock = false
	end
end )

net.Receive( "Prop Angle Snap BROADCAST", function( length )
	local ply = net.ReadEntity()
	local snapStatus = net.ReadBit()

	if( snapStatus == 1 ) then
		ply.wantAngleSnap = true
	else
		ply.wantAngleSnap = false
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

net.Receive( "Death Notice", function()
	local attacker = net.ReadString()
	local attackerTeam = net.ReadUInt( 16 )
	local verb = net.ReadString()
	local victim = net.ReadString()
	local victimTeam = net.ReadUInt( 16 )

	killicon.AddFont("kill", "Sharp HUD", verb, Color(255,255,255,255))
	GAMEMODE:AddDeathNotice(attacker, attackerTeam, "kill", victim, victimTeam)
end )

net.Receive( "Clear Round State", function()
	LocalPlayer().wantAngleLock = false
	LocalPlayer().wantAngleSnap = false
	for _, v in pairs( player.GetAll() ) do
		v.wantAgnleLock = false
		v.wantAngleSnap = false
	end
end )

-- disable default hud elements here
function GM:HUDShouldDraw( name )
	if ( name == "CHudHealth" or name == "CHudBattery" ) then
		return false
	end
	return true
end
