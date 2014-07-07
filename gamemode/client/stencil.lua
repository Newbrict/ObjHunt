local function stencilColor( ply, ent )
	-- make sure we're living props
	if( !ply:Alive() || ply:Team() != TEAM_PROPS ) then return false end

	-- make sure it's a valid object
	if(	!IsValid(ent) ) then return false end

	-- must not be a chosenProp
	if( ent:IsPlayer() ) then return false end
	if( ent:GetOwner():IsPlayer() ) then return false end

	-- must have a bounding box
	if( !ent:GetHitBoxBounds(0,0) ) then return false end
	
	-- make sure we're on the ground and standing tall
	if( ply:Crouching() || !ply:OnGround() ) then return false end

	-- make sure the distance is beneath the max
	local pos = LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*10
	local distVec = (pos - ent:GetPos())
	local distBetween = distVec:Length()
	if( distBetween > PROP_SELECT_DISTANCE ) then return false end

	-- make sure ent is a valid prop type
	if(	!table.HasValue( USABLE_PROP_ENTITIES, ent:GetClass() ) ) then return Color(255,0,0,255) end

	return Color(0,255,0,255)
end

hook.Add("PostDrawOpaqueRenderables","PlayerBorders",function()
	--DEBUG
	if( false ) then	
		theTeamers = team.GetPlayers( TEAM_PROPS )
		for _, v in pairs(theTeamers) do
			local hitpos  = v:GetEyeTrace().HitPos
			local hitpos  = v:GetEyeTrace().HitPos
			local shotpos = v:EyePos()
			render.DrawLine(shotpos,hitpos, Color(255,255,255,255), true)
		end
	end

	local prop = LocalPlayer():GetEyeTrace().Entity
	sColor = stencilColor( LocalPlayer(), prop ) 
	if( !sColor ) then return end
	--stencil work is done in postdrawopaquerenderables, where surface doesn't work correctly
	--workaround via 3D2D
	local pos = LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*10
	local ang = LocalPlayer():GetAngles()
	ang = Angle(ang.p+90,ang.y,0)
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
		local distVec = (pos - prop:GetPos())
		local propDist = distVec:Length()
		local boxMin, boxMax = prop:GetHitBoxBounds(0,0)
		local boxDiag = (boxMax-boxMin):Length()
		local pBuff = (propDist/boxDiag)/50
		prop:SetModelScale( 1+pBuff, 0 )
		prop:DrawModel()
		prop:SetModelScale( 1, 0 )
		render.SetBlend(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		cam.Start3D2D(pos,ang,1)
			surface.SetDrawColor(sColor)
			surface.DrawRect(-ScrW(),-ScrH(),ScrW()*2,ScrH()*2)
		cam.End3D2D()
		prop:DrawModel()
	render.SetStencilEnable(false)
end)