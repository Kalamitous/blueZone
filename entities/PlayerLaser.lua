local PlayerLaser = Object:extend()

function PlayerLaser:new(x, y, owner)
    self.owner = owner

    self.offset = {x = x, y = y}
    self.pos = {
        x = self.owner.pos.x + self.owner.hitbox.w / 2 + self.offset.x * self.owner.dir,
        y = self.owner.pos.y + self.owner.hitbox.h / 2 + self.offset.y 
    }
    
    self.max_speed = 6400
    self.ang = lume.angle(self.owner.pos.x, self.owner.pos.y, self.owner.pos.x + self.owner.dir, self.owner.pos.y)
    self.ending = {}
    self.ending.x, self.ending.y = lume.vector(self.ang, love.graphics.getWidth() - self.pos.x)
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)

    self.dmg = 10
    self.lifetime = 1.5

    self.is_laser = true
    self.is_attack = true
    self.sprite = true
    self.age = 0

    tick.delay(function()
        if self then
            self.remove = true
        end
    end, self.lifetime)
end

function PlayerLaser:draw()
    love.graphics.setColor(1, 0.1, 0.1, 0.9)
    love.graphics.setLineWidth(3)
    love.graphics.line(self.pos.x, self.pos.y, self.ending.x, self.ending.y)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end

function PlayerLaser:update(dt)
    self.age = self.age + dt
    self.ending = {
        x = self.pos.x + (self.vel.x * self.age),
        y = self.pos.y + (self.vel.y * self.age)
    }
end

function PlayerLaser.filter(item)
    if not item.is_player and item.health then
        return true
    end
end

function PlayerLaser:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i].other

        if e.health > 0 and e.last_hit ~= self then
            e.health = e.health - self.dmg
            
            if e.health <= 0 then
                if e.is_enemy then
                    self.owner.points = self.owner.points + 500
                elseif e.is_projectile then
                    self.owner.points = self.owner.points + 100
                end

                e.remove = true
            end

            e.last_hit = self
            e.attack_indicator = true

            tick.delay(function() 
                e.attack_indicator = false
            end, self.indicator_length)
        end
    end
end

return PlayerLaser