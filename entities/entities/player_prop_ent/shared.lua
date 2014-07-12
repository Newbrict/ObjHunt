ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Draw()

	local owner = self:GetOwner()

	if !self:IsValid() || !IsValid(owner) then return end

	self:SetPos( owner:GetPos() )

	local propAngle = owner:EyeAngles()
	-- snap to 45 degree increments on yaw, and dissallow pitch movement


	if( CLIENT ) then
		-- angle snapping stuff
		if( self.angleSnap ) then
			propAngle:SnapTo("p",180):SnapTo("y",45)
		else
			propAngle:SnapTo("p",180)
		end

		-- angle locking stuff
		if( !self.angleLock ) then 
			self:SetAngles(propAngle)
			self.lockedAngle = propAngle
		else
			self:SetAngles(self.lockedAngle)
		end

		-- third person stuff
		if( LocalPlayer().wantThirdPerson || self:GetOwner() != LocalPlayer() ) then
			self:DrawModel()
		end
	end
end

function ENT:Think()
	self:Draw()
end
