local game = {}

function game:init()
    world:add(Player(0, 300))
end

function game:update(dt)
    if input:down("pause") then
        Gamestate.switch(pause)
    end
end

return game
