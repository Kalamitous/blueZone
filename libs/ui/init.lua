local DIR = (...) .. "."

local document = {}

function document.new()
    return setmetatable({
        screen = {
            x = love.graphics.getWidth(),
            y = love.graphics.getHeight()
        },

        Button = require(DIR .. "button"),
        Container = require(DIR .. "container"),
        Dropdown = require(DIR .. "dropdown"),
        Image = require(DIR .. "image"),
        Label = require(DIR .. "label"),

        elements = {},
        update_table = {},
        draw_table = {},  

        logic = function() end
    }, {__index = document})
end

function document:update()
    for _, func in pairs(self.update_table) do
        func()
    end

    self.logic()
end

function document:draw()
    for _, func in pairs(self.draw_table) do
        func()
    end
end

function document:create(e, id, ...)
    self[e].create(self, id, ...)

    return self.elements[id]
end

function document:getState(id)
    return self.state
end

return document
