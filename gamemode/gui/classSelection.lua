local Form = vgui.Create( "DFrame" )--works here not in play_hunter?????
	Form:SetPos( ScrW() / 2 - 70, ScrH() / 2 - 125 ) -- Position form on your monitor
	Form:SetSize( 140,250 ) -- Size form
	Form:SetVisible( true ) -- Form rendered ( true or false )
	Form:SetDraggable( false ) -- Form draggable
	Form:ShowCloseButton( true ) -- Show buttons panel
	Form:MakePopup()


local HunterBtn = vgui.Create( "DButton" )
HunterBtn:SetParent( Form )
HunterBtn:SetPos( 10, 10 )
HunterBtn:SetText( "hunter" )
HunterBtn:SetSize( 100, 30 )
HunterBtn.DoClick = function()
     RunConsoleCommand( "say", "hunter selected" ) 
end

local PropBtn = vgui.Create( "DButton" )
PropBtn:SetParent( Form )
PropBtn:SetPos( 10, 70 )
PropBtn:SetText( "prop" )
PropBtn:SetSize( 100, 30 )
PropBtn.DoClick = function()
     RunConsoleCommand( "say", "prop selected" ) 
end

local SpecBtn = vgui.Create( "DButton" )
SpecBtn:SetParent( Form )
SpecBtn:SetPos( 10, 130 )
SpecBtn:SetText( "Spectator" )
SpecBtn:SetSize( 100, 30 )
SpecBtn.DoClick = function()
     RunConsoleCommand( "say", "spectator selected" ) 
end