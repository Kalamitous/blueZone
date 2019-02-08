local CollisionSystem = tiny.processingSystem(Object:extend())
CollisionSystem.filter = tiny.requireAll("hitbox")

function CollisionSystem:new(bumpWorld)
    self.bumpWorld = bumpWorld
end

function CollisionSystem:process(e, dt)
    
end

return CollisionSystem
