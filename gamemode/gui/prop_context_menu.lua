local padding = 10
local deltaTime = 0.2
local width = 200
local height = 300
local posX = ScrW() - width - padding
local posYOpen = ScrH() - height - padding
local posYClose = ScrH() + height
local enableColor = Color( 0, 255, 0, 50 )
local disableColor = Color( 255, 0, 0, 100 )
surface.CreateFont( "Toggle Buttons",
{
	font = "Helvetica",
	size = 16,
	weight = 30,
	antialias = false,
	outline = true,
})

local pButtonHeight = 40

local mainPanel = vgui.Create( "DPanel" )
	mainPanel:SetPos( ScrW()-width, ScrH() + height )
	mainPanel:SetSize( width, height )

local thirdPersonBtn = vgui.Create( "DButton", mainPanel)
	thirdPersonBtn:SetText( "" )
	thirdPersonBtn:SetPos( padding, padding )
	thirdPersonBtn:SetSize( width - 2*padding, pButtonHeight)
	thirdPersonBtn.DoClick = function()
		LocalPlayer().wantThirdPerson = !LocalPlayer().wantThirdPerson
	end 

local worldAngleBtn = vgui.Create( "DButton", mainPanel)
	worldAngleBtn:SetText( "" )
	worldAngleBtn:SetPos( padding, padding*2 + pButtonHeight)
	worldAngleBtn:SetSize( width - 2*padding, pButtonHeight)
	worldAngleBtn.DoClick = function()
		net.Start( "Prop Angle Lock" )
			net.WriteBit( !LocalPlayer().chosenProp.angleLock )
		net.SendToServer()

	end 

local snapAngleBtn = vgui.Create( "DButton", mainPanel)
	snapAngleBtn:SetText( "" )
	snapAngleBtn:SetPos( padding, padding*3 + pButtonHeight*2)
	snapAngleBtn:SetSize( width - 2*padding, pButtonHeight)
	snapAngleBtn.DoClick = function()
		net.Start( "Prop Angle Snap" )
			net.WriteBit( !LocalPlayer().chosenProp.angleSnap )
			net.WriteAngle( LocalPlayer().chosenProp:GetAngles() )
		net.SendToServer()
	end 

-- Painting
mainPanel.Paint = function(self,w,h)
	surface.SetDrawColor( 255,255,255,10 )
	surface.DrawRect( 0, 0, w, h)
	surface.SetDrawColor( 200,200,200,255 )
	surface.DrawOutlinedRect( 0, 0, w, h)
end
worldAngleBtn.Paint = function(self,w,h)
	local btnColor
	if( LocalPlayer().chosenProp.angleLock ) then
		btnColor = table.Copy(enableColor)
	else
		btnColor = table.Copy(disableColor)
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
	surface.SetDrawColor( 200,200,200,255 )
	surface.DrawOutlinedRect( 0, 0, w, h)
end

snapAngleBtn.Paint = function(self,w,h)
	local btnColor
	if( LocalPlayer().chosenProp.angleSnap ) then
		btnColor = table.Copy(enableColor)
	else
		btnColor = table.Copy(disableColor)
	end

	if( snapAngleBtn:IsHovered() ) then
		btnColor.a = btnColor.a + 20	
	end

	surface.SetFont( "Toggle Buttons" )
	surface.SetTextColor( Color( 255,255,255,255 ) )
	local text = "Angle Snaping"
	local tw, th = surface.GetTextSize( text )
	surface.SetTextPos( w/2 - tw/2, h/2 - th/2 )
	surface.DrawText( text )
	surface.SetDrawColor( btnColor )
	surface.DrawRect( 0, 0, w, h)
	surface.SetDrawColor( 200,200,200,255 )
	surface.DrawOutlinedRect( 0, 0, w, h)
end

thirdPersonBtn.Paint = function(self,w,h)
	local btnColor
	if( LocalPlayer().wantThirdPerson ) then
		btnColor = table.Copy(enableColor)
	else
		btnColor = table.Copy(disableColor)
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
	surface.SetDrawColor( 200,200,200,255 )
	surface.DrawOutlinedRect( 0, 0, w, h)
end

hook.Add( "OnContextMenuOpen", "Display the prop context menu", function()
	if( LocalPlayer():Team() != TEAM_PROPS ) then return end

	timer.Destroy( "hide prop context menu" )
	mainPanel:MoveTo(posX,posYOpen,deltaTime,0,1)
	mainPanel:SetVisible( true )
	mainPanel:MakePopup()
	mainPanel:SetKeyboardInputEnabled( false )
end )

hook.Add( "OnContextMenuClose", "Close the prop context menu", function()
	if( LocalPlayer():Team() != TEAM_PROPS ) then return end

	mainPanel:MoveTo(posX,posYClose,deltaTime,0,1)
	timer.Create("hide prop context menu",deltaTime, 1, function ()
		mainPanel:SetVisible( false )
	end )
end )