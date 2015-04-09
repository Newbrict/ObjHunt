include( "shared.lua" )

local function KillTaunt( ply )
	if( ply.tauntPatch && ply.tauntPatch:IsPlaying() ) then
		ply.tauntPatch:Stop()
	end
end

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
    LocalPlayer().lastTauntTime = CurTime()

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
        LocalPlayer().autoTauntInterval = 30
	end

end )

net.Receive( "Reset Prop", function( length )
	-- taunt default
	LocalPlayer().nextTaunt = 0
	LocalPlayer().lastTaunt = 0
	LocalPlayer().lastTauntDuration = 1
	LocalPlayer().lastTauntPitch = 100

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

net.Receive( "Taunt Selection", function()
	local taunt = net.ReadString()
	local pitch = net.ReadUInt( 8 )
	local id = net.ReadUInt( 8 )
	local ply = player.GetByID( id )
    local lastTauntTime = net.ReadFloat( 8 )
    local autoTauntInterval = net.ReadFloat( 8 )

	if not IsValid( ply ) then return end

	if( ply == LocalPlayer() ) then
		ply.nextTaunt = CurTime() + ( SoundDuration( taunt ) * (100/pitch) )
		ply.lastTaunt = CurTime()
		ply.lastTauntPitch = pitch
		ply.lastTauntDuration = SoundDuration( taunt ) * (100/pitch)
        ply.lastTauntTime = lastTauntTime
        ply.autoTauntInterval = autoTauntInterval
	end

	local s = Sound(taunt)

	-- need to delete the gc function so my ents remain
	ply.tauntPatch = CreateSound( ply, s )
	if( ply.tauntPatch.__gc ) then
		local smeta = getmetatable(ply.tauntPatch)
		smeta.__gc = function()
		end
	end

	ply.tauntPatch:SetSoundLevel( 100 )
	ply.tauntPatch:PlayEx(1, pitch)

	-- old not stoppable method
	--EmitSound( taunt , ply:GetPos(), id, CHAN_AUTO, 1, 100, 2, pitch )
end )

net.Receive( "AutoTaunt Update", function()
    local lastTauntTime = net.ReadFloat( 8 )
    local autoTauntInterval = net.ReadFloat( 8 )
    if( ply == LocalPlayer() ) then
        ply.lastTauntTime = lastTauntTime
        ply.autoTauntInterval = autoTauntInterval
	end
end)

net.Receive( "Player Death", function()
	local id = net.ReadUInt( 8 )
	local ply = player.GetByID( id )
	KillTaunt( ply )
end )

-- disable default hud elements here
function GM:HUDShouldDraw( name )
	if ( name == "CHudHealth" or name == "CHudBattery" ) then
		return false
	end
	return true
end

