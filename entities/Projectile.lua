local Projectile = Object:extend()

function Projectile:new(x, y, owner, target)
    self.pos = {x = x or 0, y = y or 0}
    self.hitbox = {w = 15, h = 15}

    self.owner = owner
    self.target = target
    self.ang = lume.angle(self.pos.x, self.pos.y, self.target.pos.x + self.target.hitbox.w / 2, self.target.pos.y + self.target.hitbox.h / 2)

    self.max_speed = 200
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)

    self.health = 1
    self.dmg = 10
    self.sprite = true
    self.is_projectile = true
end

function Projectile:update(dt)
end

function Projectile:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

function Projectile:filter(e)
    if e.is_player then
        return "cross"
    end
end

function Projectile:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i].other

        if e.is_bound then
            -- TODO: make disappear when completely off bounds
            self.remove = true
        elseif e.is_player and not e.dashing and not e.invincible and not e.dead then
            e.health = math.max(e.health - self.dmg, 0)
            e.points = math.max(e.points - 500, 0)

            if e.health <= 0 then
                e.vel.x, e.vel.y = lume.vector(self.ang, self.max_speed * 4)
            end

            e:setInvincible(e.invincible_time)

            self.remove = true
        end
    end
end

function Projectile:onDeath()
    self.remove = true
end

return Projectile
