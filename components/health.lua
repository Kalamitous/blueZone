local Health = Component(function(e, health)
    e.max = health
    e.value = e.max
end)

function Health:offset(value)
    -- is math.clamp correct?
    self.value = math.clamp(self.value + value, 0, self.max)
end

return Health
