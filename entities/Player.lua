local Player = Object:extend()

function Player:new(x, y)
    self.offset = {x = 40, y = 0}
    self.hitbox = {w = 45, h = 160}

    self.pos = {x = x, y = y - self.hitbox.h}

    self.max_speed = 500
    self.vel = {x = 0, y = 0}
    self.acc = 3000
    self.gravity = 3000
    self.jump_height = 1350
    self.bounciness = 0.5
    self.dir = 1

    self.running = false
    self.grounded = false
    self.hit_vertical_surface = false
    
    self.can_dash = 0
    self.dashing = false
    self.dashed_in_air = false
    self.dash_speed = 2400
    self.dash_time = 0.15
    self.dash_detect_timer = nil

    self.health = 100
    self.invincible = false
    self.invincible_time = 1.5
    self.opacity = 1
    self.flash_timer = nil
    self.dead = false

    self.sprite = true
    self.is_player = true

    game.points = game.points or 0

    self.can_attack = true
    self.combo = 0
    self.combo_time = 0
    self.combo_max_time = 0.65
    self.laser_charge_time = 0
    self.attacks = {
        light = {
            {
                offset = {x = 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.1,
                cooldown = 0.05,
                dmg = 10
            },
            {
                offset = {x = 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.1,
                cooldown = 0.05,
                dmg = 10
            },
            {
                offset = {x = 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.1,
                cooldown = 0.05,
                dmg = 15
            },
            {
                offset = {x = 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.1,
                cooldown = 0.25,
                dmg = 20
            }
        },
        heavy = {
            used = false,
            {
                offset = {x = 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.15,
                cooldown = 0.05,
                dmg = 20
            },
            {
                offset = {x = 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.15,
                cooldown = 0.05,
                dmg = 20
            },
            {
                offset = {x = 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.15,
                cooldown = 0.05,
                dmg = 25
            },
            {
                offset = {x = 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.15,
                cooldown = 0.25,
                dmg = 30
            }
        },
        special = {
            {
                offset = {x = self.hitbox.w + 40, y = 0},
                hitbox = {w = self.hitbox.w + 80, h = self.hitbox.h},
                duration = 0.10,
                cooldown = 0.25,
                dmg = 40
            },
            {
                offset = {x = self.hitbox.w / 2 + 34, y = -22},
                duration = 0.25,
                cooldown = 0.25,
                dmg = 40
            }
        },
        dash = {
            {
                offset = {x = 0, y = 0},
                hitbox = {w = self.hitbox.w, h = self.hitbox.h},
                duration = self.dash_time,
                cooldown = 0,
                dmg = 10
            }
        }
    }

    self.anims = {
        scale = 1,
        idle = {
            anim = animator.newAnimation({
                assets.player.idle[1]
            }, 1 / 1),
            offset = {x = 40, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        run = {
            anim = animator.newAnimation({
                assets.player.run[1],
                assets.player.run[2],
                assets.player.run[3],
                assets.player.run[4],
                assets.player.run[5],
                assets.player.run[6]
            }, 1 / 12),
            offset = {x = 12, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        jump = {
            anim = animator.newAnimation({
                assets.player.jump[1]
            }, 1 / 1),
            offset = {x = 12, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        death = {
            anim = animator.newAnimation({
                assets.player.death[1]
            }, 1 / 1),
            offset = {x = 40, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        light1 = {
            anim = animator.newAnimation({
                assets.player.attack.light[1][1],
                assets.player.attack.light[1][2]
            }, 0.15 / 2),
            offset = {x = 40, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        light2 = {
            anim = animator.newAnimation({
                assets.player.attack.light[2][1],
                assets.player.attack.light[2][2]
            }, 0.15 / 2),
            offset = {x = 40, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        light3 = {
            anim = animator.newAnimation({
                assets.player.attack.light[3][1],
                assets.player.attack.light[3][2]
            }, 0.15 / 2),
            offset = {x = 53, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        light4 = {
            anim = animator.newAnimation({
                assets.player.attack.light[4][1],
                assets.player.attack.light[4][2]
            }, 0.15 / 2),
            offset = {x = 53, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        heavy1 = {
            anim = animator.newAnimation({
                assets.player.attack.heavy[1][1],
                assets.player.attack.heavy[1][2],
                assets.player.attack.heavy[1][3]
            }, 0.2 / 3),
            offset = {x = 40, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        heavy2 = {
            anim = animator.newAnimation({
                assets.player.attack.heavy[2][1],
                assets.player.attack.heavy[2][2],
                assets.player.attack.heavy[2][3]
            }, 0.2 / 3),
            offset = {x = 40, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        heavy3 = {
            anim = animator.newAnimation({
                assets.player.attack.heavy[3][1],
                assets.player.attack.heavy[3][2],
                assets.player.attack.heavy[3][3]
            }, 0.2 / 3),
            offset = {x = 53, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        heavy4 = {
            anim = animator.newAnimation({
                assets.player.attack.heavy[4][1],
                assets.player.attack.heavy[4][2],
                assets.player.attack.heavy[4][3]
            }, 0.2 / 3),
            offset = {x = 53, y = 0},
            draw_offset = {x = 0, y = 0}
        },
        special = {
            anim = animator.newAnimation({
                assets.player.attack.special[1],
                assets.player.attack.special[2]
            }, 1 / 1),
            offset = {x = 61, y = 0},
            draw_offset = {x = 0, y = 0}
        }
    }
    self.anims.idle.anim:setLooping(true)
    self.anims.run.anim:setLooping(true)
    self.anims.jump.anim:setLooping(true)
    self.anims.death.anim:setLooping(true)

    self.anims.light1.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.light2.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.light3.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.light4.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)

    self.anims.heavy1.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.heavy2.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.heavy3.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.heavy4.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)

    self.anims.special.anim:setOnAnimationEnd(function()
        self:changeAnim("idle")
    end)
    self.anims.cur = self.anims.idle

    -- TODO: land sound
    self.sounds = {
        dash = ripple.newSound(assets.sounds.player.dash, {volume = 1}),
        emp = ripple.newSound(assets.sounds.player.emp, {volume = 1}),
        enemy_hit = ripple.newSound(assets.sounds.player.jump, {volume = 1}),
        footstep1 = ripple.newSound(assets.sounds.player.footstep1, {volume = 0.15}),
        footstep2 = ripple.newSound(assets.sounds.player.footstep2, {volume = 0.15}),
        heavy_attack = ripple.newSound(assets.sounds.player.heavy_attack, {volume = 1}),
        heavy_finisher = ripple.newSound(assets.sounds.player.heavy_finisher, {volume = 0.9}),
        jump = ripple.newSound(assets.sounds.player.jump, {volume = 1}),
        land = ripple.newSound(assets.sounds.player.land, {volume = 1}),
        laser_blast = ripple.newSound(assets.sounds.player.laser_blast, {volume = 0.9}),
        laser_charge = ripple.newSound(assets.sounds.player.laser_charge, {volume = 0.7}),
        light_attack = ripple.newSound(assets.sounds.player.light_attack, {volume = 0.3}),
        light_finisher = ripple.newSound(assets.sounds.player.light_finisher, {volume = 0.5}),
        player_death = ripple.newSound(assets.sounds.player.player_death, {volume = 1}),
        player_hit = ripple.newSound(assets.sounds.player.player_hit, {volume = 0.5}),
    }

    self.footstep1_played = false
    self.footstep2_played = false
    self.laser_charge_played = false
end

function Player:update(dt)
    self.combo_time = self.combo_time + dt

    if self.combo_time >= self.combo_max_time then
        self.combo = 0
        self.combo_time = 0
        
        self.attacks.heavy.used = false
    end

    if self.health > 0 and self.can_attack and self.laser_charge_time == 0 then
        if not self.grounded and not self.dashing then
            self:changeAnim("jump")

            --[[if math.abs(self.vel.y) < self.jump_height / 4 then
                self.anims.cur.anim:setCurrentFrame(2)
            elseif self.vel.y <= 0 then
                self.anims.cur.anim:setCurrentFrame(1)
            else
                self.anims.cur,anim:setCurrentFrame(3)
            end]]--
        elseif self.running and not self.hit_vertical_surface or self.dashing then
            self:changeAnim("run")
            if self.anims.cur.anim:getCurrentFrame() == 1 then
                if not self.footstep1_played then
                    self.sounds.footstep1:play()
                    self.footstep1_played = true
                    self.footstep2_played = false
                end
            elseif self.anims.cur.anim:getCurrentFrame() == 4 then
                if not self.footstep2_played then
                    self.sounds.footstep2:play()
                    self.footstep2_played = true
                    self.footstep1_played = false
                end
            end
        else
            self:changeAnim("idle")
        end
    end

    if not self.anims.cur then
        self.anims.cur = self.anims.idle
    end

    self.anims.cur.anim:update(dt)

    if self.grounded then
        self.dashed_in_air = false
    end

    self.grounded = false
    self.hit_vertical_surface = false
end

function Player:draw()
    --love.graphics.rectangle("line", self.pos.x, self.pos.y, self.hitbox.w, self.hitbox.h)
end

function Player:filter(e)
    -- we know for sure it is a map tile if it has `properties`
    if e.properties then
        if e.properties.collidable then
            -- pass through if player hasn't reached top of tile
            if e.y >= self.pos.y + self.hitbox.h then
                return "slide"
            end
        end
    elseif e.is_bound then
        if self.health <= 0 then
            return "bounce"
        else
            return "slide"
        end
    end
end

function Player:onCollide(cols, len)
    for i = 1, len do
        local e = cols[i]

        if e.type == "bounce" then
            self:bounce(e.normal.x, e.normal.y)

            return
        end

        if e.normal.x == 0 then
            self.vel.y = 0

            if e.normal.y < 0 then
                self.grounded = true
            end
        else
            -- stop horizontal motion if hit vertical surface
            self.vel.x = 0
            self.hit_vertical_surface = true  
        end
    end
end

function Player:onDeath()
    if not self.dead then
        self.dead = true
        game.points = math.max(game.points - 5000, 0)
        self.sounds.player_death:play()

        if self.flash_timer then
            self.flash_timer:stop()
            self.flash_timer = nil
        end

        self:changeAnim("death")
    end
end

function Player:changeAnim(anim)
    if self.anims.cur == self.anims[anim] then return end

    self.offset = self.anims[anim].offset

    self.anims.cur = self.anims[anim]
    self.anims.cur.anim:restart()
end

function Player:takeDamage(dmg, bypass)
    if (self.dashing and not bypass) or self.invincible or self.dead then return end

    self.health = math.max(self.health - dmg, 0)
    game.points = math.max(game.points - dmg * 100, 0)
    self.sounds.player_hit:play()

    self:setInvincible(self.invincible_time)
end

function Player:setInvincible(time)
    self.invincible = true

    self.flash_timer = tick.recur(function()
        if self.opacity == 1 then
            self.opacity = 0
        else
            self.opacity = 1
        end
    end, 0.1)

    tick.delay(function()
        self.invincible = false

        if self.flash_timer then
            self.flash_timer:stop()
            self.flash_timer = nil
        end

        self.opacity = 1
    end, time)
end

function Player:bounce(nx, ny)
    if (nx < 0 and self.vel.x > 0) or (nx > 0 and self.vel.x < 0) then
        self.vel.x = -self.vel.x * self.bounciness
    end

    if (ny < 0 and self.vel.y > 0) or (self.vel.y > 0 and self.vel.y < 0) then
        self.vel.y = -self.vel.y * self.bounciness
    end
end

function Player:attack(ecs_world, type, num)
    if not self.can_attack then return end
    if type == "light" and self.attacks.heavy.used then return end

    local attack = self.attacks[type][num]

    self.combo_time = 0
    self.can_attack = false
    if type == "heavy" then
        self.attacks.heavy.used = true
    elseif type == "special" then
        self.attacks.heavy.used = false
    end
    
    if type == "special" and num == 2 then
        ecs_world:add(LaserAttack(attack.offset.x, attack.offset.y, attack.duration, self.laser_charge_time, self))
    else
        if type == "special" and num == 1 then
            ecs_world:add(Attack(attack.offset.x, attack.offset.y, attack.hitbox.w, attack.hitbox.h, attack.duration, attack.dmg * ((self.combo + 1) / 4), self))
        else
            ecs_world:add(Attack(attack.offset.x, attack.offset.y, attack.hitbox.w, attack.hitbox.h, attack.duration, attack.dmg, self))
        end
    end

    tick.delay(function() 
        self.can_attack = true
    end, attack.duration + attack.cooldown)

    if type == "light" then
        self:changeAnim("light" .. tostring(num))
    elseif type == "heavy" then
        self:changeAnim("heavy" .. tostring(num))
    elseif type == "special" then
        self:changeAnim("special")
        self.anims.cur.anim:setCurrentFrame(num)
    end

    return true
end

return Player