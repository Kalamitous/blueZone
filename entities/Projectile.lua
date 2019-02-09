local Projectile = Object:extend()

function Projectile:new(x, y, target)
    self.x = x or 0
    self.y = y or 0
    self.w = 15
    self.h = 15
    self.health = 1
    self.max_speed = 8
    self.velocity = {x = 0, y = 0}
    self.sprite = true
    self.target = target
    self.dir = math.atan2(self.target.y - self.y, self.target.x - self.x)
    self.is_projectile = true
    self.hitbox = true
end

function Projectile:draw()
    love.graphics.circle("fill", self.x, self.y, self.w, self.h)
end

return Projectile
