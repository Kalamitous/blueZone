local settings = {
    panel = document.new(),
    width = 800,
    height = 600,
    options = {
        {
            prefix = "res-",
            text = "Resolution",
            type = "dropdown",
            values = {
                {"1920 x 1080", {w = 1920, h = 1080}},
                {"1600 x 900", {w = 1600, h = 900}},
                {"1366 x 768", {w = 1366, h = 768}}
            }
        },
        {
            prefix = "dm-",
            text = "Display Mode",
            type = "dropdown",
            values = {
                {"Fullscreen", "fullscreen"},
                {"Windowed", "windowed"},
                {"Windowed Borderless", "bordered"}
            }
        },
        {
            prefix = "msaa-",
            text = "MSAA",
            type = "dropdown",
            values = {
                {"off", 0},
                {"2x", 2},
                {"4x", 4},
                {"8x", 8}
            }
        },
        {
            prefix = "vsync-",
            text = "VSync",
            type = "checkbox"
        }
    }
}

function settings:init()
    local container_style = {
        color = {0.5, 0, 0},
        corner_radius = 0,
        border_thickness = 0
    }

    local button_style = {
        corner_radius = 0,
        border_thickness = 0,
        font = assets.fonts.roboto_condensed(16)
    }

    local label_style = {
        font = assets.fonts.roboto_condensed(16),
        color = {1, 0, 0}
    }

    local container = self.panel:create("Container", "container")
    container:setSize(self.width, self.height)
    container:align("center", "center")
    container:updatePosition()

    local back_button = self.panel:create("Button", "back-button")
    back_button:setParent(container)
    back_button:setSize(100, 50)
    back_button:setOffset(-(50 + 8), 25)
    back_button:setText("Back")
    back_button:align("center", "bottom")
    back_button:setStyle(button_style)
    back_button:updatePosition()
    back_button.onRelease = function()
        Gamestate.switch(menu)
    end

    local apply_button = self.panel:create("Button", "apply-button")
    apply_button:setParent(container)
    apply_button:setSize(100, 50)
    apply_button:setOffset(50 + 8, 25)
    apply_button:setText("Apply")
    apply_button:align("center", "bottom")
    apply_button:setStyle(button_style)
    apply_button:updatePosition()
    apply_button.onRelease = function()

    end

    for k, v in pairs(self.options) do
        v.container = self.panel:create("Container", v.prefix .. "container")
        v.container:setParent(container)
        v.container:setSize(self.width, 100)
        if k == 1 then
            v.container:alignV("top")
        else
            v.container:setY(self.options[k - 1].container:getDimensions().bottom)
        end
        v.container:alignH("center")
        v.container:updatePosition()

        v.label = self.panel:create("Label", v.prefix .. "label")
        v.label:setParent(v.container)
        v.label:setSize(200, 20)
        v.label:setOffset(8, 0)
        v.label:setText(v.text)
        v.label:setStyle(label_style)
        v.label:align("left", "center")
        v.label:updatePosition()

        v.container:hugContent(8, false, true)
    end
end

function settings:update(dt)
    self.panel:update(dt)
end

function settings:draw()
    self.panel:draw()
end

return settings
