DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--

PLAYER.DisplayName       = "Hunter"
PLAYER.WalkSpeed         = 222
PLAYER.RunSpeed          = 222
PLAYER.CanUseFlashlight  = true
PLAYER.AvoidPlayers      = false
PLAYER.TeammateNoCollide = true
PLAYER.MaxHealth         = 100
PLAYER.DuckSpeed         = 0.1
PLAYER.UnDuckSpeed       = 0.1
PLAYER.lastTaunt         = 0.0

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()
	self.Player:GiveAmmo( 256,	"Pistol", true )
	self.Player:GiveAmmo( 256, "SMG1" )
	self.Player:GiveAmmo( 64, "Buckshot" )
	self.Player:GiveAmmo( 24, "357" )
	self.Player:Give( "weapon_crowbar" )
	self.Player:Give( "weapon_pistol" )
	self.Player:Give( "weapon_smg1" )
	self.Player:Give( "weapon_shotgun" )
	self.Player:Give( "item_ar2_grenade" )
	self.Player:Give( "weapon_frag" )
	self.Player:Give( "weapon_357" )

end

player_manager.RegisterClass( "player_hunter", PLAYER, "player_default" )
