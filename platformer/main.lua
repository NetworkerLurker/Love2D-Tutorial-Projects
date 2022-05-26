love.graphics.setDefaultFilter("nearest", "nearest")
local Player = require("player")
local Coin = require("coin")
local GUI = require("gui") --"local GUI =" is required since GUI was declared as a local inside its file. See GUI for comments on how to make locals
local Spike = require("spike")
local Stone = require("stone")
local Camera = require("camera")
local Enemy = require("enemy")
local Map = require("map")

function love.load()
    Enemy.loadAssets()
    Map:load()
    background = love.graphics.newImage("assets/background.png") -- sets background arg(img file path)
    GUI:load()
    Player:load()
end

function love.update(dt)
    World:update(dt) -- allows movement in world. otherwise you will be stuck on one frame
    Player:update(dt)
    Coin.updateAll(dt)
    Spike.updateAll(dt)
    Stone.updateAll(dt)
    Enemy.updateAll(dt)
    GUI:update(dt)
    Camera:setPosition(Player.x, 0)
    Map:update(dt)
end

function love.draw ()
    love.graphics.draw(background) -- draws the 'background' variable into the game
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale) -- moves the map itself with the camera.

    Camera:apply() --put before things you want the camera affect
    Player:draw()
    Enemy.drawAll()
    Coin.drawAll()
    Spike.drawAll()
    Stone.drawAll()
    
    Camera:clear() --before draw calls you dont want the camera to affect

    GUI:draw() -- outside of pop so that it does not transform and stays static on screen at all times
end

function love.keypressed(key)
 Player:jump(key)
end

function beginContact(a, b, collision) --3 args 1,2 are coliding fixtures 3rd is contact object
    if Coin.beginContact(a, b, collision) then return end -- if player is touching coin it wont be set to touching ground below due to the "return" keyword
    if Spike.beginContact(a, b, collision) then return end --if player is touching spike it wont be set to touching ground below due to the "return" keyword
    Enemy.beginContact(a, b, collision) -- no return end used soi we can land on the enemy without falling through
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end

