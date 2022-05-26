

local Coin = {img = love.graphics.newImage("assets/coin.png")} --table
Coin.__index = Coin --index points to self
local ActiveCoins = {}
local Player = require("player")
Coin.width = Coin.img:getWidth() --dimensions--declared after table in order to reach image
Coin.height = Coin.img:getHeight() --dimensions

function Coin.new(x,y) --handles making new coins and position (x,y)
    local instance = setmetatable({}, Coin) --make coin meta table
    instance.x = x
    instance.y =y
    
    instance.scaleX =1 --used to manipulate scale to make coins appear to spin
    instance.spinSpeed = 2 --speed the coins spin at
    instance.randomTimeOffset = math.random(0, 0) --used to desync coin spins (so they dont all spin exactly the same)
    instance.toBeRemoved = false --used in function to check to see if coin should be removed

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static") --gives coin a physical body
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height) --sets the shape of the body
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape) -- combines shape and body
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveCoins, instance) --allows you to insert elements into a table 2args(table to insert into, what you want to insert)
end

function Coin:remove() --removes coins when touched
    for i, instance in ipairs(ActiveCoins) do --loops through all coins
        if instance == self then --sees if current instance is = self (coin that called the function) then
            Player:incrementCoins()
            print(Player.coins)
            self.physics.body:destroy() --destroys the physical coin
            table.remove(ActiveCoins, i) --removes the coin from the ActiveCoins table
        end
    end
end

function Coin.removeAll()
    for i, v in ipairs(ActiveCoins) do --loops through all active coins
        v.physics.body:destroy() -- destorys current active coin  
    end

    ActiveCoins = {} --clears out table by setting it to a new empty one
end

function Coin:update(dt)
    self:spin(dt)
    self:checkRemove()
end

function Coin:checkRemove()
    if self.toBeRemoved then --if toBeRemoved = true then
        self:remove() --calls remove coin function
    end
end

function Coin:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * self.spinSpeed + self.randomTimeOffset) --goes between -1 and 1 in a sin wave
end

function Coin:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width /2, self.height /2) --draw coin with origin point at center
end

function Coin:updateAll(dt)
    for i, instance in ipairs(ActiveCoins) do --loops until nil value is found
        instance:update()
    end
end

function Coin.drawAll() --draws coins in active coin table
    for i,instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end

function Coin.beginContact(a, b, collision) --makes coin dissapear and prevents player being set to landed when hitting a coin
    for i, instance in ipairs(ActiveCoins) do --loops through each coin in ActiveCoins
        if a == instance.physics.fixture or b == instance.physics.fixture then --check if a or b is a coin
            if a == Player.physics.fixture or b == Player.physics.fixture then --check if a or b is the player
                instance.toBeRemoved = true -- used in checkRemove function to remove coins after touching
                return true
            end
        end
    end
end

return Coin