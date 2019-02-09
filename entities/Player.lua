local Player = Object:extend()

function Player:new(x, y)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 50, h = 50}

    self.max_speed = 5
    self.vel = {x = 0, y = 0}
    self.acc = 0.2
    self.gravity = 0.2
    self.jump_height = 10
    self.grounded = false
    self.hit_vertical_surface = false

    self.health = 100
    self.sprite = true
    self.is_player = true
end

function Player:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

return Player
