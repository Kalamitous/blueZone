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

return Beamer