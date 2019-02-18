local game = {
    ecs_world = nil,
    bump_world = nil,
    camera = nil,
    map = nil,
    stage_num = 1
}

local update_filter = tiny.filter("!isDrawSystem")
local draw_filter = tiny.filter("isDrawSystem")

function game:init()
    self:stage("assets/maps/stage_1")

    assets.sounds.music.BGM_full:play()
    assets.sounds.music.BGM_full:setLooping(true)
end

function game:stage(file)
    local map = require(file)

    local window_w, window_h = love.graphics.getDimensions()

    local map_offset = {x = 0, y = 0}
    local map_size = {
        w = map.width * map.tilewidth,
        h = map.height * map.tileheight
    }

    if map_size.w < window_w then
        map_offset.x = window_w / 2 - map_size.w / 2
    end
    
    if map_size.h < window_h then
        map_offset.y = window_h / 2 - map_size.h / 2
    end

    self.bump_world = bump.newWorld()

    self.map = sti(file .. ".lua", {"bump"})
    self.map:bump_init(self.bump_world)
    self.map.offset = map_offset
    self.map.size = map_size

    self.camera = Camera()
    self.camera:setFollowLerp(0.1)
    self.camera:setFollowStyle("LOCKON")
    self.camera:setBounds(self.map.offset.x, self.map.offset.y, self.map.offset.x + self.map.size.w, self.map.offset.y + self.map.size.h)
    self.camera.x = self.map.offset.x + window_w / 2
    self.camera.y = self.map.offset.y + self.map.size.h - window_h / 2
    
    if self.ecs_world then
        self.ecs_world:clearEntities()
        self.ecs_world:clearSystems()
    end

    self.ecs_world = tiny.world()
    self.ecs_world:add(
        AISystem(self.ecs_world, self.bump_world),
        DeathSystem,
        HUDSystem,
        PlayerControlSystem(self.ecs_world),
        UpdateSystem(self.ecs_world),
        LaserSystem(self.bump_world),
        CameraTrackingSystem(self.camera),
        EnemySpawnSystem(self.ecs_world, self.map),
        PhysicsSystem(self.bump_world, self.map),
        PlayerSpawnSystem(self.ecs_world, self.map),
        SpriteSystem(self.camera, self.map)
    )
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
    
    -- sti resets draw to origin
    self.map:draw(-self.camera.x + window_w / 2 + self.map.offset.x, -self.camera.y + window_h / 2 + self.map.offset.y, self.camera.scale, self.camera.scale)
    --self.map:bump_draw(self.bump_world, -self.camera.x + window_w / 2, -self.camera.y + window_h / 2, self.camera.scale, self.camera.scale)

    --[[self.camera:attach()
        local items, len = self.bump_world:getItems()
        for i = 1, len do
            local x, y, w, h = self.bump_world:getRect(items[i])
            love.graphics.rectangle("line", x + self.map.offset.x, y + self.map.offset.y, w, h)
        end
    self.camera:detach()]]--

    self.ecs_world:update(dt, draw_filter)
end

return game