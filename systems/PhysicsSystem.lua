local PhysicsSystem = tiny.processingSystem(Object:extend())
PhysicsSystem.filter = tiny.filter("hitbox")

local GRAVITY = 0.2

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

function collisionFilter(e1, e2)
    if e1.is_player then
        -- we know for sure it is a map tile if it has `properties`
        if e2.properties then
            if e2.properties.collidable then
                -- pass through if player hasn't reached top of tile
                if e2.y >= e1.pos.y + e1.hitbox.h then
                    return "slide"
                end
            end
        elseif e2.is_bound then
            return "slide"
        elseif e2.is_projectile then
            if not e1.invincible then
                e1.health = e1.health - e2.dmg
                e1.invincible = true

                e2.remove = true

                tick.delay(function()
                    e1.invincible = false
                end, e1.invincible_time)
            end
        end
    elseif e1.is_enemy then
        return nil
    elseif e1.is_projectile then
        if e2.is_bound then
            --TODO: make projectile disappear after the whole thing is off bounds
            e1.remove = true
        end
    end
end

function PhysicsSystem:process(e, dt)
    if e.is_player then
        e.vel.y = e.vel.y + e.gravity * dt
    end

    local new_x = e.pos.x + e.vel.x * dt
    local new_y = e.pos.y + e.vel.y * dt

    if e.is_enemy then
        e.cur_dist = e.cur_dist + lume.distance(e.pos.x, e.pos.y, new_x, new_y)
    end

    e.pos.x, e.pos.y, cols, len = self.bump_world:move(e, new_x, new_y, collisionFilter)
  
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
    elseif e.is_enemy then
        if e.cur_dist >= e.goal_dist then
            e:stop()
        end
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