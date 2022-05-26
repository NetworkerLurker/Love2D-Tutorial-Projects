

local Spike = {img = love.graphics.newImage("assets/spikes.png")} --table
Spike.__index = Spike --index points to self
local ActiveSpikes = {}
local Player = require("player")
Spike.width = Spike.img:getWidth() --dimensions --declared after table in order to reach image
Spike.height = Spike.img:getHeight() --dimensions

function Spike.new(x,y) --handles making new coins and position (x,y)
    local instance = setmetatable({}, Spike) --make spike meta table
    instance.x = x
    instance.y =y

    instance.damage = 1 --spike damage amount
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static") --gives spike a physical body
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height) --sets the shape of the body
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape) -- combines shape and body
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveSpikes, instance) --allows you to insert elements into a table 2args(table to insert into, what you want to insert)
end

function Spike.removeAll()
    for i, v in ipairs(ActiveSpikes) do --loops through all active spikes
        v.physics.body:destroy() -- destorys current active spikes  
    end

    ActiveSpikes = {} --clears out table by setting it to a new empty one
end

function Spike:update(dt)

end

function Spike:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width /2, self.height /2) --draw spike with origin point at center
end

function Spike:updateAll(dt)
    for i, instance in ipairs(ActiveSpikes) do --loops until nil value is found
        instance:update()
    end
end

function Spike.drawAll() --draws coins in active spike table
    for i,instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end

function Spike.beginContact(a, b, collision) --makes spike dissapear and prevents player being set to landed when hitting a spike
    for i, instance in ipairs(ActiveSpikes) do --loops through each spike in ActiveSpikes
        if a == instance.physics.fixture or b == instance.physics.fixture then --check if a or b is a spike
            if a == Player.physics.fixture or b == Player.physics.fixture then --check if a or b is the player
                Player:takeDamage(instance.damage) -- used to damage the player based on spikes set damage
                return true
            end
        end
    end
end

return Spike