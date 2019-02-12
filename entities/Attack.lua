local Attack = Object:extend()

function Attack:new(offset_x, offset_y, lifetime, owner)
    self.offset = { x = offset_x or 0, y = offset_y or 0 }
    self.pos = {x = owner.pos.x + offset_x or 0, y = owner.pos.y + offset_y or 0}
    self.hitbox = {w = 20, h = 40}
    self.vel = {x = 0, y = 0}

    self.owner = owner
    
    self.dmg = 1
    self.lifetime = lifetime
    self.sprite = true
    self.is_projectile = false
    self.is_attack = true
end

function Attack:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

return Attack