local SpriteSystem = tiny.processingSystem(Object:extend())
SpriteSystem.isDrawSystem = true
SpriteSystem.isCameraBased = true
SpriteSystem.filter = tiny.requireAll("sprite")

function SpriteSystem:process(e, dt)
    love.graphics.rectangle("fill", e.x, e.y, e.w, e.h)
end

return SpriteSystem
