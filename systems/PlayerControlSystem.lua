local PlayerControlSystem = tiny.processingSystem(Object:extend())
PlayerControlSystem.filter = tiny.requireAll("controllable")

function PlayerControlSystem:process(e, dt)
    -- make gravity a system
    if not e:isInAir() then
        e.velocity.x = 0
    else
        e.velocity.y = e.velocity.y + 0.2
    end

    if input:down("left") then
        if not e:isInAir() then
            e.velocity.x = e.velocity.x - e.speed
        else
            e.velocity.x = lume.clamp(e.velocity.x - 0.2, -e.speed, 0)
        end
    end

    if input:down("right") then
        if not e:isInAir() then
            e.velocity.x = e.velocity.x + e.speed
        else
            e.velocity.x = lume.clamp(e.velocity.x + 0.2, 0, e.speed)
        end
    end

    if input:pressed("up") then
        if not e:isInAir() then
            e.velocity.y = e.velocity.y - e.jump_height
        end
    end

    e.x = e.x + e.velocity.x
    e.y = e.y + e.velocity.y

    -- this will be the ground for now...
    if e.y > 300 then
        e.velocity.y = 0
        e.y = 300
    end
end

return PlayerControlSystem
