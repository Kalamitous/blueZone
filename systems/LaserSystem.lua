local LaserSystem = tiny.processingSystem(Object:extend())
LaserSystem.filter = tiny.filter("is_laser")

function LaserSystem:new(bump_world)
    self.bump_world = bump_world

end

function playerFilter(item)
    if not item.is_player then
        return false
    else
        return true
    end
end

function LaserSystem:process(e, dt)
    local items, len = self.bump_world:querySegment(e.pos.x, e.pos.y, e.ending.x, e.ending.y, playerFilter)
    if len > 0 then
        if items[1].is_player then
            if not items[1].invincible and not items[1].dead then
                items[1].health = math.max(items[1].health - e.dmg, 0)
        
                if items[1].health <= 0 then
                    items[1].vel.x, items[1].vel.y = lume.vector(e.ang, e.max_speed * 4)
                end
        
                items[1]:setInvincible(items[1].invincible_time)
        
                e.remove = true
            end
        end
    end
end

return LaserSystem