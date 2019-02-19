local game_over = {
    panel = document.new()
}

function game_over:init()
    local button_style = {
        corner_radius = 0,
        border_thickness = 0,
        font = assets.fonts.roboto_condensed(16)
    }

    local label_style = {
        corner_radius = 0,
        border_thickness = 0,
        font = assets.fonts.roboto_condensed(24),
        text_color = {20 / 255, 84 / 255, 124 / 255}
    }

    local container = game_over.panel:create("Container", "container", true)
    container:align("center", "center")
    container:updatePosition()

    local points = game_over.panel:create("Label", "points")
    points:setParent(container)
    points:setText("Total Points: " .. tostring(game.points))
    points:setStyle(label_style)
    points:alignH("center")
    points:updatePosition()

    local retry_button = game_over.panel:create("Button", "retry-button")
    retry_button:setParent(container)
    retry_button:setSize(100, 50)
    retry_button:setY(points:getDimensions().bottom + 15)
    retry_button:setText("Retry")
    retry_button:alignH("center")
    retry_button:setStyle(button_style)
    retry_button:updatePosition()
    retry_button.onRelease = function()
        fade_in = true

        tick.delay(function() 
            Gamestate.switch(game)
            game:init()
            fade_out = true
        end, 1)
    end

    local exit_button = game_over.panel:create("Button", "exit-button")
    exit_button:setParent(container)
    exit_button:setSize(100, 50)
    exit_button:setY(retry_button:getDimensions().bottom + 15)
    exit_button:setText("Exit")
    exit_button:alignH("center")
    exit_button:setStyle(button_style)
    exit_button:updatePosition()
    exit_button.onRelease = function()
        Gamestate.switch(menu)
    end

    container:hugContent()
end

function game_over:update(dt)
    self.panel:update(dt)
end

function game_over:draw()
    self.panel:draw()
end

return game_over
