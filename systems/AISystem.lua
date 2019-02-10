local AISystem = tiny.processingSystem(Object:extend())
AISystem.filter = tiny.filter("is_enemy")

function AISystem:new(ecs_world)
    self.ecs_world = ecs_world
end

function AISystem:process(e, dt)
    if e.desires_move then
        e:moveTo(e.spawn_platform.x + lume.random(e.spawn_platform.width - 50), e.pos.y, true)
    end

    e.target = nil

    -- we shouldnt be looping each frame
    if not e.target then
        for k, v in pairs(self.ecs_world.entities) do
            if tostring(v) == "Object" then
                if v.is_player then
                    if lume.distance(e.pos.x, e.pos.y, v.pos.x, v.pos.y) <= 512 then
                        local ang = lume.angle(e.pos.x, e.pos.y, v.pos.x, v.pos.y)
                        
                        if e.dir == 1 then
                            if ang > -e.view_cone / 2 and ang < e.view_cone / 2 then
                                e.target = v
                            end
                        else
                            -- this is so wack
                            if (ang < -math.pi + e.view_cone / 2 and ang > -math.pi) or (ang < math.pi and ang > math.pi - e.view_cone / 2) then
                                e.target = v
                            end
                        end
                    end
                end
            end
        end
    end

    if e.target then
        e:stop()

        if e.can_shoot then
            e:shoot(self.ecs_world)
        end
    else
        -- if enemy doesn't have move_timer then we know it was manually stopped
        if e.stopped then
            tick.delay(function()
                e.desires_move = true
            end, lume.random(e.max_wait_time))

            e.stopped = false
        end
    end
end

return AISystem