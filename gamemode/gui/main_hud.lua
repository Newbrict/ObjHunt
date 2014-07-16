-- the font I will use for info
surface.CreateFont( "ObjHUDFont",
{
	font = "Helvetica",
	size = 16,
	weight = 500,
	antialias = false,
	outline = true
})

local function ObjHUD()
	local ply = LocalPlayer()
	if( !ply:IsValid() || !ply:Alive() ) then return end

	local width = 200 
	local height = 125 
	local padding = 10 
	local iconX = padding
	local barX = padding*2 + 16
	local startY = ScrH() - padding -16

	-- random color just to let the icon draw
	surface.SetDrawColor( PANEL_BORDER )

	-- HP GUI

	-- icon
	local heartMat = Material("icon16/heart.png", "unlitgeneric")
	surface.SetMaterial( heartMat )
	surface.DrawTexturedRect( iconX, startY, 16 , 16)

	-- bar
	local hpFrac = math.Clamp( ply:Health(), 0, 100 )/100

	local widthOffset = width - (padding*3) - 16
	surface.SetDrawColor( PANEL_FILL )
	surface.DrawRect( barX, startY, widthOffset, 16)
	surface.SetDrawColor( HP_COLOR )
	surface.DrawRect( barX, startY, widthOffset*hpFrac, 16)
	surface.SetDrawColor( PANEL_BORDER )
	surface.DrawOutlinedRect( barX, startY, widthOffset, 16)

	if( ply:Team() == TEAM_PROPS ) then
		-- COOLDOWN GUI
		local startY = startY - padding - 16

		-- icon
		local clockMat = Material("icon16/clock.png", "unlitgeneric")
		surface.SetMaterial( clockMat )
		surface.DrawTexturedRect( iconX, startY, 16 , 16)

		-- bar
		local cdFrac = math.Clamp( os.time() - ply.lastPropChange , 0, PROP_CHOOSE_COOLDOWN)/PROP_CHOOSE_COOLDOWN
		local cdColor = LerpColor( cdFrac, DEPLETED_COLOR, FULL_COLOR )

		local widthOffset = width - (padding*3) - 16
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( barX, startY, widthOffset, 16)
		surface.SetDrawColor( cdColor )
		surface.DrawRect( barX, startY, widthOffset*cdFrac, 16)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( barX, startY, widthOffset, 16)
	end
end

hook.Add("HUDPaint", "Main ObjHunt HUD", ObjHUD )