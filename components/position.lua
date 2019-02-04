local Position = Component(function(e, x, y)
    e.x = x
    e.y = y
end)

function Position:translate(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

return Position
