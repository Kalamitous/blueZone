local PhysicsSystem = tiny.processingSystem(Object:extend())
PhysicsSystem.filter = tiny.requireAll("hitbox")

local GRAVITY = 0.2

function PhysicsSystem:new(bumpWorld)
    self.bumpWorld = bumpWorld
end

function collisionFilter(e1, e2)
    if e1.is_player then
        -- we know for sure it is a map tile if it has properties.collidable
        if e2.properties then
            if e2.properties.collidable then
                -- pass through if player hasn't reached top of tile
                if e2.y >= e1.y + e1.h then
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
    e.x, e.y, cols, len = self.bumpWorld:move(e, e.x + e.velocity.x, e.y + e.velocity.y, collisionFilter)

    if len == 0 then
        e.velocity.y = e.velocity.y + GRAVITY

        e.hit_vertical_surface = false
    else
        -- sliding
        if e.velocity.x ~= 0 then
            local dir = e.velocity.x / math.abs(e.velocity.x)
            local max = 0
            local min = 0

            if dir == -1 then
                max = 0
                min = -e.max_speed
            else
                max = e.max_speed
                min = 0
            end

            e.velocity.x = lume.clamp(e.velocity.x - dir * e.acceleration, min, max)
        end
    end

    for i = 1, len do
        if cols[i].normal.x == 0 then
            e.velocity.y = 0

            if cols[i].normal.y < 0 then
                e.on_ground = true
            end

            e.hit_vertical_surface = false
        else
            -- stop horizontal motion if hit vertical surface
            e.velocity.x = 0
            
            e.hit_vertical_surface = true  
        end
    end
end

function PhysicsSystem:onAdd(e)
    self.bumpWorld:add(e, e.x, e.y, e.w, e.h)
end

function PhysicsSystem:onRemove(e)
    self.bumpWorld:remove(e)
end

return PhysicsSystem
