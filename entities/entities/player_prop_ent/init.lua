AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/player.mdl")
	self.health = 100
end 

function ENT:OnTakeDamage(dmg)
	local ply = self:GetOwner()
	local attacker = dmg:GetAttacker()
	local inflictor = dmg:GetInflictor()
	
	if ply && ply:IsValid() && ply:Alive() && ply:IsPlayer() && attacker:IsPlayer() && dmg:GetDamage() > 0 then
		self.health = self.health - dmg:GetDamage()
		ply:SetHealth(self.health)
		
		if self.health <= 0 then
			ply:KillSilent()
			
		end
	end
end 