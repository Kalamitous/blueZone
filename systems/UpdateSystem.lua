local UpdateSystem = tiny.processingSystem(Object:extend())
UpdateSystem.filter = tiny.filter("update")

function UpdateSystem:new(ecs_world)
    self.ecs_world = ecs_world
end

function UpdateSystem:process(e, dt)
    e:update(dt)

    if e.remove then
        self.ecs_world:remove(e)
    end
end

return UpdateSystem