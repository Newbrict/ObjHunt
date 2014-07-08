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

local pTPButt = vgui.Create( "DButton", propContextPanel)
	pTPButt:SetText( "Toggle Thirdperson" )
	pTPButt:SetPos( pContextPadding, pContextPadding )
	pTPButt:SetSize( pContextWidth - 2*pContextPadding, pButtonHeight)
	pTPButt.DoClick = function()
		LocalPlayer().wantThirdPerson = !LocalPlayer().wantThirdPerson
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