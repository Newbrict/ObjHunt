local mainPanel
local padding = 10
local deltaTime = 0.2
local width = 200
local height = 300
local posXOpen
local posXClose
local posY
surface.CreateFont( "Toggle Buttons",
{
	font = "Helvetica",
	size = 16,
	weight = 30,
	antialias = false,
	outline = true,
})

local btnHeight = 30

local function DrawContextMenu()

	local totalBtns = 0

	mainPanel = vgui.Create( "DPanel" )
	mainPanel:SetPos( ScrW()-width, ScrH() + height )

	if( LocalPlayer():Team() == TEAM_PROPS ||
		LocalPlayer():Team() == TEAM_HUNTERS ) then
		totalBtns = totalBtns + 1
		local thirdPersonBtn = vgui.Create( "DButton", mainPanel)
		thirdPersonBtn:SetText( "" )
		thirdPersonBtn:SetPos( padding, padding )
		thirdPersonBtn:SetSize( width - 2*padding, btnHeight)
		thirdPersonBtn.DoClick = function()
			LocalPlayer().wantThirdPerson = !LocalPlayer().wantThirdPerson
		end

		-- painting
		thirdPersonBtn.Paint = function(self,w,h)
			local btnColor
			if( LocalPlayer().wantThirdPerson ) then
				btnColor = table.Copy(ON_COLOR)
			else
				btnColor = table.Copy(OFF_COLOR)
			end

			if( thirdPersonBtn:IsHovered() ) then
				btnColor.a = btnColor.a + 20
			end

			surface.SetFont( "Toggle Buttons" )
			surface.SetTextColor( Color( 255,255,255,255 ) )
			local text = "Third Person"
			local tw, th = surface.GetTextSize( text )
			surface.SetTextPos( w/2 - tw/2, h/2 - th/2 )
			surface.DrawText( text )
			surface.SetDrawColor( btnColor )
			surface.DrawRect( 0, 0, w, h)
			surface.SetDrawColor( PANEL_BORDER )
			surface.DrawOutlinedRect( 0, 0, w, h)

		end
	end

	if( LocalPlayer():Team() == TEAM_PROPS ) then
		totalBtns = totalBtns + 1
		local worldAngleBtn = vgui.Create( "DButton", mainPanel)
		worldAngleBtn:SetText( "" )
		worldAngleBtn:SetPos( padding, padding*2 + btnHeight)
		worldAngleBtn:SetSize( width - 2*padding, btnHeight)
		worldAngleBtn.DoClick = function()
			net.Start( "Prop Angle Lock" )
				net.WriteBit( !LocalPlayer().wantAngleLock )
				net.WriteAngle( LocalPlayer():GetProp():GetAngles() )
			net.SendToServer()
		end

		-- painting
		worldAngleBtn.Paint = function(self,w,h)
			local btnColor
			if( LocalPlayer().wantAngleLock ) then
				btnColor = table.Copy(ON_COLOR)
			else
				btnColor = table.Copy(OFF_COLOR)
			end

			if( worldAngleBtn:IsHovered() ) then
				btnColor.a = btnColor.a + 20
			end

			surface.SetFont( "Toggle Buttons" )
			surface.SetTextColor( Color( 255,255,255,255 ) )
			local text = "Angle Lock"
			local tw, th = surface.GetTextSize( text )
			surface.SetTextPos( w/2 - tw/2, h/2 - th/2 )
			surface.DrawText( text )
			surface.SetDrawColor( btnColor )
			surface.DrawRect( 0, 0, w, h)
			surface.SetDrawColor( PANEL_BORDER )
			surface.DrawOutlinedRect( 0, 0, w, h)
		end
	end

	if( LocalPlayer():Team() == TEAM_PROPS ) then
		totalBtns = totalBtns + 1
		local snapAngleBtn = vgui.Create( "DButton", mainPanel)
		snapAngleBtn:SetText( "" )
		snapAngleBtn:SetPos( padding, padding*3 + btnHeight*2)
		snapAngleBtn:SetSize( width - 2*padding, btnHeight)
		snapAngleBtn.DoClick = function()
			if( !IsValid( LocalPlayer():GetProp() ) ) then return end
			net.Start( "Prop Angle Snap" )
				net.WriteBit( !LocalPlayer().wantAngleSnap )
			net.SendToServer()
		end

		-- painting
		snapAngleBtn.Paint = function(self,w,h)
			local btnColor
			if( LocalPlayer().wantAngleSnap ) then
				btnColor = table.Copy(ON_COLOR)
			else
				btnColor = table.Copy(OFF_COLOR)
			end

			if( snapAngleBtn:IsHovered() ) then
				btnColor.a = btnColor.a + 20
			end

			surface.SetFont( "Toggle Buttons" )
			surface.SetTextColor( Color( 255,255,255,255 ) )
			local text = "Angle Snapping"
			local tw, th = surface.GetTextSize( text )
			surface.SetTextPos( w/2 - tw/2, h/2 - th/2 )
			surface.DrawText( text )
			surface.SetDrawColor( btnColor )
			surface.DrawRect( 0, 0, w, h)
			surface.SetDrawColor( PANEL_BORDER )
			surface.DrawOutlinedRect( 0, 0, w, h)
		end
	end

	mainPanel.Paint = function(self,w,h)
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( 0, 0, w, h)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, 0, w, h)
	end

	-- after drawing all the buttons, size the panel
	local nHeight = padding*(totalBtns+1) + btnHeight*totalBtns
	mainPanel:SetSize( width, nHeight )
	posXOpen = ScrW() - width - padding
	posXClose = ScrW() + width
	posY = ScrH()/2 - nHeight/2
end



hook.Add( "OnContextMenuOpen", "Display the context menu", function()
	if( LocalPlayer():Team() != TEAM_PROPS &&
		LocalPlayer():Team() != TEAM_HUNTERS ||
		!LocalPlayer():Alive() ) then return end
	if( mainPanel && mainPanel:IsVisible() ) then
		mainPanel:SetVisible( false )
	end
	DrawContextMenu()

	timer.Destroy( "hide context menu" )
	mainPanel:MoveTo(posXOpen,posY,deltaTime,0,1)
	mainPanel:SetVisible( true )
	mainPanel:MakePopup()
	mainPanel:SetKeyboardInputEnabled( false )
end )

hook.Add( "OnContextMenuClose", "Close the context menu", function()
	if( LocalPlayer():Team() != TEAM_PROPS &&
		LocalPlayer():Team() != TEAM_HUNTERS ||
		!LocalPlayer():Alive() ) then return end

	mainPanel:MoveTo(posXClose,posY,deltaTime,0,1)
	mainPanel:SetKeyboardInputEnabled( true )
	-- make sure it's not open before we kill it
	timer.Destroy( "hide context menu" )
	timer.Create("hide context menu",deltaTime, 1, function ()
		mainPanel:SetVisible( false )
	end )
end )