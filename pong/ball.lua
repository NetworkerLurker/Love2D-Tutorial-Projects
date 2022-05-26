

Ball = {}


function Ball:load()
    self.x = love.graphics.getWidth() / 2 --ball start x axis
    self.y = love.graphics.getHeight() / 2 --balls start y axis
    self.img = love.graphics.newImage("assets/ball.png") --sets ball to this img
    self.width = self.img:getWidth() --sets collision width to img
    self.height = self.img:getHeight() --sets collision  height to img
    self.speed = 250 --ball speed, higher = faster
    self.xVel = -self.speed --ball starts going towards the left (player) at game start. remove the negative sign to start going right at start
    self.yVel = 0 --starting speed (ball is still until game starts)

    self.timer = 0  --resets rate keep 0
    self.rate = 0.5 --the lower the value the faster the balls speed will ramp up
    self.maxspeed = 9999 --ball max speed. cant go faster

    self.ballAngle = 8 -- max angle the ball trajectory can take 
    self.speedIncrease = .1 --amount speed increases per second

    self.clock = 0 -- starting clock time
    self.clocktime = 0
    self.clockrate = 0.1 --clock tick time in seconds

    self.bestTime = 0
end

function Ball:update(dt) --happens every frame
    self:move(dt)
    self:collide()
    self:increaseClock(dt)
    self:increaseSpeed()
    self.timer = self.timer + dt
    if self.timer > self.rate then
        self.timer = 0
        
    end
end

function Ball:collide() --collision functions bundled
    self:collideWall()
    self:collidePlayer()
    self:collideAI()
    self:score()
end

function Ball:collideWall() --wall collisions
    if self.y< 0 then
        self.y = 0
        self.yVel = -self.yVel 
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
        self.yVel = -self.yVel --change direction
    end
end

function Ball:collidePlayer()
    if checkCollision(self, Player) then
        self.xVel = self.speed
        local middleBall = self.y + self.height / 2
        local middlePlayer = Player.y + Player.height / 2
        local collisionPosition = middleBall - middlePlayer
        self.yVel = collisionPosition * self.ballAngle                 
    end
end

function Ball:collideAI()
    if checkCollision(self, AI) then
        self.xVel = -self.speed
        local middleBall = self.y + self.height / 2
        local middleAI = AI.y + AI.height / 2
        local collisionPosition = middleBall - middleAI
        self.yVel = collisionPosition * self.ballAngle 
    end
end

function Ball:score()
    if self.x < 0 then 
        self:resetPosition(1)
        Score.ai = Score.ai + 1
    end
    if self.x + self.width > love.graphics.getWidth() then
        self:resetPosition(-1)
        Score.player = Score.player + 1
    end
end

function Ball:resetPosition(modifier)
    if self.clock > self.bestTime then
        self.bestTime = self.clock 
    end
    self.x = love.graphics.getWidth() / 2 - self.width / 2
        self.y = love.graphics.getHeight() / 2 - self.height / 2
        self.yVel = 0
        self.speed = 250
        self.xVel = self.speed * modifier
        self.clock = 0
       
end

function Ball:increaseSpeed()
    if self.speed < self.maxspeed then
        self.speed = self.speed + self.speedIncrease --increase to ramp up speed faster
    end
end

function Ball:increaseClock(dt)
    self.clocktime = self.clocktime + dt 
    if self.clocktime > self.clockrate then
        self.clocktime = 0
        self.clock = self.clock + 0.1
    end
end

function Ball:move(dt)
    self.x = self.x + self.xVel * dt
    self.y = self.y + self.yVel * dt
end

function Ball:draw()
    love.graphics.setFont(font)
    love.graphics.print("Time: ".. self.clock, 500, 50)
    love.graphics.print("Best Time: ".. self.bestTime, 750, 50)
    love.graphics.draw(self.img, self.x, self.y)
end