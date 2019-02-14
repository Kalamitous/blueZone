local DIR = (...):match('(.-)[^%.]+$')
local element = require(DIR .. "element")

return {
    create = function(self, id)
        self.elements[id] = element.new({
            id = id,
            text = love.graphics.newText(love.graphics.getFont(), "Label"),
            style = {
                border_thickness = 0,
                color = {1, 1, 1, 1}
            },
            setText = function(self, text)
                self.text:set(text)
                self:updateSize()
            end,
            setStyle = function(self, style)
                for k, v in pairs(style) do
                    self.style[k] = v

                    if k == "font" then
                        self.text:setFont(v)
                        self:updateSize()
                    end
                end
            end,
            updateSize = function(self)
                self.innerWidth, self.innerHeight = self.text:getDimensions()

                self:updateOuterSize()
            end
        })

        local attributes = self.elements[id]
        local style = attributes.style
        
        table.insert(self.draw_table, function()
            love.graphics.setColor(unpack(style.color))
            love.graphics.draw(attributes.text, attributes.x, attributes.y) 
            love.graphics.setColor(1, 1, 1, 1)
        end)
    end,
}