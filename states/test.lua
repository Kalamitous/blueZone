local test = {
    panel = Document:extend()
}

function test:init()
    self.a = self.panel.Container:extend()
end

function test:update(dt)
    self.a:update(dt)
end

function test:draw()
    self.a:draw()
end

return test