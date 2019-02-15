local SpriteSystem = tiny.processingSystem(Object:extend())
SpriteSystem.filter = tiny.filter("sprite")
SpriteSystem.isDrawSystem = true

function SpriteSystem:new(camera, map_size)
    self.camera = camera
    self.map_size = map_size
end

function SpriteSystem:preProcess(dt)
    local window_w, window_h = love.graphics.getDimensions()
    local x, y

    if self.map_size.w >= window_w then
        x = 0
    else
        x = window_w / 2 - self.map_size.w / 2
    end
    
    if self.map_size.h >= window_h then
        y = 0
    else
        y = window_h / 2 - self.map_size.h / 2
    end

    love.graphics.push()
    love.graphics.translate(x, y)

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
    
    love.graphics.pop()
end

return SpriteSystem