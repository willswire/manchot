import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

local gfx = playdate.graphics

local penguin = gfx.sprite.new()
local clock = gfx.sprite.new()
local coin = gfx.sprite.new()

local states = {idle = 1, run = 2}
local state = states.idle

local function setupGame()
    -- Setup background
    local backgroundImage = gfx.image.new("img/background")
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            backgroundImage:draw(0, 0)
        end
    )

    -- Setup penguin
    penguin:moveTo(20, 215)
    penguin.imagetable = gfx.imagetable.new("img/penguin")
    penguin.animation = gfx.animation.loop.new(100, penguin.imagetable, true)
    penguin:add()

    -- Setup coin
    local coinImage = gfx.image.new("img/coin")
    coin:setImage(coinImage)
    coin:moveTo(370, 10)
    coin:add()

    -- Setup clock
    local clockImage = gfx.image.new("img/clock")
    clock:setImage(clockImage)
    clock:moveTo(390, 10)
    clock:add()
end

function penguin:update()
    if state == states.run then
        self:setImage(self.animation:image())
    else
        local penguinImage = gfx.image.new("img/penguin")
        self:setImage(penguinImage)
    end
end

setupGame()

function playdate.update()
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        penguin:moveBy(2, 0)
        state = states.run
    end
    
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        penguin:moveBy(-2, 0)
        state = states.run
    end

    -- Update sprites and timers
    gfx.sprite.update()
    playdate.timer.updateTimers()
    state = states.idle
end
