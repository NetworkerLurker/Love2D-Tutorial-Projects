AI = {}

function AI:load()
    self.img = love.graphics.newImage("assets/2.png") -- AI image
    self.width = self.img:getWidth()  --sets collision to img width
    self.height = self.img:getHeight() --sets ai paddle collision to img height
    self.x = love.graphics.getWidth() - self.width - 50 --sets x position on screen
    self.y = love.graphics.getHeight() / 2 --sets y position on screen
    self.yVel = 0 --ai speed at start (this means AI will be still until the ball moves)
    self.speed = 2000 -- ai move speed

    self.timer = 0  --self created ai lag
    self.rate = 0 --the lower the value the lower the lag (harder to win)

end

function AI:update(dt)
    self:move(dt)
    self.timer = self.timer + dt
    if self.timer > self.rate then
        self.timer = 0
        self:acquireTarget()
    end
end

function AI:move(dt)
    self.y = self.y + self.yVel * dt
end

function AI:acquireTarget()
    if Ball.y + Ball.height < self.y then
        self.yVel = -self.speed
    elseif Ball.y > self.y + self.height then
        self.yVel = self.speed
    else
        self.yVel = 0
    end
end

function AI:draw()
    love.graphics.draw(self.img, self.x, self.y)
end