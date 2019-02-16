local Beamer = Enemy:extend()

function Beamer:new(spawn_platform)
    Beamer.super.new(self, spawn_platform)
    self.lock_time = 0.35
    self.delay = nil
end

function Beamer:shoot(ecs_world)
    ecs_world:add(Laser(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self, self.target))
    
    self.can_shoot = false

    tick.delay(function()
        self.can_shoot = true
    end, self.reload_time)
end

function Beamer:draw()
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