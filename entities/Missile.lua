local Missile = Projectile:extend()

function Missile:new(x, y, owner, target)
    Missile.super.new(self, x, y, owner, target)

    self.owner = owner
    self.target = target

    self.offset = {x = x, y = y}
    self.hitbox = {w = 60, h = 60}
    self.pos = {
        x = self.owner.pos.x + self.owner.hitbox.w / 2 - self.hitbox.w / 2 + self.offset.x * self.owner.dir,
        y = self.owner.pos.y + self.owner.hitbox.h / 2 - self.hitbox.h / 2 + self.offset.y 
    }
    
    self.ang = lume.angle(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.target.pos.x + self.target.hitbox.w / 2, self.target.pos.y + self.target.hitbox.h / 2)
    
    self.max_speed = 150
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)

    self.dmg = 20
    self.exploded = false
    self.explosion_radius = 100
    self.explosion_duration = 0.2

    self.sprite = true
    self.img = assets.objects.orb_2
    self.is_missile = true
    self.needs_bump = true
end

function Missile:draw()
    if self.exploded then
        love.graphics.setColor(0.95, 0.35, 0.0)
        love.graphics.circle("fill", self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.explosion_radius)
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.draw(self.img, self.pos.x, self.pos.y)
end

function Missile:filter(e)
    if not e.is_enemy then
        return "cross"
    end
end

function explosionFilter(item)
    if item.is_player then
        return true
    end
end

function Missile:onCollide(cols, len, bump_world)
    if self.exploded then return end

    for i = 1, len do
        local e = cols[i].other

        -- TODO: make missiles only collide on platforms on or past the player
        self:explode(bump_world)
    end
end

function Missile:explode(bump_world)
    self.exploded = true
    self.vel.x = 0
    self.vel.y = 0

    tick.delay(function()
        self.remove = true
    end, self.explosion_duration)

    local dist = lume.distance(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.target.pos.x + self.target.hitbox.w / 2, self.target.pos.y + self.target.hitbox.h / 2)

    if dist < self.explosion_radius then
        local items, len = bump_world:querySegment(self.pos.x + self.hitbox.w / 2, self.pos.y + self.hitbox.h / 2, self.target.pos.x + self.target.hitbox.w / 2, self.target.pos.y + self.target.hitbox.h / 2, explosionFilter)

        for i = 1, len do
            local e = items[i]
            
            if e.is_player and not e.invincible and not e.dead then
                e:takeDamage(self.dmg)

                if e.dead then
                    e.vel.x, self.vel.y = lume.vector(self.ang, 800)
                end
            end
        end
    end
end

return Missile