local menu = {}

function menu:init()
    local Document = require 'libs/ui'
    menu.panel = Document.new()

    local button_style = {
        corner_radius = 0,
        border_thickness = 0,
        font = love.graphics.newFont("assets/fonts/RobotoCondensed-Regular.ttf", 16)
    }

    local container = menu.panel:create("Container", "menu-container", true)
    container:align("center", "center")
    container:updatePosition()

    local logo = menu.panel:create("Image", "logo")
    logo:setParent(container)
    logo:setImage("assets/images/test-logo.png")
    logo:align("center", "top")
    logo:updatePosition()

    local play_button = menu.panel:create("Button", "play-button")
    play_button:setParent(container)
    play_button:setSize(100, 50)
    play_button:setY(logo:getDimensions().bottom + 45)
    play_button:setText("Play")
    play_button:alignH("center")
    play_button:setStyle(button_style)
    play_button:updatePosition()
    play_button.onRelease = function()
        Gamestate.switch(game)
    end

    local settings_button = menu.panel:create("Button", "settings-button")
    settings_button:setParent(container)
    settings_button:setSize(100, 50)
    settings_button:setY(play_button:getDimensions().bottom + 15)
    settings_button:setText("Settings")
    settings_button:alignH("center")
    settings_button:setStyle(button_style)
    settings_button:updatePosition()
    settings_button.onRelease = function()
        Gamestate.switch(settings)
    end

    local exit_button = menu.panel:create("Button", "exit-button")
    exit_button:setParent(container)
    exit_button:setSize(100, 50)
    exit_button:setY(settings_button:getDimensions().bottom + 15)
    exit_button:setText("Exit")
    exit_button:alignH("center")
    exit_button:setStyle(button_style)
    exit_button:updatePosition()
    exit_button.onRelease = function()
        love.event.quit()
    end

    container:hugContent()
end

function menu:update(dt)
    if self.panel then
        self.panel:update(dt)
    end
end

function menu:draw()
    if self.panel then
        self.panel:draw()
    end
end

return menu
