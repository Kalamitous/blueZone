local Enemy = Object:extend()

function Enemy:new(x, y, spawn_platform)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 50, h = 75}

    self.max_speed = 1
	self.vel = {x = 0, y = 0}

    self.goal = {}
	self.desires_move = true
	self.stopped = false
    self.max_wait_time = 10
    self.move_timer = nil
	self.wait_timer = nil

    self.dir = 1
    self.view_dist = 450
	self.view_cone = math.pi / 4
    
    self.target = nil
    self.can_shoot = true
    self.reload_time = 3

    self.health = 100
    self.spawn_platform = spawn_platform
    self.sprite = true
    self.is_enemy = true
end

function Enemy:draw()
    if self.target then
        love.graphics.setColor(1, 0.5, 0.5)
    end
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)
end

function Enemy:moveTo(x, y, wait)
    local dist = lume.distance(self.pos.x, self.pos.y, x, y)
    local ang = lume.angle(self.pos.x, self.pos.y, x, y)

    self.vel.x, self.vel.y = lume.vector(ang, self.max_speed)
	self.desires_move = false
	
	self:updateDir()

    self.move_timer = tick.delay(function()
        self.vel = {x = 0, y = 0}

		if wait then
			self.wait_timer = tick.delay(function()
				self.desires_move = true
			end, lume.random(self.max_idle_time))
		end
    end, dist / (self.max_speed / (1 / 100)))
end

function Enemy:updateDir()
	if self.vel.x == 0 then return end

	self.dir = lume.sign(self.vel.x)
end

function Enemy:stop()
    self.vel = {x = 0, y = 0}

    if self.move_timer then
        self.move_timer:stop()
        self.move_timer = nil
    end

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
        self.can_shoot = true
    end, self.reload_time)
end

return Enemy