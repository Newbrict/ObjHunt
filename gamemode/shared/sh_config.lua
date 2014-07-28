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
--OBJHUNT_ROUND_TIME = 5

-- Initial waiting time before first round starts
--OBJHUNT_PRE_ROUND_TIME = 30
OBJHUNT_PRE_ROUND_TIME = 10

-- Waiting time before new round starts after first round
--OBJHUNT_POST_ROUND_TIME = 10
OBJHUNT_POST_ROUND_TIME = 5

-- How much time props have before hunters are released
OBJHUNT_HIDE_TIME = 15


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
TEXT_COLOR = Color( 255, 255, 255, 255 )

-- context menu elements
ON_COLOR = Color( 0, 255, 0, 100 )
OFF_COLOR = Color( 255, 0, 0, 100 )

-- HUD elements
HP_COLOR = Color( 255, 0, 0, 150 )
DEPLETED_COLOR = Color( 255, 0, 0, 150 )
FULL_COLOR = Color( 0, 0, 255, 150 )
ROUND_TIME_COLOR = Color( 85, 85, 85, 200 )
