local game = {}

-- based on what i know (very little of) about ECS, movement code should be part of a System
-- let's figure this out
function game:update(dt)
    dx = 0
    dy = 0

    -- implement Baton input library
    -- also we're using arrow keys
    if love.keyboard.isDown("w") then
        dy = -1
    elseif love.keyboard.isDown("s") then
        dy = 1
    end

    if love.keyboard.isDown("a") then
        dx = -1
    elseif love.keyboard.isDown("d") then
        dx = 1
    end

    local player_position = player:get(Position)
    player_position:translate(dx, dy)
end

function game:draw()
    local player_position = player:get(Position)
    local player_size = player:get(Size)

    love.graphics.rectangle("fill", player_position.x, player_position.y, player_size.w, player_size.h)
end

return game
