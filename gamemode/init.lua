AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

resource.AddFile("sound/taunts/jihad.wav") 

function GM:PlayerInitialSpawn( ply )
	print( "Start PlayerInitialSpawnHook, player's team:" )
	print( ply:Team() )
	ply:SetTeam( TEAM_SPECTATOR )
	player_manager.SetPlayerClass( ply, "player_spectator" )
	print( "End PlayerInitialSpawnHook, player's team:" )
	print( ply:Team() )
	return true

end

function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
    umsg.Start( "class_selection", ply ) -- Sending a message to the client.
    umsg.End()
end	

function GM:ShowSpare1( ply ) -- This hook is called everytime F2 is pressed.
    umsg.Start( "taunt_selection", ply ) -- Sending a message to the client.
    umsg.End()
end	

function GM:PlayerSetModel( ply )
	class = player_manager.GetPlayerClass( ply )
	if( class == "player_hunter" ) then
		ply:SetModel( TEAM_HUNTERS_DEFAULT_MODEL )

		-- default
		ply:SetViewOffset( Vector(0,0,64) )
	elseif( class == "player_prop" ) then
		ply:SetModel( TEAM_PROPS_DEFAULT_MODEL )

		-- this fixes ent culling when head in ceiling
		ply:SetViewOffset( Vector(0,0,1) )
	else
		return
	end
end

function GM:CreateTeams( )
	team.SetUp( TEAM_PROPS , "Props" , Color( 255, 0, 0 ), true )
	team.SetUp( TEAM_HUNTERS , "Hunters" , Color( 0, 255, 0 ), true  )
	team.SetUp( TEAM_SPECTATOR , "Spectators" , Color( 127, 127, 127 ), true  )
	team.SetClass( TEAM_PROPS, {"player_prop"})
	team.SetClass( TEAM_HUNTERS, {"player_hunter"})
	team.SetClass( TEAM_SPECTATOR, {"player_spectator"})
	team.SetSpawnPoint( TEAM_PROPS, {"info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_allies"} )
	team.SetSpawnPoint( TEAM_HUNTERS, {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"} )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"} )

end

function GM:PlayerShouldTakeDamage( victim, attacker )
	-- non prop falls
	if( victim:Team() == TEAM_HUNTERS && attacker:GetClass() == "worldspawn" ) then
		return true
	end
	return false
end

--[[ All network strings should be precached HERE ]]--
hook.Add( "Initialize", "Precache all network strings", function()
	util.AddNetworkString( "Map Time" )
	util.AddNetworkString( "Prop Update" )
	util.AddNetworkString( "Reset Prop" )
	util.AddNetworkString( "round Time" )
	util.AddNetworkString( "Selected Prop" )
	util.AddNetworkString( "Prop Angle Lock" )
	util.AddNetworkString( "Prop Angle Lock BROADCAST" )
	util.AddNetworkString( "Prop Angle Snap" )
	util.AddNetworkString( "Prop Angle Snap BROADCAST" )
end )

--[[ Map Time ]]--
hook.Add( "Initialize", "Set Map Time", function() 
	mapStartTime = os.time() 
	roundWaitTime = 60
	roundsPlayed = 0
	--roundGoing = -1
end )

hook.Add( "PlayerInitialSpawn", "Send Map Time To New Player", function( ply )
	net.Start( "Map Time" )
	//local toSend = ( mapStartTime || os.time() ) --useless?
	net.Send( ply )
end )

--[[ round time ]]--
hook.Add( "Initialize", "Set round Time", function() 
	mapStartTimeForRound = os.time() 
	roundWaitTime = 60
	roundsPlayed = 0
	--roundGoing = -1
end )

hook.Add( "PlayerInitialSpawn", "Send round Time To New Player", function( ply )
	net.Start( "round Time" )
	local toSend = ( mapStartTimeForRound || os.time() )
	net.WriteUInt( toSend, 32 )
	net.WriteUInt( roundWaitTime, 32)
	net.WriteUInt( roundsPlayed, 32)
	--net.WriteUInt( roundGoing, 32)
	net.Send( ply )
end )

--[[ sets the players prop, run PlayerCanBeEnt before using this ]]--
function SetPlayerProp( ply, ent, scale, hbMin, hbMax )

	local tHitboxMin, tHitboxMax
	if( !hbMin || !hbMax ) then
		tHitboxMin, tHitboxMax = ent:GetHitBoxBounds( 0, 0 )
		if( !tHitboxMin || !tHitboxMax ) then return false, "Invalid Hull" end
	else
		tHitboxMin = hbMin
		tHitboxMax = hbMax
	end

	-- scaling
	ply.chosenProp:SetModelScale( scale, 0)

	ply.chosenProp:SetModel( ent:GetModel() )
	ply.chosenProp:SetSkin( ent:GetSkin() )
	ply.chosenProp:SetSolid( SOLID_BBOX )
	ply.chosenProp:SetAngles( ply:GetAngles() )

	-- we round to reduce getting stuck
	tHitboxMin = Vector( math.Round(tHitboxMin.x),math.Round(tHitboxMin.y),math.Round(tHitboxMin.z) )
	tHitboxMax = Vector( math.Round(tHitboxMax.x),math.Round(tHitboxMax.y),math.Round(tHitboxMax.z) )

	ply:SetHull( tHitboxMin, tHitboxMax )
	ply:SetHullDuck( tHitboxMin, tHitboxMax )
	local tHeight = tHitboxMax.z-tHitboxMin.z

	-- scale steps to prop size
	ply:SetStepSize( math.Round( 4+(tHeight)/4 ) )

	-- give bigger props a bonus for being big
	ply:SetJumpPower( 200 + math.sqrt(tHeight) )

	ply.lastPropChange = os.time()

	-- Update the player's mass to be something more reasonable to the prop
	local phys = ent:GetPhysicsObject()
	if IsValid(ent) and phys:IsValid() then
		ply:GetPhysicsObject():SetMass(phys:GetMass())
	else
		-- Entity doesn't have a physics object so calculate mass
		local density = PROP_DEFAULT_DENSITY
		local volume = (tHitboxMax.x-tHitboxMin.x)*(tHitboxMax.y-tHitboxMin.y)*(tHitboxMax.z-tHitboxMin.z)
		local mass = volume * density

		mass = math.min(100, mass)
		mass = math.max(0, mass)

		ply:GetPhysicsObject():SetMass(mass)
	end

	net.Start( "Prop Update" )
		net.WriteVector( tHitboxMax )
		net.WriteVector( tHitboxMin )
		net.WriteUInt( ply.chosenProp:EntIndex(), 8 )
	net.Send( ply )

end

--[[ When a player presses +use on a prop ]]--
net.Receive( "Selected Prop", function( len, ply )
	local ent = net.ReadEntity()
	
	local tHitboxMin, tHitboxMax = ply.chosenProp:GetHitBoxBounds( 0, 0 )
	if( !playerCanBeEnt( ply, ent) ) then return end
	local oldHP = ply.chosenProp.health
	SetPlayerProp( ply, ent, PROP_CHOSEN_SCALE )
	ply.chosenProp.health = oldHP
end )

--[[ When a player on team_props spawns ]]--
hook.Add( "PlayerSpawn", "Set ObjHunt model", function ( ply )
	if( ply:Team() != TEAM_PROPS ) then return end

	-- make the player invisible
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	ply:SetColor( Color(0,0,0,0) )
	ply:SetBloodColor( DONT_BLEED )
	
	ply.chosenProp = ents.Create("player_prop_ent")
	ply.chosenProp:Spawn()
	ply.chosenProp:SetOwner( ply )
	-- custom initial hb
	SetPlayerProp( ply, ply.chosenProp, PROP_DEFAULT_SCALE, PROP_DEFAULT_HB_MIN, PROP_DEFAULT_HB_MAX )

	-- default prop should be able to step wherever
	ply:SetStepSize( 20 )

end )

--[[ When a player wants to lock world angles on their prop ]]--
net.Receive( "Prop Angle Lock", function( len, ply )
	local lockStatus = net.ReadBit() //equates to false if zero
	local propAngle = net.ReadAngle()

	net.Start( "Prop Angle Lock BROADCAST" )
		net.WriteEntity( ply.chosenProp )
		net.WriteBit( lockStatus ) 
		net.WriteAngle( propAngle ) 
	net.Broadcast()
end )

--[[ When a player wants toggle world angle snapping on their prop ]]--
net.Receive( "Prop Angle Snap", function( len, ply )
	local snapStatus = net.ReadBit() //equates to false if zero

	net.Start( "Prop Angle Snap BROADCAST" )
		net.WriteEntity( ply.chosenProp )
		net.WriteBit( snapStatus ) 
	net.Broadcast()
end )

hook.Add( "PlayerDisconnected", "Remove ent prop on dc", function( ply )
	RemovePlayerProp( ply )
end )

hook.Add( "PlayerDeath", "Remove ent prop on death", function( ply )
	RemovePlayerProp( ply )
end )

--[[ remove the ent prop ]]--
function RemovePlayerProp( ply )
	if( ply.chosenProp ) then
		ply.chosenProp:Remove()
		ply.chosenProp = nil
		ply:ResetHull()
		net.Start( "Reset Prop" )
			-- empty, just used for the hook
		net.Send( ply )
	end
end

function GM:PlayerSelectSpawn( ply )
	local spawns = team.GetSpawnPoints( ply:Team() )
	if( !spawns ) then return false end

    local ret, _ = table.Random( spawns )
    return ret
end