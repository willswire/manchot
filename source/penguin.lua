-- Define the Penguin class
class('Penguin').extends(playdate.graphics.sprite)

function Penguin:init(x, y)
    Penguin.super.init(self)

    self:moveTo(x, y)

    self.states = {
        idle = 'idle',
        walking = 'walking',
        jumping = 'jumping'
    }
    self.currentState = self.states.idle
    self.isJumping = false
    self.walkSpeed = 2
    self.jumpSpeed = 5
    self.gravity = 0.5
    self.velocityY = 0

    local penguin_standing_image = playdate.graphics.image.new("images/penguin_standing")
    self:setImage(penguin_standing_image)

    self:add()
end

function Penguin:update()
    Penguin.super.update(self)

    local isMoving = false

    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        self:moveBy(-self.walkSpeed, 0)
        self.currentState = self.states.walking
        isMoving = true
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        self:moveBy(self.walkSpeed, 0)
        self.currentState = self.states.walking
        isMoving = true
    end

    if playdate.buttonJustPressed(playdate.kButtonA) and not self.isJumping then
        self.isJumping = true
        self.velocityY = -self.jumpSpeed
        self.currentState = self.states.jumping
    end

    if self.isJumping then
        self:updateJump()
    elseif not isMoving then
        self.currentState = self.states.idle
    end

    self:updateImageByState()
end

function Penguin:updateJump()
    self.velocityY = self.velocityY + self.gravity
    self:moveBy(0, self.velocityY)

    if self.y > 200 then
        self.y = 200
        self.isJumping = false
        self.velocityY = 0
        self.currentState = self.states.idle
    end
end

function Penguin:updateImageByState()
    if self.currentState == self.states.walking then
        local penguin_walking_image = playdate.graphics.image.new("images/penguin_standing")
        self:setImage(penguin_walking_image)
    elseif self.currentState == self.states.jumping then
        local penguin_jumping_image = playdate.graphics.image.new("images/penguin_standing")
        self:setImage(penguin_jumping_image)
    else
        local penguin_standing_image = playdate.graphics.image.new("images/penguin_standing")
        self:setImage(penguin_standing_image)
    end
end

function Penguin:create()
    self = Penguin(50, 200)
end
