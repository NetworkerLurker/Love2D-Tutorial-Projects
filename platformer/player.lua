local Player = {} --since player is used in other files (coin, spike, gui, etc..) making it local will crash the game. This is why you must add a "require player" at the top of each file using this local.

function Player:load() -- colon allows for use of the keyword "self"
    self.x = 100
    self.y = 0
    self.startX = self.x
    self.startY = self.y
    self.width = 20
    self.height = 60
    self.xVel = 0 --left/right movement set to 0 so player is still by default
    self.yVel = 0 --up/down movement
    self.maxSpeed = 200 -- max speed in pixels per second
    self.acceleration = 4000 --increases speed  200/4000 = 0.05 sec to max speed
    self.friction =  3500 --decreases speed 200/3500 = .0571 to full stop
    self.gravity = 1500 -- used to set a constant -yVel on the player when not grounded
    self.jumpAmount = -500 --jump height
    self.coins = 0 --starting coin count
    self.health = {current = 3, max = 3} -- sets player starting health and max health

    self.color = { --colors use a scale between 0-1 --used to tint players color when damaged
        red = 1,
        green = 1,
        blue = 1,
        speed = 3 --determines how quickly player will untint
    }

    self.direction = "right"
    self.state = "idle"

    self.graceTime = 0 --allows player to jump even when not on the ground or recently leaving the ground
    self.graceDuration = 0.1

    self.alive = true
    self.grounded = false -- boolean tells whether the player is on the ground(true) or in the air(false)
    self.hasDoubleJump = true -- sets double jump to true used in other functions
    self.secondJump = 0.8 --multiple power of original jump. (2nd jump is 80% as powerful)

    self:loadAssets()

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic") --sets char physics and body- takes 4 args (world, x, y, type) 3 types: static, dynamic, kinematic
    self.physics.body:setFixedRotation(true) -- removes default ability to rotate (lock body rotation)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height) --define shape of char physicle body
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape) --connects shape and body args(body, shape, density(omitted here))
    self.physics.body:setGravityScale(0) --1 arg() 0 means the player will not be affected by the world gravity (we made our own gravity for the player elsewhere). however this will let everything else be affected by gravity
end

function Player:loadAssets()
    self.animation = {timer = 0, rate = 0.1}
 
    self.animation.run = {total = 6, current = 1, img = {}}
    for i=1, self.animation.run.total do
       self.animation.run.img[i] = love.graphics.newImage("assets/player/run/"..i..".png")
    end
 
    self.animation.idle = {total = 4, current = 1, img = {}}
    for i=1, self.animation.idle.total do
       self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/"..i..".png")
    end
 
    self.animation.air = {total = 4, current = 1, img = {}}
    for i=1, self.animation.air.total do
       self.animation.air.img[i] = love.graphics.newImage("assets/player/air/"..i..".png")
    end
 
    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

function Player:takeDamage(amount)
    self:tintRed()
     if self.health.current - amount > 0 then --if health is not 0 then take damage
         self.health.current = self.health.current - amount --subtract damage amount from current health
     else --if health - ammount is not greater than 0
        self.health.current = 0 --set health to 0 
        self:die() --die
     end
     print("Player health: " .. self.health.current)
end

function Player:die()
    print("Player died")
    self.alive = false --make dead
end

function Player:respawn()
    if not self.alive then -- if dead then
        self:resetPosition()
        self.health.current = self.health.max --reset health to max
        self.alive = true -- make alive
    end
end

function Player:resetPosition()
    self.physics.body:setPosition(self.startX, self.startY) --reset position to starting posisiton
end

function Player:tintRed() --tints player red on dmg
    self.color.green = 0 --with green and blue set to 0 only red will show
    self.color.blue = 0
end

function Player:incrementCoins()
    self.coins = self.coins + 1
end

function Player:update(dt)
    self:unTint(dt)
    self:respawn()
    self:setState()
    self:setDirection()
    self:animate(dt)
    self:decreaseGraceTime(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
end

function Player:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1) --sets each color to whichever is the smallest. --1/3rd of a second to untint (since speed is 3 and dt is 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Player:setState()
    if not self.grounded then -- if not on the ground must be in the air
        self.state = "air" 
    elseif self.xVel == 0 then -- if x is 0 must not be moving
        self.state = "idle"
    else -- if not in air or idle then you must be moving (process of elimination)
        self.state = "run"
    end
   -- print(self.state) --prints state into console for debugging
end

function Player:setDirection()
    if self.xVel < 0 then --checks if player is moving left
        self.direction = "left" --changes direction variable to left
    elseif self.xVel > 0 then --check if player is moving right
        self.direction = "right" --changes direction variable to right
    end
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt --increments timer by dt
    if self.animation.timer > self.animation.rate then --check if timer is greather than the rate
        self.animation.timer = 0 --if timer is greater than rate set time back to 0
        self:setNewFrame()
    end
end

function Player:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Player:decreaseGraceTime(dt)
    if not self.grounded then 
        self.graceTime = self.graceTime * dt
    end
end

function Player:applyGravity(dt)
    if not self.grounded then --if not on the ground then
       self.yVel = self.yVel + self.gravity * dt --apply gravity
    end
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then --sets right movement key to D and right arrow
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed) --replaces code below (mathmin, takes the lowest of the 2 args)
        --[[if self.xVel < self.maxSpeed then --if not going max speed
            if self.xVel + self.acceleration * dt < self.maxSpeed then --checks to see if acceleration will cause you to go over maxspeed
               self.xVel = self.xVel + self.acceleration * dt --increases speed if not maxspeed
            else
               self.xVel = self.maxSpeed --stops increasing speed at maxspeed
            end
        end]]
    elseif love.keyboard.isDown("a", "left") then --sets left movement keys, same as above but operators are reversed
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed) --replaces code below (math.max takes the highest of the two args)
        --[[if self.xVel > -self.maxSpeed then
            if self.xVel - self.acceleration * dt > self.maxSpeed then
               self.xVel = self.xVel - self.acceleration * dt
            else
               self.xVel = -self.maxSpeed
            end
        end]]
    else
        self:applyFriction(dt)
    end
end

function Player:applyFriction(dt) --slows down player when not pressing a movement key. reduces x velocity to 0 if it is above or below
    if self.xVel > 0 then  --above 0 (moving right)
        self.xVel = math.max(self.xVel - self.friction * dt, 0)
        --[[if self.xVel - self.friction * dt > 0 then
            self.xVel = self.xVel - self.friction * dt
        else
            self.xVel = 0
        end]]
    elseif self.xVel < 0 then --below 0 (moving left)
        self.xVel = math.min(self.xVel + self.friction * dt, 0)
       --[[ if self.xVel + self.friction * dt < 0 then
            self.xVel = self.xVel + self.friction * dt
        else
            self.xVel = 0 --stops function at 0 xVelocity (player will be still)
        end]]
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition() -- syncs physics by putting physical body on img of body
    self.physics.body:setLinearVelocity(self.xVel, self.yVel) --ramps of velocity at a constant rate instead of 0 to 100 instantly
end

function Player:beginContact(a, b, collision)
  if self.grounded == true then return end --does not execute below code if player is grounded
  local nx, ny = collision:getNormal() --gets normals of the objects. (so player cant walk on ceilings for instance)
  if a == self.physics.fixture then --check to see if player is object A or B
      if ny > 0 then
        self:land(collision)
      elseif ny < 0 then --if u hit an object you lose all velocity
        self.yVel = 0
      end
  elseif b == self.physics.fixture then
    if ny < 0 then
        self:land(collision)
    elseif ny > 0 then --if u hit an object you lose all velocity
        self.yVel = 0
    end
  end
end

function Player:land(collision) -- collision added to make player fall when walking off an edge
    self.currentGroundCollision = collision
    self.yVel = 0 --removes gravity if player is on the ground
    self.grounded = true --tells other functions player is on the ground
    self.hasDoubleJump = true
    self.graceTime = self.graceDuration
end

function Player:jump(key)
    if (key == "w" or key == "up") then --sets jump key and checks to see if player is grounded before executing code. keys are in paranthesis due to the use of OR and AND.
       if self.grounded or self.graceTime > 0 then
        self.yVel = self.jumpAmount --sets y velocity to jumpamount(500) making the player go up
        self.grounded = false
        self.graceTime = 0
       elseif self.hasDoubleJump then
        self.hasDoubleJump = false
        self.yVel = self.jumpAmount * self.secondJump
       end
    end
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end

function Player:draw()
    local scaleX = 1 --x scaling used in draw below, variable x scaling is needed to flip the animation when moving left
   if self.direction == "left" then
    scaleX = -1
   end
   love.graphics.setColor(self.color.red, self.color.green, self.color.blue) --allows player color to be changed with color table created in Player:load (self.color) --USE BEFORE PLAYER IS LOADED
   love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2, self.animation.height / 2) --draws character with sprite
   -- love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height) --draws rectangle and determines size (need to subtract width/2 and height/2 when using box2d to make box2d line up with love)
   love.graphics.setColor(1,1,1,1) --resets color back, avoids tinting other things besides the player
end

return Player
