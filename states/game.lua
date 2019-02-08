local game = {
    world = tiny.world(PlayerControlSystem, SpriteSystem),
    map = nil
}

local updateFilter = tiny.rejectAny("isDrawSystem")
local drawFilter = tiny.requireAll("isDrawSystem")

function game:init()
    self.world:add(Player(0, 300), Enemy(300, 275))
    self:stage("assets/maps/test.lua")
end

function game:stage(file)
    self.map = sti(file, {"bump"})
end

function game:update(dt)
    self.map:update(dt)
    self.world:update(dt, updateFilter)

    if input:down("pause") then
        Gamestate.switch(pause)
    end
end

function game:draw()
    self.map:draw()
    self.world:update(dt, drawFilter)
end

return game
