GM.Name    = "ObjHunt"
GM.Author  = "Newbrict, Pepsi, Maxwellstorm"
GM.Email   = "N/A"
GM.Website = "N/A"

if SERVER then
	include("shared/sh_config.lua")
	AddCSLuaFile("shared/sh_config.lua")

	include("player_class/player_hunter.lua")
	include("player_class/player_prop.lua")
	include("player_class/player_spectator.lua")
	AddCSLuaFile("player_class/player_hunter.lua")
	AddCSLuaFile("player_class/player_prop.lua")
	AddCSLuaFile("player_class/player_spectator.lua")

	AddCSLuaFile("gui/class_selection.lua")
	AddCSLuaFile("client/views.lua")
else
	include("player_class/player_hunter.lua")
	include("player_class/player_prop.lua")
	include("player_class/player_spectator.lua")
	include("gui/class_selection.lua")
	include("client/views.lua")
	include("shared/sh_config.lua")

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
