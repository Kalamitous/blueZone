local AISystem = tiny.processingSystem(Object:extend())
AISystem.filter = tiny.filter("is_enemy")

function AISystem:init(world)
    self.world = world
end

function AISystem:process(e, dt)
    if not e.target then
        for k, v in pairs(self.world.entities) do
            if tostring(v) == "Object" then
                if v.is_player then
                    e.target = v
                end
            end
        end
    end

    if not self.projectile then
        self.projectile = Projectile(e.pos.x, e.pos.y, e.target)
        
        self.world:add(self.projectile)
    end
end

return AISystem
