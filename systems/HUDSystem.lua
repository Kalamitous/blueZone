local HUDSystem = tiny.processingSystem(Object:extend())
HUDSystem.filter = tiny.requireAll("is_player")
HUDSystem.isDrawSystem = true

function HUDSystem:process(e, dt)
    love.graphics.print(e.pos.x, 0, 0)
    love.graphics.print(e.pos.y, 0, 16)
end

return HUDSystem
