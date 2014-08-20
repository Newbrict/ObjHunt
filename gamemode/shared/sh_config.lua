--[[==============]]--
--[[GENERAL CONFIG]]--
--[[==============]]--

-- the team numbers ( this value generally should not have to be changed )
TEAM_PROPS      = 1
TEAM_HUNTERS    = 2

-- the default player models
TEAM_PROPS_DEFAULT_MODEL = "models/player/kleiner.mdl"
TEAM_HUNTERS_DEFAULT_MODEL = "models/player/combine_super_soldier.mdl"

-- the maximum difference between the number of players for each team
MAX_TEAM_NUMBER_DIFFERENCE = 2

-- Number of rounds per map
OBJHUNT_ROUNDS = 4

-- Length of each round in seconds
OBJHUNT_ROUND_TIME = 300

-- Initial waiting time before first round starts
OBJHUNT_PRE_ROUND_TIME = 30

-- Waiting time before new round starts after first round
OBJHUNT_POST_ROUND_TIME = 5

-- How much time props have before hunters are released
OBJHUNT_HIDE_TIME = 30

-- Can players talk between teams or only amongst?
DISABLE_GLOBAL_CHAT = false

-- Round constants
ROUND_WAIT  = 0
ROUND_START = 1
ROUND_IN    = 2
ROUND_END   = 3

-- The minimum Z height that the props view will be set to
VIEW_MIN_Z = 5

-- the default hitbox for the initial prop
PROP_DEFAULT_HB_MIN = Vector( -10,-10,0 )
PROP_DEFAULT_HB_MAX = Vector( 10,10,35 )

-- the default scale for the initial prop
PROP_DEFAULT_SCALE = 0.5

-- the scale for the props chosen by the player
PROP_CHOSEN_SCALE = 1

-- the time in seconds the prop has to wait before they can change prop
PROP_CHOOSE_COOLDOWN = 5

-- the maximum distance at which a prop can be selected
PROP_SELECT_DISTANCE = 150

-- this value should be left alone
PROP_DEFAULT_DENSITY = 0.0025879917184265

-- the maximum distance from the player the camera will render when in third person
THIRDPERSON_DISTANCE = 100

-- entities that are capable of being chosen by props
USABLE_PROP_ENTITIES = {
	"prop_physics",
	"prop_physics_multiplayer"
}

BANNED_PROPS = {
	"models/props/cs_office/tv_plasma.mdl",
	"models/props/cs_office/fire_extinguisher.mdl",
	"models/props/cs_office/snowman_arm.mdl",
	"models/props/cs_assault/money.mdl",
	"models/props/cs_assault/dollar.mdl",
	"models/props_c17/door01_left.mdl",
	"models/props_c17/signpole001.mdl"
}

--[[=====================]]--
--[[COLORS AND HUD CONFIG]]--
--[[=====================]]--

-- halos around props
GOOD_HOVER_COLOR = Color(0,255,0,255)
BAD_HOVER_COLOR = Color(255,0,0,255)

-- general look and feel of gui
PANEL_FILL = Color(200,200,200,20)
PANEL_BORDER = Color(200,200,200,255)

-- team colors displayed on the scoreboard
PLAYER_LINE_COLOR = Color( 85, 85, 85 )
TEAM_PROPS_COLOR = Color( 255, 0, 0, 100 )
TEAM_HUNTERS_COLOR = Color( 0, 0, 255, 100 )
TEAM_PROPS_CHAT_COLOR = Color( 255, 0, 0, 255 )
TEAM_HUNTERS_CHAT_COLOR = Color( 0, 0, 255, 255 )

-- context menu elements
ON_COLOR = Color( 0, 255, 0, 100 )
OFF_COLOR = Color( 255, 0, 0, 100 )

-- HUD elements
HP_COLOR = Color( 255, 0, 0, 150 )
DEPLETED_COLOR = Color( 255, 0, 0, 150 )
FULL_COLOR = Color( 0, 255, 0, 150 )
ROUND_TIME_COLOR = Color( 85, 85, 85, 200 )
TAUNT_BAR_COLOR = Color( 0, 255, 255, 150 )
TEXT_COLOR = Color( 255, 255, 255, 255 )

--[[============]]--
--[[TAUNT CONFIG]]--
--[[============]]--

-- change within 0 < range < 256
TAUNT_MAX_PITCH = 128
TAUNT_MIN_PITCH = 64

TAUNTS = {}
-- USAGE:
-- TAUNTS["Display Name"] = "taunts/file_name.wav"
TAUNTS["Jihad"]                    = "taunts/jihad.wav"
TAUNTS["Atatatat"]                 = "taunts/atatatat.wav"
TAUNTS["Boom, Headshot!"]          = "taunts/boom_headshot.wav"
TAUNTS["Doh!"]                     = "taunts/doh.wav"
TAUNTS["I Guarantee it"]           = "taunts/guarantee_it.wav"
TAUNTS["LEEROY... JENKINS!"]       = "taunts/leeroy_jenkins.wav"
TAUNTS["Negative"]                 = "taunts/negative.wav"
TAUNTS["Never Do Laundry Again"]   = "taunts/never_again.wav"
TAUNTS["Over 9000"]                = "taunts/over_9000.wav"
TAUNTS["Pingas"]                   = "taunts/pingas.wav"
TAUNTS["Please Come Again"]        = "taunts/please_come_again.wav"
TAUNTS["What do you like to play"] = "taunts/pokemon.wav"
TAUNTS["Vince With Shamwow"]       = "taunts/shamwow.wav"
TAUNTS["This Is SPARTA!"]          = "taunts/sparta.wav"
TAUNTS["Woohoo!"]                  = "taunts/woohoo.wav"
TAUNTS["What you mean flames?"]    = "taunts/flames.wav"
