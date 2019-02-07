local game = {}

local updateFilter = tiny.rejectAny("isDrawSystem")
local drawFilter = tiny.requireAll("isDrawSystem")

function game:init()
    world:add(Player(0, 300), Enemy(300, 275))
end

function game:update(dt)
    world:update(dt, updateFilter)

    if input:down("pause") then
        Gamestate.switch(pause)
    end
end

function game:draw()
    world:update(dt, drawFilter)
end

return game
