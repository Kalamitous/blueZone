-- fixed timestep so love.update() and love.draw() are not based on fps
require 'libs/class'
require 'run'

tiny = require("libs.tiny/tiny")
Position = require 'components.position'
Size = require 'components.size'
Health = require 'components.health'
player = require 'entities.player'

Gamestate = require 'libs.gamestate'
game = require 'states.game'
menu = require 'states.menu'
pause = require 'states.pause'
settings = require 'states.settings'

document = require 'libs/ui'
lume = require 'libs/lume'
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
    instance = tiny.world()
    Gamestate.switch(menu)
end

function love.update(dt)
    input:update()
    instance:update(dt)
    Gamestate:update()
end

function love.draw()
    Gamestate:draw()
end
