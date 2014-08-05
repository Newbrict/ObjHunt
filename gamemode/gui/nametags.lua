surface.CreateFont( "Nametags",
{
	font = "Helvetica",
	size = 128,
	weight = 30,
	antialias = false,
	outline = true,
})

hook.Add( "PostDrawOpaqueRenderables", "Draw Nametags", function()
	if( LocalPlayer():Team() != TEAM_HUNTERS &&
		LocalPlayer():Team() != TEAM_PROPS ) then return end
	if( !LocalPlayer():Alive() ) then return end

	local toTag = GetLivingPlayers( LocalPlayer():Team() )

	if( LocalPlayer():Team() == TEAM_PROPS ) then
		table.Add( toTag, GetLivingPlayers( TEAM_HUNTERS ) )
	end

	for _, v in pairs(toTag) do
		if( v == LocalPlayer() ) then continue end

		local cOffset = Vector( 0, 0, 10 )
		local pos = v:GetPos() + v:GetViewOffset() + cOffset

		local pDiff = v:GetPos() - LocalPlayer():GetPos()

		-- 'Sprite' like angles based on positional angles
		-- angle between local player and target player
		--local pAng = (pDiff):Angle():Right():Angle()
		--local angle = Angle(0,0,90) + pAng

		-- 'Sprite' like angles based on view angle
		angle = Angle(0,0,90) + LocalPlayer():GetAimVector():Angle():Right():Angle()

		cam.Start3D2D( pos, angle, .05 )
			surface.SetFont( "Nametags" )
			surface.SetTextColor( Color( 255,255,255,255 ) )
			local text = v:Nick()
			local tw, th = surface.GetTextSize( text )
			surface.SetTextPos( -tw/2, -th )
			surface.DrawText( text )
		cam.End3D2D()
	end
end )