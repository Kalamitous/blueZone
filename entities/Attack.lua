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
    
    self.is_attack = true
    self.sprite = true

    tick.delay(function()
        self.remove = true
    end, duration)
end

function Attack:update(dt)
end

function Attack:draw()
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

function Attack:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i].other

        if e.health > 0 and e.last_hit ~= self then
            e:takeDamage(self.dmg)
            e.last_hit = self

            self.owner.points = self.owner.points + self.dmg * 10
            if e.health == 0 then
                self.owner.points = self.owner.points + 2000
            end
        end
    end
end

function Attack:filter(e)
    if not e.is_player and e.health then
        return "cross"
    end
end

return Attack