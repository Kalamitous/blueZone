local HUDSystem = tiny.processingSystem(Object:extend())
HUDSystem.filter = tiny.requireAll("is_player")
HUDSystem.isDrawSystem = true

function HUDSystem:process(e, dt)
    love.graphics.print(e.health, 0, 0)
end

return HUDSystem
