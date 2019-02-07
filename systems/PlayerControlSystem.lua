local PlayerControlSystem = tiny.processingSystem(Object:extend())
PlayerControlSystem.filter = tiny.requireAll("controllable")

function PlayerControlSystem:process(e, dt)
    e.velocity.x = 0
    
    -- make gravity a system
    if e.velocity.y ~= 0 then
        e.velocity.y = e.velocity.y + 0.2
    end

    if input:down("up") then
        if e.velocity.y == 0 then
            e.velocity.y = e.velocity.y - e.jump_height
        end
    end

    if input:down("left") then
        e.velocity.x = e.velocity.x - e.speed
    end

    if input:down("right") then
        e.velocity.x = e.velocity.x + e.speed
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
