local menu = {}

function menu:init()
    self.panel = document.new()

    local button_style = {
        corner_radius = 0,
        border_thickness = 0,
        font = assets.fonts.roboto_condensed(16)
    }

    local container = menu.panel:create("Container", "menu-container", true)
    container:align("center", "center")
    container:updatePosition()

    local logo = menu.panel:create("Image", "logo")
    logo:setParent(container)
    logo:setImage("assets/images/logo.png")
    logo:align("center", "top")
    logo:updatePosition()

    local play_button = menu.panel:create("Button", "play-button")
    play_button:setParent(container)
    play_button:setSize(100, 50)
    play_button:setY(logo:getDimensions().bottom + 48)
    play_button:setText("Play")
    play_button:alignH("center")
    play_button:setStyle(button_style)
    play_button:updatePosition()
    play_button.onRelease = function()
        fade_in = true

        tick.delay(function() 
            Gamestate.switch(game)
            game:init()
            fade_out = true
        end, 1)
    end

    local fs_button = menu.panel:create("Button", "fs-button")
    fs_button:setParent(container)
    fs_button:setSize(100, 50)
    fs_button:setY(play_button:getDimensions().bottom + 16)
    fs_button:setText("Toggle Fullscreen")
    fs_button:alignH("center")
    fs_button:setStyle(button_style)
    fs_button:updatePosition()
    fs_button.onRelease = function()
        if love.window.getFullscreen() then
            love.window.setFullscreen(false)
        else
            love.window.setFullscreen(true)
        end

        self:init()
    end

    local exit_button = menu.panel:create("Button", "exit-button")
    exit_button:setParent(container)
    exit_button:setSize(100, 50)
    exit_button:setY(fs_button:getDimensions().bottom + 16)
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
    self.panel:update(dt)
end

function menu:draw()
    self.panel:draw()
end

return menu
