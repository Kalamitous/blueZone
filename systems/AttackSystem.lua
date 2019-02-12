local AttackSystem = tiny.processingSystem(Object:extend())
AttackSystem.filter = tiny.filter("is_attack")

function AttackSystem:new(ecs_world, bump_world)
    self.ecs_world = ecs_world
    self.bump_world = bump_world
end

function attackCollisionFilter(e1, e2)
    if e2.is_enemy then
        e2.health = e2.health - e1.dmg
    end
end

function AttackSystem:process(e, dt)
    e.lifetime = e.lifetime - 1
    if e.lifetime < 1 then
        self.ecs_world:remove(e)
    end
    e.pos.x, e.pos.y, cols, len = self.bump_world:move(e, e.owner.pos.x + e.offset.x, e.owner.pos.y + e.offset.y, attackCollisionFilter)
end

return AttackSystem