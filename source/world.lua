-- Define the Penguin class
class('World').extends(playdate.graphics.sprite)

-- World class initializer
function World:init(x, y)
    World.super.init(self)

    -- Background image
    local backgroundImage = playdate.graphics.image.new("images/background")
    if backgroundImage ~= nil then
        playdate.graphics.sprite.setBackgroundDrawingCallback(
            function(x, y, width, height)
                backgroundImage:draw(0, 0)
            end
        )
    else
        print("Error: Background image could not be loaded.")
    end

    -- Background music
    local fp = playdate.sound.fileplayer.new("sounds/soundtrack")
    fp:setLoopRange(0, 18)
    fp:play(0)
end

-- Create the World
function World:create()
    self = World(0, 0)
end
