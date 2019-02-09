local CameraTrackingSystem = tiny.processingSystem(Object:extend())
CameraTrackingSystem.filter = tiny.filter("is_player")

function CameraTrackingSystem:new(camera)
    self.camera = camera
end

function CameraTrackingSystem:process(e, dt)
    self.camera:follow(e.pos.x + e.hitbox.w / 2, e.pos.y + e.hitbox.h / 2)
end

return CameraTrackingSystem
