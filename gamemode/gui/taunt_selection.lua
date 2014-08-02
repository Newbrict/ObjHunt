local function playTaunt( taunt )
	-- only play if the last taunt has ended
	if( CurTime() < LocalPlayer().lastTaunt + LocalPlayer().lastTauntDuration ) then return end

	net.Start( "Taunt Selection" )
		net.WriteString( taunt )
	net.SendToServer()
	LocalPlayer().lastTaunt = CurTime()
	LocalPlayer().lastTauntDuration = SoundDuration( taunt )
end

local function tauntSelection()
	if( LocalPlayer():Team() != TEAM_PROPS ) then return end

	local padding = 10

	local width = 250
	local height = 200

	local btnWidth = width
	local btnHeight = 50

	local tauntPanel = vgui.Create( "DPanel" )
		tauntPanel:SetSize( width + padding*4, height + padding*5 + btnHeight )
		tauntPanel:Center()
		tauntPanel:SetVisible( true )
		tauntPanel:SetDrawBackground( false )
		tauntPanel:MakePopup()

	local prettyPanel = vgui.Create( "DPanel", tauntPanel )
		prettyPanel:SetPos( padding, padding )
		prettyPanel:SetSize( width + padding*2, height + padding*3 + btnHeight )

	local exitBtn = vgui.Create( "DImageButton", tauntPanel )
		exitBtn:SetImage( "icon16/cancel.png" )
		exitBtn:SizeToContents()
		local ebw = exitBtn:GetSize()/2
		exitBtn:SetPos( width + padding*3-ebw, padding-ebw )
		exitBtn.DoClick = function()
			tauntPanel:Remove()
		end

	local tauntList = vgui.Create( "DListView", prettyPanel )
		tauntList:SetMultiSelect( false )
		tauntList:SetSize( width, height )
		tauntList:SetPos( padding, padding )
		tauntList:AddColumn( "Select A Taunt" )
		for k, v in pairs( TAUNTS ) do
			tauntList:AddLine( k, v )
		end
		tauntList.OnClickLine = function(parent, line, isSelected)
			tauntPanel:SetVisible( false )
			playTaunt( line:GetValue(2) )
		end

	local randomBtn = vgui.Create( "DButton", prettyPanel )
		randomBtn:SetText( "" )
		randomBtn:SetSize( btnWidth, btnHeight )
		randomBtn:SetPos( padding, height + padding*2 )
		randomBtn.DoClick = function()
			tauntPanel:SetVisible( false )
			playTaunt( table.Random( TAUNTS ) )
		end

	-- Painting
	prettyPanel.Paint = function(self,w,h)
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	randomBtn.Paint = function(self,w,h)
		local btnColor = Color( 0, 0, 255, 100 )

		if( randomBtn:IsHovered() ) then
			btnColor.a = btnColor.a + 50
		end

		surface.SetFont( "Toggle Buttons" )
		surface.SetTextColor( Color( 255,255,255,255 ) )
		local text = "Play A Random Taunt"
		local tw, th = surface.GetTextSize( text )
		surface.SetTextPos( w/2 - tw/2, h/2 - th/2 )
		surface.DrawText( text )
		surface.SetDrawColor( btnColor )
		surface.DrawRect( 0, 0, w, h)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, 0, w, h)
	end

end
net.Receive("Taunt Selection", tauntSelection)
