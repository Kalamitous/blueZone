local CameraTrackingSystem = tiny.processingSystem(Object:extend())
CameraTrackingSystem.filter = tiny.requireAll("is_player")

function CameraTrackingSystem:new(camera)
    print("A")
    self.camera = camera
end

function CameraTrackingSystem:process(e, dt)
    print("w")
    self.camera:follow(e.x, e.y)
end

return CameraTrackingSystem
