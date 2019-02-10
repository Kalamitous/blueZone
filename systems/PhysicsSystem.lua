local PhysicsSystem = tiny.processingSystem(Object:extend())
PhysicsSystem.filter = tiny.filter("hitbox")

local GRAVITY = 0.2

function PhysicsSystem:new(bump_world)
    self.bump_world = bump_world
end

function collisionFilter(e1, e2)
    if e1.is_player then
        -- we know for sure it is a map tile if it has properties.collidable
        if e2.properties then
            if e2.properties.collidable then
                -- pass through if player hasn't reached top of tile
                if e2.y >= e1.pos.y + e1.hitbox.h then
                    return "slide"
                end
            end
        end
    end

    if e1.is_enemy then
        return nil
    end
end

function PhysicsSystem:process(e, dt)
    if e.is_player then
        e.vel.y = e.vel.y + e.gravity
    end

    e.pos.x, e.pos.y, cols, len = self.bump_world:move(e, e.pos.x + e.vel.x, e.pos.y + e.vel.y, collisionFilter)
    
    if e.is_player then
        e.grounded = false
        e.hit_vertical_surface = false

        for i = 1, len do
            if cols[i].normal.x == 0 then
                e.vel.y = 0

                if cols[i].normal.y < 0 then
                    e.grounded = true
                end
            else
                -- stop horizontal motion if hit vertical surface
                e.vel.x = 0
                
                e.hit_vertical_surface = true  
            end
        end
    end
end

function PhysicsSystem:onAdd(e)
    self.bump_world:add(e, e.pos.x, e.pos.y, e.hitbox.w, e.hitbox.h)
end

function PhysicsSystem:onRemove(e)
    self.bump_world:remove(e)
end

return PhysicsSystem