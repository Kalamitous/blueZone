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
tick = require 'libs.tick'
tiny = require 'libs.tiny'

Enemy = require 'entities.Enemy'
Player = require 'entities.Player'
Projectile = require 'entities.Projectile'
Attack = require 'entities.Attack'

AISystem = require 'systems.AISystem'
CameraTrackingSystem = require 'systems.CameraTrackingSystem'
HUDSystem = require 'systems.HUDSystem'
PhysicsSystem = require 'systems.PhysicsSystem'
PlayerControlSystem = require 'systems.PlayerControlSystem'
SpawnSystem = require 'systems.SpawnSystem'
SpriteSystem = require 'systems.SpriteSystem'
AttackSystem = require 'systems.AttackSystem'

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
        z = {'key:z', 'button:a'},
        pause = {'key:escape'},
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'}
    },
    joystick = love.joystick.getJoysticks()[1],
}

function love.load()
    math.randomseed(os.time())
    math.random(); math.random(); math.random()

    --Gamestate.switch(menu)
    Gamestate.switch(game)
end

function love.update(dt)
    tick.update(dt)
    input:update(dt)

    game:update(dt)
    menu:update(dt)
    pause:update(dt)
    settings:update(dt)
end

function love.draw()
    game:draw()
    menu:draw()
    pause:draw()
    settings:draw()
end