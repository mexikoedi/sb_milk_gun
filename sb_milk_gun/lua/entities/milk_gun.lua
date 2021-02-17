ENT.Type = "anim"
ENT.PrintName = "Milk"
ENT.Author = "mexikoedi"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.AlreadyHit = {}
ENT.Collided = 0
local CollisionsBeforeRemove = 10

if SERVER then
    AddCSLuaFile()

    function ENT:Initialize()
        self:SetModel("models/props_junk/garbage_milkcarton002a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()

        if (phys:IsValid()) then
            phys:Wake()
            phys:SetMass(5)
        end

        self:GetPhysicsObject():SetMass(2)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:PhysicsCollide(data, phys)
        self.Collided = self.Collided + 1

        if self.Collided <= CollisionsBeforeRemove then
            local Ent = data.HitEntity
            if not IsValid(self) or not IsValid(Ent) or not Ent:IsPlayer() then return end
        else
            timer.Simple(0, function()
                if IsValid(self) then
                    self:Remove()
                end
            end)
        end
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end
