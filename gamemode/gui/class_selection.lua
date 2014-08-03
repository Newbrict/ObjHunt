surface.CreateFont( "Sharp HUD",
{
	font = "Helvetica",
	size = 32,
	weight = 800,
	antialias = true,
	outline = false,
	shadow = true,
})

local function SendTeam( chosen )
	net.Start("Class Selection")
		net.WriteUInt( chosen, 32 )
	net.SendToServer()
end

local function classSelection()
	local padding = 10
	local btnHeight = 30
	local btnWidth  = 80
	local width   = 3*btnWidth + 4*padding
	local height  = btnHeight + 2*padding

	local classPanel = vgui.Create( "DPanel" )
		classPanel:SetSize( width+padding*2, ScrH() )
		classPanel:Center()
		classPanel:SetVisible( true )
		classPanel:SetDrawBackground( false )
		classPanel:MakePopup()

	local prettyPanel = vgui.Create( "DPanel", classPanel )
		prettyPanel:SetPos( padding, padding )
		prettyPanel:SetSize( width, height )
		prettyPanel:Center()

	local hunterBtn = vgui.Create( "DButton", prettyPanel )
		hunterBtn:SetText( "" )
		hunterBtn:SetSize( btnWidth, btnHeight )
		hunterBtn:SetPos( padding, padding )
		hunterBtn.DoClick = function()
			SendTeam( TEAM_HUNTERS )
			classPanel:Remove()
		end

	local propBtn = vgui.Create( "DButton", prettyPanel )
		propBtn:SetText( "" )
		propBtn:SetSize( btnWidth, btnHeight )
		propBtn:SetPos( padding*2 + btnWidth, padding )
		propBtn.DoClick = function()
			SendTeam( TEAM_PROPS )
			classPanel:Remove()
		end

	local specBtn = vgui.Create( "DButton", prettyPanel )
		specBtn:SetText( "" )
		specBtn:SetSize( btnWidth, btnHeight )
		specBtn:SetPos( padding*3 + btnWidth*2, padding )
		specBtn.DoClick = function()
			SendTeam( TEAM_SPECTATOR )
			classPanel:Remove()
		end

	local exitBtn = vgui.Create( "DImageButton", classPanel )
		exitBtn:SetImage( "icon16/cancel.png" )
		exitBtn:SizeToContents()
		local ebw = exitBtn:GetSize()/2
		local px, py = prettyPanel:GetPos()
		exitBtn:SetPos( width + padding - ebw, py - ebw )
		exitBtn.DoClick = function()
			classPanel:Remove()
		end

	classPanel.Paint = function( self, w, h )
		Derma_DrawBackgroundBlur( self, CurTime() )

		surface.SetFont( "Sharp HUD" )
		surface.SetTextColor( 255, 255, 255, 255 )
		local textToDraw = "Select Your Team"
		local tw, th = surface.GetTextSize( textToDraw )
		local px, py = prettyPanel:GetPos()
		surface.SetTextPos(px, py-th)
		surface.DrawText( textToDraw )
	end

	prettyPanel.Paint = function(self,w,h)
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( 0, 0, width, height )
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, 0, width, height )
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

net.Receive("Class Selection", classSelection )
