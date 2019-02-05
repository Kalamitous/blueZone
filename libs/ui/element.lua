local element = {}

function element.new(attributes)
    return setmetatable(attributes, {__index = {
        x = 0,
        y = 0,
        offset_x = 0,
        offset_y = 0,
        innerWidth = 0,
        innerHeight = 0,
        parent = {
            x = 0,
            y = 0,
            innerWidth = love.graphics.getWidth(),
            innerHeight = love.graphics.getHeight(),
            outerWidth = love.graphics.getWidth(),
            outerHeight = love.graphics.getHeight(),
            style = {
                border_thickness = 0
            }
        },
        children = {},
        style = {
            border_thickness = 0,
        },
        setParent = function(self, parent)
            self.parent = parent
    
            parent.children[self.id] = self
        end,
        setSize = function(self, w, h)
            self.innerWidth = w
            self.innerHeight = h
    
            self:updateOuterSize()
        end,
        setOffset = function(self, x, y)
            self.offset_x = x
            self.offset_y = y
        end,
        setX = function(self, x)
            self.x = x
        end,
        setY = function(self, y)
            self.y = y
        end,
        align = function(self, h, v)
            self.align_h = h
            self.align_v = v
        end,
        alignH = function(self, h)
            self.align_h = h
        end,
        alignV = function(self, v)
            self.align_v = v
        end,
        setStyle = function(self, style)
            for k, v in pairs(style) do
                self.style[k] = v
            end
        end,
        getDimensions = function(self)
            return {
                left = self.x,
                right = self.x + self.outerWidth,
                top = self.y,
                bottom = self.y + self.outerHeight
            }
        end,
        updateOuterSize = function(self)
            self.outerWidth = self.innerWidth + self.style.border_thickness * 2
            self.outerHeight = self.innerHeight + self.style.border_thickness * 2
        end,
        updatePosition = function(self)
            -- remember that unparented elements have fake parent
            if self.parent.updateOuterSize then
                self.parent:updateOuterSize()
            end
    
            self:updateOuterSize()
    
            local x, y
    
            if self.align_h then
                if (self.align_h == "left") then
                    x = self.parent.style.border_thickness
                elseif (self.align_h == "center") then
                    x = self.parent.outerWidth / 2 - self.outerWidth / 2
                elseif (self.align_h == "right") then
                    x = self.parent.outerWidth - self.parent.style.border_thickness - self.outerWidth
                end
    
                self.x = self.parent.x + self.offset_x + x
            end
                
            if self.align_v then
                if (self.align_v == "top") then
                    y = self.parent.style.border_thickness
                elseif (self.align_v == "center") then
                    y = self.parent.outerHeight / 2 - self.outerHeight / 2
                elseif (self.align_v == "bottom") then
                    y = self.parent.outerHeight - self.parent.style.border_thickness - self.outerHeight
                end
    
                self.y = self.parent.y + self.offset_y + y
            end
        end,
        hugContent = function(self, padding)
            padding = padding or 0
    
            local min_x = 0
            local max_x = 0
            local min_y = 0
            local max_y = 0
    
            local first_loop = false
    
            for _, c in pairs(self.children) do
                if not first_loop then
                    min_x = c.x
                    max_x = c.x + c.outerWidth
                    min_y = c.y
                    max_y = c.y + c.outerHeight
    
                    first_loop = true
                end
    
                if min_x > c.x then
                    min_x = c.x
                end
    
                if max_x < c.x + c.outerWidth then
                    max_x = c.x + c.outerWidth
                end
    
                if min_y > c.y then
                    min_y = c.y
                end
    
                if max_y < c.y + c.outerHeight then
                    max_y = c.y + c.outerHeight
                end
            end
    
            self.innerWidth = max_x - min_x + padding * 2
            self.innerHeight = max_y - min_y + padding * 2
    
            self:updateOuterSize()
            self:updatePosition()
    
            for _, c in pairs(self.children) do
                -- shift children by the same amount the parent shifted
                c.x = c.x + (self.x - min_x) + self.style.border_thickness + padding
                c.y = c.y + (self.y - min_y) + self.style.border_thickness + padding
            end
        end
    }})
end

return element
