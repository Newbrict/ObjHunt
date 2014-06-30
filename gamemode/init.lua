AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

local csDirs = { "player_class" }

print( "Adding Client Side Lua Files..." )


for _, addDir in pairs(csDirs) do
	print( "-- " .. addDir )
	local csFiles, _ = file.Find( "gamemodes/ObjHunt/gamemode/"..addDir.."/*", "MOD" )
	for _, csFile in ipairs(csFiles) do
		AddCSLuaFile( addDir.."/"..csFile )
	print( " + " .. csFile )
	end
end

include( "shared.lua" )