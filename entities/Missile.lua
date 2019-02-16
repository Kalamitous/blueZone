local Missile = Projectile:extend()

function Missile:new(x, y, owner, target)
    Missile.super.new(self, x, y, owner, target)
    self.hitbox = {w = 30, h = 30}
    self.explosion_radius = 100
    self.dmg = 10
    self.max_speed = 150
    self.vel = {}
    self.vel.x, self.vel.y = lume.vector(self.ang, self.max_speed)

    self.is_projectile = false
    self.is_missile = true
    self.needs_bump = true
    self.exploded = false
    self.explosion_duration = 0.2
end

function Missile:draw()
    if not self.exploded then
        love.graphics.setColor(0.9, 0.5, 0.2)
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
    else
        love.graphics.setColor(0.95, 0.35, 0.0)
        centerX, centerY = (self.pos.x + self.hitbox.w / 2), (self.pos.y + self.hitbox.h / 2)
        minX, minY = centerX - self.explosion_radius, centerY - self.explosion_radius
        love.graphics.rectangle("fill", minX, minY, self.explosion_radius * 2, self.explosion_radius * 2)
    end
end

function Missile:filter(e)
    -- we know for sure it is a map tile if it has `properties`
    if e.properties then
        if e.properties.collidable then
            -- pass through if player hasn't reached top of tile
            return "cross"
            --[[if e.y >= self.pos.y + self.hitbox.h then
                return "slide"
            end]]
        end
    elseif e.is_player then
        return "cross"
    elseif e.is_bound then
        return "cross"
    end
end

function Missile:onCollide(cols, len, bump_world)
    if not self.exploded and len > 0 then
        self:explode(bump_world)
        tick.delay(function()
            if self then
                self.remove = true
            end
        end, self.explosion_duration)
    end
end

function explosionFilter(e)
    if e.is_player then
        return "cross"
    end
end

function Missile:explode(bump_world)
    self.exploded = true
    self.vel.x, self.vel.y = 0, 0
    centerX, centerY = (self.pos.x + self.hitbox.w / 2), (self.pos.y + self.hitbox.h / 2)
    cols, len = bump_world:queryRect(centerX - self.explosion_radius, centerY - self.explosion_radius, self.explosion_radius * 2,self.explosion_radius * 2, explosionFilter)
    for i = 1, len do
        local e = cols[i]
        if e.is_player then
            print("Boom?")
        end
        if e.is_player and not e.invincible and not e.dead then
            e.health = math.max(e.health - self.dmg, 0)
            print("Boom damage")
            if e.health <= 0 then
                e.vel.x, e.vel.y = lume.vector(self.ang, self.max_speed * 4)
            end
    
            e:setInvincible(e.invincible_time)
        end
    end
end

return Missile