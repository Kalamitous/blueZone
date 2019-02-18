local HUDSystem = tiny.processingSystem(Object:extend())
HUDSystem.filter = tiny.filter("is_player")
HUDSystem.isDrawSystem = true

function HUDSystem:process(e, dt)
    love.graphics.print("Health: " .. e.health, 10, 10)
    love.graphics.print("Combo: " .. e.combo, 10, 30)
    love.graphics.print("Points: " .. game.points, 10, 50)
    love.graphics.print("Laser Charge: " .. e.laser_charge_time, 10, 70)
end

return HUDSystem
