local helpPanel
local padding = 10
local width = math.max( 500, ScrW()/2 )
local height = math.max( 500, ScrH()/1.2 )

local function helpHUD()
	helpPanel = vgui.Create( "DPanel" )
		helpPanel:SetSize( width + padding*4, height + padding*4 )
		helpPanel:Center()
		helpPanel:SetVisible( true )
		helpPanel:SetDrawBackground( false )
		helpPanel:MakePopup()

	local prettyPanel = vgui.Create( "DPanel", helpPanel )
		prettyPanel:SetPos( padding, padding )
		prettyPanel:SetSize( width + padding*2, height + padding*2 )

	local htmlPanel = vgui.Create( "DPanel", prettyPanel )
		htmlPanel:SetPos( padding, padding )
		htmlPanel:SetSize( width, height )

	local html = vgui.Create( "DHTML" , htmlPanel )
		html:Dock( FILL )
		html:SetAllowLua( false )
		html:OpenURL( "http://objhunt.com/" )

	local exitBtn = vgui.Create( "DImageButton", helpPanel )
		exitBtn:SetImage( "icon16/cancel.png" )
		exitBtn:SizeToContents()
		local ebw = exitBtn:GetSize()/2
		exitBtn:SetPos( width + padding*3-ebw,0 )
		exitBtn.DoClick = function()
			helpPanel:Remove()
		end

	-- Painting
	prettyPanel.Paint = function(self,w,h)
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

end

net.Receive( "help", helpHUD )