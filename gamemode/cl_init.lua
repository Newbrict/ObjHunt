include( "shared.lua" )
include("gui/classSelection.lua")
--intial startup gui probably should be in another file but not farmiliar enough with lua to do that

--attempt to bind taunts and eventually menus also
hook.Add("PlayerStartTaunt", "",test )--why doesnt this work???
local function test()
	print("here")
end
	


