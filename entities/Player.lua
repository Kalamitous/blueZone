local Player = Object:extend()

function Player:new(x, y)
    self.hitbox = {w = 50, h = 67}
    self.pos = {x = x, y = y - self.hitbox.h}

    self.max_speed = 500
    self.vel = {x = 0, y = 0}
    self.acc = 3000
    self.gravity = 3000
    self.jump_height = 1200
    self.bounciness = 0.5
    self.dir = 1

    self.running = false
    self.grounded = false
    self.hit_vertical_surface = false
    
    self.can_dash = 0
    self.dashing = false
    self.dashed_in_air = false
    self.dash_speed = 2400
    self.dash_time = 0.15
    self.dash_detect_timer = nil

    self.attack_cooldown = 0.3
    self.attack_lifetime = 0.25
    self.can_attack = true

    self.health = 50
    self.invincible = false
    self.invincible_time = 1.5
    self.opacity = 1
    self.flash_timer = nil
    self.dead = false

    self.sprite = true
    self.is_player = true

    self.anims = {
        scale = 4,
        idle = animator.newAnimation({
            assets.player.idle[1],
        }, 1 / 1),
        run = animator.newAnimation({
            assets.player.run[1],
            assets.player.run[2],
            assets.player.run[3]
        }, 1 / 10),
        jump = animator.newAnimation({
            assets.player.jump[1],
        }, 1 / 1),
        death = animator.newAnimation({
            assets.player.death[1],
        }, 1 / 1)
    }
    self.anims.idle:setLooping(true)
    self.anims.run:setLooping(true)
    self.anims.jump:setLooping(true)
    self.anims.death:setLooping(true)
    self.anims.cur = self.anims.idle

    self.sounds = {
        jump = ripple.newSound(assets.sounds.player.jump, {volume = 0.3})
    }
end

function Player:update(dt)
    if self.health > 0 then
        if not self.grounded then
            self:changeAnim("jump")
        elseif self.running and not self.hit_vertical_surface then
            self:changeAnim("run")
        else
            self:changeAnim("idle")
        end
    end

    self.anims.cur:update(dt)

    if self.grounded then
        self.dashed_in_air = false
    end

    self.grounded = false
    self.hit_vertical_surface = false
end

function Player:draw()
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
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
        if self.health <= 0 then
            return "bounce"
        else
            return "slide"
        end
    end
end

function Player:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i]

        if e.type == "bounce" then
            self:bounce(e.normal.x, e.normal.y)

            return
        end

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

function Player:onDeath()
    self.dead = true

    if self.flash_timer then
        self.flash_timer:stop()
        self.flash_timer = nil
    end

    self:changeAnim("death")
end

function Player:changeAnim(anim)
    if self.anims.cur == self.anims[anim] then return end

    self.anims.cur = self.anims[anim]
    self.anims.cur:restart()
end

function Player:setInvincible(time)
    self.invincible = true

    self.flash_timer = tick.recur(function()
        if self.opacity == 1 then
            self.opacity = 0
        else
            self.opacity = 1
        end
    end, 0.1)

    tick.delay(function()
        self.invincible = false

        if self.flash_timer then
            self.flash_timer:stop()
            self.flash_timer = nil
        end

        self.opacity = 1
    end, time)
end

function Player:bounce(nx, ny)
    if (nx < 0 and self.vel.x > 0) or (nx > 0 and self.vel.x < 0) then
        self.vel.x = -self.vel.x * self.bounciness
    end

    if (ny < 0 and self.vel.y > 0) or (self.vel.y > 0 and self.vel.y < 0) then
        self.vel.y = -self.vel.y * self.bounciness
    end
end

function Player:startDashDetection()
    if self.dash_detect_timer then 
        self.dash_detect_timer:stop()
        self.dash_detect_timer = nil
    end

    self.can_dash = self.dir

    self.dash_detect_timer = tick.delay(function()
        self.can_dash = 0
        self.dash_detect_timer = nil
    end, 0.3)
end

function Player:dash()
    self.dashing = true
    self.vel.x = self.dash_speed * self.dir

    tick.delay(function()
        self.dashing = false
        self.vel.x = 0
    end, self.dash_time)
end

function Player:attack(ecs_world)
    if self.can_attack then
        ecs_world:add(Attack(35, 0, self.attack_lifetime, self))
        self.can_attack = false
        tick.delay(function() 
            self.can_attack = true
        end, self.attack_cooldown)
    end
end

return Player