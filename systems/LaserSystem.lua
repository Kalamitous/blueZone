local LaserSystem = tiny.processingSystem(Object:extend())
LaserSystem.filter = tiny.filter("is_laser")

function LaserSystem:new(bump_world)
    self.bump_world = bump_world
end

function LaserSystem:process(e, dt)
    local items, len = self.bump_world:querySegment(e.pos.x, e.pos.y, e.ending.x, e.ending.y, e.filter)

    for i = 1, len do
        items[i]:takeDamage(e.dmg)
    end
end

return LaserSystem