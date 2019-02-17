local LaserSystem = tiny.processingSystem(Object:extend())
LaserSystem.filter = tiny.filter("is_laser")

function LaserSystem:new(bump_world)
    self.bump_world = bump_world
end

function LaserSystem:process(e, dt)
    local items, len = self.bump_world:querySegment(e.pos.x, e.pos.y, e.end_pos.x, e.end_pos.y, e.filter)

    e:onCollide(items, len)
end

return LaserSystem