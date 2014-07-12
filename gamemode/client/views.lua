--[[ Do thirdperson, view heights, etc ]]--
hook.Add("CalcView", "ObjHunt CalcView", function( ply, pos, angles, fov )
	local view = {}
	view.angles = angles
	view.fov = fov
	view.drawviewer = ply.wantThirdPerson

	if( ply.wantThirdPerson ) then
		local trace = {}
		local addToPlayer = Vector(0, 0, ply.propHeight)
		local viewDist = THIRDPERSON_DISTANCE
		
		trace.start = ply:GetPos() + addToPlayer
		trace.endpos = trace.start + view.angles:Forward() * -viewDist
		trace.mask = MASK_SOLID_BRUSHONLY
		tr = util.TraceLine(trace)
		
		-- efficient check when not hitting walls
		if(tr.Fraction < 1) then
			viewDist = viewDist * tr.Fraction
		end
		
		view.origin = trace.start + view.angles:Forward() * -viewDist
		ply.viewOrigin = view.origin
		return view
	elseif( ply:Team() == TEAM_PROPS ) then
		view.origin = ply:GetPos() + Vector(0,0,ply.propHeight)
		ply.viewOrigin = view.origin
		return view
	end
end )

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

	-- make sure ent is a valid prop type
	if(	!table.HasValue( USABLE_PROP_ENTITIES, ent:GetClass() ) ) then return BAD_HOVER_COLOR end

	-- make sure ent is a valid prop type
	if( WouldBeStuck( ply, ent, ply.chosenProp ) ) then return BAD_HOVER_COLOR end

	-- cooldown on switching props
	if( ply.lastPropChange &&
		os.time() - ply.lastPropChange < PROP_CHOOSE_COOLDOWN ) then return BAD_HOVER_COLOR end

	return GOOD_HOVER_COLOR
end

local function getViewEnt(ply)
	local trace = {}
	trace.start = ply.viewOrigin
	if( ply.wantThirdPerson ) then
		trace.endpos = trace.start + ply:GetAngles():Forward() * (THIRDPERSON_DISTANCE+PROP_SELECT_DISTANCE)
	else
		trace.endpos = trace.start + ply:GetAngles():Forward() * (PROP_SELECT_DISTANCE)
	end
	trace.filter = {ply.chosenProp}
	tr = util.TraceLine(trace)
	return tr.Entity
end

hook.Add( "PreDrawHalos", "Selectable Prop Halos", function()
	if( LocalPlayer():Team() != TEAM_PROPS ) then return end
	local prop = getViewEnt( LocalPlayer() )
	sColor = stencilColor( LocalPlayer(), prop ) 
	if( !sColor ) then return end
	halo.Add( {prop}, sColor, 3, 3, 1 )
end )
