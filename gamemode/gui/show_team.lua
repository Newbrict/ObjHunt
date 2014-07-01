local function show_team()
	print("attempting to get all teams")
	Test = table.ToString(team:GetAllTeams(), "Test") --my created teams not showing up?????
	print("here"..Test)
	--print("team name is "..team:GetName(1))
	for _,ply in pairs(team:GetPlayers( 1 ) ) do
		print( "here" )
  		print(ply:GetName())
     end
	--creat main form
	local team_form = vgui.Create( "DFrame" ) -- works here not in play_hunter?????
	team_form:SetPos( ScrW() / 2 - 300, ScrH() / 2 - 200 ) -- Position form on your monitor
	team_form:SetTitle( "Select a class" )
	team_form:SetSize( 700,400) 		  -- Size form
	team_form:SetVisible( true ) 		  -- Form rendered ( true or false )
	team_form:SetDraggable( false ) 	  -- Form draggable
	team_form:ShowCloseButton( true )   -- Show buttons panel
	team_form.btnMaxim:Hide()
	team_form.btnMinim:Hide()
	team_form:MakePopup()
	
	--create prop team player list
	local prop_list = vgui.Create( "DListView")
	prop_list:SetParent( team_form )
	prop_list:AddColumn( "props")
	--prop_list:AddLine( "test" )
	prop_list:SetSize( 300,250 )
	prop_list:SetPos( 10, 50 )
	
	--create hunter player list
	local hunter_list = vgui.Create( "DListView" )
	hunter_list:SetParent( team_form )
	hunter_list:SetSize( 300,250 )
	hunter_list:SetPos( 350, 50 )
	hunter_list:AddColumn( "hunters" )
end
usermessage.Hook("show_team", show_team)