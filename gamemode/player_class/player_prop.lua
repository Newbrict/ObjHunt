DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--

PLAYER.DisplayName      = "Prop"
PLAYER.WalkSpeed        = 200
PLAYER.RunSpeed         = 400
PLAYER.CanUseFlashlight = false
PLAYER.UseVMHands       = false
PLAYER.AvoidPlayers     = false
PLAYER.MaxHealth        = 100
PLAYER.DuckSpeed        = 0.1
PLAYER.UnDuckSpeed      = 0.1


function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

end

function PLAYER:Spawn()
   self.Player:SetModel( "models/player/odessa.mdl" )
end

player_manager.RegisterClass( "player_prop", PLAYER, "player_default" )