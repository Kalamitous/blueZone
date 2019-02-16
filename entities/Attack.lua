local Attack = Object:extend()

function Attack:new(offset_x, offset_y, lifetime, owner)
    self.owner = owner

    self.offset = {x = offset_x or 0, y = offset_y or 0}
    self.hitbox = {w = 20, h = 40}
    self.pos = {
        x = self.owner.pos.x + self.owner.hitbox.w / 2 + self.offset.x * self.owner.dir - self.hitbox.w / 2,
        y = self.owner.pos.y + self.owner.hitbox.h / 2 + self.offset.y - self.hitbox.h / 2
    }
    
    self.vel = {x = 0, y = 0}
    
    self.dmg = 20
    self.lifetime = lifetime
    self.indicator_length = 0.2
    
    self.is_attack = true
    self.sprite = true

    tick.delay(function()
        self.remove = true
    end, self.lifetime)
end

function Attack:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

function Attack:update(dt)
end

function Attack:filter(e)
    return "cross"
end

function Attack:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i].other

        if e.is_enemy then
            if e.last_hit ~= self then
                e.health = e.health - self.dmg
                
                if e.health <= 0 then
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
end

return Attack