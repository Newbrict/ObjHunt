DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--

PLAYER.DisplayName       = "Prop"
PLAYER.WalkSpeed         = 222
PLAYER.RunSpeed          = 222
PLAYER.CanUseFlashlight  = false
PLAYER.UseVMHands        = false
PLAYER.AvoidPlayers      = false
PLAYER.TeammateNoCollide = false
PLAYER.MaxHealth         = 100
PLAYER.DuckSpeed         = 0.1
PLAYER.UnDuckSpeed       = 0.1
PLAYER.lastTaunt         = 0.0


function PLAYER:Loadout()
	self.Player:RemoveAllAmmo()
end

function PLAYER:SetupDataTables()
	self.Player:NetworkVar( "Entity", 0, "Prop" );
end

player_manager.RegisterClass( "player_prop", PLAYER, "player_default" )