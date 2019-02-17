local AISystem = tiny.processingSystem(Object:extend())
AISystem.filter = tiny.filter("is_enemy")

function AISystem:new(ecs_world, bump_world)
    self.ecs_world = ecs_world
    self.bump_world = bump_world

    self.view_cone_subdivisions = 10
end

function viewConeFilter(item)
    if item.properties or item.is_player then
        return true
    end
end

function AISystem:process(e, dt)
    if e.desires_move then
        if not e.is_rocketeer then
            e:moveTo(e.spawn_platform.x + lume.random(e.spawn_platform.width - 50), e.pos.y)
        else
           -- e:moveTo(e.pos.x, e.pos.y + 10)
        end
    end

    e.target = nil

    -- TODO: optimize by calculating segment coords on init
    for i = 1, self.view_cone_subdivisions do
        local x1, y1, x_offset, y_offset

        if e.dir == 1 then
            x1 = e.pos.x
            y1 = e.pos.y + (e.hitbox.h / (self.view_cone_subdivisions - 1)) * (i - 1)

            x_offset, y_offset = lume.vector(-e.view_cone / 2 + (e.view_cone / (self.view_cone_subdivisions - 1)) * (i - 1), e.view_dist)
        else
            x1 = e.pos.x + e.hitbox.w
            y1 = e.pos.y + (e.hitbox.h / (self.view_cone_subdivisions - 1)) * (i - 1)

            x_offset, y_offset = lume.vector(math.pi + e.view_cone / 2 - (e.view_cone / (self.view_cone_subdivisions - 1)) * (i - 1), e.view_dist)
        end

        local x2 = x1 + x_offset
        local y2 = y1 + y_offset

        local items, len = self.bump_world:querySegment(x1, y1, x2, y2, viewConeFilter)

        if len > 0 then
            if items[1].is_player then
                e.target = items[1]
            end
        end
    end
    
    if e.target then
        if e.is_rocketeer then
            local distance = lume.distance(e.pos.x, e.pos.y, e.target.pos.x, e.target.pos.y)
            if distance >= e.target_distance then
                if e.delay then
                    e.delay:stop()
                    e.delay = nil
                end
                e:moveTo(e.target.pos.x, e.target.pos.y)
            elseif distance < e.escape_distance then
                e.delay = tick.delay(function()
                    if e and e.target then
                        local ang = lume.angle(e.pos.x, e.pos.y, e.target.pos.x + e.target.hitbox.w / 2, e.target.pos.y + e.target.hitbox.h / 2)
                        ang = ang + math.pi
                        e.vel.x, e.vel.y = lume.vector(ang, e.max_speed)
                    end
                end, e.escape_time)
            else
                if e.delay then
                    e.delay:stop()
                    e.delay = nil
                end
                e:stop()
            end
        end
        if not e.stopped and not e.ignores_stop then
            e:stop()
        end

        if e.can_shoot and not e.lock_time then
            e:shoot(self.ecs_world)
        elseif e.lock_time and not e.delay then
            e.delay = tick.delay(function()
                if e and e.target then
                    e:shoot(self.ecs_world)
                end
            end, e.lock_time)
        end
    else
        if e.is_rocketeer then
            e.vel.x, e.vel.y = 0, 0
        end
        if e.lock_time and e.delay then
            e.delay:stop()
            e.delay = nil
        end
        -- if enemy doesn't have move_timer then we know it was manually stopped
        if e.stopped then
            tick.delay(function()
                if not e.target then
                    e.desires_move = true
                end
            end, lume.random(e.max_wait_time))

            e.stopped = false
        end
    end
end

return AISystem