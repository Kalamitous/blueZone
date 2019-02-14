local Container = Object:extend()

function Container:new()
    self.x = 0
    self.y = 0
    self.w = 20
    self.h = 20
end

function Container:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Container