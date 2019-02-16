local HUDSystem = tiny.processingSystem(Object:extend())
HUDSystem.filter = tiny.filter("is_player")
HUDSystem.isDrawSystem = true

function HUDSystem:process(e, dt)
    love.graphics.print("Health: " .. e.health, 0, 0)
    love.graphics.print("Combo: " .. e.combo, 0, 20)
end

return HUDSystem
