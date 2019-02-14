local DIR = (...) .. "."
local Object = require(DIR .. "classic")

local Document = Object:extend()

function Document:new()
    self.Container = require(DIR .. "container")
end

function Document:update(dt)
end

function Document:draw()
end

return Document