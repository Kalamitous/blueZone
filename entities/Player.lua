local Player = Object:extend()

function Player:new(x, y)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 50, h = 67}

    self.max_speed = 500
    self.vel = {x = 0, y = 0}
    self.acc = 3000
    self.gravity = 3000
    self.jump_height = 1200
    self.dir = 1

    self.running = false
    self.grounded = false
    self.hit_vertical_surface = false

    self.health = 100
    self.invincible = false
    self.invincible_time = 2
    self.opacity = 1
    self.flash_timer = nil

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
        }, 1 / 1)
    }
    self.anims.idle:setLooping(true)
    self.anims.run:setLooping(true)
    self.anims.jump:setLooping(true)
end

function Player:update(dt)
    if not self.grounded then
        self:changeAnim("jump")
    elseif self.running and not self.hit_vertical_surface then
        self:changeAnim("run")
    else
        self:changeAnim("idle")
    end

    self.anims.cur:update(dt)

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

    love.graphics.setColor(1, 1, 1, self.opacity)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
        love.graphics.push()
        love.graphics.translate(self.pos.x + self.hitbox.w / 2 - self.anims.cur:getWidth() * self.anims.scale / 2 * self.dir, self.pos.y + self.hitbox.h - self.anims.cur:getHeight() * self.anims.scale)
        love.graphics.scale(self.anims.scale * self.dir, self.anims.scale)
            self.anims.cur:draw()
        love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
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

function Player:changeAnim(anim)
    if self.anims.cur == self.anims[anim] then return end

    self.anims.cur = self.anims[anim]
    self.anims.cur:restart()
end

return Player