AddCSLuaFile()

SWEP.Author 				= "Captain Ken"
SWEP.Base 					= "weapon_base"
SWEP.PrintName 				= "Agility Laser Cannon"	
SWEP.Instructions 			= "A learning lesson on how to create effects with sweps!"

SWEP.ViewModel  			=	"models/weapons/v_physcannon.mdl"
SWEP.ViewModelFlip 			= 	false 
SWEP.UseHands				=	true
SWEP.WorldModel     		=	"models/weapons/w_physics.mdl"
SWEP.HoldType 				= 	"shotgun"

SWEP.Weight 				= 	5
SWEP.AutoSwitchTo 			=	"true"
SWEP.AutoSwitchFrom 		=	"false"

SWEP.Slot 					= 	1
SWEP.SlotPos 				=	0

SWEP.DrawAmmo 				=	"false"
SWEP.DrawCrosshair  		=	"false"


SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true

SWEP.Primary.Delay  		= 0
SWEP.Primary.ClipSize 		= 5
SWEP.Primary.DefaultClip 	= 5
SWEP.Primary.Ammo 			= "SMG1"

SWEP.Primary.Automatic 		= true
SWEP.Recoil 				= 0
SWEP.Primary.Damage 		= 100
SWEP.Cone 					= 0
SWEP.ConeVariance 			= 0

// Goal of this weapon //
// Mouse 1 : Shoot a laser //
// EFFECT : Laser spins and is green //
// Mouse 2 : Does not shoot //

function SWEP:Initialize()

	if ( !self:CanPrimaryAttack() ) then return end

     self:SetWeaponHoldType(self.HoldType)
     
     --self:EmitSound("weapons/physcannon/energy_bounce2.wav")



end

function SWEP:Think()

	local owner = self:GetOwner()
	if owner:IsValid() then
	end

end

function SWEP:MaterialBeam()



end

function SWEP:PrimaryAttack()

	if self:CanPrimaryAttack() then

	self:EmitSound("weapons/physcannon/energy_bounce2.wav")

	end

	local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Tracer = 1
        bullet.TracerName = "Main_Beam"
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo

		self:ShootEffects()
		self.Owner:FireBullets( bullet )


end



function SWEP:SecondaryAttack()
end

if SERVER then return end

	--local matBeam = Material("effects/laser1")
	--local matMainBeam = Material("effects/laser_citadel1")
	--local matGlow = Material("sprites/glow04_noz") 

local EFFECT = {}

local matMainBeam = Material("effects/laser_citadel1")

function EFFECT:Init( data )


	self.Position = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.Dir = ( self.EndPos - self.StartPos ):GetNormalized()
	self.Dist = self.StartPos:Distance( self.EndPos )
	
	self.LifeTime = 1 - ( 1 / self.Dist )
	self.DieTime = CurTime() + self.LifeTime

end

function EFFECT:Think()
	if ( CurTime() > self.DieTime ) then return false end
	return true
end

function EFFECT:Render()

	local v1 = ( CurTime() - self.DieTime ) / self.LifeTime
	local v2 = ( self.DieTime - CurTime() ) / self.LifeTime
	local a = self.EndPos - self.Dir * math.min( 1 - ( v1 * self.Dist ), self.Dist )

	render.SetMaterial( matMainBeam )
	render.DrawBeam( a, self.EndPos, 50, 0, self.Dist / 10, Color( 0,255,0,10 ))

end
effects.Register( EFFECT, "Main_Beam")