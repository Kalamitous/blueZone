local PlayerSpawnSystem = tiny.processingSystem(Object:extend())
PlayerSpawnSystem.filter = tiny.filter("is_player")

function PlayerSpawnSystem:new(ecs_world, map)
    self.ecs_world = ecs_world
    self.map = map

    self.player_spawn = nil
    for _, o in pairs(self.map.objects) do
        if o.properties.player_spawn then
            self.player_spawn = o
        end
    end

    self:spawnPlayer()
end

function PlayerSpawnSystem:process(e, dt) 
end

function PlayerSpawnSystem:spawnPlayer()
    self.ecs_world:add(Player(self.player_spawn.x, self.player_spawn.y))
end

return PlayerSpawnSystem