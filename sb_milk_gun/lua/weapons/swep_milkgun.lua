if SERVER then
    AddCSLuaFile( )
    resource.AddFile( "materials/vgui/entities/swep_milkgun.vmt" )
    resource.AddFile( "materials/HUD/killicons/milk_gun.vmt" )
    resource.AddFile( "sound/milk.wav" )
    resource.AddFile( "sound/milk_altfire.wav" )
end

SWEP.PrintName = "Milk Gun"
SWEP.Author = "mexikoedi"
SWEP.Instructions = "Shoot and play a sound with Primaryfire. Secondaryfire to hear a different sound."
SWEP.Purpose = "Gives milk bags to everyone"
SWEP.Category = "mexikoedi's SWEPS"
SWEP.DrawWeaponInfoBox = true
SWEP.BounceWeaponIcon = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Icon = "vgui/entities/swep_milkgun"
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
local ShootSound = Sound( "milk.wav" )
local SecondSound = Sound( "milk_altfire.wav" )
local Killicon_Color_Icon = Color( 255 , 255 , 255 , 255 )

if CLIENT then
    killicon.Add( "milk_gun" , "/HUD/killicons/milk_gun" , Killicon_Color_Icon )
end

function SWEP:Initialize( )
end

SWEP.WepSelectIcon = Material( "vgui/entities/swep_milkgun" )

function SWEP:DrawWeaponSelection( x , y , w , h , a )
    render.PushFilterMag( TEXFILTER.ANISOTROPIC )
    render.PushFilterMin( TEXFILTER.ANISOTROPIC )
    surface.SetDrawColor( 255 , 255 , 255 , a )
    surface.SetMaterial( self.WepSelectIcon )
    local fsin = 0

    if ( self.BounceWeaponIcon == true ) then
        fsin = math.sin( CurTime( ) * 10 ) * 5
    end

    local size = math.min( w , h ) - 32
    surface.DrawTexturedRect( x - 50 + w + fsin / 2 - size - fsin / 2 , y + h * 0.05 - fsin * 2 , size , size + fsin )
    render.PopFilterMag( )
    render.PopFilterMin( )
    self:PrintWeaponInfo( x + 220 + w / 2 - size / 2 , y + 170 + h * 0.05 , 255 )
end

function SWEP:PrimaryAttack( )
    self:SetNextPrimaryFire( CurTime( ) + 1 / self.Primary.RPS )
    if !self:CanPrimaryAttack( ) then return end
    self:TakePrimaryAmmo( 1 )
    self:EmitSound( ShootSound )
    if ( CLIENT ) then return end
    local ent = ents.Create( "milk_gun" )
    if ( !IsValid( ent ) ) then return end
    ent:SetModel( "models/props_junk/garbage_milkcarton002a.mdl" )
    ent:SetAngles( self:GetOwner( ):EyeAngles( ) )
    ent:SetPos( self:GetOwner( ):EyePos( ) + ( self:GetOwner( ):GetAimVector( ) * 16 ) )
    ent:SetOwner( self:GetOwner( ) )
    ent:Spawn( )
    ent.Owner = self:GetOwner( )
    ent:Activate( )
    util.SpriteTrail( ent , 0 , Color( 255 , 255 , 255 ) , false , 16 , 1 , 6 , 1 / ( 15 + 1 ) * 0.5 , "trails/laser.vmt" )
    local phys = ent:GetPhysicsObject( )

    if ( !IsValid( phys ) ) then
        ent:Remove( )

        return
    end

    phys:SetMass( 100 )
    phys:SetVelocity( self:GetOwner( ):GetAimVector( ) * 100000 )
    local anglo = Angle( -10 , -5 , 0 )
    self:GetOwner( ):ViewPunch( anglo )
end

function SWEP:SecondaryAttack( )
    self:SetNextSecondaryFire( CurTime( ) + 5 )

    if SERVER then
        self.currentOwner = self:GetOwner( )
        self:GetOwner( ):EmitSound( SecondSound )
    end
end

function SWEP:Holster( )
    if SERVER && IsValid( self.currentOwner ) then
        self.currentOwner:StopSound( "milk_altfire.wav" )
    end

    return true
end

function SWEP:OnRemove( )
    if SERVER && IsValid( self.currentOwner ) then
        self.currentOwner:StopSound( "milk_altfire.wav" )
    end
end

function SWEP:OnDrop( )
    if SERVER && IsValid( self.currentOwner ) then
        self.currentOwner:StopSound( "milk_altfire.wav" )
    end
end