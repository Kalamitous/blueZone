local LaserSystem = tiny.processingSystem(Object:extend())
LaserSystem.filter = tiny.filter("is_laser")

function LaserSystem:new(bump_world)
    self.bump_world = bump_world
end

function LaserSystem:process(e, dt)
    local offset_x, offset_y = lume.vector(e.ang + math.pi / 2, e.thickness)

    e:onCollide(self.bump_world:querySegment(e.pos.x + offset_x / 2, e.pos.y + offset_y / 2, e.end_pos.x + offset_x / 2, e.end_pos.y + offset_y / 2, e.filter))
    e:onCollide(self.bump_world:querySegment(e.pos.x - offset_x / 2, e.pos.y - offset_y / 2, e.end_pos.x - offset_x / 2, e.end_pos.y - offset_y / 2, e.filter))
end

return LaserSystem