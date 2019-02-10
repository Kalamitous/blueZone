local Projectile = Object:extend()

function Projectile:new(x, y, target)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 15, h = 15}

    self.target = target
    self.angle = lume.angle(self.pos.x, self.pos.y , self.target.pos.x, self.target.pos.y)

    self.max_speed = 8
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.angle, self.max_speed)

    self.health = 1
    self.sprite = true
    self.is_projectile = true
end

function Projectile:draw()
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

return Projectile