local HUDSystem = tiny.processingSystem(Object:extend())
HUDSystem.filter = tiny.filter("is_player")
HUDSystem.isDrawSystem = true

function HUDSystem:process(e, dt)
<<<<<<< HEAD
    love.graphics.setFont(assets.fonts.roboto_condensed(24))
    love.graphics.print("Stage: " .. game.stage_num, 10, 10)
    love.graphics.print("Health: " .. e.health, 10, 35)
    love.graphics.print("Points: " .. game.points, 10, 60)
=======
    love.graphics.print("Health: " .. e.health, 0, 0)
    love.graphics.print("Combo: " .. e.combo, 0, 20)
    love.graphics.print("Points: " .. e.points, 0, 40)
    love.graphics.print("Laser Charge: " .. e.laser_charge_time, 0, 60)
>>>>>>> parent of a61e236... new maps + stage system + remove useless lib lol
end

return HUDSystem
