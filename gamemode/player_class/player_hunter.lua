DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--

PLAYER.DisplayName      = "Hunter"
PLAYER.WalkSpeed        = 200
PLAYER.RunSpeed         = 400
PLAYER.CanUseFlashlight = true
PLAYER.AvoidPlayers     = false
PLAYER.MaxHealth        = 100
PLAYER.DuckSpeed        = 0.1
PLAYER.UnDuckSpeed      = 0.1


function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()
	self.Player:GiveAmmo( 256,	"Pistol", 		true )
	self.Player:Give( "weapon_pistol" )

end

player_manager.RegisterClass( "player_hunter", PLAYER, "player_default" )