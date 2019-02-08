local Projectile = Object:extend()

function Projectile:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.w = 15
    self.h = 15
    self.health = 1
    self.max_speed = 8
    self.velocity = {x = 0, y = 0}
    self.sprite = true
end

return Projectile
