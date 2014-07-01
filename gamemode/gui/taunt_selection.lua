local function taunt_selection()
	local t_form = vgui.Create( "DFrame" ) -- works here not in play_hunter?????
	t_form:SetPos( ScrW() / 2 - 200, ScrH() / 2 - 50 ) -- Position form on your monitor
	t_form:SetTitle( "PLay a taunt!" )
	t_form:SetSize( 380,100) 		  -- Size form
	t_form:SetVisible( true ) 		  -- Form rendered ( true or false )
	t_form:SetDraggable( false ) 	  -- Form draggable
	t_form:ShowCloseButton( true )   -- Show buttons panel
	t_form.btnMaxim:Hide()
	t_form.btnMinim:Hide()
	t_form:MakePopup()

	local PlayBtn = vgui.Create( "DButton" )
	PlayBtn:SetParent( t_form )
	PlayBtn:SetPos( 10, 50 )
	PlayBtn:SetText( "PLay" )
	PlayBtn:SetSize( 100, 30 )

	
	PlayBtn.DoClick = function()
		--sound.Play("vo/npc/female01/yeah02.wav", Vector(839.750000, 720.000000, -79.000000), 75, 100, 1)
		sound.Play("vo/npc/female01/yeah02.wav", LocalPlayer():GetPos(), 75, 100, 1)
	end


end
usermessage.Hook("taunt_selection", taunt_selection)
