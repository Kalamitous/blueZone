local Player = Object:extend()

function Player:new(x, y)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 50, h = 50}

    self.max_speed = 500
    self.vel = {x = 0, y = 0}
    self.acc = 3000
    self.gravity = 3000
    self.jump_height = 1200
    self.grounded = false
    self.hit_vertical_surface = false

    self.health = 100
    self.invincible = false
    self.invincible_time = 2
    self.opacity = 1
    self.flash_timer = nil

    self.sprite = true
    self.is_player = true
end

function Player:update(dt)
    self.grounded = false
    self.hit_vertical_surface = false
end

function Player:draw()
    if self.invincible then
        if not self.flash_timer then
            self.flash_timer = tick.recur(function()
                if self.opacity == 1 then
                    self.opacity = 0
                else
                    self.opacity = 1
                end
            end, 0.1)
        end
    else
        if self.flash_timer then
            self.flash_timer:stop()
            self.flash_timer = nil

            self.opacity = 1
        end
    end

    love.graphics.setColor(0, 0.5, 1, self.opacity)
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)
end

function Player:filter(e)
    -- we know for sure it is a map tile if it has `properties`
    if e.properties then
        if e.properties.collidable then
            -- pass through if player hasn't reached top of tile
            if e.y >= self.pos.y + self.hitbox.h then
                return "slide"
            end
        end
    elseif e.is_bound then
        return "slide"
    end
end

function Player:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i]

        if e.normal.x == 0 then
            self.vel.y = 0

            if e.normal.y < 0 then
                self.grounded = true
            end
        else
            -- stop horizontal motion if hit vertical surface
            self.vel.x = 0
            self.hit_vertical_surface = true  
        end
    end
end

return Player