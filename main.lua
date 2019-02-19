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
ripple = require "libs.ripple"
tick = require "libs.tick"
tiny = require "libs.tiny"

Enemy = require 'entities.Enemy'
Beamer = require 'entities.Beamer'
Rocketeer = require 'entities.Rocketeer'
Player = require 'entities.Player'
Attack = require 'entities.Attack'
LaserAttack = require 'entities.LaserAttack'
Projectile = require 'entities.Projectile'
Laser = require 'entities.Laser'
Missile = require 'entities.Missile'
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
game_over = require "states.game_over"

assets = cargo.init("assets")
input = baton.new {
    controls = {
        pause = {'key:escape'},
        left = {'key:left', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'axis:leftx+', 'button:dpright'},
        up = {'key:up', 'axis:lefty-', 'button:dpup'},
        down = {'key:down', 'axis:lefty+', 'button:dpdown'},
        light = {'key:z'},
        heavy = {'key:x'},
        special = {'key:c'}
    },
    pairs = {
        move = {"left", "right", "up", "down"}
    },
    joystick = love.joystick.getJoysticks()[1],
}

opacity = 0
fade_out = false
fade_in = false

function love.load()
    math.randomseed(os.time())
    math.random(); math.random(); math.random()

    love.graphics.setDefaultFilter("nearest", "nearest")

    Gamestate.switch(menu)
end

function love.update(dt)
    input:update(dt)
    tick.update(dt)

    Gamestate.update(dt)

    if fade_in then
        opacity = math.min(opacity + dt, 1)

        if opacity == 1 then
            fade_in = false
        end

        if game.stage_num == 1 then
            assets.sounds.music.BGM_2:setVolume(opacity / 2)
        elseif game.stage_num == 2 then
            assets.sounds.music.BGM_3:setVolume(opacity / 2)
        end
    elseif fade_out then
        opacity = math.max(opacity - dt, 0)

        if opacity == 0 then
            fade_out = false
        end

        if game.stage_num == 2 then
            assets.sounds.music.BGM_1:setVolume(opacity / 2)
        elseif game.stage_num == 3 then
            assets.sounds.music.BGM_2:setVolume(opacity / 2)
        elseif game.stage_num == 0 then
            assets.sounds.music.BGM_3:setVolume(opacity / 2)
        end
    end
end

function love.draw()
    local window_w, window_h = love.graphics.getDimensions()
    local bg_w, bg_h = assets.objects.bg:getDimensions()

    love.graphics.draw(assets.objects.bg, 0, 0, 0, window_w / 1800, window_w / 1800)

    Gamestate.draw(dt)

    love.graphics.setColor(0, 0, 0, opacity)
    love.graphics.rectangle("fill", 0, 0, window_w, window_h)
    love.graphics.setColor(1, 1, 1, 1)
end