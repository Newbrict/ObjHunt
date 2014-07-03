GM.Name    = "ObjHunt"
GM.Author  = "Newbrict, Pepsi, Maxwellstorm"
GM.Email   = "N/A"
GM.Website = "N/A"

--[[ Add all the files on server/client ]]--
local resources = {}
resources["server"] = { "server" }
resources["shared"] = { "player_class" }
resources["client"] = { "client", "gui" }

local function resourceLoader(dirs, includeFunc)
	for _, addDir in pairs(dirs) do
		print( "-- " .. addDir )
		local csFiles, _ = file.Find( "ObjHunt/gamemode/"..addDir.."/*", "LUA" )
		for _, csFile in ipairs(csFiles) do
		   	includeFunc( addDir.."/"..csFile )
			print( " + " .. csFile )
		end
	end
end

if SERVER then
	print( "Adding Server Side Lua Files..." )
	resourceLoader( resources["server"], include )
	resourceLoader( resources["shared"], function(x) include(x) AddCSLuaFile(x) end )
	resourceLoader( resources["client"], AddCSLuaFile )
else
	print( "Adding Client Side Lua Files..." )
	resourceLoader( resources["shared"], include )
	resourceLoader( resources["client"], include )
end