local function class_selection()
	local cs_form = vgui.Create( "DFrame" ) -- works here not in play_hunter?????
	cs_form:SetPos( ScrW() / 2 - 200, ScrH() / 2 - 50 ) -- Position form on your monitor
	cs_form:SetTitle( "Select a class" )
	cs_form:SetSize( 380,100) 		  -- Size form
	cs_form:SetVisible( true ) 		  -- Form rendered ( true or false )
	cs_form:SetDraggable( false ) 	  -- Form draggable
	cs_form:ShowCloseButton( true )   -- Show buttons panel
	cs_form.btnMaxim:Hide()
	cs_form.btnMinim:Hide()
	cs_form:MakePopup()


<<<<<<< Updated upstream
	local HunterBtn = vgui.Create( "DButton" )
	HunterBtn:SetParent( cs_form )
	HunterBtn:SetPos( 10, 50 )
	HunterBtn:SetText( "Hunter" )
	HunterBtn:SetSize( 100, 30 )
	HunterBtn.DoClick = function()
		RunConsoleCommand( "chooseTeam", "player_hunter" )
	end

	local PropBtn = vgui.Create( "DButton" )
	PropBtn:SetParent( cs_form )
	PropBtn:SetPos( 140, 50 )
	PropBtn:SetText( "Prop" )
	PropBtn:SetSize( 100, 30 )
	PropBtn.DoClick = function()
		RunConsoleCommand( "chooseTeam", "player_prop" ) 
	end

	local SpecBtn = vgui.Create( "DButton" )
	SpecBtn:SetParent( cs_form )
	SpecBtn:SetPos( 270, 50 )
	SpecBtn:SetText( "Spectator" )
	SpecBtn:SetSize( 100, 30 )
	SpecBtn.DoClick = function()
		RunConsoleCommand( "say", "spectator selected" ) 
	end
end
usermessage.Hook("class_selection", class_selection)
