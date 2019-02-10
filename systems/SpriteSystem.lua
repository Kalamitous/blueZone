local SpriteSystem = tiny.processingSystem(Object:extend())
SpriteSystem.filter = tiny.requireAll("sprite")
SpriteSystem.isDrawSystem = true
SpriteSystem.isCameraBased = true

function SpriteSystem:process(e, dt)
    e:draw()
end

return SpriteSystem