local Beamer = Enemy:extend()

function Beamer:new(spawn_platform)
    Beamer.super.new(self, spawn_platform)
    self.lock_time = 0.5
    self.delay = nil
end

function Beamer:shoot(ecs_world)
    ecs_world:add(Laser(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self, self.target))
    
    self.can_shoot = false

    tick.delay(function()
        if self then
            self.can_shoot = true
        end
    end, self.reload_time)
end

function Beamer:draw()
    if self.target then
        love.graphics.setColor(1, 0.1, 0.1, 0.25)
        love.graphics.setLineWidth(1)
        local centerX = self.pos.x + (self.hitbox.w / 2)
        local centerY = self.pos.y + (self.hitbox.h / 2)
        local targetCenterX = self.target.pos.x + (self.target.hitbox.w / 2)
        local targetCenterY = self.target.pos.y + (self.target.hitbox.h / 2)
        love.graphics.line(centerX, centerY, targetCenterX, targetCenterY)
    end
    brightness = self.health / 100
    love.graphics.setColor(brightness*0.5, brightness*0.75, brightness)
    
    if self.attack_indicator then
        love.graphics.setColor(1, 0, 0.25)
    elseif self.target then
        love.graphics.setColor(0.2 * brightness, 1 * brightness, 0.65 * brightness)
    end
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)
end

return Beamer