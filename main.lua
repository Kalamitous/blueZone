-- fixed timestep so love.update() and love.draw() are not based on fps
require "run"

Camera = require "libs.camera"
Object = require "libs.classic"
Gamestate = require "libs.gamestate"

animator = require "libs.animator"
sti = require "libs.sti"
document = require "libs.ui"
baton = require "libs.baton"
bump = require "libs.bump"
cargo = require "libs.cargo"
lume = require "libs.lume"
tick = require "libs.tick"
tiny = require "libs.tiny"

Enemy = require 'entities.Enemy'
Beamer = require 'entities.Beamer'
Player = require 'entities.Player'
Projectile = require 'entities.Projectile'
Laser = require 'entities.Laser'
Attack = require 'entities.Attack'

AISystem = require "systems.AISystem"
CameraTrackingSystem = require "systems.CameraTrackingSystem"
DeathSystem = require "systems.DeathSystem"
EnemySpawnSystem = require "systems.EnemySpawnSystem"
HUDSystem = require "systems.HUDSystem"
PhysicsSystem = require "systems.PhysicsSystem"
PlayerControlSystem = require "systems.PlayerControlSystem"
PlayerSpawnSystem = require "systems.PlayerSpawnSystem"
SpriteSystem = require "systems.SpriteSystem"
UpdateSystem = require "systems.UpdateSystem"
LaserSystem = require "systems.LaserSystem"

game = require "states.game"
menu = require "states.menu"
pause = require "states.pause"

assets = cargo.init("assets")
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
        move = {"left", "right", "up", "down"}
    },
    joystick = love.joystick.getJoysticks()[1],
}

function love.load()
    math.randomseed(os.time())
    math.random(); math.random(); math.random()

    -- temporary
    love.graphics.setDefaultFilter("nearest", "nearest")

    --Gamestate.switch(menu)
    Gamestate.switch(menu)
end

function love.update(dt)
    input:update(dt)
    tick.update(dt)

    Gamestate.update(dt)
end

function love.draw()
    Gamestate.draw(dt)
end