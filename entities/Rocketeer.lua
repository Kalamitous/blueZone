local Rocketeer = Enemy:extend()

function Rocketeer:new(spawn_platform)
    Rocketeer.super.new(self, spawn_platform)

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
    end

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
    
    if self.attack_indicator then
        love.graphics.setColor(1, 0, 0, 0.25)
    elseif self.target then
        love.graphics.setColor(0, 0.35, 0.05, 0.25)
    end

    love.graphics.setColor(0.9, 0.55, 0.25, 0.25)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)

    self:drawHealthbar()
end

function Rocketeer:shoot(ecs_world)
    ecs_world:add(Missile(0, 0, self, self.target))
    
    self.can_shoot = false

    tick.delay(function()
        if self then
            self.can_shoot = true
        end
    end, self.reload_time)
end

return Rocketeer