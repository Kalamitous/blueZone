local DIR = (...):match('(.-)[^%.]+$')
local element = require(DIR .. "element")

return {
    create = function(self, id)
        self.elements[id] = element.new({
            id = id,
            text = love.graphics.newText(love.graphics.getFont(), "Button"),
            style = {
                corner_radius = 4,

                color = {1, 1, 1, 1},
                hover_color = {0.75, 0.75, 0.75, 1},
                press_color = {0.5, 0.5, 0.5, 1},

                text_color = {0, 0, 0, 1},
                text_hover_color = {0, 0, 0, 1},
                text_press_color = {0, 0, 0, 1},

                border_thickness = 4,
                border_color = {0.5, 0, 0, 1},
                border_hover_color = {0.5, 0, 0, 1},
                border_press_color = {0.5, 0, 0, 1}
            },
            setText = function(self, text)
                self.text:setf(text, self.innerWidth, "center")
            end,
            setStyle = function(self, style)
                for k, v in pairs(style) do
                    self.style[k] = v

                    if k == "font" then
                        self.text:setFont(v)
                    end
                end
            end,
            getState = function()
                return self:getState(id)
            end
        })

        local attributes = self.elements[id]
        local style = attributes.style

        table.insert(self.update_table, function()
            -- create system where users can externally create inputs for use here (like we can use baton without hardcoding it into this library)
            local x, y = love.mouse.getPosition()
            local pressing = love.mouse.isDown(1)

            if (x >= attributes.x) and (x < attributes.x + attributes.outerWidth) and (y >= attributes.y) and (y < attributes.y + attributes.outerHeight) then
                if pressing then
                    attributes.state = "pressed"
                else
                    if attributes.state == "pressed" then
                        attributes.state = "released"

                        if attributes.onRelease then
                            attributes.onRelease()
                        end
                    else
                        if attributes.state == "none" then
                            attributes.state = "entered"
                        else
                            attributes.state = "hovered"
                        end
                    end
                end
            else
                if attributes.state == "hovered" or attributes.state == "pressed" then
                    attributes.state = "exited"
                else
                    attributes.state = "none"
                end
            end
        end)
        
        table.insert(self.draw_table, function()
            local color = style.color
            local text_color = style.text_color
            local border_color = style.border_color

            if attributes.state == "hovered" then
                color = style.hover_color
                text_color = style.text_hover_color
                border_color = style.border_hover_color
            elseif attributes.state == "pressed" then
                color = style.press_color
                text_color = style.text_press_color
                border_color = style.border_press_color
            end

            local text_height = math.ceil(attributes.text:getWidth() / attributes.innerWidth) * attributes.text:getHeight()

            love.graphics.setColor(unpack(border_color))
            love.graphics.rectangle("fill", attributes.x, attributes.y, attributes.outerWidth, attributes.outerHeight, style.corner_radius, style.corner_radius)

            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", attributes.x + style.border_thickness, attributes.y + style.border_thickness, attributes.innerWidth, attributes.innerHeight, style.corner_radius, style.corner_radius)

            love.graphics.setColor(unpack(text_color))
            love.graphics.draw(attributes.text, attributes.x + style.border_thickness, attributes.y + style.border_thickness + attributes.innerHeight / 2 - text_height / 2)

            love.graphics.setColor(1, 1, 1, 1)
        end)

        attributes.state = "none"
    end,
}
