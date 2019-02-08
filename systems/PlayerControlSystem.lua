local PlayerControlSystem = tiny.processingSystem(Object:extend())
local GRAVITY = 0.2
PlayerControlSystem.filter = tiny.requireAll("is_player")

function PlayerControlSystem:process(e, dt)
    if e:isInAir() then
        e.velocity.y = e.velocity.y + GRAVITY
    end

    if input:down("left") then
        if not e:isInAir() then
            e.velocity.x = lume.clamp(e.velocity.x - e.acceleration, -e.max_speed, 0)
        else
            e.velocity.x = lume.clamp(e.velocity.x - e.acceleration, -e.max_speed, e.max_speed)
        end
    end

    if input:down("right") then
        if not e:isInAir() then
            e.velocity.x = lume.clamp(e.velocity.x + e.acceleration, 0, e.max_speed)
        else
            e.velocity.x = lume.clamp(e.velocity.x + e.acceleration, -e.max_speed, e.max_speed)
        end
    end

    if input:pressed("up") then
        if not e:isInAir() then
            e.velocity.y = e.velocity.y - e.jump_height
        end
    end

    -- player will jump higher the longer they hold up by increasing gravity when they let go
    if not input:down("up") and e:isInAir() then
        if e.velocity.y < 0 then
            e.velocity.y = e.velocity.y + GRAVITY / 2
        end
    end

    e.x = e.x + e.velocity.x
    e.y = e.y + e.velocity.y

    -- sliding
    if not input:down("left") and not input:down("right") and not e:isInAir() then
        if e.velocity.x < 0 then
            e.velocity.x = lume.clamp(e.velocity.x + e.acceleration, -e.max_speed, 0)
        elseif e.velocity.x > 0 then
            e.velocity.x = lume.clamp(e.velocity.x - e.acceleration, 0, e.max_speed)
        end
    end

    -- this will be the ground for now...
    if e.y > 300 then
        e.velocity.y = 0
        e.y = 300
    end
end

return PlayerControlSystem
