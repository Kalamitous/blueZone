local LaserSystem = tiny.processingSystem(Object:extend())
LaserSystem.filter = tiny.filter("is_laser")

function LaserSystem:new(bump_world)
    self.bump_world = bump_world

end

function LaserSystem:process(e, dt)
    self.bump_world:querySegment(e.pos.x, e.pos.y, e.ending.x, e.ending.y, e.filter)
end

return LaserSystem