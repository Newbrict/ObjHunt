surface.CreateFont( "Nametags",
{
	font = "Helvetica",
	size = 128,
	weight = 30,
	antialias = false,
	outline = true,
})

hook.Add( "PostDrawOpaqueRenderables", "example", function()
	if( LocalPlayer():Team() != TEAM_HUNTERS &&
		LocalPlayer():Team() != TEAM_PROPS ) then return end
	local toTag = GetLivingPlayers( LocalPlayer():Team() )
	for _, v in pairs(toTag) do
		if( v == LocalPlayer() ) then continue end
		local angle = LocalPlayer():GetAimVector():Angle()
		local rAng = angle:Right():Angle()
		local pAng = (v:GetPos() - LocalPlayer():GetPos()):Angle()
		pAng:RotateAroundAxis( Vector(0,0,1), -90 )
		cam.Start3D2D( v:GetPos() + 20*pAng:Right(), pAng, .05 )
			surface.SetFont( "Nametags" )
			surface.SetTextColor( Color( 255,255,255,255 ) )
			local text = v:Nick()
			local tw, th = surface.GetTextSize( text )
			surface.SetTextPos( -tw/2, -th)
			surface.DrawText( text )
		cam.End3D2D()
	end
end )