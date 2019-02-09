local ProjectileSystem = tiny.processingSystem(Object:extend())
ProjectileSystem.filter = tiny.requireAll("is_projectile")

function ProjectileSystem:process(e, dt)
    e.velocity.x = e.max_speed * math.cos(e.dir)
    e.velocity.y = e.max_speed * math.sin(e.dir) 

    print(e.velocity.x)
end

return ProjectileSystem
