local ProjectileSystem = tiny.processingSystem(Object:extend())
ProjectileSystem.filter = tiny.filter("is_projectile")

function ProjectileSystem:process(e, dt)
    e.vel.x = e.max_speed * math.cos(e.dir)
    e.vel.y = e.max_speed * math.sin(e.dir) 
end

return ProjectileSystem
