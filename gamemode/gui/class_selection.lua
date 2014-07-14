surface.CreateFont( "Sharp HUD",
{
	font = "Helvetica",
	size = 32,
	weight = 800,
	antialias = true,
	outline = false,
	shadow = true,
})

local function class_selection()
	local width   = 300
	local height  = 100
	local padding = 10
	local startX  = ScrW()/2 - (width/2)
	local startY  = ScrH()/2 - (height/2) 
	local btnHeight = 30
	local btnWidth  = 80

	local cSPanel = vgui.Create( "DPanel" )
		cSPanel:SetSize( width, height )
		cSPanel:Center()
		cSPanel:SetVisible( true )
		cSPanel:MakePopup()

	local hunterBtn = vgui.Create( "DButton", cSPanel )
		hunterBtn:SetText( "" )
		hunterBtn:SetSize( btnWidth, btnHeight )
		hunterBtn.DoClick = function()
			RunConsoleCommand( "chooseTeam", "player_hunter" )
			cSPanel:SetVisible( false )
		end

	local propBtn = vgui.Create( "DButton", cSPanel )
		propBtn:SetText( "" )
		propBtn:SetSize( btnWidth, btnHeight )
		propBtn.DoClick = function()
			RunConsoleCommand( "chooseTeam", "player_prop" ) 
			cSPanel:SetVisible( false )
		end

	local specBtn = vgui.Create( "DButton", cSPanel )
		specBtn:SetText( "" )
		specBtn:SetSize( btnWidth, btnHeight )
		specBtn.DoClick = function()
			RunConsoleCommand( "chooseTeam", "player_spectator" ) 
			cSPanel:SetVisible( false )
		end

	local exitBtn = vgui.Create( "DImageButton", cSPanel )
		exitBtn:SetImage( "icon16/cancel.png" )
		exitBtn:SizeToContents()
		exitBtn.DoClick = function()
			cSPanel:Remove()
		end

	cSPanel.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur( self, CurTime() )


		surface.SetFont( "Sharp HUD" )
		surface.SetTextColor( 255, 255, 255, 255 )
		local textToDraw = "Select Your Team"
		local tw, th = surface.GetTextSize( textToDraw )
		surface.SetTextPos(0, 0)
		surface.DrawText( textToDraw )
	
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( 0, th,  4*padding + 3*btnWidth, 2*padding + btnHeight )
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, th, 4*padding + 3*btnWidth, 2*padding + btnHeight)

		local ebw = exitBtn:GetSize()/2
		exitBtn:SetPos(4*padding + 3*btnWidth - ebw,th-ebw)
		hunterBtn:SetPos( padding, th + padding )
		propBtn:SetPos( padding*2 + btnWidth, th + padding )
		specBtn:SetPos( padding*3 + btnWidth*2, th + padding )

	end

	hunterBtn.Paint = function(self,w,h)
		local btnColor = table.Copy(TEAM_HUNTERS_COLOR)

		if( hunterBtn:IsHovered() ) then
			btnColor.a = btnColor.a + 50
		end

		surface.SetFont( "Toggle Buttons" )
		surface.SetTextColor( Color( 255,255,255,255 ) )
		local text = "Hunter"
		local tw, th = surface.GetTextSize( text )
		surface.SetTextPos( w/2 - tw/2, h/2 - th/2 )
		surface.DrawText( text )
		surface.SetDrawColor( btnColor )
		surface.DrawRect( 0, 0, w, h)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, 0, w, h)
	end

	propBtn.Paint = function(self,w,h)
		local btnColor = table.Copy(TEAM_PROPS_COLOR)

		if( propBtn:IsHovered() ) then
			btnColor.a = btnColor.a + 50
		end

		surface.SetFont( "Toggle Buttons" )
		surface.SetTextColor( Color( 255,255,255,255 ) )
		local text = "Prop"
		local tw, th = surface.GetTextSize( text )
		surface.SetTextPos( w/2 - tw/2, h/2 - th/2 )
		surface.DrawText( text )
		surface.SetDrawColor( btnColor )
		surface.DrawRect( 0, 0, w, h)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, 0, w, h)
	end

	specBtn.Paint = function(self,w,h)
		local btnColor = table.Copy( PANEL_FILL )

		if( specBtn:IsHovered() ) then
			btnColor.a = btnColor.a + 50
		end

		surface.SetFont( "Toggle Buttons" )
		surface.SetTextColor( Color( 255,255,255,255 ) )
		local text = "Spectator"
		local tw, th = surface.GetTextSize( text )
		surface.SetTextPos( w/2 - tw/2, h/2 - th/2 )
		surface.DrawText( text )
		surface.SetDrawColor( btnColor )
		surface.DrawRect( 0, 0, w, h)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, 0, w, h)
	end

end
usermessage.Hook("class_selection", class_selection)
