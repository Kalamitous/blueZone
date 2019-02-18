local Enemy = Object:extend()

function Enemy:new(spawn_platform)
    self.spawn_platform = spawn_platform

    self.offset = {x = 0, y = 0}
    self.hitbox = {w = 45, h = 160}
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

    self.max_health = 100
    self.health = self.max_health
    self.health_width = 75
    self.health_height = 10
    self.health_hover = 25
    self.stunned = false
    self.stun_time = 1

    self.last_hit = nil
    self.attack_indicator = false

    self.sprite = true
    self.is_enemy = true

    self.anims = {
        scale = 1,
        idle = {
            anim = animator.newAnimation({
                assets.enemy.idle[1]
            }, 1 / 1),
            offset = {x = 0, y = 0}
        },
        run = {
            anim = animator.newAnimation({
                assets.enemy.run[1],
                assets.enemy.run[2],
                assets.enemy.run[3],
                assets.enemy.run[4]
            }, 1 / 4),
            offset = {x = 0, y = 0}
        }
    }
    self.anims.idle.anim:setLooping(true)
    self.anims.run.anim:setLooping(true)
    self.anims.cur = self.anims.idle.anim
end

function Enemy:update(dt)
    if self.vel.x ~= 0 or self.vel.y ~= 0 then
        self:changeAnim("run")
    else
        self:changeAnim("idle")
    end

    self.anims.cur:update(dt)

    local new_x = self.pos.x + self.vel.x * dt
    local new_y = self.pos.y + self.vel.y * dt

    self.cur_dist = self.cur_dist + lume.distance(self.pos.x, self.pos.y, new_x, new_y)

    if self.cur_dist >= self.goal_dist then
        self:stop()
    end
end

function Enemy:draw()
    if self.attack_indicator then
        love.graphics.setColor(1, 0, 0, 0.25)
    elseif self.target then
        love.graphics.setColor(0.5, 1, 0.5, 0.25)
    end

    love.graphics.setColor(1, 1, 1, 0.25)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    love.graphics.setColor(1, 1, 1)

    self:drawHealthbar()
end

function Enemy:drawHealthbar()
    center_x = self.pos.x + self.hitbox.w / 2
    indicatorWidth = self.health_width * (self.health / self.max_health)

    love.graphics.rectangle("fill", center_x - self.health_width / 2, self.pos.y - self.health_hover - self.health_height, self.health_width, self.health_height)

    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", center_x - self.health_width / 2, self.pos.y - self.health_hover - self.health_height, indicatorWidth, self.health_height)
    love.graphics.setColor(1,1,1)
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
    ecs_world:add(Projectile(0, 0, self, self.target))
    
    self.can_shoot = false

    tick.delay(function()
        self.can_shoot = true
    end, self.reload_time)
end

function Enemy:takeDamage(dmg)
    self.health = math.max(self.health - dmg, 0)
    self.attack_indicator = true
    
    tick.delay(function() 
        self.attack_indicator = false
    end, 0.2)

    self.stunned = true
    self:stop()
    if not self.target then
        self.dir = -self.dir
    end
    tick.delay(function()
        self.stunned = false
    end, self.stun_time)
end

function Enemy:onDeath()
    self.remove = true
end

function Enemy:changeAnim(anim)
    if self.anims.cur == self.anims[anim].anim then return end

    self.offset = self.anims[anim].offset

    self.anims.cur = self.anims[anim].anim
    self.anims.cur:restart()
end

return Enemy