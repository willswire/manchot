-- Common CoreLibs imports.
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

-- Project imports
import "world"
import "penguin"

-- Initial setup
World:create()
Penguin:create()

--- This update method is called once per frame.
---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
    playdate.graphics.sprite.update()
    playdate.timer.updateTimers()
end
