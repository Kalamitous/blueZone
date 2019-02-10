local ProjectileSystem = tiny.processingSystem(Object:extend())
ProjectileSystem.filter = tiny.filter("is_projectile")

function ProjectileSystem:process(e, dt)
end

return ProjectileSystem