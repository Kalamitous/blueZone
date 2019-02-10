local AISystem = tiny.processingSystem(Object:extend())
AISystem.filter = tiny.filter("is_enemy")

function AISystem:new(ecs_world)
    self.ecs_world = ecs_world
end

function AISystem:process(e, dt)
    if e.desires_move then
        e:moveTo(e.spawn_platform.x + lume.random(e.spawn_platform.width - 50), e.pos.y)
    end

    if not e.target then
        for k, v in pairs(self.ecs_world.entities) do
            if tostring(v) == "Object" then
                if v.is_player then
                    e.target = v
                end
            end
        end
    end

    if not e.projectile then
        e.projectile = Projectile(e.pos.x, e.pos.y, e.target)
        
        --self.ecs_world:add(e.projectile)
    end
end

return AISystem