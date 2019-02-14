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
    self.attack_cooldown = 0.5
    self.attack_lifetime = 0.25
    self.can_attack = true
    self.opacity = 1
    self.flash_timer = nil
    self.dir = 0

    self.sprite = true
    self.is_player = true
end

function Player:update(dt)
    self.grounded = false
    self.hit_vertical_surface = false
    self:updateDir()
end

function Player:updateDir()
	if self.vel.x == 0 then return end

	self.dir = lume.sign(self.vel.x)
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

function Player:attack(ecs_world)
    if self.can_attack then
        if self.dir == 1 then
            ecs_world:add(Attack(50, 5, self.attack_lifetime, self))
        else
            ecs_world:add(Attack(-20, 5, self.attack_lifetime, self))
        end
        self.can_attack = false
        tick.delay(function() 
            self.can_attack = true
        end, self.attack_cooldown)
    end
end

return Player