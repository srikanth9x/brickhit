Paddle = Class{}

function Paddle:init(skin)
  self.x = VIRTUAL_WIDTH / 2 - 32
  self.y = VIRTUAL_HEIGHT - 32
  
  self.dx = 0
  
  self.width = 64
  self.height = 16
  
  self.skin = skin
  
  self.size = 2
end

function Paddle:touchpressed(id, x, y)
  if y > screenH * 0.1 then
    if x < screenW / 2 then
      self.dx = -PADDLE_SPEED
    elseif x > screenW / 2 then
      self.dx = PADDLE_SPEED
    end
  end
end

function Paddle:touchreleased(id, x, y)
  self.dx = 0
end

function Paddle:update(dt)
  if self.dx < 0 then
    self.x = math.max(0, self.x + self.dx * dt)
  else
    self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
  end
end

function Paddle:draw()
  love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end