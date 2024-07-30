import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

local gfx <const> = playdate.graphics

local GROUND = 198

-- Define the Penguin class
class('Penguin').extends(gfx.sprite)

function Penguin:init(x, y)
    Penguin.super.init(self)
    self:moveTo(x, y)
    self.walkingImageTable = gfx.imagetable.new("images/penguin_walking")
    self.jumpingImageTable = gfx.imagetable.new("images/penguin_jumping")
    self.animation = gfx.animation.loop.new(100, self.walkingImageTable, true)
    self.state = "idle"
    self.lastDirection = "right"
    self.velocityY = 0
    self.gravity = 0.5
    self.jumpStrength = -10
    self:setCollideRect(0, 0, 30, 30)
    self:add()
end

function Penguin:update()
    if self.state == "walk" then
        self:walkUpdate()
    elseif self.state == "jump" then
        self:jumpUpdate()
    else
        self:idleUpdate()
    end
end

function Penguin:walk(direction)
    if self.state ~= "jump" then
        self.state = "walk"
        self.lastDirection = direction
        local moveX = direction == "right" and 2 or -2
        self:moveWithCollisions(self.x + moveX, self.y)
        playdate.timer.performAfterDelay(100, function()
            if self.state == "walk" then
                self.state = "idle"
            end
        end)
    end
end

function Penguin:jump()
    if self.state ~= "jump" then
        local sp = playdate.sound.sampleplayer.new("sounds/jump")
        sp:play()

        self.state = "jump"
        self.velocityY = self.jumpStrength
        self.animation = gfx.animation.loop.new(100, self.jumpingImageTable, true)
    end
end

function Penguin:walkUpdate()
    self:setImage(self.animation:image())
end

function Penguin:jumpUpdate()
    self:setImage(self.jumpingImageTable:getImage(2))
    self:applyGravity()
    local moveX = self.lastDirection == "right" and 2 or -2
    local actualX, actualY, collisions, length = self:moveWithCollisions(self.x + moveX, self.y + self.velocityY)

    if length > 0 then
        for i = 1, length do
            local collision = collisions[i]
            if collision.other:isa(Platform) then
                if self.velocityY > 0 then
                    self.state = "idle"
                    self.velocityY = 0
                    self.y = collision.other.y - self.height / 2
                    self.animation = gfx.animation.loop.new(100, self.walkingImageTable, true)
                end
            end
        end
    end

    if self:isOnGround() then
        self.state = "idle"
        self.velocityY = 0
        self.animation = gfx.animation.loop.new(100, self.walkingImageTable, true)
    end
end

function Penguin:idleUpdate()
    local penguinImage = gfx.image.new("images/penguin_standing")
    self:setImage(penguinImage)
end

function Penguin:applyGravity()
    self.velocityY = self.velocityY + self.gravity
end

function Penguin:isOnGround()
    local _, y = self:getPosition()
    return y >= GROUND
end

-- Define the Coin class
class('Coin').extends(gfx.sprite)

function Coin:init(x, y)
    Coin.super.init(self)
    local coinImage = gfx.image.new("images/coin")
    self:setImage(coinImage)
    self:moveTo(x, y)
    self:add()
end

-- Define the Clock class
class('Clock').extends(gfx.sprite)

function Clock:init(x, y)
    Clock.super.init(self)
    local clockImage = gfx.image.new("images/clock")
    self:setImage(clockImage)
    self:moveTo(x, y)
    self:add()
end

-- Define the Platform class
class('Platform').extends(gfx.sprite)

function Platform:init(x, y)
    Platform.super.init(self)
    local platformImage = gfx.image.new("images/platform")
    self:setImage(platformImage)
    self:setCollideRect(0, 0, self:getImage():getSize())
    self:moveTo(x, y)
    self:add()
end

-- Setup background
local function setupBackground()
    local backgroundImage = gfx.image.new("images/background")
    if backgroundImage ~= nil then
        gfx.sprite.setBackgroundDrawingCallback(
            function(x, y, width, height)
                backgroundImage:draw(0, 0)
            end
        )
    else
        print("Error: Background image could not be loaded.")
    end
end

-- Setup game objects
local function setupGameObjects()
    local penguin = Penguin(20, GROUND)
    local coin = Coin(370, 10)
    local clock = Clock(390, 10)
    local platform = Platform(200, 170)
    return penguin
end

-- Game loop
local function gameLoop(penguin)
    function playdate.update()
        local isJumping = playdate.buttonIsPressed(playdate.kButtonA)
        local isWalkingRight = playdate.buttonIsPressed(playdate.kButtonRight)
        local isWalkingLeft = playdate.buttonIsPressed(playdate.kButtonLeft)

        if isJumping then
            penguin:jump()
        elseif isWalkingRight then
            penguin:walk("right")
        elseif isWalkingLeft then
            penguin:walk("left")
        else
            if penguin.state == "walk" then
                penguin.state = "idle"
            end
        end

        -- Update sprites and timers
        gfx.sprite.update()
        playdate.timer.updateTimers()
    end
end

-- Main function to start the game
local function play()
    local fp = playdate.sound.fileplayer.new("sounds/soundtrack")
    fp:setLoopRange(0, 18)
    fp:play(0)

    setupBackground()
    local penguin = setupGameObjects()
    gameLoop(penguin)
end

play()
