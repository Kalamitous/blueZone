local Rocketeer = Enemy:extend()

function Rocketeer:new(spawn_platform)
    Rocketeer.super.new(self, spawn_platform)

    self.max_speed = 200
    self.max_health = 125
    self.health = self.max_health
    self.view_box = {}
    self.view_box.idle_size = {w = 500, h = 500}
    self.view_box.lock_size = {w = 1000, h = 1000}
    self.view_box.size = self.view_box.idle_size
    self.view_box.pos = {
        x = self.pos.x + self.hitbox.w / 2 - self.view_box.size.w / 2,
        y = self.pos.y + self.hitbox.h / 2 - self.view_box.size.h / 2
    }

    self.safe_dist = 250
    self.dist_threshold = 125

    self.is_rocketeer = true

    self.anims = {
        scale = 1,
        idle = {
            anim = animator.newAnimation({
                assets.enemy[3].idle[1],
                assets.enemy[3].idle[2]
            }, 1 / 1),
            offset = {x = 0, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        attack = {
            anim = animator.newAnimation({
                assets.enemy[3].attack[1]
            }, 1 / 1),
            offset = {x = 0, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        death = {
            anim = animator.newAnimation({
                assets.enemy[3].death[1],
            }, 1 / 1),
            offset = {x = 0, y = 0},
            draw_offset = {x = 0, y = 0}
        }
    }
    self.anims.idle.anim:setLooping(true)
    self.anims.death.anim:setLooping(true)
    self.anims.attack.anim:setActive(false)
    self.anims.attack.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.cur = self.anims.idle
end

function Rocketeer:onDeath()
    if not self.dead then
        self.dead = true
        self.anims.cur = self.anims.death
        self.sounds.death:play()

        tick.delay(function()
            self.remove = true
        end, 1)
    end
end

function Rocketeer:update(dt)
    if self.dead then
        self.pos.y = self.pos.y + 300 * dt
    end

    if not self.anims.attack.anim:isActive() and not self.dead then
        self:changeAnim("idle")

        if self.vel.y > 0 then
            self.anims.idle.anim:setCurrentFrame(1)
        else
            self.anims.idle.anim:setCurrentFrame(2)
        end
    end

    self.anims.cur.anim:update(dt)

    local new_x = self.pos.x + self.vel.x * dt
    local new_y = self.pos.y + self.vel.y * dt

    self.cur_dist = self.cur_dist + lume.distance(self.pos.x, self.pos.y, new_x, new_y)

    if self.cur_dist >= self.goal_dist then
        self:stop()
    end

    self:updateDir()
end

function viewBoxFilter(item)
    if item.is_player then
        return true
    end
end

function Rocketeer:think(bump_world, dt)
    self.target = nil
    
    local items, len = bump_world:queryRect(self.view_box.pos.x, self.view_box.pos.y, self.view_box.size.w, self.view_box.size.h, viewBoxFilter)

    if len > 0 then
        self.target = items[1]
        if self.previous_target ~= self.target then
            self.spotted = false
            self.delay = tick.delay(function()
                self.spotted = true
            end, self.reaction_time)
        end
    end

    self.previous_target = self.target

    if self.target and self.spotted and not self.stunned then
        self.view_box.size = self.view_box.lock_size
        self.view_box.pos = {
            x = self.pos.x + self.hitbox.w / 2 - self.view_box.size.w / 2,
            y = self.pos.y + self.hitbox.h / 2 - self.view_box.size.h / 2
        }

        local dist = lume.distance(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.target.pos.x + self.target.hitbox.w / 2, self.target.pos.y + self.target.hitbox.w / 2)
        local ang = lume.angle(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.target.pos.x + self.target.hitbox.w / 2, self.target.pos.y+ self.target.hitbox.h / 2)

        if dist > self.safe_dist + self.dist_threshold then
            self.vel.x, self.vel.y = lume.vector(ang, self.max_speed)
            self.goal_dist = dist - self.safe_dist
        elseif dist < self.safe_dist - self.dist_threshold then
            self.vel.x, self.vel.y = lume.vector(ang + math.pi, self.max_speed)
            self.goal_dist = self.safe_dist - dist
        end
    else
        self.view_box.size = self.view_box.idle_size
        self.view_box.pos = {
            x = self.pos.x + self.hitbox.w / 2 - self.view_box.size.w / 2,
            y = self.pos.y + self.hitbox.h / 2 - self.view_box.size.h / 2
        }
    end
end

function Rocketeer:draw()
    --[[love.graphics.rectangle("line", self.view_box.pos.x, self.view_box.pos.y, self.view_box.size.w, self.view_box.size.h)
    love.graphics.circle("line", self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.safe_dist + self.dist_threshold)
    love.graphics.circle("line", self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.safe_dist - self.dist_threshold)]]--
    
    --[[if self.attack_indicator then
        love.graphics.setColor(1, 0, 0, 0.25)
    elseif self.target then
        love.graphics.setColor(0, 0.35, 0.05, 0.25)
    end

    love.graphics.setColor(0.9, 0.55, 0.25, 0.25)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)]]--

    self:drawHealthbar()
end

function Rocketeer:shoot(ecs_world)
    self.can_shoot = false
    self:changeAnim("attack")

    if self.target then
        if self.target.pos.x < self.pos.x then
            if self.dir == 1 then
                self:moveTo(self.pos.x - self.dir, self.pos.y)
            end
        elseif self.target.pos.x > self.pos.x then
            if self.dir == -1 then
                self:moveTo(self.pos.x - self.dir, self.pos.y)
            end
        end
    end

    tick.delay(function()
        if self.health == 0 or self.stunned then return end

        if self.target then
            self.sounds.blast:play()
            ecs_world:add(Missile(68, -20, self, self.target))
        end

        tick.delay(function()
            self.can_shoot = true
        end, self.reload_time)
    end, 1 * 1 / 4)
end

return Rocketeer