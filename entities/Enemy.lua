local Enemy = Object:extend()

function Enemy:new(x, y)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 50, h = 75}

    self.max_speed = 2
    self.vel = {x = 0, y = 0}
    self.acc = 0.2

    self.health = 100
    self.target = nil
    self.projectile = nil
    self.sprite = true
    self.is_enemy = true
end

function Enemy:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

return Enemy
