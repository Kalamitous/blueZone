local HUDSystem = tiny.processingSystem(Object:extend())
HUDSystem.filter = tiny.filter("is_player")
HUDSystem.isDrawSystem = true

function HUDSystem:process(e, dt)
    love.graphics.print("Health: " .. e.health, 0, 0)
    love.graphics.print("Combo: " .. e.combo, 0, 20)
    love.graphics.print("Points: " .. e.points, 0, 40)
    love.graphics.print("Laser Charge: " .. e.laser_charge_time, 0, 60)
end

return HUDSystem
