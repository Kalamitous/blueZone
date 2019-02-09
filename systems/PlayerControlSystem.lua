local PlayerControlSystem = tiny.processingSystem(Object:extend())
local GRAVITY = 0.2
PlayerControlSystem.filter = tiny.requireAll("is_player")

function PlayerControlSystem:process(e, dt)
    if input:down("left") then
        if e.on_ground then
            e.velocity.x = lume.clamp(e.velocity.x - e.acceleration, -e.max_speed, e.max_speed)
        else
            if not e.hit_vertical_surface then
                e.velocity.x = lume.clamp(e.velocity.x - e.acceleration, -e.max_speed, e.max_speed)
            end
        end
    end

    if input:down("right") then
        if e.on_ground then
            e.velocity.x = lume.clamp(e.velocity.x + e.acceleration, -e.max_speed, e.max_speed)
        else
            if not e.hit_vertical_surface then
                e.velocity.x = lume.clamp(e.velocity.x + e.acceleration, -e.max_speed, e.max_speed)
            end
        end
    end

    if input:pressed("up") then
        if e.on_ground then
            e.velocity.y = e.velocity.y - e.jump_height

            e.on_ground = false
        end
    end

    -- player will jump higher the longer they hold up by increasing gravity when they let go
    if not input:down("up") and not e.on_ground then
        if e.velocity.y < 0 then
           e.velocity.y = e.velocity.y + GRAVITY / 2
        end
    end
end

return PlayerControlSystem
