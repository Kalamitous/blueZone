local game = {
    ecs_world = tiny.world(),
    bump_world = bump.newWorld(),
    camera = Camera(),
    map = nil
}

game.ecs_world:add(
    AISystem(game.ecs_world, game.bump_world),
    CameraTrackingSystem(game.camera),
    DeathSystem,
    HUDSystem,
    PlayerControlSystem,
    SpriteSystem(game.camera),
    UpdateSystem(game.ecs_world)
)

game.camera:setFollowLerp(0.2)
game.camera:setFollowStyle('LOCKON')

local update_filter = tiny.filter("!isDrawSystem")
local draw_filter = tiny.filter("isDrawSystem")
local window_w, window_h = love.graphics.getDimensions()

function game:init()
    self.ecs_world:add(Player(0, 300))
    self:stage("assets/maps/test.lua")
end

function game:stage(file)
    self.map = sti(file, {"bump"})
    self.map:bump_init(self.bump_world)

    self.ecs_world:add(
        PhysicsSystem(self.bump_world, self.map),
        SpawnSystem(self.ecs_world, self.map)
    )

    self.camera:setBounds(0, 0, self.map.width * self.map.tilewidth, self.map.height * self.map.tileheight)
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
end

return game