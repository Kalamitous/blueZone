local DeathSystem = tiny.processingSystem(Object:extend())
DeathSystem.filter = tiny.filter("onDeath&health")

function DeathSystem:process(e, dt)
    if e.health <= 0 then
        e:onDeath()
    end
end

return DeathSystem