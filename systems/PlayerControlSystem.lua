local PlayerControlSystem = tiny.processingSystem(Object:extend())
PlayerControlSystem.filter = tiny.filter("is_player")

function PlayerControlSystem:new(ecs_world)
    self.ecs_world = ecs_world
end

function PlayerControlSystem:process(e, dt)
    --[[MOVEMENT]]--
    e.running = false

    if input:down("left") and not (input:down("right") or e.dead) then
        if e.grounded then
            e.vel.x = math.max(e.vel.x - e.acc * dt, -e.max_speed)

            e.running = true
        else
            if not (e.hit_vertical_surface or e.dashing) then
                e.vel.x = math.max(e.vel.x - e.acc * dt / 2, -e.max_speed)
            end
        end

        e.dir = -1
    end

    if input:down("right") and not (input:down("left") or e.dead) then
        if e.grounded then
            e.vel.x = math.min(e.vel.x + e.acc * dt, e.max_speed)

            e.running = true
        else
            if not (e.hit_vertical_surface or e.dashing) then
                e.vel.x = math.min(e.vel.x + e.acc * dt / 2, e.max_speed)
            end
        end

        e.dir = 1
    end

    if input:pressed("up") and e.grounded and not e.dead then
        e.vel.y = e.vel.y - e.jump_height
        e.sounds.jump:play()
        e.grounded = false
    end

    -- player will jump higher the longer they hold up by increasing gravity when they let go
    if not (input:down("up") or e.grounded) and not e.dead then
        if e.vel.y < 0 then
           e.vel.y = e.vel.y + e.gravity * dt
        end
    end

    -- sliding
    if (((input:down("left") and input:down("right")) or not (input:down("left") or input:down("right"))) and e.grounded) or e.dead then
        local acc = e.acc

        if e.dead then
            acc = acc / 8
        end

        if e.vel.x < 0 then
            e.vel.x = math.min(e.vel.x + acc * dt, 0)
        elseif e.vel.x > 0 then
            e.vel.x = math.max(e.vel.x - acc * dt, 0)
        end
    end

    -- dash
    if e.dead then return end

    if input:pressed("left") or input:pressed("right") then
        local dir = 1

        if input:pressed("left") then
            dir = -1
        end

        if e.can_dash == dir and not e.dashed_in_air then
            e.dashing = true
            e.vel.x = e.dash_speed * e.dir

            e:attack(self.ecs_world, "dash", 1)

            tick.delay(function()
                e.dashing = false
                e.vel.x = 0
            end, e.dash_time)

            -- will be set back to false in Player:update() in the same frame if player is on ground
            e.dashed_in_air = true
        else
            if e.dash_detect_timer then 
                e.dash_detect_timer:stop()
                e.dash_detect_timer = nil
            end

            e.can_dash = dir

            e.dash_detect_timer = tick.delay(function()
                e.can_dash = 0
                e.dash_detect_timer = nil
            end, 0.3)
        end
    end

    --[[ATTACKS]]--
    if input:pressed("light") then
        e:attack(self.ecs_world, "light", 1)
    elseif input:pressed("heavy") then
        e:attack(self.ecs_world, "heavy", 1)
    elseif input:pressed("special") then
        if self.combo == 0 then
            e:attack(self.ecs_world, "special", 1)
        else
            e:attack(self.ecs_world, "special", 2)
        end
    end
end

return PlayerControlSystem