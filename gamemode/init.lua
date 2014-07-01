AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

local resources = {}
resources["server"] = {}
resources["shared"] = {"player_class"}
resources["client"] = {"gui"}

function resourceLoader(dirs, includeFunc)
	for _, addDir in pairs(dirs) do
		print( "-- " .. addDir )
		local csFiles, _ = file.Find( "gamemodes/ObjHunt/gamemode/"..addDir.."/*", "MOD" )
		for _, csFile in ipairs(csFiles) do
		   	includeFunc( addDir.."/"..csFile )
			print( " + " .. csFile )
		end
	end
end

print( "Adding Server Side Lua Files..." )
resourceLoader( resources["server"], include )
resourceLoader( resources["shared"], include )

print( "Adding Client Side Lua Files..." )
resourceLoader( resources["shared"], AddCSLuaFile )
resourceLoader( resources["client"], AddCSLuaFile )

function GM:PlayerInitialSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_spectator" )
end

concommand.Add( "chooseTeam", function( ply, _, class )
	player_manager.SetPlayerClass( ply, class[1] )

	ply:KillSilent()
			if( class[1]== "player_hunter" ) then
			ply:SetTeam( 2 )--set team to hunters
			print("players team is "..team:GetName(2))
		else
			print("set "..ply:GetName().." to props")
			ply:SetTeam( 1 ) --set team to props
			print("players team is "..team:GetName(1))--not working?????
	end
	ply:Spawn()

end )

hook.Add("PlayerSwitchFlashlight","test_hook" ,test)--this is a test works!
 local function test()
 	--print("here")
 end

function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
    umsg.Start( "class_selection", ply ) -- Sending a message to the client.
    umsg.End()
end --Ends function	


function GM:ShowSpare1( ply ) -- This hook is called everytime F2 is pressed.
    umsg.Start( "taunt_selection", ply ) -- Sending a message to the client.
    umsg.End()
end --Ends function	

function GM:PlayerSetModel( ply )
	class = player_manager.GetPlayerClass( ply )

	if( class == "player_hunter" ) then
		ply:SetModel( "models/player/Combine_Super_Soldier.mdl" )
	elseif( class == "player_prop" ) then
		ply:SetModel( "models/player/herecomestheerrorsign.mdl" )
	else
		return
	end
end

function GM:CreateTeams( )
	print("creating teams")--this runs
	--this must be problem here teams not being created for some reason???
	team:SetUp( 1 , "Props" , Color( 255, 0, 0 ), true )---should create teams but appears it is not
	team:SetUp( 2 , "Hunters" , Color( 0, 255, 0 ), true  )

end

function GM:ShowTeam( ply )
	umsg.Start( "show_team", ply )
	umsg.End()
end

