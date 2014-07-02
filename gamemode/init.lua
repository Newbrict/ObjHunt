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
	print_timers( ply )

end

concommand.Add( "chooseTeam", function( ply, _, class )
	player_manager.SetPlayerClass( ply, class[1] )
	ply:KillSilent()
	if( class[1] == "player_hunter" ) then
		ply:SetTeam( TEAM_HUNTERS )--set team to hunters
	elseif( class[1] == "player_prop" ) then
		ply:SetTeam( TEAM_PROPS ) --set team to props
	else
		ply:SetTeam( TEAM_SPECTATOR ) --set team to spectator
	end
	ply:Spawn()

end )


function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
    umsg.Start( "class_selection", ply ) -- Sending a message to the client.
    umsg.End()
end --Ends function	


function GM:ShowSpare1( ply ) -- This hook is called everytime F2 is pressed.
    umsg.Start( "taunt_selection", ply ) -- Sending a message to the client.
    umsg.End()
end --Ends function	

function print_timers( ply )
		umsg.Start( "create_time_panel", ply, intial )
		umsg.End()
		initial=false
end

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
	TEAM_PROPS = 1
	TEAM_HUNTERS = 2
	--this must be problem here teams not being created for some reason???
	team:SetUp( TEAM_PROPS , "Props" , Color( 255, 0, 0 ), true )---should create teams but appears it is not
	team:SetUp( TEAM_HUNTERS , "Hunters" , Color( 0, 255, 0 ), true  )
	team:SetClass( TEAM_PROPS, {"player_prop"})
	team:SetClass( TEAM_HUNTERS, {"player_hunter"})

end

function GM:Initialize()
	initial=true
   timer.Create("round_timer", .8, 0, function()--ask for updated time every .8 seconds instead of every tick like previously
   		for _,ply in pairs( player.GetAll() ) do
			umsg.Start("update_timer", ply)
			umsg.End()
		end
	end)
    --timer that continuously asks for the tome update for each client orginally asked every server tick 
	--however I figured this would increase effciency
	--possibly implemnt only asks for new timer everytime round swithces or starts leave this for now
end
function test()
		for _,ply in pairs( player.GetAll() ) do
		umsg.Start("update_timer", ply)
		umsg.End()
	end
end

function GM:Tick()
	
end
	




