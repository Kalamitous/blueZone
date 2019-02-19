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

    assets.sounds.music.BGM_3:play()
    assets.sounds.music.BGM_3:setVolume(0)
    assets.sounds.music.BGM_3:setLooping(true)

    assets.sounds.music.BGM_2:play()
    assets.sounds.music.BGM_2:setVolume(0)
    assets.sounds.music.BGM_2:setLooping(true)

    assets.sounds.music.BGM_1:play()
    assets.sounds.music.BGM_1:setVolume(0.5)
    assets.sounds.music.BGM_1:setLooping(true)

    self.points = 0
    self.stage_num = 1
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
        PlayerControlSystem(self.ecs_world, self.camera),
        UpdateSystem(self.ecs_world),
        LaserSystem(self.bump_world),
        CameraTrackingSystem(self.camera),
        EnemySpawnSystem(self.ecs_world, self.map),
        PhysicsSystem(self.bump_world, self.map),
        SpriteSystem(self.camera, self.map),
        HUDSystem,
        PlayerSpawnSystem(self.ecs_world, self.map)
    )

    if game.reset_timer then
        game.reset_timer:stop()
        game.reset_timer = nil
    end
    
    game.reset_timer = tick.recur(function()
        local current_enemies = 0
        
        for _, e in pairs(self.ecs_world.entities) do
            if tostring(e) == "Object" and e.is_enemy then
                current_enemies = current_enemies + 1
            end
        end

        if current_enemies ~= 0 then return end
        
        if game.stage_num == 1 then
            fade_in = true

            tick.delay(function()
                if game.stage_num == 2 then return end
                
                game:stage("assets/maps/stage_2")
                game.stage_num = 2

                assets.sounds.music.BGM_1:stop()

                fade_out = true
            end, 1)
        elseif game.stage_num == 2 then
            fade_in = true

            tick.delay(function()
                if game.stage_num == 3 then return end

                game:stage("assets/maps/stage_3")
                game.stage_num = 3

                assets.sounds.music.BGM_2:stop()

                fade_out = true
            end, 1)
        elseif game.stage_num == 3 then
            fade_in = true

            tick.delay(function()
                if game.stage_num == 0 then return end

                Gamestate.switch(game_over)
                game.stage_num = 0

                tick.delay(function()
                    assets.sounds.music.BGM_3:stop()
                end, 1)

                fade_out = true
            end, 1)
        end
    end, 1)
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
    local bg_w, bg_h = assets.objects.bg:getDimensions()

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