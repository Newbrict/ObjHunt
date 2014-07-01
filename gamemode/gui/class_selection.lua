local Form = vgui.Create( "DFrame" )--works here not in play_hunter?????
	Form:SetPos( ScrW() / 2 - 150, ScrH() / 2 - 50 ) -- Position form on your monitor
	Form:SetTitle( "select a class" )
	Form:SetSize( 400,100 ) -- Size form
	Form:SetVisible( true ) -- Form rendered ( true or false )
	Form:SetDraggable( false ) -- Form draggable
	Form:ShowCloseButton( true ) -- Show buttons panel
	Form:MakePopup()


local HunterBtn = vgui.Create( "DButton" )
HunterBtn:SetParent( Form )
HunterBtn:SetPos( 10, 50 )
HunterBtn:SetText( "hunter" )
HunterBtn:SetSize( 100, 30 )
HunterBtn.DoClick = function()
     RunConsoleCommand( "say", "hunter selected" ) 
end

local PropBtn = vgui.Create( "DButton" )
PropBtn:SetParent( Form )
PropBtn:SetPos( 140, 50 )
PropBtn:SetText( "prop" )
PropBtn:SetSize( 100, 30 )
PropBtn.DoClick = function()
     RunConsoleCommand( "say", "prop selected" ) 
end

local SpecBtn = vgui.Create( "DButton" )
SpecBtn:SetParent( Form )
SpecBtn:SetPos( 270, 50 )
SpecBtn:SetText( "Spectator" )
SpecBtn:SetSize( 100, 30 )
SpecBtn.DoClick = function()
     RunConsoleCommand( "say", "spectator selected" ) 
end