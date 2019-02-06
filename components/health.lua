local Health = class()

function Health:init(health)
    self.max = health
    self.value = self.max
end

function Health:offset(value)
    self.value = lume.clamp(self.value + value, 0, self.max)
end

return Health
