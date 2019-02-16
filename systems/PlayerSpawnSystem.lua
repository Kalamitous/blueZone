local PlayerSpawnSystem = tiny.processingSystem(Object:extend())
PlayerSpawnSystem.filter = tiny.filter("is_player")

function PlayerSpawnSystem:new(ecs_world, map)
    self.ecs_world = ecs_world
    self.map = map

    self.respawn_timer = nil
    self.player_spawn = nil
    for _, o in pairs(self.map.objects) do
        if o.properties.player_spawn then
            self.player_spawn = o
        end
    end

    self.ecs_world:add(Player(self.player_spawn.x, self.player_spawn.y))
end

function PlayerSpawnSystem:process(e, dt)
    if e.dead and e.vel.x == 0 and e.vel.y == 0 and not self.respawn_timer then
        self.respawn_timer = tick.delay(function()
            e:new(self.player_spawn.x, self.player_spawn.y)
            e:setInvincible(e.invincible_time)

            self.respawn_timer = nil
        end, 1)
    end
end

return PlayerSpawnSystem