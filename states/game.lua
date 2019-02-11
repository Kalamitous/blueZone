local game = {
    ecs_world = tiny.world(),
    bump_world = bump.newWorld(),
    camera = Camera(),
    map = nil
}

game.ecs_world:add(
    AISystem(game.ecs_world, game.bump_world),
    CameraTrackingSystem(game.camera),
    HUDSystem,
    PlayerControlSystem,
    SpriteSystem
)

game.camera:setFollowLerp(0.2)
game.camera:setFollowStyle('LOCKON')

local update_filter = tiny.filter("!isDrawSystem")
local draw_filter = tiny.filter("isDrawSystem&!isCameraBased")
local camera_draw_filter = tiny.filter("isDrawSystem&isCameraBased")
local window_w, window_h = love.graphics.getDimensions()

function game:init()
    self.ecs_world:add(Player(0, 300))
    self:stage("assets/maps/test.lua")
end

function game:stage(file)
    self.map = sti(file, {"bump"})
    self.map:bump_init(game.bump_world)

    self.ecs_world:add(
        PhysicsSystem(game.ecs_world, game.bump_world, game.map),
        SpawnSystem(self.ecs_world, self.map)
    )

    -- there has to be a better way to do this.
    local objects = self.map.objects
    for _, o in pairs(objects) do
        if o.name == "Bounds" then
            self.camera:setBounds(o.x, o.y, o.width, o.height)
        end
    end
end

function game:update(dt)
    self.camera:update(dt)
    self.map:update(dt)
    self.ecs_world:update(dt, update_filter)

    if input:down("pause") then
        Gamestate.switch(pause)
    end
end

function game:draw()
    -- sti resets draw to origin
    self.map:draw(-self.camera.x + window_w / 2, -self.camera.y + window_h / 2, self.camera.scale, self.camera.scale)
    self.map:bump_draw(self.bump_world, -self.camera.x + window_w / 2, -self.camera.y + window_h / 2, self.camera.scale, self.camera.scale)
    
    self.ecs_world:update(dt, draw_filter)

    self.camera:attach()
        self.ecs_world:update(dt, camera_draw_filter)
    self.camera:detach()
end

return game