local PlayerControlSystem = tiny.processingSystem(Object:extend())
PlayerControlSystem.filter = tiny.filter("is_player")

function PlayerControlSystem:new(ecs_world, camera)
    self.ecs_world = ecs_world
    self.camera = camera
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
            e.sounds.dash:play()
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
        if e:attack(self.ecs_world, "light", e.combo + 1) then
            if e.combo < 3 then
                e.combo = e.combo + 1

                e.sounds.light_attack:play()
            else
                e.combo = 0
                e.attacks.heavy.used = false

                e.sounds.light_finisher:play()
            end
        end
    elseif input:pressed("heavy") then
        if e:attack(self.ecs_world, "heavy", e.combo + 1) then
            if e.combo < 3 then
                e.combo = e.combo + 1
                e.attacks.heavy.used = true

                e.sounds.heavy_attack:play()
            else
                e.combo = 0
                e.attacks.heavy.used = false

                e.sounds.heavy_finisher:play()
            end 
        end
    elseif input:pressed("special") then
        if e.combo ~= 0 then
            if e:attack(self.ecs_world, "special", 1) then
                e.combo = 0
                e.sounds.emp:play()
                self.camera:shake(15, 0.25, 144)
            end
        else
            if e.grounded and not e.running and e.can_attack then
                e.laser_charge_time = e.laser_charge_time + dt
            end
        end
    elseif input:down("special") then
        if e.grounded and not e.running and e.can_attack and e.laser_charge_time > 0 then
            e.laser_charge_time = math.min(e.laser_charge_time + dt, 4)
            if not e.laser_charge_played then
                e.sounds.laser_charge:play()
                e.laser_charge_played = true
            end

            if e.laser_charge_time == 4 then
                self.camera:shake(e.laser_charge_time * 10, 1, 144)
                e:attack(self.ecs_world, "special", 2)
                e.laser_charge_time = 0
                e.laser_charge_played = false
                e.sounds.laser_charge:stop()
                e.sounds.laser_blast:play()
            end

            e:changeAnim("special")
            e.anims.cur.anim:setCurrentFrame(2)
        else
            e.laser_charge_time = 0
        end
    elseif input:released("special") then
        if e.laser_charge_time > 0 then
            self.camera:shake(e.laser_charge_time * 10, 1, 144)
            e:attack(self.ecs_world, "special", 2)
            e.laser_charge_time = 0

            e.laser_charge_played = false
            e.sounds.laser_charge:stop()
            e.sounds.laser_blast:play()
        end
    end

    if e.laser_charge_time == 0 then
        e.sounds.laser_charge:stop()
    end
end

return PlayerControlSystem