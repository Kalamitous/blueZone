local Enemy = Object:extend()

function Enemy:new(spawn_platform)
    self.spawn_platform = spawn_platform

    self.hitbox = {w = 100, h = 200}
    self.pos = {x = self.spawn_platform.x + lume.random(self.spawn_platform.width - self.hitbox.w), y = self.spawn_platform.y - self.hitbox.h}

    self.max_speed = 100
	self.vel = {x = 0, y = 0}

    self.goal_dist = 0
    self.cur_dist = 0
	self.desires_move = true
	self.stopped = false
    self.max_wait_time = 10
    self.move_timer = nil
    self.wait_timer = nil
    self.lock_time = 0.3
    self.locked = false

    self.dir = 1
    self.view_dist = 450
	self.view_cone = math.pi / 4
    
    self.target = nil
    self.can_shoot = true
    self.reload_time = 3

    self.health = 100
    self.last_hit = nil
    self.attack_indicator = false

    self.sprite = true
    self.is_enemy = true
end

function Enemy:update(dt)
    local new_x = self.pos.x + self.vel.x * dt
    local new_y = self.pos.y + self.vel.y * dt

    self.cur_dist = self.cur_dist + lume.distance(self.pos.x, self.pos.y, new_x, new_y)

    if self.cur_dist >= self.goal_dist then
        self:stop()
    end
end

function Enemy:draw()
    brightness = self.health / 100
    love.graphics.setColor(brightness, brightness, brightness)
    
    if self.attack_indicator then
        love.graphics.setColor(1, 0, 0)
    elseif self.target then
        love.graphics.setColor(0.5 * brightness, 1 * brightness, 0.5 * brightness)
    end
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)
end

function Enemy:filter(e)
    return nil
end

function Enemy:updateDir()
	if self.vel.x == 0 then return end

	self.dir = lume.sign(self.vel.x)
end

function Enemy:moveTo(x, y)
    local ang = lume.angle(self.pos.x, self.pos.y, x, y)

    self.goal_dist = lume.distance(self.pos.x, self.pos.y, x, y)
    self.vel.x, self.vel.y = lume.vector(ang, self.max_speed)
	self.desires_move = false
	
	self:updateDir()
end

function Enemy:stop()
    self.vel = {x = 0, y = 0}
    self.cur_dist = 0

    if self.wait_timer then
        self.wait_timer:stop()
        self.wait_timer = nil
    end

	self.desires_move = false
	self.stopped = true
end

function Enemy:shoot(ecs_world)
    ecs_world:add(Projectile(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self, self.target))
    
    self.can_shoot = false

    tick.delay(function()
        if self then
            self.can_shoot = true
        end
    end, self.reload_time)
end

function Enemy:onDeath()
    self.remove = true
end

return Enemy