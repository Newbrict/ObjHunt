-- the font I will use for info
surface.CreateFont( "ObjHUDFont",
{
	font = "Helvetica",
	size = 40,
	weight = 2000,
	antialias = true,
	outline = false
})

surface.CreateFont( "barHUD",
{
	font = "Helvetica",
	size = 16,
	weight = 1000,
	antialias = false,
	outline = true
})

--[[=======================]]--
--[[ This has all the bars ]]--
--[[=======================]]--
local function ObjHUD()
	local ply = LocalPlayer()
	if( !ply:IsValid() ) then return end

	local width = 200
	local height = 125
	local padding = 10
	local iconX = padding
	local barX = padding*2 + 16
	local startY = ScrH()

	-- random color just to let the icon draw
	surface.SetDrawColor( PANEL_BORDER )

	-- HP GUI
	if( ply:Alive() && ( ply:Team() == TEAM_PROPS || ply:Team() == TEAM_HUNTERS ) ) then
		startY = startY - padding - 16

		-- icon
		local heartMat = Material("icon16/heart.png", "unlitgeneric")
		surface.SetMaterial( heartMat )
		surface.DrawTexturedRect( iconX, startY, 16 , 16)

		-- bar
		hpFrac = math.Clamp( ply:Health(), 0, 100 )/100

		local widthOffset = width - (padding*3) - 16
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( barX, startY, widthOffset, 16)
		surface.SetDrawColor( HP_COLOR )
		surface.DrawRect( barX, startY, widthOffset*hpFrac, 16)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( barX, startY, widthOffset, 16)

		--text
		surface.SetFont( "barHUD" )
		surface.SetTextColor( 255, 255, 255, 255 )
		local textToDraw = LocalPlayer():Health()
		local textWidth, textHeight = surface.GetTextSize( textToDraw )
		local textX = barX + 3
		local textY = startY
		surface.SetTextPos( textX, textY )
		surface.DrawText( textToDraw )
	end

	-- PROP COOLDOWN GUI
	if( ply:Alive() && ply:Team() == TEAM_PROPS ) then
		-- this needs to be here otherwise some people get errors for some unknown reason
		if( ply.viewOrigin == nil || ply.wantThirdPerson == nil ) then return end
		if( ply.lastPropChange == nil ) then return end

		startY = startY - padding - 16

		-- icon
		local propMat = Material("icon16/package.png", "unlitgeneric")
		surface.SetMaterial( propMat )
		surface.DrawTexturedRect( iconX, startY, 16 , 16)

		-- bar
		local propFrac = math.Clamp( CurTime() - ply.lastPropChange , 0, PROP_CHOOSE_COOLDOWN)/PROP_CHOOSE_COOLDOWN
		local propColor = LerpColor( propFrac, DEPLETED_COLOR, FULL_COLOR )

		local widthOffset = width - (padding*3) - 16
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( barX, startY, widthOffset, 16)
		surface.SetDrawColor( propColor )
		surface.DrawRect( barX, startY, widthOffset*propFrac, 16)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( barX, startY, widthOffset, 16)

		--text
		local textToDraw = PROP_CHOOSE_COOLDOWN - propFrac*PROP_CHOOSE_COOLDOWN
		textToDraw = math.ceil( textToDraw )
		if( textToDraw != 0 ) then
			surface.SetFont( "barHUD" )
			surface.SetTextColor( 255, 255, 255, 255 )
			local textWidth, textHeight = surface.GetTextSize( textToDraw )
			local textX = barX + 3
			local textY = startY
			surface.SetTextPos( textX, textY )
			surface.DrawText( textToDraw )
		end
	end

	-- TAUNT COOLDOWN GUI
	if( ply:Alive() && ( ply:Team() == TEAM_PROPS || ply:Team() == TEAM_HUNTERS ) ) then
		-- defaults
		if( !ply.lastTaunt ) then
			LocalPlayer().lastTaunt = 0
			LocalPlayer().lastTauntDuration = 1
			LocalPlayer().lastTauntPitch = 100
		end

		startY = startY - padding - 16

		-- icon
		local tauntMat = Material("icon16/music.png", "unlitgeneric")
		surface.SetMaterial( tauntMat )
		surface.DrawTexturedRect( iconX, startY, 16 , 16)

		-- bar
		local tauntFrac = math.Clamp( CurTime() - ply.lastTaunt , 0, ply.lastTauntDuration)/ply.lastTauntDuration
		local tauntColor = TAUNT_BAR_COLOR

		local widthOffset = width - (padding*3) - 16
		surface.SetDrawColor( PANEL_FILL )
		surface.DrawRect( barX, startY, widthOffset, 16)
		surface.SetDrawColor( tauntColor )
		surface.DrawRect( barX, startY, widthOffset*tauntFrac, 16)
		surface.SetDrawColor( PANEL_BORDER )
		surface.DrawOutlinedRect( barX, startY, widthOffset, 16)

		--text
		local textToDraw = ply.lastTauntDuration - tauntFrac*ply.lastTauntDuration
		textToDraw = math.ceil( textToDraw )
		if( textToDraw != 0 ) then
			surface.SetFont( "barHUD" )
			surface.SetTextColor( 255, 255, 255, 255 )
			local textWidth, textHeight = surface.GetTextSize( textToDraw )
			local textX = barX + 3
			local textY = startY
			surface.SetTextPos( textX, textY )
			surface.DrawText( textToDraw )
		end
	end

	-- INFO GUI
	startY = startY - padding - 16

	-- icon
	local infoMat = Material("icon16/information.png", "unlitgeneric")
	surface.SetMaterial( infoMat )
	surface.DrawTexturedRect( iconX, startY, 16 , 16)

	--text
	surface.SetFont( "barHUD" )
	surface.SetTextColor( 255, 255, 255, 255 )
	local textToDraw = "Press F1 For Information"
	local textWidth, textHeight = surface.GetTextSize( textToDraw )
	local textX = barX
	local textY = startY
	surface.SetTextPos( textX, textY )
	surface.DrawText( textToDraw )
end

--[[=========================]]--
--[[ This has the round info ]]--
--[[=========================]]--
local function RoundHUD()
	local ply = LocalPlayer()
	if( !ply:IsValid() ) then return end

	local width = 200
	local height = 50
	local padding = 10
	local startY = ScrH() - padding - height
	local startX = ScrW() - padding - width

	startX = startX/2

	-- box with border
	surface.SetDrawColor( ROUND_TIME_COLOR )
	surface.DrawRect( startX, startY, width, height)
	surface.SetDrawColor( PANEL_BORDER )
	surface.DrawOutlinedRect( startX, startY, width, height)

	local lineX = startX + width/2
	local lineY = startY + height - 1
	local box1Width = lineX - startX
	local box2Width = startX + width - lineX
	if( round.state ) then
		-- labels for round/ time left
		surface.SetFont( "InfoFont" )
		surface.SetTextColor( 255, 255, 255, 255 )
		local textToDraw = "Time"
		local textWidth, textHeight = surface.GetTextSize( textToDraw )
		local textX = startX + box1Width/2 - textWidth/2
		local textY = startY - textHeight
		surface.SetTextPos( textX, textY )
		surface.DrawText( textToDraw )
		textToDraw = "Round"
		textWidth, textHeight = surface.GetTextSize( textToDraw )
		textX = lineX + box2Width/2 - textWidth/2
		surface.SetTextPos( textX, textY )
		surface.DrawText( textToDraw )

		surface.DrawLine( lineX, lineY, lineX, startY)

		-- Time left text
		surface.SetFont( "ObjHUDFont" )
		surface.SetTextColor( 255, 255, 255, 255 )
		if( round.startTime == 0 || round.state == 3 ) then
			textToDraw = "00:00"
		else
			local secs = CurTime() - round.startTime + round.timePad
			secs = OBJHUNT_ROUND_TIME - secs
			secs = math.max( 0, secs )
			secs = math.Round( secs, 0 )
			textToDraw = string.FormattedTime( secs, "%02i:%02i" )
		end
		textWidth, textHeight = surface.GetTextSize( textToDraw )
		textX = startX + box1Width/2 - textWidth/2
		textY = startY + height/2 - textHeight/2
		surface.SetTextPos( textX, textY )
		surface.DrawText( textToDraw )

		-- Rounds text
		textToDraw = round.current.."/"..OBJHUNT_ROUNDS
		textWidth, textHeight = surface.GetTextSize( textToDraw )
		textX = lineX + box2Width/2 - textWidth/2
		textY = startY + height/2 - textHeight/2

		surface.SetTextPos( textX, textY )
		surface.DrawText( textToDraw )
	end
end

--[[=========================]]--
--[[ This has spectater info ]]--
--[[=========================]]--
local function SpectateHUD()
	local ply = LocalPlayer()

	if( !ply:IsValid() ) then return end

	local sTarget = ply:GetObserverTarget()
	if( !sTarget ) then return end
	local sNick = sTarget:Nick()

	local padding = 10


	local fColor
	if( sTarget:Team() == TEAM_HUNTERS ) then
		fColor = TEAM_HUNTERS_COLOR
	else
		fColor = TEAM_PROPS_COLOR
	end

	local dColor = LerpColor( .70, fColor, Color(255,255,255,255) )
	surface.SetFont( "ObjHUDFont" )
	surface.SetTextColor( dColor )
	local textWidth, textHeight = surface.GetTextSize( sNick )
	local textX = ScrW()/2 - textWidth/2
	local textY = padding*2
	local width = textWidth + 2*padding
	local height = textHeight + 2*padding
	surface.SetTextPos( textX, textY )
	surface.DrawText( sNick )


end

hook.Add("HUDPaint", "Main ObjHunt HUD", ObjHUD )
hook.Add("HUDPaint", "Round HUD", RoundHUD )
hook.Add("HUDPaint", "Spec HUD", SpectateHUD )