-- fixed timestep so love.update() and love.draw() are not based on fps
require 'run'

bump = require 'libs.bump'
Object = require 'libs.classic'
tiny = require 'libs.tiny'
Player = require 'entities.Player'
Enemy = require 'entities.Enemy'
Projectile = require 'entities.Projectile'
CameraTrackingSystem = require 'systems.CameraTrackingSystem'
CollisionSystem = require 'systems.CollisionSystem'
HUDSystem = require 'systems.HUDSystem'
PlayerControlSystem = require 'systems.PlayerControlSystem'
SpriteSystem = require 'systems.SpriteSystem'
PhysicsSystem = require 'systems.PhysicsSystem'
Camera = require 'libs.camera'
Gamestate = require 'libs.gamestate'
game = require 'states.game'
menu = require 'states.menu'
pause = require 'states.pause'
settings = require 'states.settings'
sti = require 'libs.sti'
document = require 'libs.ui'
lume = require 'libs.lume'
baton = require 'libs.baton'

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
    --Gamestate.switch(menu)
    Gamestate.switch(game)
end

function love.update(dt)
    input:update()

    Gamestate:update()
end

function love.draw()
    Gamestate:draw()
end
