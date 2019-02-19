local Beamer = Enemy:extend()

function Beamer:new(spawn_platform)
    Beamer.super.new(self, spawn_platform)
    
    self.reload_time = 2
    self.in_attack = false
    self.color = {1, 1, 0.8}
    self.max_health = 125
    self.view_dist = 600
    self.health = self.max_health
    self.anims = {
        scale = 1,
        idle = {
            anim = animator.newAnimation({
                assets.enemy[2].idle[1]
            }, 1 / 1),
            offset = {x = 0, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        run = {
            anim = animator.newAnimation({
                assets.enemy[2].run[1],
                assets.enemy[2].run[2],
                assets.enemy[2].run[3],
                assets.enemy[2].run[4]
            }, 1 / 4),
            offset = {x = 0, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        attack = {
            anim = animator.newAnimation({
                assets.enemy[2].attack[1]
            }, 1 / 4),
            offset = {x = 0, y = 0},
            draw_offset = {x = 24, y = 0}
        },
        death = {
            anim = animator.newAnimation({
                assets.enemy[2].death[1],
            }, 1 / 1),
            offset = {x = 0, y = 0},
            draw_offset = {x = 0, y = 0}
        }
    }
    self.anims.idle.anim:setLooping(true)
    self.anims.run.anim:setLooping(true)
    self.anims.death.anim:setLooping(true)
    self.anims.attack.anim:setActive(false)
    self.anims.attack.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.cur = self.anims.idle
end

function Beamer:draw()
    --[[if self.target and self.can_shoot and not self.stunned then
        local center_x = self.pos.x + (self.hitbox.w / 2)
        local center_y = self.pos.y + (self.hitbox.h / 2)
        local target_center_x = self.target.pos.x + (self.target.hitbox.w / 2)
        local target_center_y = self.target.pos.y + (self.target.hitbox.h / 2)
        
        love.graphics.setColor(1, 0.1, 0.1, 0.25)
        love.graphics.line(center_x, center_y, target_center_x, target_center_y)
    end

    if self.attack_indicator then
        love.graphics.setColor(1, 0, 0, 0.25)
    elseif self.target then
        love.graphics.setColor(0.2, 1, 0.65, 0.25)
    end

    love.graphics.setColor(0.5, 0.75, 0, 0.25)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)]]--

    self:drawHealthbar()
end

function Beamer:shoot(ecs_world)
    self.can_shoot = false
    self.in_attack = true
    self:changeAnim("attack")
    self.anims.cur.anim:pause()

    tick.delay(function()
        if self.health == 0 or self.stunned then return end

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

        local laser_duration = 1.5 + 2
        if self.target then
            ecs_world:add(Laser(52, -16, self, self.target))
        else
            self.anims.cur.anim:resume()

            return
        end

        tick.delay(function()
            self.anims.cur.anim:resume()
            self.in_attack = false

            tick.delay(function()
                self.can_shoot = true
            end, self.reload_time)
        end, laser_duration)
    end, 1 * 1 / 4)
end

return Beamer