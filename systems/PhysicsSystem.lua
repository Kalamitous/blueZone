local PhysicsSystem = tiny.processingSystem(Object:extend())
PhysicsSystem.filter = tiny.filter("hitbox")

function PhysicsSystem:new(ecs_world, bump_world, map)
    self.ecs_world = ecs_world
    self.bump_world = bump_world
    self.map = map
    
    local objects = self.map.objects

    for _, o in pairs(objects) do
        if o.name == "Bounds" then
            self.bump_world:add({is_bound = true}, o.x - 1, o.y, 1, o.height)
            self.bump_world:add({is_bound = true}, o.x + o.width, o.y, 1, o.height)
            self.bump_world:add({is_bound = true}, o.x, o.y - 1, o.width, 1)
            self.bump_world:add({is_bound = true}, o.x, o.y + o.height, o.width, 1)
        end
    end
end

function PhysicsSystem:process(e, dt)
    if e.gravity then
        e.vel.y = e.vel.y + e.gravity * dt
    end

    local new_x = e.pos.x + e.vel.x * dt
    local new_y = e.pos.y + e.vel.y * dt

    if e.update then
        e:update(dt)
    end

    e.pos.x, e.pos.y, cols, len = self.bump_world:move(e, new_x, new_y, e.filter)

    if e.onCollide then
        e:onCollide(cols, len)
    end
        
    if e.remove then
        self.ecs_world:remove(e)
    end
end

function PhysicsSystem:onAdd(e)
    self.bump_world:add(e, e.pos.x, e.pos.y, e.hitbox.w, e.hitbox.h)
end

function PhysicsSystem:onRemove(e)
    self.bump_world:remove(e)
end

return PhysicsSystem