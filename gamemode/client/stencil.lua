hook.Add("PostDrawOpaqueRenderables","PlayerBorders",function()
	local prop = LocalPlayer():GetEyeTrace().Entity
	if( !playerCanBeEnt( LocalPlayer(), prop ) ) then return end
	--stencil work is done in postdrawopaquerenderables, where surface doesn't work correctly
	--workaround via 3D2D
	local pos = LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*10
	local ang = LocalPlayer():GetAngles()
	ang = Angle(ang.p+90,ang.y,0)
	print( prop:GetPhysicsObject():GetMass() )
	render.ClearStencil()
	render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(15)
		render.SetStencilFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		render.SetBlend(0) --don't visually draw, just stencil
		prop:SetModelScale( 1.01, 0 )
		prop:DrawModel()
		prop:SetModelScale( 1, 0 )
		render.SetBlend(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		cam.Start3D2D(pos,ang,1)
				surface.SetDrawColor(0,255,0,255)
				surface.DrawRect(-ScrW(),-ScrH(),ScrW()*2,ScrH()*2)
		cam.End3D2D()
		prop:DrawModel()
	render.SetStencilEnable(false)
end)