local Laser = Projectile:extend()

function Laser:new(x, y, owner, target)
    Laser.super.new(self, x, y, owner, target)
    self.hitbox=nil
    self.ending = {
        x = x or 0,
        y = y or 0
    }
    self.dmg = 1
    self.max_speed = 400
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)
    self.lifetime = 2.5

    self.is_projectile = false
    self.is_laser = true
    self.age = 0

    tick.delay(function()
        self.remove = true
    end, self.lifetime)
end

function Laser:draw()
    love.graphics.setColor(1, 0.1, 0.1, 0.9)
    love.graphics.setLineWidth(3)
    love.graphics.line(self.pos.x, self.pos.y, self.ending.x, self.ending.y)
end

function Laser:update(dt)
    self.age = self.age + dt
    self.ending = {
        x = self.pos.x + (self.vel.x * self.age),
        y = self.pos.y + (self.vel.y * self.age)
    }
end

function Laser:filter(item)
    if item and item.is_player and not item.invincible and not item.dead then
        item.health = math.max(item.health - self.dmg, 0)

        if item.health <= 0 then
            item.vel.x, item.vel.y = lume.vector(self.ang, self.max_speed * 4)
        end

        item:setInvincible(item.invincible_time)

        self.remove = true
        return "cross"
    end
end

return Laser