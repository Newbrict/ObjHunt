local pContextPadding = 10
local pContextOpenTime = 0.2
local pContextWidth = 200
local pContextHeight = 300
local pContextX = ScrW() - pContextWidth - pContextPadding
local pContextYOpen = ScrH() - pContextHeight - pContextPadding
local pContextYClose = ScrH() + pContextHeight

local pButtonHeight = 20

local propContextPanel = vgui.Create( "DPanel" )
	propContextPanel:SetPos( ScrW()-pContextWidth, ScrH() + pContextHeight )
	propContextPanel:SetSize( pContextWidth, pContextHeight )

local thirdPersonBtn = vgui.Create( "DButton", propContextPanel)
	thirdPersonBtn:SetText( "Toggle Thirdperson" )
	thirdPersonBtn:SetPos( pContextPadding, pContextPadding )
	thirdPersonBtn:SetSize( pContextWidth - 2*pContextPadding, pButtonHeight)
	thirdPersonBtn.DoClick = function()
		LocalPlayer().wantThirdPerson = !LocalPlayer().wantThirdPerson
	end 

local worldAngleBtn = vgui.Create( "DButton", propContextPanel)
	worldAngleBtn:SetText( "Toggle Angle Lock" )
	worldAngleBtn:SetPos( pContextPadding, pContextPadding*2 + pButtonHeight)
	worldAngleBtn:SetSize( pContextWidth - 2*pContextPadding, pButtonHeight)
	worldAngleBtn.DoClick = function()
		net.Start( "Prop Angle Lock" )
			net.WriteBit( !LocalPlayer().chosenProp.angleLock )
		net.SendToServer()

	end 

hook.Add( "OnContextMenuOpen", "Display the prop context menu", function()
	if( LocalPlayer():Team() != TEAM_PROPS ) then return end

	timer.Destroy( "hide prop context menu" )
	propContextPanel:MoveTo(pContextX,pContextYOpen,pContextOpenTime,0,1)
	propContextPanel:SetVisible( true )
	propContextPanel:MakePopup()
	propContextPanel:SetKeyboardInputEnabled( false )
end )

hook.Add( "OnContextMenuClose", "Close the prop context menu", function()
	if( LocalPlayer():Team() != TEAM_PROPS ) then return end

	propContextPanel:MoveTo(pContextX,pContextYClose,pContextOpenTime,0,1)
	timer.Create("hide prop context menu",pContextOpenTime, 1, function ()
		propContextPanel:SetVisible( false )
	end )
end )