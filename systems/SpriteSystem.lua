local SpriteSystem = tiny.processingSystem(Object:extend())
SpriteSystem.isDrawSystem = true
SpriteSystem.isCameraBased = true
SpriteSystem.filter = tiny.requireAll("sprite")

function SpriteSystem:process(e, dt)
    e:draw()
end

return SpriteSystem
