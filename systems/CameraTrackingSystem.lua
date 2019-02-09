local CameraTrackingSystem = tiny.processingSystem(Object:extend())
CameraTrackingSystem.filter = tiny.requireAll("is_player")

function CameraTrackingSystem:new(camera)
    self.camera = camera
end

function CameraTrackingSystem:process(e, dt)
    self.camera:follow(e.x + e.w / 2, e.y + e.h / 2)
end

return CameraTrackingSystem
