local Rocketeer = Enemy:extend()

function Rocketeer:new(spawn_platform)
    Rocketeer.super.new(self, spawn_platform)
    self.lock_time = 0.4
    self.delay = nil
    self.is_rocketeer = true
    self.target_distance = 150
    self.escape_distance = 100
    self.escape_time = 0.25
    self.ignores_stop = true
end

function Rocketeer:shoot(ecs_world)
    ecs_world:add(Missile(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self, self.target))
    
    self.can_shoot = false

    tick.delay(function()
        if self then
            self.can_shoot = true
        end
    end, self.reload_time)
end

function Rocketeer:draw()
    --[[if self.target then
        love.graphics.setColor(1, 0.1, 0.1, 0.25)
        love.graphics.setLineWidth(1)
        local centerX = self.pos.x + (self.hitbox.w / 2)
        local centerY = self.pos.y + (self.hitbox.h / 2)
        local targetCenterX = self.target.pos.x + (self.target.hitbox.w / 2)
        local targetCenterY = self.target.pos.y + (self.target.hitbox.h / 2)
        love.graphics.line(centerX, centerY, targetCenterX, targetCenterY)
    end]]
    brightness = self.health / 100
    love.graphics.setColor(brightness*0.9, brightness*0.55, brightness*0.25)
    
    if self.attack_indicator then
        love.graphics.setColor(1, 0.3, 0)
    elseif self.target then
        love.graphics.setColor(brightness, 0.35 * brightness, 0.05 * brightness)
    end
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)
end

return Rocketeer