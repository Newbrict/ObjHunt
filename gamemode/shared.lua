GM.Name    = "Prop Hunt"
GM.Author  = "Newbrict, TheBerryBeast, Zombie"
GM.Email   = "newbrict@gmail.com"
GM.Website = "www.objhunt.com"

GM.BaseDir = "prop_hunt/gamemode/"

--[[ Add all the files on server/client ]]--
local resources = {}
resources["server"] = { "server" }
resources["shared"] = { "shared","player_class", "autotaunt" }
resources["client"] = { "client", "gui" }

local function resourceLoader(dirs, includeFunc)
	for _, addDir in pairs(dirs) do
		print( "-- " .. addDir )
		local csFiles, _ = file.Find( GM.BaseDir..addDir.."/*", "LUA" )
		for _, csFile in ipairs(csFiles) do
		   	includeFunc( addDir.."/"..csFile )
			print( " + " .. csFile )
		end
	end
end

if SERVER then
	print( "Adding Server Side Lua Files..." )
	resourceLoader( resources["shared"], function(x) include(x) AddCSLuaFile(x) end )
	resourceLoader( resources["server"], include )
	resourceLoader( resources["client"], AddCSLuaFile )
	-- add the taunts in
	for _,t in pairs(PROP_TAUNTS) do
		if file.Exists( "sound/"..t, "MOD" ) then
			resource.AddSingleFile("sound/"..t)
		end
	end
	for _,t in pairs(HUNTER_TAUNTS) do
		if file.Exists( "sound/"..t, "MOD" ) then
			resource.AddSingleFile("sound/"..t)
		end
	end
else
	print( "Adding Client Side Lua Files..." )
	resourceLoader( resources["shared"], include )
	resourceLoader( resources["client"], include )
end

if file.Exists( GM.BaseDir .. "maps/" .. game.GetMap() .. ".lua", "LUA" ) then
	print( "Adding Config Of Current Map..." )
	print( "-- maps" )
	print( " + " .. game.GetMap() .. ".lua" )
	include( "maps/" .. game.GetMap() .. ".lua" )
	if SERVER then AddCSLuaFile( "maps/"..game.GetMap()..".lua" ) end
end

function playerCanBeEnt( ply, ent )
	-- this caused an issue once
	if( !ent || !IsValid( ent ) ) then return false end

	-- make sure we're living props
	if( !ply:Alive() || ply:Team() != TEAM_PROPS ) then return false end

	-- make sure ent is a valid prop type
	if(	!table.HasValue( USABLE_PROP_ENTITIES, ent:GetClass() ) ) then return false end

	-- make sure it's a valid phys object
	if(	!IsValid(ent:GetPhysicsObject()) ) then return false end

	-- make sure we can get the model and class
	if(	!ent:GetClass() || !ent:GetModel() ) then return false end

	-- cooldown on switching props
	if( ply:GetProp():GetModel() != "models/player.mdl" ) then
		if( ply.lastPropChange && os.time() - ply.lastPropChange < PROP_CHOOSE_COOLDOWN ) then
			return false
		end
	end

	if( WouldBeStuck( ply, ent ) ) then return false end

	return true
end

--[[ set up the teams ]]--
function GM:CreateTeams( )
	team.SetUp( TEAM_PROPS , "Props" , TEAM_PROPS_CHAT_COLOR, true )
	team.SetUp( TEAM_HUNTERS , "Hunters" , TEAM_HUNTERS_CHAT_COLOR, true  )
	team.SetUp( TEAM_SPECTATOR , "Spectators" , Color( 127, 127, 127 ), true  )
	team.SetClass( TEAM_PROPS, {"player_prop"})
	team.SetClass( TEAM_HUNTERS, {"player_hunter"})
	team.SetClass( TEAM_SPECTATOR, {"player_spectator"})
	team.SetSpawnPoint( TEAM_PROPS, {"info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_allies"} )
	team.SetSpawnPoint( TEAM_HUNTERS, {"info_player_start", "info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"} )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_start", "info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"} )
end

--[[ some share hooks, disable footsteps and taget id's ]]--
function GM:HUDDrawTargetID()
	return true
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
	if( ply:Team() != TEAM_HUNTERS ) then return true end
end

-- initial collisions for props
function initNoCollide( ent1, ent2 )
	if( !IsValid( ent1 ) || !IsValid( ent2 ) ) then return end
	if( !ent1:IsPlayer() || !ent2:IsPlayer() ) then return end
	if( ent1:Team() != ent2:Team() && !( ent1:IsFrozen() || ent2:IsFrozen() ) ) then return end
	if( ent1:Team() == TEAM_PROPS && ent1.GetProp && IsValid( ent1:GetProp() ) && ent1:GetProp():GetModel() == "models/player.mdl" ) then
		return false
	elseif( ent2:Team() == TEAM_PROPS && ent2.GetProp && IsValid( ent2:GetProp() ) && ent2:GetProp():GetModel() == "models/player.mdl" ) then
		return false
	end
end
hook.Add( "ShouldCollide", "Initial Nocollide For Props", initNoCollide )
