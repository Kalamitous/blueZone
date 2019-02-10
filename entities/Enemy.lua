local Enemy = Object:extend()

function Enemy:new(x, y, spawn_platform)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 50, h = 75}

    self.max_speed = 1
    self.vel = {x = 0, y = 0}

    self.goal = {}
    self.desires_move = true
    self.max_idle_time = 10

    self.health = 100
    self.target = nil
    self.projectile = nil
    self.spawn_platform = spawn_platform
    self.sprite = true
    self.is_enemy = true
end

function Enemy:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)

    love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)
end

function Enemy:moveTo(x, y)
    local dist = lume.distance(self.pos.x, self.pos.y, x, y)
    local ang = lume.angle(self.pos.x, self.pos.y, x, y)

    self.vel.x, self.vel.y = lume.vector(ang, self.max_speed)
    self.desires_move = false

    tick.delay(function()
        self.vel = {x = 0, y = 0}
    end, dist / (self.max_speed / (1 / 100)))
        :after(function()
            self.desires_move = true
        end, lume.random(self.max_idle_time))
end

return Enemy