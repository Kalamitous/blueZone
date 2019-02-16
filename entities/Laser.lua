local Laser = Projectile:extend()

function Laser:new(x, y, owner, target)
    Laser.super.new(self, x, y, owner, target)
    self.hitbox=nil
    self.ending = {
        x = x or 0,
        y = y or 0
    }
    self.dmg = 1
    self.max_speed = 750
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)
    self.lifetime = 1.5

    self.is_projectile = false
    self.is_laser = true
    self.age = 0

    tick.delay(function()
        if self then
            self.remove = true
        end
    end, self.lifetime)
end

function Laser:draw()
    love.graphics.setColor(1, 0.1, 0.1, 0.9)
    love.graphics.setLineWidth(3)
    love.graphics.line(self.pos.x, self.pos.y, self.ending.x, self.ending.y)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end

function Laser:update(dt)
    self.age = self.age + dt
    self.ending = {
        x = self.pos.x + (self.vel.x * self.age),
        y = self.pos.y + (self.vel.y * self.age)
    }
end

return Laser