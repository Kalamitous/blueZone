local Attack = Object:extend()

function Attack:new(offset_x, offset_y, lifetime, owner)
    self.base_offset = { x = offset_x or 0, y = offset_y or 0 }
    if owner.dir == 1 then
        self.offset = { x = offset_x or 0, y = offset_y or 0 }
    else
        self.offset = { x = -offset_x or 0, y = offset_y or 0 }
    end
    self.hitbox = {w = 20, h = 40}
    self.pos = {
        x = owner.pos.x + owner.hitbox.w / 2 + self.offset.x - self.hitbox.w / 2,
        y = owner.pos.y + owner.hitbox.h / 2 + self.offset.y - self.hitbox.h / 2
    }
    self.vel = {x = 0, y = 0}

    self.owner = owner
    self.bump_world = bump_world
    
    self.dmg = 20
    self.lifetime = lifetime
    self.sprite = true
    self.is_projectile = false
    self.is_attack = true
    self.indicator_length = 0.25
    tick.delay(function() 
        self.remove = true
    end, self.lifetime)
end

function Attack:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

function Attack:update(dt)
    if self.owner.dir == 1 then
        self.offset.x = self.base_offset.x
    else
        self.offset.x = -self.base_offset.x
    end
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