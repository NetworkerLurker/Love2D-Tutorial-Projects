

local GUI = {} --adding local makes the file performance, idependence, and resistance to variable overwriting go up. (MUST RETURN FILE NAME AT VERY END OF THE CODE FILE)

local Player = require("player")

function GUI:load()
    self.coins = {}
    self.coins.img = love.graphics.newImage('assets/coin.png') --asset we want to draw
    self.coins.width = self.coins.img:getWidth() --dimension
    self.coins.height = self.coins.img:getHeight()-- dimension
    self.coins.scale = 3 --scale of the coin (300%)
    self.coins.x = love.graphics.getWidth() - 200 --x coord where img will be displayed (right)
    self.coins.y = 50 --y coord where img will be displayed (top)

    self.hearts = {}
    self.hearts.img = love.graphics.newImage("assets/heart.png")
    self.hearts.width = self.hearts.img:getWidth()
    self.hearts.height = self.hearts.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 30
    self.hearts.scale = 3
    self.hearts.space = 30 -- amount of additional space between hearts
    self.hearts.spacing = self.hearts.width * self.hearts.scale + self.hearts.space --puts space between the 3 hearts in the GUI

    self.font = love.graphics.newFont("assets/bit.ttf", 36) --changes GUI font
    
end

function GUI:update(dt)
    
end

function GUI:draw()
    GUI:displayCoins()
    GUI:displayCoinText()
    GUI:displayHearts()
end

function GUI:displayHearts()
    for i=1,Player.health.current do --loop using player current health to display amount of hearts
        local x = self.hearts.x + self.hearts.spacing * i --local used to shorten code lines
        love.graphics.setColor(0,0,0,0.5) --black with half opacity for a "shadow" effect
        love.graphics.draw(self.hearts.img, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale) -- +2 for offset
        love.graphics.setColor(1,1,1,1) --white with full opacity
        love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
    end
end
function GUI:displayCoins()
    love.graphics.setColor(0,0,0,0.5) --black with half opacity for a "shadow" effect
    love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale) --draws the GUI coin image (+2 offsets shadow)
    love.graphics.setColor(1,1,1,1) --white with full opacity
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
end

function GUI:displayCoinText()
    love.graphics.setFont(self.font)
    local x = self.coins.x + self.coins.width * self.coins.scale
    local y = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
    love.graphics.setColor(0,0,0,0.5) --black with half opacity for a "shadow" effect
    love.graphics.print(" : " .. Player.coins, x + 2, y + 2) -- +2 is used to offset the "shadow"
    love.graphics.setColor(1,1,1,1) --white with full opacity
    love.graphics.print(" : " .. Player.coins, x, y)
    --love.graphics.print(" : "..Player.coins, self.coins.x + self.coins.width * self.coins.scale, self.coins.y + self.coins.height / 2) --draws the amount of coins collected to the right of the icon
end

return GUI --required since GUI was declared as a local