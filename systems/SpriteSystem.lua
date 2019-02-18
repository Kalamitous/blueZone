local SpriteSystem = tiny.processingSystem(Object:extend())
SpriteSystem.filter = tiny.filter("sprite")
SpriteSystem.isDrawSystem = true

function SpriteSystem:new(camera, map)
    self.camera = camera
    self.map = map
end

function SpriteSystem:preProcess(dt)
    love.graphics.push()
    love.graphics.translate(self.map.offset.x, self.map.offset.y)
    
    self.camera:attach()
end

function SpriteSystem:process(e, dt)
    local opacity = e.opacity or 1
    
    love.graphics.setColor(1, 1, 1, opacity)
        if e.anims then
            local scale = e.anims.scale
            local draw_offset = e.anims.cur.draw_offset
            local cur_anim = e.anims.cur.anim
            local x = e.pos.x + e.hitbox.w / 2 + (e.offset.x + draw_offset.x) * e.dir - cur_anim:getWidth() * scale / 2 * e.dir
            local y = e.pos.y + e.hitbox.h + (e.offset.y + draw_offset.y) - cur_anim:getHeight() * scale

            love.graphics.push()
            love.graphics.translate(x, y)
            love.graphics.scale(scale * e.dir, scale)
                cur_anim:draw()
            love.graphics.pop()
        end

        if e.draw then
            e:draw()
        end
    love.graphics.setColor(1, 1, 1, 1)
end

function SpriteSystem:postProcess(dt)
    self.camera:detach()

    love.graphics.pop()
end

return SpriteSystem