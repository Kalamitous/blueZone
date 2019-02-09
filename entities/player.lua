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
    self.on_ground = false
    self.hit_vertical_surface = false
    self.sprite = true
    self.is_player = true
    self.hitbox = true
end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Player
