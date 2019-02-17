local Projectile = Object:extend()

function Projectile:new(x, y, owner, target)
    self.owner = owner
    self.target = target

    self.offset = {x = x, y = y}
    self.hitbox = {w = 15, h = 15}
    self.pos = {
        x = self.owner.pos.x + self.owner.hitbox.w / 2 - self.hitbox.w / 2 + self.offset.x * self.owner.dir,
        y = self.owner.pos.y + self.owner.hitbox.h / 2 - self.hitbox.h / 2 + self.offset.y
    }

    self.ang = lume.angle(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.target.pos.x + self.target.hitbox.w / 2, self.target.pos.y + self.target.hitbox.h / 2)

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
    if not e then return end
    if e.is_projectile then
        return "slide"
    end
    if e.is_player then
        return "cross"
    end
end

function Projectile:takeDamage(dmg)
    self.health = math.max(self.health - dmg, 0)
end

function Projectile:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i].other

        if e.is_bound then
            -- TODO: make disappear when completely off bounds
            self.remove = true
        elseif e.is_player and not e.invincible and not e.dead then
            e:takeDamage(self.dmg)

            if e.dead then
                e.vel.x, self.vel.y = lume.vector(self.ang, 800)
            end

            self.remove = true
        end
    end
end

function Projectile:onDeath()
    self.remove = true
end

return Projectile
