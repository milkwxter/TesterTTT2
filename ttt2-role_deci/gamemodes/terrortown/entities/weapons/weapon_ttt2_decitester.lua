if SERVER then
    AddCSLuaFile()
end

SWEP.Base = "weapon_tttbase"

if CLIENT then
  SWEP.ViewModelFOV = 78
  SWEP.DrawCrosshair = false
  SWEP.ViewModelFlip = false

  SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "Decipherer's Minitester",
    desc = "deci_minitester_desc"
  }

  SWEP.Icon = "vgui/ttt/icon_decitester"
end

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = nil

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "pistol"
SWEP.LimitedStock = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.AllowDrop = false

-- Removes the Minitester on death or drop
function SWEP:OnDrop()
	self:Remove()
end

-- Override original primary attack
function SWEP:PrimaryAttack()
  -- Melee attack code
  self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
  
  if not IsValid(self:GetOwner()) then return end

  self:GetOwner():LagCompensation(true)

  local spos = self:GetOwner():GetShootPos()
  local sdest = spos + (self:GetOwner():GetAimVector() * 70)

  local kmins = Vector(1,1,1) * -10
  local kmaxs = Vector(1,1,1) * 10

  local tr = util.TraceHull({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

  -- Hull might hit environment stuff that line does not hit
  if not IsValid(tr.Entity) then
    tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
  end

  local hitEnt = tr.Entity

  -- Check if we just hit an entity
  if IsValid(hitEnt) then
    -- Check if that entity was a player
    if hitEnt:IsPlayer() then
      -- Get the player that was hit and the client
      local hitPlayer = hitEnt
      local client = self:GetOwner()

      -- Create a string and gather colors
      local teamStr = hitPlayer:GetName() .. " has been deciphered as a " .. hitPlayer:GetRoleString()
      local hitColor = hitPlayer:GetRoleColor()
      local clientColor = client:GetRoleColor()

      -- Send a message to the client
      EPOP:AddMessage({text = "Minitester results are in!", color = clientColor}, {text = teamStr, color = hitColor}, 6, nil, true)
    end
  end
end