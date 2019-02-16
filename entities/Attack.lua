local Attack = Object:extend()

function Attack:new(x, y, w, h, duration, dmg, owner)
    self.owner = owner

    self.offset = {x = x, y = y}
    self.hitbox = {w = w, h = h}
    self.pos = {
        x = self.owner.pos.x + self.owner.hitbox.w / 2 - self.hitbox.w / 2 + self.offset.x * self.owner.dir,
        y = self.owner.pos.y + self.owner.hitbox.h / 2 - self.hitbox.h / 2 + self.offset.y 
    }
    
    self.vel = {x = 0, y = 0}
    
    self.dmg = dmg
    self.duration = duration
    self.indicator_length = 0.2
    
    self.is_attack = true
    self.sprite = true

    tick.delay(function()
        self.remove = true
    end, self.duration)
end

function Attack:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

function Attack:update(dt)
end

function Attack:filter(e)
    if not e.is_player and e.health then
        return "cross"
    end
end

function Attack:onCollide(cols, len)
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

return Attack