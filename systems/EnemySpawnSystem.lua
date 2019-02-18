local EnemySpawnSystem = tiny.processingSystem(Object:extend())
EnemySpawnSystem.filter = tiny.filter("is_enemy")

function EnemySpawnSystem:new(ecs_world, map)
    self.ecs_world = ecs_world
    self.map = map

    --self.enemy_spawns = {}
    for _, o in pairs(self.map.objects) do
        if o.type == "enemy_spawn" then
            --table.insert(self.enemy_spawns, o)
            if o.properties["1"] then
                for i = 1, o.properties["1"] do
                    self:spawnEnemy(o, 1)
                end
            end

            if o.properties["2"] then
                for i = 1, o.properties["2"] do
                    self:spawnEnemy(o, 2)
                end
            end

            if o.properties["3"] then
                for i = 1, o.properties["3"] do
                    self:spawnEnemy(o, 3)
                end
            end
        end
    end

    --[[self.total_enemies = 20
    self.max_enemies = 10
    self.spawned_enemies = 0

    for _, e in pairs(self.ecs_world.entities) do
        if tostring(e) == "Object" and e.is_enemy then
            self.current_enemies = self.current_enemies + 1
        end
    end
    
    for i = 1, self.max_enemies do
        self:spawnEnemy()
    end

    self.timer = tick.recur(function()
        local current_enemies = 0
        for _, e in pairs(self.ecs_world.entities) do
            if tostring(e) == "Object" and e.is_enemy then
                current_enemies = current_enemies + 1
            end
        end

        if current_enemies >= self.max_enemies then return end
        if self.spawned_enemies >= self.total_enemies then return end

        self:spawnEnemy()
    end, 1)]]--
end

function EnemySpawnSystem:process(e, dt)
end

function EnemySpawnSystem:spawnEnemy(spawn_platform, enemy_type)
    --[[local spawn_platform = self.enemy_spawns[math.random(#self.enemy_spawns)]
    local enemy_type = math.random(3)

    if enemy_type == 1 then
        self.ecs_world:add(Enemy(spawn_platform))
    elseif enemy_type == 2 then
        self.ecs_world:add(Beamer(spawn_platform))
    elseif enemy_type == 3 then
        self.ecs_world:add(Rocketeer(spawn_platform))
    end

    self.spawned_enemies = self.spawned_enemies + 1]]--

    if enemy_type == 1 then
        self.ecs_world:add(Enemy(spawn_platform))
    elseif enemy_type == 2 then
        self.ecs_world:add(Beamer(spawn_platform))
    elseif enemy_type == 3 then
        self.ecs_world:add(Rocketeer(spawn_platform))
    end
end

return EnemySpawnSystem