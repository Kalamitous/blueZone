local Attack = Object:extend()

function Attack:new(offset_x, offset_y, lifetime, owner)
    self.offset = { x = offset_x or 0, y = offset_y or 0 }
    self.pos = {x = owner.pos.x + offset_x or 0, y = owner.pos.y + offset_y or 0}
    self.hitbox = {w = 20, h = 40}
    self.vel = {x = 0, y = 0}

    self.owner = owner
    self.bump_world = bump_world
    
    self.dmg = 20
    self.lifetime = lifetime
    self.sprite = true
    self.is_projectile = false
    self.is_attack = true
    tick.delay(function() 
        self.remove = true
    end, self.lifetime)
end

function Attack:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

function Attack:update(dt)
    self.vel.x = self.owner.vel.x
    self.vel.y = self.owner.vel.y
    --self.pos.x, self.pos.y, cols, len = self.bump_world:move(self, self.owner.pos.x + self.offset.x, self.owner.pos.y + self.offset.y, self.filter)
end

function Attack:filter(e)
    return "cross"
end

function Attack:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i].other

        if e.is_enemy then
            if not e.invincible then
                e.health = e.health - self.dmg
                e.invincible = true
                
                self.remove = true

                tick.delay(function()
                    e.invincible = false
                end, e.invincible_time)
            end
        end
    end
end

return Attack