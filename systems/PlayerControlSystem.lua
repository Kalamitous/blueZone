local PlayerControlSystem = tiny.processingSystem(Object:extend())
PlayerControlSystem.filter = tiny.filter("is_player")

function PlayerControlSystem:new(ecs_world)
    self.ecs_world = ecs_world
end

function PlayerControlSystem:process(e, dt)
    if input:down("left") then
        if e.grounded then
            e.vel.x = math.max(e.vel.x - e.acc * dt, -e.max_speed)
        else
            if not e.hit_vertical_surface then
                e.vel.x = math.max(e.vel.x - e.acc * dt / 2, -e.max_speed)
            end
        end
    end

    if input:down("right") then
        if e.grounded then
            e.vel.x = math.min(e.vel.x + e.acc * dt, e.max_speed)
        else
            if not e.hit_vertical_surface then
                e.vel.x = math.min(e.vel.x + e.acc * dt / 2, e.max_speed)
            end
        end
    end

    -- sliding
    if not (input:down("left") or input:down("right")) and e.grounded then
        if e.vel.x < 0 then
            e.vel.x = math.min(e.vel.x + e.acc * dt, 0)
        elseif e.vel.x > 0 then
            e.vel.x = math.max(e.vel.x - e.acc * dt, 0)
        end
    end

    if input:pressed("up") and e.grounded then
        e.vel.y = e.vel.y - e.jump_height

        e.grounded = false
    end

    -- player will jump higher the longer they hold up by increasing gravity when they let go
    if not (input:down("up") or e.grounded) then
        if e.vel.y < 0 then
           e.vel.y = e.vel.y + e.gravity * dt
        end
    end

    --attacks
    if input:pressed("z") then
        e:attack(self.ecs_world)
    end
end

return PlayerControlSystem