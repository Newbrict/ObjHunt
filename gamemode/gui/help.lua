local function helpHUD()
local frame = vgui.Create( "DFrame" )
	frame:SetSize( ScrW()/1.2, ScrH()/1.2 )
	frame:SetTitle( "ObjHunt Help" )
	frame:SetVisible( true )
	frame:SetDraggable( true )
	frame:Center()
	--Fill the form with a html page
	local html = vgui.Create( "DHTML" , frame )
	html:Dock( FILL )
	html:SetAllowLua( false )
	html:OpenURL( "http://google.com" )

	--Enable the webpage to call lua code
	frame:MakePopup()

end

net.Receive( "help", helpHUD )