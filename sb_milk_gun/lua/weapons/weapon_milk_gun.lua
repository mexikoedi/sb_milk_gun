if engine.ActiveGamemode() == "terrortown" then return end

if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/vgui/entities/weapon_milk_gun.vmt")
    resource.AddFile("materials/HUD/killicons/milk_gun.vmt")
    resource.AddFile("sound/milk.wav")
    resource.AddFile("sound/milk_altfire.wav")
end

SWEP.PrintName = "Milk Gun"
SWEP.Author = "mexikoedi"
SWEP.Instructions = "Shoot and play a sound with primary attack. Use secondary attack to hear a different sound."
SWEP.Purpose = "Gives milk bags to everyone"
SWEP.Category = "mexikoedi's SWEPS"
SWEP.DrawWeaponInfoBox = true
SWEP.BounceWeaponIcon = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Icon = "vgui/entities/weapon_milk_gun"
SWEP.Base = "weapon_base"
SWEP.HoldType = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 769
SWEP.Primary.Automatic = true
SWEP.Primary.RPS = 3
SWEP.Primary.Ammo = "pistol"
SWEP.Weight = 7
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.FiresUnderwater = false
SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
local ShootSound = Sound("milk.wav")
local SecondSound = Sound("milk_altfire.wav")
local Killicon_Color_Icon = Color(255, 255, 255, 255)

if CLIENT then
    killicon.Add("ent_sb_milk_gun", "HUD/killicons/milk_gun", Killicon_Color_Icon)
end

function SWEP:Initialize()
end

SWEP.WepSelectIcon = Material("vgui/entities/weapon_milk_gun")

function SWEP:DrawWeaponSelection(x, y, w, h, a)
    render.PushFilterMag(TEXFILTER.ANISOTROPIC)
    render.PushFilterMin(TEXFILTER.ANISOTROPIC)
    surface.SetDrawColor(255, 255, 255, a)
    surface.SetMaterial(self.WepSelectIcon)
    local fsin = 0

    if (self.BounceWeaponIcon == true) then
        fsin = math.sin(CurTime() * 10) * 5
    end

    local size = math.min(w, h) - 32
    surface.DrawTexturedRect(x - 50 + w + fsin / 2 - size - fsin / 2, y + h * 0.05 - fsin * 2, size, size + fsin)
    render.PopFilterMag()
    render.PopFilterMin()
    self:PrintWeaponInfo(x + 220 + w / 2 - size / 2, y + 170 + h * 0.05, 255)
end

function SWEP:PrimaryAttack()
    self.currentOwner = self:GetOwner()
    self:SetNextPrimaryFire(CurTime() + 1 / self.Primary.RPS)
    if not self:CanPrimaryAttack() then return end
    self:TakePrimaryAmmo(1)

    if SERVER then
        self.currentOwner:EmitSound(ShootSound)
    end

    if (CLIENT) then return end
    local ent = ents.Create("ent_sb_milk_gun")
    if (not IsValid(ent)) then return end
    ent:SetModel("models/props_junk/garbage_milkcarton002a.mdl")
    ent:SetAngles(self.currentOwner:EyeAngles())
    ent:SetPos(self.currentOwner:EyePos() + (self.currentOwner:GetAimVector() * 16))
    ent.Owner = self.currentOwner
    ent:SetOwner(self.currentOwner)
    ent:SetPhysicsAttacker(self.currentOwner)
    ent.fingerprints = self.fingerprints
    ent:Spawn()
    ent:Activate()
    util.SpriteTrail(ent, 0, Color(255, 255, 255), false, 16, 1, 6, 1 / (15 + 1) * 0.5, "trails/laser.vmt")
    local phys = ent:GetPhysicsObject()

    if (not IsValid(phys)) then
        ent:Remove()

        return
    end

    phys:SetMass(100)
    phys:SetVelocity(self.currentOwner:GetAimVector() * 100000)
    local anglo = Angle(-10, -5, 0)
    self.currentOwner:ViewPunch(anglo)
end

function SWEP:SecondaryAttack()
    self.currentOwner = self:GetOwner()
    self:SetNextSecondaryFire(CurTime() + 5)

    if SERVER then
        self.currentOwner:EmitSound(SecondSound)
    end
end

function SWEP:Holster()
    if SERVER and IsValid(self.currentOwner) then
        self.currentOwner:StopSound("milk_altfire.wav")
    end

    return true
end

function SWEP:OnRemove()
    if SERVER and IsValid(self.currentOwner) then
        self.currentOwner:StopSound("milk_altfire.wav")
    end
end

function SWEP:OnDrop()
    if SERVER and IsValid(self.currentOwner) then
        self.currentOwner:StopSound("milk_altfire.wav")
    end
end
