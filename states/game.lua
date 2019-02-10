local game = {
    world = tiny.world(),
    bump_world = bump.newWorld(),
    camera = Camera(),
    map = nil
}

game.world:add(
    AISystem(game.world),
    CameraTrackingSystem(game.camera),
    HUDSystem,
    PhysicsSystem(game.bump_world),
    PlayerControlSystem,
    ProjectileSystem,
    SpriteSystem
)

game.camera:setFollowLerp(0.2)
game.camera:setFollowStyle('LOCKON')

local update_filter = tiny.filter("!isDrawSystem")
local draw_filter = tiny.filter("isDrawSystem&!isCameraBased")
local camera_draw_filter = tiny.filter("isDrawSystem&isCameraBased")
local window_w, window_h = love.graphics.getDimensions()

function game:init()
    self.world:add(Player(0, 300))
    self:stage("assets/maps/test.lua")
end

function game:stage(file)
    self.map = sti(file, {"bump"})
    self.map:bump_init(game.bump_world)

    self.world:add(SpawnSystem(self.world, self.map))
end

function game:update(dt)
    self.camera:update(dt)
    self.map:update(dt)
    self.world:update(dt, update_filter)

    if input:down("pause") then
        Gamestate.switch(pause)
    end
end

function game:draw()
    -- sti resets draw to origin
    -- clean this up later
    self.map:draw(-self.camera.x + window_w / 2, -self.camera.y + window_h / 2, self.camera.scale, self.camera.scale)
    self.map:bump_draw(self.bump_world, -self.camera.x + window_w / 2, -self.camera.y + window_h / 2, self.camera.scale, self.camera.scale)
    
    self.world:update(dt, draw_filter)

    self.camera:attach()
        self.world:update(dt, camera_draw_filter)
    self.camera:detach()
end

return game