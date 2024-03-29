local pause = {
    panel = document.new()
}

function pause:init()
    local button_style = {
        corner_radius = 0,
        border_thickness = 0,
        font = assets.fonts.roboto_condensed(16)
    }

    local container = pause.panel:create("Container", "container", true)
    container:align("center", "center")
    container:updatePosition()

    local resume_button = pause.panel:create("Button", "resume-button")
    resume_button:setParent(container)
    resume_button:setSize(100, 50)
    resume_button:setText("Resume")
    resume_button:alignH("center")
    resume_button:setStyle(button_style)
    resume_button:updatePosition()
    resume_button.onRelease = function()
        Gamestate.switch(game)
    end

    local exit_button = pause.panel:create("Button", "exit-button")
    exit_button:setParent(container)
    exit_button:setSize(100, 50)
    exit_button:setY(resume_button:getDimensions().bottom + 15)
    exit_button:setText("Exit")
    exit_button:alignH("center")
    exit_button:setStyle(button_style)
    exit_button:updatePosition()
    exit_button.onRelease = function()
        Gamestate.switch(menu)
    end

    container:hugContent()
end

function pause:update(dt)
    self.panel:update(dt)
end

function pause:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics:getWidth(), love.graphics:getHeight())
    love.graphics.setColor(1, 1, 1, 1)

    self.panel:draw()
end

return pause
