local Player = Object:extend()

function Player:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.w = 50
    self.h = 50
    self.health = 100
    self.max_speed = 5
    self.velocity = {x = 0, y = 0}
    self.acceleration = 0.2
    self.jump_height = 10
    self.sprite = true
    self.controllable = true
    self.hitbox = true
end

function Player:isInAir()
    return self.velocity.y ~= 0
end

return Player
