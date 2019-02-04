local Concord = require("concord").init()

local Concord = require("concord")
local Entity = require("concord.entity")
local Component = require("concord.component")
local System = require("concord.system")
local Instance = require("concord.instance")

local myInstance = Instance()

function myInstance:collide(x, y)
    if x < 0 or x > love.graphics.getWidth() then
        return true
    end
    if y < 0 or y > love.graphics.getHeight() then
        return true
    end
    return false
end

local Position = Component(function(e, x, y)
    e.x = x
    e.y = y
end)

function Position:translate(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

local player = Entity()
player:give(Position, 0, 0)

function love.load()

end

function love.update()
    myInstance:emit("update", dt)
    moveX = 0
    moveY = 0
    if love.keyboard.isDown("w") then
        moveY = -1
        -- up
    elseif love.keyboard.isDown("s") then
        moveY = 1
        -- down
    end
    if love.keyboard.isDown("a") then
        moveX = -1
        -- left
    elseif love.keyboard.isDown("d") then
        moveX = 1
        -- right
    end
    local playerPosition = player:get(Position)
    if not myInstance:collide(playerPosition.x + moveX, playerPosition.y + moveY) then
        playerPosition:translate(moveX, moveY)
    end
end

function love.draw()
    myInstance:emit("draw")
    local playerPosition = player:get(Position)
    love.graphics.rectangle("fill", playerPosition.x, playerPosition.y, 5, 5)
    love.graphics.print("Hello World", 400, 300)
    love.graphics.print(tostring(playerPosition.x), 400, 350)
    love.graphics.print(tostring(playerPosition.y), 400, 250)
end