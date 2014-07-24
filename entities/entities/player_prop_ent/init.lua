AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/player.mdl")
	self.health = 100
	self.angleSnap = false
	self.angleLock = false
	self.lockedAngle = Angle(0,0,0)
end 

function ENT:OnTakeDamage(dmg)
	local ply = self:GetOwner()
	-- still keeping track of hp for now, might not need to later though
	self.health = math.min( ply:Health(), self.health )
	local attacker = dmg:GetAttacker()
	local inflictor = dmg:GetInflictor()
	
	if ply && ply:IsValid() && ply:Alive() && ply:IsPlayer() && attacker:IsPlayer() && dmg:GetDamage() > 0 then
		self.health = self.health - dmg:GetDamage()
		ply:TakeDamage(dmg:GetDamage())
	end
end 