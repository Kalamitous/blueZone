local Sprite = tiny.processingSystem(Object:extend())
Sprite.isDrawSystem = true
Sprite.filter = tiny.requireAll("sprite")

function Sprite:process(e, dt)
    love.graphics.rectangle("fill", e.x, e.y, e.w, e.h)
end

return Sprite
