AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/player.mdl")
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.angleSnap = false
	self.angleLock = false
	self.lockedAngle = Angle(0,0,0)
end
