local Projectile = Object:extend()

function Projectile:new(x, y, owner, target)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 15, h = 15}

    self.owner = owner
    self.target = target
    self.ang = lume.angle(self.pos.x, self.pos.y, self.target.pos.x, self.target.pos.y)

    self.max_speed = 2
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)

    self.health = 1
    self.dmg = 10
    self.sprite = true
    self.is_projectile = true
end

function Projectile:draw()
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

return Projectile

-- make projectiles die when off screen