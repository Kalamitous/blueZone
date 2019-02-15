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
    PlayerControlSystem(game.ecs_world),
    UpdateSystem(game.ecs_world)
)

game.camera:setFollowLerp(0.2)
game.camera:setFollowStyle("LOCKON")

local update_filter = tiny.filter("!isDrawSystem")
local draw_filter = tiny.filter("isDrawSystem")

function game:init()
    self.ecs_world:add(Player(0, 300))
    self:stage("assets/maps/test.lua")
end

function game:stage(file)
    self.map = sti(file, {"bump"})
    self.map:bump_init(self.bump_world)
    
    self.map_size = {
        w = self.map.width * self.map.tilewidth,
        h = self.map.height * self.map.tileheight
    }

    self.ecs_world:add(
        PhysicsSystem(self.bump_world, self.map),
        SpawnSystem(self.ecs_world, self.map),
        SpriteSystem(self.camera, self.map_size)
    )

    local window_w, window_h = love.graphics.getDimensions()
    local x1, x2, y1, y2

    if self.map_size.w >= window_w then
        x1 = 0
        x2 = self.map_size.w
    else
        x1 = window_w / 2 - self.map_size.w / 2
        x2 = window_w / 2 + self.map_size.w / 2
    end
    
    if self.map_size.h >= window_h then
        y1 = 0
        y2 = self.map_size.h
    else
        y1 = window_h / 2 - self.map_size.h / 2
        y2 = window_h / 2 + self.map_size.h / 2
    end

    self.camera:setBounds(x1, y1, x2, y2)
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
    local window_w, window_h = love.graphics.getDimensions()
    local offset_x, offset_y

    if self.map_size.w >= window_w then
        offset_x = 0
    else
        offset_x = window_w / 2 - self.map_size.w / 2
    end
    
    if self.map_size.h >= window_h then
        offset_y = 0
    else
        offset_y = window_h / 2 - self.map_size.h / 2
    end

    -- sti resets draw to origin
    self.map:draw(-self.camera.x + window_w / 2 + offset_x, -self.camera.y + window_h / 2 + offset_y, self.camera.scale, self.camera.scale)
    --self.map:bump_draw(self.bump_world, -self.camera.x + window_w / 2 + offset_x, -self.camera.y + window_h / 2 + offset_y, self.camera.scale, self.camera.scale)

    self.ecs_world:update(dt, draw_filter)
end

return game