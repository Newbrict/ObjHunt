local function sendTeam( theTeam )
	net.Start("team selection")
	net.WriteUInt( theTeam, 32 )
	net.SendToServer()
end

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
		hunterBtn:SetText( "hunter" )
		hunterBtn:SetSize( btnWidth, btnHeight )
		hunterBtn:SetPos( 0,0 )
		hunterBtn.DoClick = function()
			sendTeam( TEAM_HUNTERS )
			cSPanel:Remove()
		end

	local propBtn = vgui.Create( "DButton", cSPanel )
		propBtn:SetText( "prop" )
		propBtn:SetSize( btnWidth, btnHeight )
		propBtn:SetPos( btnWidth,0 )
		propBtn.DoClick = function()
			sendTeam( TEAM_PROPS )
			cSPanel:Remove()
		end

	local specBtn = vgui.Create( "DButton", cSPanel )
		specBtn:SetText( "spec" )
		specBtn:SetSize( btnWidth, btnHeight )
		specBtn:SetPos( btnWidth*2,0 )
		specBtn.DoClick = function()
			sendTeam( TEAM_SPECTATOR )
			cSPanel:Remove()
		end

end

net.Receive("team selection", function()
	class_selection()
end )
