local HUDSystem = tiny.processingSystem(Object:extend())
HUDSystem.filter = tiny.filter("is_player")
HUDSystem.isDrawSystem = true

function HUDSystem:process(e, dt)
    love.graphics.setFont(assets.fonts.roboto_condensed(24))
    love.graphics.print("Stage: " .. game.stage_num, 10, 10)
    love.graphics.print("Health: " .. e.health, 10, 35)
    love.graphics.print("Points: " .. game.points, 10, 60)
end

return HUDSystem
