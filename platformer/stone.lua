

local Stone = {img = love.graphics.newImage("assets/stone.png")} --table
Stone.__index = Stone --index points to self
local ActiveStones = {}
Stone.width = Stone.img:getWidth() --dimensions --declared after table in order to reach image
Stone.height = Stone.img:getHeight() --dimensions

function Stone.new(x,y) --handles making new coins and position (x,y)
    local instance = setmetatable({}, Stone) --make stone meta table
    instance.x = x
    instance.y =y
    instance.r = 0 --will be used to allow rotation of stone in syncPhysics() function
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic") --gives stone a physical body that can move
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height) --sets the shape of the body
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape) -- combines shape and body
    instance.physics.body:setMass(25) --1 arg, makes the stone mass higher, thus gravity will have a bigger effect on it, will seem heavier
    table.insert(ActiveStones, instance) --allows you to insert elements into a table 2args(table to insert into, what you want to insert)
end

function Stone.removeAll()
    for i, v in ipairs(ActiveStones) do --loops through all active stones
        v.physics.body:destroy() -- destorys current active stones  
    end

    ActiveStones = {} --clears out table by setting it to a new empty one
end

function Stone:update(dt)
    self:syncPhysics()
end

function Stone:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle() --gets the angle of the stone and sets the stones rotation to it. (allows stone to rotate in game)
end

function Stone:draw()
    love.graphics.draw(self.img, self.x, self.y, self.r, self.scaleX, 1, self.width /2, self.height /2) --draw stone with origin point at center (self.r allows stone draw to rotate)
end

function Stone:updateAll(dt)
    for i, instance in ipairs(ActiveStones) do --loops until nil value is found
        instance:update()
    end
end

function Stone.drawAll() --draws coins in active stone table
    for i,instance in ipairs(ActiveStones) do
        instance:draw()
    end
end

return Stone