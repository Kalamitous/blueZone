local DIR = (...):match('(.-)[^%.]+$')
local element = require(DIR .. "element")

return {
    create = function(self, id, invisible)
        self.elements[id] = element.new({
            id = id,
            style = {
                corner_radius = 4,
        
                color = {1, 1, 1, 1},

                text_color = {0, 0, 0, 1},
        
                border_thickness = 4,
                border_color = {0.5, 0, 0, 1},
            }
        })
        
        if invisible then return end

        local attributes = self.elements[id]
        local style = attributes.style

        table.insert(self.draw_table, function()
            local color = style.color
            local border_color = style.border_color

            love.graphics.setColor(unpack(border_color))
                love.graphics.rectangle("fill", attributes.x, attributes.y, attributes.outerWidth, attributes.outerHeight, style.corner_radius, style.corner_radius)
            love.graphics.setColor(unpack(color))
                love.graphics.rectangle("fill", attributes.x + style.border_thickness, attributes.y + style.border_thickness, attributes.innerWidth, attributes.innerHeight, style.corner_radius, style.corner_radius)
            love.graphics.setColor(255, 255, 255, 255)
        end)
    end,
}
