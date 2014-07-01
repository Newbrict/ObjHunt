include( "shared.lua" )
--intial startup gui probably should be in another file but not farmiliar enough with lua to do that
local Form = vgui.Create( "DFrame" )--works here not in play_hunter?????
	Form:SetPos( 15, 15 ) -- Position form on your monitor
	Form:SetSize( 1200, 600 ) -- Size form
	Form:SetTitle( "Welcome to obj Hunt!" ) -- Form set name
	Form:SetVisible( true ) -- Form rendered ( true or false )
	Form:SetDraggable( false ) -- Form draggable
	Form:ShowCloseButton( true ) -- Show buttons panel
	Form:MakePopup()


local HunterBtn = vgui.Create( "DButton" )
HunterBtn:SetParent( Form )
HunterBtn:SetPos( 40, 100 )
HunterBtn:SetText( "hunter" )
HunterBtn:SetSize( 120, 60 )
HunterBtn.DoClick = function()
     RunConsoleCommand( "say", "hunter selected" ) 
end

local PropBtn = vgui.Create( "DButton" )
PropBtn:SetParent( Form )
PropBtn:SetPos( 40, 200 )
PropBtn:SetText( "prop" )
PropBtn:SetSize( 120, 60 )
PropBtn.DoClick = function()
     RunConsoleCommand( "say", "prop selected" ) 
end

local SpecBtn = vgui.Create( "DButton" )
SpecBtn:SetParent( Form )
SpecBtn:SetPos( 40, 300 )
SpecBtn:SetText( "Spectator" )
SpecBtn:SetSize( 120, 60 )
SpecBtn.DoClick = function()
     RunConsoleCommand( "say", "spectator selected" ) 
end

--attempt to bind taunts and eventually menus also
hook.Add("PlayerStartTaunt", "",test )--why doesnt this work???
local function test()
	print("here")
end
	
