Position = class(function(self, x, y)
    self.x = x
    self.y = y
end)

function Position:translate(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

return Position