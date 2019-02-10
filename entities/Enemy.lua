local Enemy = Object:extend()

function Enemy:new(x, y)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 50, h = 75}

    self.max_speed = 2
    self.vel = {x = 0, y = 0}

    self.health = 100
    self.target = nil
    self.projectile = nil
    self.sprite = true
    self.is_enemy = true
end

function Enemy:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)

    love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)
end

return Enemy