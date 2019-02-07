local PlayerControl = tiny.processingSystem(Object:extend())
PlayerControl.filter = tiny.requireAll("controllable")

function PlayerControl:process(e, dt)
    dx = 0
    dy = 0

    if input:down("up") then
        dy = dy - 1
    end

    if input:down("down") then
        dy = dy + 1
    end

    if input:down("left") then
        dx = dx - 1
    end

    if input:down("right") then
        dx = dx + 1
    end

    e.x = e.x + dx
    e.y = e.y + dy
end

return PlayerControl
