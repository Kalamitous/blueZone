local Projectile = Object:extend()

function Projectile:new(x, y, target)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 15, h = 15}

    self.max_speed = 8
    self.vel = {x = 0, y = 0}

    self.health = 1
    self.target = target
    self.dir = math.atan2(self.target.pos.y - self.pos.y, self.target.pos.x - self.pos.x)
    self.sprite = true
    self.is_projectile = true
end

function Projectile:draw()
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

return Projectile
