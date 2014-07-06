pContextOpenTime = 0.2
pContextWidth = 200
pContextHeight = 300

propContextPanel = vgui.Create( "DFrame" )
propContextPanel:SetPos( ScrW()-pContextWidth, ScrH() + pContextHeight )
propContextPanel:SetSize( pContextWidth, pContextHeight )
propContextPanel:SetTitle( "Options" )
propContextPanel:SetDraggable( true )
propContextPanel:ShowCloseButton( false )
propContextPanel:SetKeyBoardInputEnabled( false )

hook.Add( "OnContextMenuOpen", "Display the prop context menu", function()
	timer.Destroy( "hide prop context menu" )
	propContextPanel:MoveTo(ScrW()-pContextWidth,ScrH()-pContextHeight,pContextOpenTime,0,1)
	propContextPanel:MakePopup()
	propContextPanel:SetVisible( true )
end )

hook.Add( "OnContextMenuClose", "Close the prop context menu", function()
	propContextPanel:MoveTo(ScrW()-pContextWidth,ScrH()+pContextHeight,pContextOpenTime,0,1)
	timer.Create("hide prop context menu",pContextOpenTime, 1, function ()
		propContextPanel:SetVisible( false )
	end )
end )