-- fixed timestep so love.update() and love.draw() are not based on fps
require 'run'

Camera = require 'libs.camera'
Object = require 'libs.classic'
Gamestate = require 'libs.gamestate'

sti = require 'libs.sti'
document = require 'libs.ui'
baton = require 'libs.baton'
bump = require 'libs.bump'
lume = require 'libs.lume'
tiny = require 'libs.tiny'

Enemy = require 'entities.Enemy'
Player = require 'entities.Player'
Projectile = require 'entities.Projectile'

AISystem = require 'systems.AISystem'
CameraTrackingSystem = require 'systems.CameraTrackingSystem'
HUDSystem = require 'systems.HUDSystem'
PhysicsSystem = require 'systems.PhysicsSystem'
PlayerControlSystem = require 'systems.PlayerControlSystem'
ProjectileSystem = require 'systems.ProjectileSystem'
SpriteSystem = require 'systems.SpriteSystem'

game = require 'states.game'
menu = require 'states.menu'
pause = require 'states.pause'
settings = require 'states.settings'

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
