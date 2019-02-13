local PlayerControlSystem = tiny.processingSystem(Object:extend())
PlayerControlSystem.filter = tiny.filter("is_player")

function PlayerControlSystem:process(e, dt)
    e.running = false

    if input:down("left") then
        if e.grounded then
            e.vel.x = math.max(e.vel.x - e.acc * dt, -e.max_speed)

            e.running = true
        else
            if not e.hit_vertical_surface then
                e.vel.x = math.max(e.vel.x - e.acc * dt / 2, -e.max_speed)
            end
        end

        e.dir = -1
    end

    if input:down("right") then
        if e.grounded then
            e.vel.x = math.min(e.vel.x + e.acc * dt, e.max_speed)

            e.running = true
        else
            if not e.hit_vertical_surface then
                e.vel.x = math.min(e.vel.x + e.acc * dt / 2, e.max_speed)
            end
        end

        e.dir = 1
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
end

return PlayerControlSystem