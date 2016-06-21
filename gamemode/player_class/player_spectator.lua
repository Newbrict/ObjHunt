DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--

PLAYER.DisplayName      = "Spectator"
PLAYER.SetObserverMode  = 6
PLAYER.CanUseFlashlight = false
PLAYER.AvoidPlayers     = false
PLAYER.lastTaunt     = 0.0

function PLAYER:Spawn()
	self.Player:Spectate( OBS_MODE_ROAMING )
end

function PLAYER:Loadout()
	self.Player:RemoveAllAmmo()
end

player_manager.RegisterClass( "player_spectator", PLAYER, "player_default" )