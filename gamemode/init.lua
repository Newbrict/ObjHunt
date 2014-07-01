AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

local csDirs = { "player_class" }

print( "Adding Client Side Lua Files..." )


for _, addDir in pairs(csDirs) do
	print( "-- " .. addDir )
	local csFiles, _ = file.Find( "gamemodes/ObjHunt/gamemode/"..addDir.."/*", "MOD" )
	for _, csFile in ipairs(csFiles) do
		AddCSLuaFile( addDir.."/"..csFile )
	   	include( addDir.."/"..csFile )
		print( " + " .. csFile )
	end
end

function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_hunter" )
end

hook.Add("PlayerSwitchFlashlight","test_hook" ,test)--this is a test works!
 local function test()
 	--print("here")
 end

include( "shared.lua" )
