GM.Name    = "ObjHunt"
GM.Author  = "Newbrict, Pepsi, Maxwellstorm"
GM.Email   = "N/A"
GM.Website = "N/A"

DeriveGamemode("PolyBase")

--[[ Add all the files on server/client ]]--
local resources = {}
resources["server"] = { "server" }
resources["shared"] = { "shared","player_class","utils" }
resources["client"] = { "client", "gui" }

local function resourceLoader(dirs, includeFunc)
	for _, addDir in pairs(dirs) do
		print( "-- " .. addDir )
		local csFiles, _ = file.Find( "ObjHunt/gamemode/"..addDir.."/*", "LUA" )
		for _, csFile in ipairs(csFiles) do
		   	includeFunc( addDir.."/"..csFile )
			print( " + " .. csFile )
		end
	end
end

if SERVER then
	print( "Adding Server Side Lua Files..." )
	resourceLoader( resources["server"], include )
	resourceLoader( resources["shared"], function(x) include(x) AddCSLuaFile(x) end )
	resourceLoader( resources["client"], AddCSLuaFile )
else
	print( "Adding Client Side Lua Files..." )
	resourceLoader( resources["shared"], include )
	resourceLoader( resources["client"], include )
end

function playerCanBeEnt( ply, ent )
	-- make sure we're living props
	if( !ply:Alive() || ply:Team() != TEAM_PROPS ) then return false end

	-- make sure ent is a valid prop type
	if(	!table.HasValue( USABLE_PROP_ENTITIES, ent:GetClass() ) ) then return false end

	-- make sure it's a valid phys object
	if(	!IsValid(ent:GetPhysicsObject()) ) then return false end

	-- make sure we can get the model and class
	if(	!ent:GetClass() || !ent:GetModel() ) then return false end

	-- cooldown on switching props
	if( ply.chosenProp:GetModel() != "models/player.mdl" ) then
		if( ply.lastPropChange && os.time() - ply.lastPropChange < PROP_CHOOSE_COOLDOWN ) then
			return false
		end
	end

	if( WouldBeStuck( ply, ent ) ) then return false end 

	return true
end

--[[ set up the teams ]]--
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

--[[ some share hooks, disable footsteps and taget id's ]]--
function GM:HUDDrawTargetID() 
	return true
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 
	if( ply:Team() != TEAM_HUNTERS ) then return true end
end

function LerpColor(frac,from,to)
	return Color(
		Lerp(frac,from.r,to.r),
		Lerp(frac,from.g,to.g),
		Lerp(frac,from.b,to.b),
		Lerp(frac,from.a,to.a)
	)
end