-- fixed timestep so love.update() and love.draw() are not based on fps
require 'run'

Object = require 'libs.classic'
tiny = require 'libs.tiny'
Player = require 'entities.player'
PlayerControl = require 'systems.PlayerControl'
Sprite = require 'systems.Sprite'

Gamestate = require 'libs.gamestate'
game = require 'states.game'
menu = require 'states.menu'
pause = require 'states.pause'
settings = require 'states.settings'

document = require 'libs/ui'
lume = require 'libs/lume'
baton = require 'libs/baton'

world = tiny.world(PlayerControl, Sprite)
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

local updateFilter = tiny.rejectAny("isDrawSystem")
local drawFilter = tiny.requireAll("isDrawSystem")

function love.load()
    Gamestate.switch(menu)
end

function love.update(dt)
    world:update(dt, updateFilter)
    input:update()

    Gamestate:update()
end

function love.draw()
    world:update(dt, drawFilter)

    Gamestate:draw()
end
