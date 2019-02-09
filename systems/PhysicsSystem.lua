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
        if e2.is_player then
            return nil
        end

        return "slide"
    end
end

function PhysicsSystem:process(e, dt)
    e.pos.x, e.pos.y, cols, len = self.bump_world:move(e, e.pos.x + e.vel.x, e.pos.y + e.vel.y, collisionFilter)

    if len == 0 then
        e.vel.y = e.vel.y + GRAVITY

        e.hit_vertical_surface = false
    else
        -- sliding
        if e.vel.x < 0 then
            e.vel.x = math.min(e.vel.x + e.acc, 0)
        elseif e.vel.x > 0 then
            e.vel.x = math.max(e.vel.x - e.acc, 0)
        end
    end

    for i = 1, len do
        if cols[i].normal.x == 0 then
            e.vel.y = 0

            if cols[i].normal.y < 0 then
                e.on_ground = true
            end

            e.hit_vertical_surface = false
        else
            -- stop horizontal motion if hit vertical surface
            e.vel.x = 0
            
            e.hit_vertical_surface = true  
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
