require("player") -- runs file at start
require("ball")
require("ai")
require("background")

function love.load()
    Player:load()
    Ball:load()
    AI:load()
    Background:load()

    Score = {player = 0, ai = 0}
    font = love.graphics.newFont(30)
end


function love.update(dt)
    Player:update(dt)
    Ball:update(dt)
    AI:update(dt)
    Background:update(dt)
end


function love.draw()
    Background:draw() --must be loaded first so that new sprites are loaded on top 
    Player:draw()
    Ball:draw()
    AI:draw()
end

function checkCollision(a,b) -- a = ball, b = player
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    else
        return false
    end
end
