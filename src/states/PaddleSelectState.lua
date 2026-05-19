PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(params)
  self.highScores = params.highScores
end

function PaddleSelectState:init()
  self.currentPaddle = 1
end

function PaddleSelectState:touchpressed(id, x, y)
  if x < screenW / 2 and y < screenH * 0.8 then
    if self.currentPaddle == 1 then
      gSounds['no-select']:play()
    else
      gSounds['select']:play()
      self.currentPaddle = self.currentPaddle - 1
    end
  elseif x > screenW / 2 and y < screenH * 0.8 then
    if self.currentPaddle == 4 then
      gSounds['no-select']:play()
    else
      gSounds['select']:play()
      self.currentPaddle = self.currentPaddle + 1
    end
  end
  if y > screenH * 0.8 then
      gSounds['confirm']:play()
      
    gStateMachine:change('serve', {
      paddle = Paddle(self.currentPaddle),
      bricks = LevelMaker.createMap(1),
      health = 3,
      score = 0,
      highScores = self.highScores,
      level = 1
    })
  end
end

function PaddleSelectState:draw()
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Select your paddle', 0, VIRTUAL_HEIGHT * 0.1 - 8, VIRTUAL_WIDTH, 'center')
  
  if self.currentPaddle == 1 then
    love.graphics.setColor(40/225, 40/225, 40/225, 128/225)
  end
  
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24, VIRTUAL_HEIGHT / 2 - 12)
  
  love.graphics.setColor(1, 1, 1, 1)
  
  if self.currentPaddle == 4 then
    love.graphics.setColor(40/225, 40/225, 40/225, 128/225)
  end
  
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 2 - 12)
  
  love.graphics.setColor(1, 1, 1, 1)
  
  love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)], VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT / 2 - 16)
  
  love.graphics.setFont(gFonts['small'])
  love.graphics.printf('Tap to Continue', 0, VIRTUAL_HEIGHT * 0.9 - 4, VIRTUAL_WIDTH, 'center')
end