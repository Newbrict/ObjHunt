AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

resource.AddFile("sound/taunts/jihad.wav") 
for k, v in pairs(ents.FindByClass("prop_physics*")) do
	if IsValid(v:GetPhysicsObject()) then
	v:GetPhysicsObject():Wake()
	end
end


function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_spectator" )
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
		ply:SetModel( "models/player/Combine_Super_Soldier.mdl" )
	elseif( class == "player_prop" ) then
		ply:SetModel( "models/player.mdl" )
	else
		return
	end
end

function GM:CreateTeams( )
	team:SetUp( TEAM_PROPS , "Props" , Color( 255, 0, 0 ), true )
	team:SetUp( TEAM_HUNTERS , "Hunters" , Color( 0, 255, 0 ), true  )
	team:SetClass( TEAM_PROPS, {"player_prop"})
	team:SetClass( TEAM_HUNTERS, {"player_hunter"})
	team:SetSpawnPoint( TEAM_PROPS, {"info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_allies"} )
	team:SetSpawnPoint( TEAM_HUNTERS, {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"} )

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
end )

--[[ Map Time ]]--
hook.Add( "Initialize", "Set Map Time", function() mapStartTime = os.time() end )
hook.Add( "PlayerInitialSpawn", "Send Map Time To New Player", function( ply )
	net.Start( "Map Time" )
	local toSend = ( mapStartTime || os.time() )
	net.WriteUInt( toSend, 32 )
	net.Send( ply )
end )


--[[ sets the players prop, run PlayerCanBeEnt before using this ]]--
function SetPlayerProp( ply, ent )

	local tHitboxMin, tHitboxMax = ent:GetHitBoxBounds( 0, 0 )

	if( !tHitboxMin || !tHitboxMax ) then return false, "Invalid Hull" end

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

	net.Start( "Prop Update" )
		net.WriteVector( tHitboxMax )
		net.WriteVector( tHitboxMin )
		net.WriteEntity( ply.chosenProp )
		net.WriteUInt( ply.lastPropChange, 32 )
	net.Send( ply )

end

--[[ When a player presses +use on a prop ]]--
hook.Add( "PlayerUse", "Players pressed use on ent", function( ply, ent )
	if( !playerCanBeEnt( ply, ent) ) then return end

	local oldHP = ply.chosenProp.health
	SetPlayerProp( ply, ent )
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

	SetPlayerProp( ply, ply.chosenProp )

	-- default prop should be able to step wherever
	ply:SetStepSize( 20 )

end )

hook.Add( "PlayerDisconnected", "Remove ent prop on dc", function( ply )
	RemoveProp( ply )
end )

hook.Add( "PlayerDeath", "Remove ent prop on death", function( ply )
	RemoveProp( ply )
end )

--[[ remove the ent prop ]]--
function RemoveProp( ply )
	if( ply.chosenProp ) then
		ply.chosenProp:Remove()
		ply.chosenProp = nil
	end
end
