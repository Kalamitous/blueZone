local SpriteSystem = tiny.processingSystem(Object:extend())
SpriteSystem.filter = tiny.filter("sprite")
SpriteSystem.isDrawSystem = true

function SpriteSystem:new(camera)
    self.camera = camera
end

function SpriteSystem:preProcess(dt)
    self.camera:attach()
end

function SpriteSystem:process(e, dt)
    local opacity = e.opacity or 1
    
    love.graphics.setColor(1, 1, 1, opacity)
        if e.anims then
            local scale = e.anims.scale
            local x = e.pos.x + e.hitbox.w / 2 - e.anims.cur:getWidth() * scale / 2 * e.dir
            local y = e.pos.y + e.hitbox.h - e.anims.cur:getHeight() * scale

            love.graphics.push()
            love.graphics.translate(x, y)
            love.graphics.scale(scale * e.dir, scale)
                e.anims.cur:draw()
            love.graphics.pop()
        end

        if e.draw then
            e:draw()
        end
    love.graphics.setColor(1, 1, 1, 1)
end

function SpriteSystem:postProcess(dt)
    self.camera:detach()
end

return SpriteSystem