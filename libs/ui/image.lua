local DIR = (...):match('(.-)[^%.]+$')
local element = require(DIR .. "element")

return {
    create = function(self, id)
        self.elements[id] = element.new({
            id = id,
            setSize = function(self, x, y)
                self.scale_x = x
                self.scale_y = y

                self.innerWidth = self.innerWidth * self.scale_x
                self.innerHeight = self.innerHeight * self.scale_y

                self:updateOuterSize()
            end,
            setImage = function(self, file)
                self.image = love.graphics.newImage(file)

                self.innerWidth, self.innerHeight = self.image:getDimensions()

                self:updateOuterSize()
            end
        })

        local attributes = self.elements[id]

        table.insert(self.draw_table, function()
            love.graphics.draw(attributes.image, attributes.x, attributes.y, 0, attributes.scale_x, attributes.scale_y)
        end)
    end,
}
