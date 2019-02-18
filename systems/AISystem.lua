local AISystem = tiny.processingSystem(Object:extend())
AISystem.filter = tiny.filter("is_enemy")

function AISystem:new(ecs_world, bump_world, camera)
    self.ecs_world = ecs_world
    self.bump_world = bump_world
    self.camera = camera

    self.view_cone_subdivisions = 10
end

function viewConeFilter(item)
    if item.properties or item.is_player then
        return true
    end
end

function AISystem:process(e, dt)
    if e.stunned then
        return
    end

    -- custom behavior
    if e.think then
        e:think(self.bump_world, dt)
        
        if e.target and e.can_shoot and not e.stunned and e.spotted then
            e:shoot(self.ecs_world)
        end

        return
    end

    if e.desires_move then
        print("no")
        e:moveTo(e.spawn_platform.x + lume.random(e.spawn_platform.width - 50), e.pos.y)
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
                if e.target ~= e.previous_target then
                    e.spotted = false

                    e.delay = tick.delay(function()
                        e.spotted = true
                    end, e.reaction_time)
                end
            end
        end
    end

    e.previous_target = e.target

    if e.target then
        if not e.stopped then
            e:stop()
        end

        if e.can_shoot and e.spotted then
            e:shoot(self.ecs_world)
        end
    else
        e.spotted = false

        if e.delay then
            e.delay:stop()
            e.delay = nil
        end
        -- if enemy doesn't have move_timer then we know it was manually stopped
        if e.stopped then
            tick.delay(function()
                if not e.target then
                    print("THIS WILL NOT HAPPEN")
                    e.desires_move = true
                end
            end, lume.random(e.max_wait_time))

            e.stopped = false
        end
    end
end

return AISystem