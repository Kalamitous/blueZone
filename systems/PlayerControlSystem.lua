local PlayerControlSystem = tiny.processingSystem(Object:extend())
PlayerControlSystem.filter = tiny.filter("is_player")

local GRAVITY = 0.2

function PlayerControlSystem:process(e, dt)
    if input:down("left") then
        if e.on_ground then
            e.vel.x = math.max(e.vel.x - e.acc, -e.max_speed)
        else
            if not e.hit_vertical_surface then
                e.vel.x = math.max(e.vel.x - e.acc / 2, -e.max_speed)
            end
        end
    end

    if input:down("right") then
        if e.on_ground then
            e.vel.x = math.min(e.vel.x + e.acc, e.max_speed)
        else
            if not e.hit_vertical_surface then
                e.vel.x = math.min(e.vel.x + e.acc / 2, e.max_speed)
            end
        end
    end

    if input:pressed("up") then
        if e.on_ground then
            e.vel.y = e.vel.y - e.jump_height

            e.on_ground = false
        end
    end

    -- player will jump higher the longer they hold up by increasing gravity when they let go
    if not input:down("up") and not e.on_ground then
        if e.vel.y < 0 then
           e.vel.y = e.vel.y + GRAVITY
        end
    end
end

return PlayerControlSystem
