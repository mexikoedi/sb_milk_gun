SWEP.PrintName = "Milk Gun"
SWEP.Author = "mexikoedi"
SWEP.Instructions = "Give the milk"
SWEP.Category = "Milk Gun"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Base = "weapon_base"
SWEP.Kind = WEAPON_EQUIP1
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.AutoSpawnable = false
SWEP.HoldType = "pistol"
SWEP.Primary.ClipSize = 1000
SWEP.Primary.DefaultClip = 1000
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Weight = 7
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

if SERVER then
    resource.AddFile( "materials/vgui/sandbox/icon_milk.vmt" )
    resource.AddFile( "sound/milk.wav" )
    resource.AddFile( "sound/milk_altfire.wav" )
end

SWEP.Icon = "vgui/sandbox/icon_milk"
local ShootSound = Sound( "milk.wav" )
local SecondSound = Sound( "milk_altfire.wav" )

function SWEP:PrimaryAttack( )
    self:SetNextPrimaryFire( CurTime( ) + 2.5 )
    if !self:CanPrimaryAttack( ) then return end
    self:TakePrimaryAmmo( 1 )
    self:EmitSound( ShootSound )
    if ( CLIENT ) then return end
    local ent = ents.Create( "prop_physics" )
    if ( !IsValid( ent ) ) then return end
    ent:SetModel( "models/props_junk/garbage_milkcarton002a.mdl" )
    util.SpriteTrail( ent , 0 , Color( 255 , 255 , 255 ) , false , 16 , 1 , 6 , 1 / ( 15 + 1 ) * 0.5 , "trails/laser.vmt" )
    ent:SetPos( self:GetOwner( ):EyePos( ) + ( self:GetOwner( ):GetAimVector( ) * 16 ) )
    ent:SetAngles( self:GetOwner( ):EyeAngles( ) )
    ent:Spawn( )
    local phys = ent:GetPhysicsObject( )

    if ( !IsValid( phys ) ) then
        ent:Remove( )

        return
    end

    phys:SetMass( 300 )
    local velocity = self:GetOwner( ):GetAimVector( )
    velocity = velocity * 1000000
    phys:ApplyForceCenter( velocity )
end

function SWEP:SecondaryAttack( )
    self:SetNextSecondaryFire( CurTime( ) + 0.5 )
    self:EmitSound( SecondSound )
end