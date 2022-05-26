

local Camera = {
    x = - 0, --x pos of camera
    y = 0, --y pos of camera
    scale = 2, -- 2 = 200% zoom
}

function Camera:apply() --starts camera
    love.graphics.push() 
    love.graphics.scale(self.scale,self.scale)
    love.graphics.translate(-self.x, -self.y) -- moves window (negative because if we want to move camera to right we must move its content to the left)
end

function Camera:clear() --pops and clears camera
    love.graphics.pop()
end

function Camera:setPosition(x, y)
    self.x = x - love.graphics.getWidth() / 2 / self.scale --sets center of window = to passed in value. makes it easier to center the player
    self.y = y
    local RS = self.x + love.graphics.getWidth() / 2 --right side of screen

    if self.x < 0 then
        self.x = 0
    elseif RS > MapWidth then
        self.x = MapWidth - love.graphics.getWidth() / 2
    end
end

return Camera