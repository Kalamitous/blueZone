local game = {}

-- based on what i know (very little of) about ECS, movement code should be part of a System
-- let's figure this out
function game:update(dt)
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

    local player_position = player.position
    player_position:translate(dx, dy)

    -- pause functionality
    if input:down("pause") then
        Gamestate.switch(pause)
    end
end

function game:draw()
    local player_position = player.position
    local player_size = player.size

    love.graphics.rectangle("fill", player_position.x, player_position.y, player_size.w, player_size.h)
end

return game
