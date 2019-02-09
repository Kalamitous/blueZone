local HUDSystem = tiny.processingSystem(Object:extend())
HUDSystem.isDrawSystem = true
HUDSystem.filter = tiny.requireAll("is_player")

function HUDSystem:process(e, dt)
    love.graphics.print(e.x, 0, 0)
    love.graphics.print(e.y, 0, 16)
end

return HUDSystem
