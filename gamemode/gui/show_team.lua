local function show_team()
	local team_form = vgui.Create( "DFrame" ) -- works here not in play_hunter?????
	team_form:SetPos( ScrW() / 2 - 300, ScrH() / 2 - 200 ) -- Position form on your monitor
	team_form:SetTitle( "Select a class" )
	team_form:SetSize( 600,400) 		  -- Size form
	team_form:SetVisible( true ) 		  -- Form rendered ( true or false )
	team_form:SetDraggable( false ) 	  -- Form draggable
	team_form:ShowCloseButton( true )   -- Show buttons panel
	team_form.btnMaxim:Hide()
	team_form.btnMinim:Hide()
	team_form:MakePopup()
	local prop_list = vgui.Create( "DListView")
	prop_list:SetParent( team_form )
	prop_list:AddColumn( "props")
	--prop_list:AddLine( "test" )
	prop_list:SetSize( 300,250 )
	prop_list:SetPos( 10, 50 )
end
usermessage.Hook("show_team", show_team)