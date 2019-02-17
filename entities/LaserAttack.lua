local LaserAttack = Attack:extend()

function LaserAttack:new(x, y, duration, charge_time, owner)
    Attack.super.new(self, x, y, 0, 0, duration, owner)
    self.owner = owner

    self.offset = {x = x, y = y}
    self.pos = {
        x = self.owner.pos.x + self.owner.hitbox.w / 2 + self.offset.x * self.owner.dir,
        y = self.owner.pos.y + self.owner.hitbox.h / 2 + self.offset.y 
    }
    
    self.ang = lume.angle(self.owner.pos.x, self.owner.pos.y, self.owner.pos.x + self.owner.dir, self.owner.pos.y)
    self.end_pos = {x = self.pos.x , y = self.pos.y}

    self.max_speed = 6400
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)

    self.dmg = 10 + 20 * charge_time
    self.age = 0

    self.is_laser = true
    self.is_attack = true
    self.sprite = true

    tick.delay(function()
        self.remove = true
    end, duration)
end

function LaserAttack:update(dt)
    self.age = self.age + dt

    self.end_pos.x = self.pos.x + (self.vel.x * self.age)
    self.end_pos.y = self.pos.y + (self.vel.y * self.age)
end

function LaserAttack:draw()
    love.graphics.setColor(1, 0.1, 0.1, 0.9)
    love.graphics.setLineWidth(3)
    love.graphics.line(self.pos.x, self.pos.y, self.end_pos.x, self.end_pos.y)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end

function LaserAttack:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i]

        if e.health > 0 and e.last_hit ~= self then
            e:takeDamage(self.dmg)
            e.last_hit = self
        end
    end
end

-- must be .filter and not :filter idk why
function LaserAttack.filter(e)
    if not e.is_player and e.health then
        return "cross"
    end
end

return LaserAttack