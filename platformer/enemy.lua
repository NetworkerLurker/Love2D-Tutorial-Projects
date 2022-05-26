

local Enemy = {} --table
Enemy.__index = Enemy --index points to self
local Player = require("player") --since enemy will be able to damage player

local ActiveEnemies = {}

function Enemy.new(x,y) --handles making new coins and position (x,y)
    local instance = setmetatable({}, Enemy) --make enemy meta table
    instance.x = x
    instance.y =y
    instance.offsetY = -8 --used to offset enemy upwards so it doesnt appear to be inside the ground
    instance.r = 0 --will be used to allow rotation of enemy in syncPhysics() function

    instance.speed = 100 --enemies movement speed
    instance.speedMod = 1
    instance.xVel = instance.speed

    instance.rageCounter = 0
    instance.rageTrigger = 3

    instance.damage = 1 --enemy dmg to player on collision

    instance.state = "walk"

    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.run = {total = 4, current = 1, img = Enemy.runAnim}
    instance.animation.walk = {total = 4, current = 1, img = Enemy.walkAnim}
    instance.animation.draw = instance.animation.walk.img[1]
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic") --gives enemy a physical body that can move
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width * 0.4, instance.height * 0.75) --sets the shape of the body (.4 and .75 are used to reduce the shape since there is white space around the enemy in the png)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape) -- combines shape and body
    instance.physics.body:setMass(25) --1 arg, makes the enemy mass higher, thus gravity will have a bigger effect on it, will seem heavier
    table.insert(ActiveEnemies, instance) --allows you to insert elements into a table 2args(table to insert into, what you want to insert)
end

function Enemy.loadAssets() -- use dot not colon since we want to store assets in parent table "enemy" and not in each instance
    Enemy.runAnim = {}
    for i=1,4 do --loops through frames (there are 4 total for this enemy)
        Enemy.runAnim[i] = love.graphics.newImage("assets/enemy/run/"..i..".png")
    end

    Enemy.walkAnim = {}
    for i=1,4 do
        Enemy.walkAnim[i] = love.graphics.newImage("assets/enemy/walk/"..i..".png")
    end

    Enemy.width = Enemy.runAnim[1]:getWidth()
    Enemy.height = Enemy.runAnim[1]:getHeight()
end

function Enemy.removeAll()
    for i, v in ipairs(ActiveEnemies) do --loops through all active enemies
        v.physics.body:destroy() -- destorys current active enemies  
    end

    ActiveEnemies = {} --clears out table by setting it to a new empty one
end

function Enemy:update(dt)
    self:syncPhysics()
    self:animate(dt)
end

function Enemy:incrementRage()
    self.rageCounter = self.rageCounter + 1
    if self.rageCounter > self.rageTrigger then
        self.state = "run"
        self.speedMod = 3
        self.rageCounter = 0
    else
        self.state = "walk"
        self.speedMod = 1
    end
end

function Enemy:flipDirection()
    self.xVel = -self.xVel
end

function Enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt --increments timer by dt
    if self.animation.timer > self.animation.rate then --check if timer is greather than the rate
        self.animation.timer = 0 --if timer is greater than rate set time back to 0
        self:setNewFrame()
    end
end

function Enemy:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Enemy:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel * self.speedMod, 100) -- moves enmey
end

function Enemy:draw()
    local scaleX = 1
    if self.xVel < 0 then
        scaleX = -1
    end
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r, scaleX, 1, self.width /2, self.height /2) --draw enemy with origin point at center (self.r allows enemy draw to rotate)
end

function Enemy.updateAll(dt)
    for i, instance in ipairs(ActiveEnemies) do --loops until nil value is found
        instance:update(dt)
    end
end

function Enemy.drawAll() --draws coins in active enemy table
    for i,instance in ipairs(ActiveEnemies) do
        instance:draw()
    end
end

function Enemy.beginContact(a, b, collision) --makes enemy dissapear and prevents player being set to landed when hitting a enemy
    for i, instance in ipairs(ActiveEnemies) do --loops through each enemy in ActiveEnemies
        if a == instance.physics.fixture or b == instance.physics.fixture then --check if a or b is a enemy
            if a == Player.physics.fixture or b == Player.physics.fixture then --check if a or b is the player
                Player:takeDamage(instance.damage) -- used to damage the player based on enemies set damage
            end
            instance:incrementRage()
            instance:flipDirection() --flips enemy direction whe nit collides with wall or player
        end
    end
end

return Enemy