--[[ Do thirdperson, view heights, etc ]]--
hook.Add("CalcView", "ObjHunt CalcView", function( ply, pos, angles, fov )
	-- disable custom viewing if we're dead, this fixes spec bug
	if( !ply:Alive() ) then return true end

	-- this needs to be here otherwise some people get errors for some unknown reason
	if( ply.wantThirdPerson == nil ) then return end

	local view = {}
	view.angles = angles
	view.fov = fov
	view.drawviewer = ply.wantThirdPerson

	-- blinding the player
	if ( ply:Team() == TEAM_HUNTERS ) && ( round.state == 2 ) && ( ( CurTime() - round.startTime ) < OBJHUNT_HIDE_TIME ) then
		view.origin = Vector( 0, 0, 34343 )
		return view

	elseif( ply.wantThirdPerson ) then
		local trace = {}
		local addToPlayer
		if( ply:Team() == TEAM_PROPS ) then
			addToPlayer = Vector(0, 0, ply.propHeight)
		else
			addToPlayer = Vector(0, 0, 64 )
		end
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
		local height = math.max( ply.propHeight || 64, VIEW_MIN_Z )
		view.origin = ply:GetPos() + Vector(0,0, height)
		ply.viewOrigin = view.origin
		return view
	end
end )

local function stencilColor( ply, ent )
	-- make sure we're living props
	if( !ply:Alive() || ply:Team() != TEAM_PROPS ) then return false end

	-- make sure it's a valid object
	if(	!IsValid(ent) ) then return false end

	-- must not be a player's chosen Prop
	if( ent:IsPlayer() ) then return false end
	if( ent:GetOwner():IsPlayer() ) then return false end

	-- must have a bounding box
	if( !ent:GetHitBoxBounds(0,0) ) then return false end

	-- make sure ent is a valid prop type
	if(	!table.HasValue( USABLE_PROP_ENTITIES, ent:GetClass() ) ) then return BAD_HOVER_COLOR end

	-- make sure ent is a valid prop type
	if( WouldBeStuck( ply, ent ) ) then return BAD_HOVER_COLOR end

	-- cooldown on switching props
	if( ply.lastPropChange && CurTime() - ply.lastPropChange < PROP_CHOOSE_COOLDOWN ) then
		local frac = math.Clamp( CurTime() - ply.lastPropChange , 0, PROP_CHOOSE_COOLDOWN)/PROP_CHOOSE_COOLDOWN
		frac = frac/2

		return LerpColor( frac, BAD_HOVER_COLOR, GOOD_HOVER_COLOR )
	end

	return GOOD_HOVER_COLOR
end

local function getViewEnt(ply)
	-- this needs to be here otherwise some people get errors for some unknown reason
	if( ply.viewOrigin == nil || ply.wantThirdPerson == nil ) then return end

	local trace = {}
	trace.start = ply.viewOrigin
	if( ply.wantThirdPerson ) then
		trace.endpos = trace.start + ply:GetAngles():Forward() * (THIRDPERSON_DISTANCE+PROP_SELECT_DISTANCE)
	else
		trace.endpos = trace.start + ply:GetAngles():Forward() * (PROP_SELECT_DISTANCE)
	end
	trace.filter = { ply:GetProp() }
	tr = util.TraceLine(trace)
	return tr.Entity
end

hook.Add( "PreDrawHalos", "Selectable Prop Halos", function()
	if( LocalPlayer():Team() != TEAM_PROPS ) then return end
	local prop = getViewEnt( LocalPlayer() )
	local sColor = stencilColor( LocalPlayer(), prop )
	if( !sColor ) then return end
	halo.Add( {prop}, sColor, 3, 3, 1 )
end )

--[[ when the player tries to select a prop ]]--
hook.Add( "PlayerTick", "New Player Use", function( ply )
	if( ply:Team() != TEAM_PROPS ) then return end
	if( ply:KeyPressed( IN_USE ) ) then
		if( !ply.lastPropChange || os.time() - ply.lastPropChange < PROP_CHOOSE_COOLDOWN ) then return end
		local prop = getViewEnt( ply )
		local sColor = stencilColor( LocalPlayer(), prop )
		if( sColor == GOOD_HOVER_COLOR) then
			net.Start( "Selected Prop" )
				net.WriteEntity( prop )
			net.SendToServer()
		end
	end
end )
