local PhysicsSystem = tiny.processingSystem(Object:extend())
PhysicsSystem.filter = tiny.filter("hitbox")

function PhysicsSystem:new(bump_world, map)
    self.bump_world = bump_world
    self.map = map
    
    local objects = self.map.objects

    self.bump_world:add({is_bound = true}, -1, 0, 1, self.map.size.h)
    self.bump_world:add({is_bound = true}, self.map.size.w, 0, 1, self.map.size.h)
    self.bump_world:add({is_bound = true}, 0, -1, self.map.size.w, 1)
    self.bump_world:add({is_bound = true}, 0, self.map.size.h, self.map.size.w, 1)
end

function PhysicsSystem:process(e, dt)
    if e.gravity then
        if e.dashing then
            e.vel.y = 0
        else
            e.vel.y = e.vel.y + e.gravity * dt
        end
    end
    
    local new_x = e.pos.x + e.vel.x * dt
    local new_y = e.pos.y + e.vel.y * dt

    if e.owner and e.offset then
        new_x = e.owner.pos.x + e.owner.hitbox.w / 2 + e.offset.x * e.owner.dir - e.hitbox.w / 2
        new_y = e.owner.pos.y + e.owner.hitbox.h / 2 + e.offset.y - e.hitbox.h / 2
    end

    e.pos.x, e.pos.y, cols, len = self.bump_world:move(e, new_x, new_y, e.filter)

    if e.onCollide then
        e:onCollide(cols, len)
    end
end

function PhysicsSystem:onAdd(e)
    self.bump_world:add(e, e.pos.x, e.pos.y, e.hitbox.w, e.hitbox.h)
end

function PhysicsSystem:onRemove(e)
    self.bump_world:remove(e)
end

return PhysicsSystem