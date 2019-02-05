-- fixed timestep so love.update() and love.draw() are not based on fps
require 'run'

Concord = require("libs.concord").init()
Entity = require 'libs.concord.entity'
Component = require 'libs.concord.component'
System = require 'libs.concord.system'
Instance = require 'libs.concord.instance'

-- automate these requires
Position = require 'components.position'
Size = require 'components.size'
Health = require 'components.health'
player = require 'entities.player'

Gamestate = require 'libs.gamestate'
game = require 'states.game'
menu = require 'states.menu'
pause = require 'states.pause'
settings = require 'states.settings'

lume = require 'lume'
baton = require 'libs/baton'
input = baton.new {
    controls = {
        left = {'key:left', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'axis:leftx+', 'button:dpright'},
        up = {'key:up', 'axis:lefty-', 'button:dpup'},
        down = {'key:down', 'axis:lefty+', 'button:dpdown'},
        pause = {'key:escape'},
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'}
    },
    joystick = love.joystick.getJoysticks()[1],
}

function love.load()
    instance = Instance()
    Gamestate.switch(menu)
end

function love.update(dt)
    input:update()
    instance:emit("update", dt)
    Gamestate:update()
end

function love.draw()
    instance:emit("draw")
    Gamestate:draw()
end
