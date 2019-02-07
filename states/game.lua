local game = {}

function game:init()
    world:add(Player())
end

function game:update(dt)
    -- pause functionality
    if input:down("pause") then
        Gamestate.switch(pause)
    end
end

return game
