local Beamer = Enemy:extend()

function Beamer:new(spawn_platform)
    Beamer.super.new(self, spawn_platform)

    self.lock_time = 0.5
    self.reload_time = 2
end

function Beamer:draw()
    if self.target and self.can_shoot and not self.stunned then
        local center_x = self.pos.x + (self.hitbox.w / 2)
        local center_y = self.pos.y + (self.hitbox.h / 2)
        local target_center_x = self.target.pos.x + (self.target.hitbox.w / 2)
        local target_center_y = self.target.pos.y + (self.target.hitbox.h / 2)
        
        love.graphics.setColor(1, 0.1, 0.1, 0.25)
        love.graphics.line(center_x, center_y, target_center_x, target_center_y)
    end

    if self.attack_indicator then
        love.graphics.setColor(1, 0, 0, 0.25)
    elseif self.target then
        love.graphics.setColor(0.2, 1, 0.65, 0.25)
    end

    love.graphics.setColor(0.5, 0.75, 0, 0.25)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)

    self:drawHealthbar()
end

function Beamer:shoot(ecs_world)
    ecs_world:add(Laser(0, 0, self, self.target))
    
    self.can_shoot = false

    tick.delay(function()
        self.can_shoot = true
    end, self.reload_time)
end

return Beamer