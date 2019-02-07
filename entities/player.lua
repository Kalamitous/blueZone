local Player = Object:extend()

function Player:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.w = 50
    self.h = 50
    self.health = 100
    self.speed = 5
    self.jump_height = 6
    self.velocity = {x = 0, y = 0}
    self.sprite = true
    self.controllable = true
end

return Player
