local SpawnSystem = tiny.processingSystem(Object:extend())
SpawnSystem.filter = tiny.filter("is_enemy")

function SpawnSystem:new(ecs_world, map)
    self.ecs_world = ecs_world
    self.map = map

    self.total_enemies = 20
    self.max_enemies = 100
    self.spawned_enemies = 0
    self.current_enemies = 0

    for _, e in pairs(self.ecs_world.entities) do
        if tostring(e) == "Object" and e.is_enemy then
            self.current_enemies = self.current_enemies + 1
        end
    end

    self.enemy_spawns = {}
    for _, o in pairs(self.map.objects) do
        if o.properties.enemy_spawn then
            table.insert(self.enemy_spawns, o)
        end
    end
    
    for i = 1, self.max_enemies do
        self:spawnEnemy()
    end

    self.timer = tick.recur(function()
        if self.current_enemies >= self.max_enemies then return end
        if self.spawned_enemies >= self.total_enemies then return end

        self:spawnEnemy()
    end, 1)
end

function SpawnSystem:process(e, dt)
    self.current_enemies = 0

    for _, e in pairs(self.ecs_world.entities) do
        if tostring(e) == "Object" and e.is_enemy then
            self.current_enemies = self.current_enemies + 1
        end
    end
end

-- distribute enemies to correspond w/ platform size
function SpawnSystem:spawnEnemy()
    local spawn_platform = self.enemy_spawns[math.random(#self.enemy_spawns)]
    
    self.ecs_world:add(Enemy(spawn_platform.x + lume.random(spawn_platform.width - 50), spawn_platform.y - 75, spawn_platform))
    self.spawned_enemies = self.spawned_enemies + 1
end

return SpawnSystem