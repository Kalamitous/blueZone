local PhysicsSystem = tiny.processingSystem(Object:extend())
PhysicsSystem.filter = tiny.requireAll("hitbox")

function PhysicsSystem:new(bumpWorld)
    self.bumpWorld = bumpWorld
end

function PhysicsSystem:process(e, dt)
    e.x, e.y, cols, lens = self.bumpWorld:move(e, e.x + e.velocity.x, e.y + e.velocity.y)

    if lens == 0 then
        e.velocity.y = e.velocity.y + 0.2
    else
        e.velocity.y = 0
    end
end

function PhysicsSystem:onAdd(e)
    self.bumpWorld:add(e, e.x, e.y, e.w, e.h)
end

function PhysicsSystem:onRemove(e)
    self.bumpWorld:remove(e)
end

return PhysicsSystem
