local Map = {}

local STI = require("sti")
local Coin = require("coin")
local Spike = require("spike")
local Stone = require("stone")
local Enemy = require("enemy")
local Player = require("player")


function Map:load()
    self.currentLevel = 1
    World = love.physics.newWorld(0,2000) -- enbales box2d physics for variable World args: (xVelocity, yVelocity)
    World:setCallbacks(beginContact, endContact) -- allows use of begin contact and endcontact callbacks (when player contacts and uncontacts an obj)
    self:init()
end

function Map:init()
    self.level = STI("map/" .. self.currentLevel ..".lua", {"box2d"}) --Tells tile library what lua file to convert and that we will be using box2d physics. self.current allows for level switching
    
    self.level:box2d_init(World) -- loads in the 'colidable' boxes set in Tile. args(world you want them to spawn in ie. 'World')
    self.solidLayer = self.level.layers.solid
    self.groundLayer = self.level.layers.ground
    self.entityLayer = self.level.layers.entity

    self.solidLayer.visible = false --makes the colidable box invisible (otherwise you see large white boxes on tiles)
    self.entityLayer.visible = false --makes the entity layer invisible
    MapWidth = self.groundLayer.width * 16 --removes the ability to see the level past the camera (voids at ends of map) multiplied by pixel tile size, which is 16

    self:spawnEntities()
end

function Map:next()
    self:clean()
    self.currentLevel = self.currentLevel + 1
    self:init()
    Player:resetPosition()
end

function Map:clean()
    self.level:box2d_removeLayer("solid") -- destroys level boundaries. takes 1 arg(index or name of layer you want destroyed)
    Coin.removeAll()
    Enemy.removeAll()
    Stone.removeAll()
    Spike.removeAll()
end

function Map:update()
    if Player.x > MapWidth - 32 then --if player is 32 pixels near the far right end of the map then switch maps
        self:next()
    end
end

function Map:spawnEntities() --spawns entities set in Tile app
    for i,v in ipairs(self.entityLayer.objects) do --loops through table
        if v.type == "spikes" then --checks what type the object is. if spike
            Spike.new(v.x + v.width / 2, v.y + v.height / 2) --spawns spikes at object x and y coords -- since the origin point is in the top left corner we must divide by 2
        elseif v.type == "stone" then --if stone
            Stone.new(v.x + v.width / 2, v.y + v.height / 2)--spawns stone at object x and y coords
        elseif v.type == "enemy" then -- if enemy
            Enemy.new(v.x + v.width / 2, v.y + v.height / 2)--spawns enemy at object x and y coords
        elseif v.type == "coin" then --if coin
            Coin.new(v.x, v.y) --since this is a circle its origin is always in the center so we dont need to divide by 2
        end
    end
end

return Map