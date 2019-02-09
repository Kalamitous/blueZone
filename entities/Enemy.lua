local Enemy = Object:extend()

function Enemy:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.w = 50
    self.h = 75
    self.health = 100
    self.max_speed = 2
    self.velocity = {x = 0, y = 0}
    self.acceleration = 0.2
    self.sprite = true
    self.hitbox = true
    self.is_enemy = true
end

return Enemy
