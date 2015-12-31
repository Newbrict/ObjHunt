local padding = 10
local width = 250
local height = 200
local btnWidth = width
local btnHeight = 50
local tauntPanel
local pitchSlider

local function playTaunt( taunt, pitch )
	if( !LocalPlayer().nextTaunt ) then
		LocalPlayer().nextTaunt = 0
	end

	-- only play if the last taunt has ended
	if( CurTime() < LocalPlayer().nextTaunt ) then return end
	if( !LocalPlayer():Alive() ) then return end

	net.Start( "Taunt Selection" )
		net.WriteString( taunt )
		net.WriteUInt( pitch, 8 )
	net.SendToServer()

	pitchSlider:SetValue( pitch )
end


local function tauntSelection()
	if( LocalPlayer():Team() != TEAM_PROPS && LocalPlayer():Team() != TEAM_HUNTERS || !LocalPlayer():Alive() ) then return end
	local TAUNTS
	if( LocalPlayer():Team() == TEAM_PROPS ) then
		TAUNTS = PROP_TAUNTS
	else
		TAUNTS = HUNTER_TAUNTS
	end


	tauntPanel = vgui.Create( "DPanel" )
		tauntPanel:SetSize( width + padding*4, height + padding*5 + btnHeight*2 )
		tauntPanel:Center()
		tauntPanel:SetVisible( true )
		tauntPanel:SetDrawBackground( false )
		tauntPanel:MakePopup()

	local prettyPanel = vgui.Create( "DPanel", tauntPanel )
		prettyPanel:SetPos( padding, padding )
		prettyPanel:SetSize( width + padding*2, height + padding*3 + btnHeight*2 )

	local exitBtn = vgui.Create( "DImageButton", tauntPanel )
		exitBtn:SetImage( "icon16/cancel.png" )
		exitBtn:SizeToContents()
		local ebw = exitBtn:GetSize()/2
		exitBtn:SetPos( width + padding*3-ebw, padding-ebw )
		exitBtn.DoClick = function()
			tauntPanel:Remove()
		end

	pitchSlider = vgui.Create( "DNumSlider", prettyPanel )
		pitchSlider:SetText( "Pitch" )
		pitchSlider:SetMin( TAUNT_MIN_PITCH )
		pitchSlider:SetMax( TAUNT_MAX_PITCH )
		pitchSlider:SetDecimals( 0 )
		pitchSlider:SetValue( LocalPlayer().lastTauntPitch )
		pitchSlider:SetWide( width )
		pitchSlider:SetPos( padding*2, height + btnHeight + padding*3 )

	local tauntList = vgui.Create( "DListView", prettyPanel )
		tauntList:SetMultiSelect( false )
		tauntList:SetSize( width, height )
		tauntList:SetPos( padding, padding )
		tauntList:AddColumn( "Select A Taunt" )
		for k, v in orderedPairs( TAUNTS ) do
			tauntList:AddLine( k, v )
		end
		tauntList.OnClickLine = function(parent, line, isSelected)
			playTaunt( line:GetValue(2), pitchSlider:GetValue() )
		end

	local randomBtn = vgui.Create( "DButton", prettyPanel )
		randomBtn:SetText( "" )
		randomBtn:SetSize( btnWidth, btnHeight )
		randomBtn:SetPos( padding, height + padding*2 )
		randomBtn.DoClick = function()
			local pRange = TAUNT_MAX_PITCH - TAUNT_MIN_PITCH
			playTaunt( table.Random( TAUNTS ), math.random()*pRange + TAUNT_MIN_PITCH )
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

hook.Add( "OnSpawnMenuOpen", "Display the taunt menu", function()
	if( LocalPlayer():Team() != TEAM_PROPS && LocalPlayer():Team() != TEAM_HUNTERS || !LocalPlayer():Alive() ) then return end
	if( tauntPanel && tauntPanel:IsVisible() ) then
		tauntPanel:SetVisible( false )
	end
	tauntSelection()
	tauntPanel:SetVisible( true )
	tauntPanel:MakePopup()
	tauntPanel:SetKeyboardInputEnabled( false )
end )

hook.Add( "OnSpawnMenuClose", "Close the context menu", function()
	if( LocalPlayer():Team() != TEAM_PROPS && LocalPlayer():Team() != TEAM_HUNTERS || !LocalPlayer():Alive() ) then return end
	if( tauntPanel && !tauntPanel:IsVisible() ) then return end
	tauntPanel:SetKeyboardInputEnabled( true )
	tauntPanel:SetVisible( false )
end )
