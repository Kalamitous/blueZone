
local game = {
    map = nil,
    camera = Camera(),
    bumpWorld = bump.newWorld()
}
game.world = tiny.world(
    PhysicsSystem(game.bumpWorld),
    PlayerControlSystem,
    SpriteSystem,
    CameraTrackingSystem(game.camera),
    HUDSystem,
    ProjectileSystem
)
game.world:add(AISystem(game.world))
game.camera:setFollowLerp(0.2)
game.camera:setFollowStyle('LOCKON')

local updateFilter = tiny.filter("!isDrawSystem")
local drawFilter = tiny.filter("isDrawSystem&!isCameraBased")
local cameraDrawFilter = tiny.filter("isDrawSystem&isCameraBased")

function game:init()
    self.world:add(
        Player(0, 300), 
        Enemy(300, 275)
    )
    self:stage("assets/maps/test.lua")
end

function game:stage(file)
    self.map = sti(file, {"bump"})
    self.map:bump_init(game.bumpWorld)
end

function game:update(dt)
    self.camera:update(dt)
    self.map:update(dt)
    self.world:update(dt, updateFilter)

    if input:down("pause") then
        Gamestate.switch(pause)
    end
end

function game:draw()
    -- sti resets draw to origin
    -- clean this up later
    self.map:draw(-self.camera.x + love.graphics.getWidth() / 2, -self.camera.y + love.graphics.getHeight() / 2, self.camera.scale, self.camera.scale)
    --self.map:bump_draw(self.bumpWorld, -self.camera.x + love.graphics.getWidth() / 2, -self.camera.y + love.graphics.getHeight() / 2, self.camera.scale, self.camera.scale)
    
    self.world:update(dt, drawFilter)

    self.camera:attach()
        self.world:update(dt, cameraDrawFilter)
    self.camera:detach()
end

return game
