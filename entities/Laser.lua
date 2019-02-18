local Laser = Projectile:extend()

function Laser:new(x, y, owner, target)
    Laser.super.new(self, x, y, owner, target)

    self.hitbox = nil
    self.pos = {
        x = self.owner.pos.x + self.owner.hitbox.w / 2 + self.offset.x * self.owner.dir,
        y = self.owner.pos.y + self.owner.hitbox.h / 2 + self.offset.y 
    }

    self.ang = lume.angle(self.pos.x, self.pos.y, self.target.pos.x + self.target.hitbox.w / 2, self.target.pos.y + self.target.hitbox.h / 2)
    
    self.max_speed = 1000
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)
    
    --self.end_pos = {x = self.pos.x + self.delta.x, y = self.pos.y + self.delta.y}

    self.dmg = 10
    self.charge_time = 1.5
    self.lifetime = 2
    self.charging = true
    self.flash_state = false
    self.flash_delay = 0.10
    self.flash_delta = -0.01
    self.flash_min_delay = 0.05

    self.end_pos = {}
    self.end_pos.x = self.pos.x + (self.vel.x * self.lifetime)
    self.end_pos.y = self.pos.y + (self.vel.y * self.lifetime)

    self.is_laser = true
    
    
    tick.delay(function()
        self.end_pos.x = self.pos.x
        self.end_pos.y = self.pos.y
        self.charging = false
        tick.delay(function()
            self.remove = true
        end, self.lifetime)

    end, self.charge_time)
    self:flash()
end

function Laser:flash()
    tick.delay(function() 
        self.flash_delay = self.flash_delay + self.flash_delta
        if self.flash_delay < self.flash_min_delay then
            self.flash_delay = self.flash_min_delay
        end
        if self.flash_state then
            self.flash_state = false
        else
            self.flash_state = true
        end
        if self.charging then
            self:flash()
        end
    end, self.flash_delay)
end

function Laser:update(dt)
    if not self.charging then
        self.end_pos.x = self.end_pos.x + self.vel.x * dt
        self.end_pos.y = self.end_pos.y + self.vel.y * dt
    else
        self.pos.x = self.owner.pos.x + self.owner.hitbox.w / 2
        self.pos.y = self.owner.pos.y + self.owner.hitbox.h / 2
        if self.owner.stunned then
            self.remove = true
        end
    end
end

function Laser:filter(e)
    if not e or not e.is_enemy then
        return "cross"
    end
end

function Laser:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i]

        if e.is_bound then
            -- TODO: make disappear when completely off bounds
            -- self.remove = true
        elseif e.is_player and not e.invincible and not e.dead and not self.charging then
            e:takeDamage(self.dmg)

            if e.dead then
                e.vel.x, self.vel.y = lume.vector(self.ang, 800)
            end

            --self.remove = true
        end
    end
end

function Laser:draw()
    if self.charging then
        if self.flash_state then
            love.graphics.setColor(1, 0.1, 0.1, 0.8)
        else
            love.graphics.setColor(1, 1, 1, 0.8)
        end
        love.graphics.setLineWidth(1)
        love.graphics.line(self.pos.x, self.pos.y, self.end_pos.x, self.end_pos.y)
    else
        love.graphics.setColor(1, 0.1, 0.1, 0.9)
        love.graphics.setLineWidth(3)
        love.graphics.line(self.pos.x, self.pos.y, self.end_pos.x, self.end_pos.y)
        love.graphics.setLineWidth(1)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Laser