AddCSLuaFile()

-- This is our entity that our tool creates

ENT.Type = "anim"
ENT.PrintName = "Template Entity"
ENT.Author = "YOU"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Float", 1, "Scale")

    if SERVER then
        self:SetScale(1.0)
    end
end

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/Kleiner.mdl")
        self:SetColor(Color(255, 255, 0))
        self:PhysicsInit(SOLID_VPHYSICS)
    end

    self:SetModelScale(self:GetScale())
end