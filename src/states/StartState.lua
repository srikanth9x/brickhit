StartState = Class{__includes = BaseState}

function StartState:enter(params)
  self.highScores = params.highScores
end

function StartState:touchpressed(id, x, y)
  if y > screenH * 0.8 and x < screenW / 2 then
    gSounds['paddle-hit']:play()
    gStateMachine:change('high-scores', {
      highScores = self.highScores
    })
  elseif y > screenH * 0.8 and x > screenW / 2 then
    gSounds['paddle-hit']:play()
    gStateMachine:change('paddle-select', {
      highScores = self.highScores
    })
  end
  
end

function StartState:draw()
  love.graphics.setFont(gFonts['large'])
  
  love.graphics.printf('Brickhit', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['medium'])
  
  love.graphics.printf('High Scores', 10, VIRTUAL_HEIGHT * 0.9 - 8, VIRTUAL_WIDTH, 'left')
  
  love.graphics.printf('Start', -10, VIRTUAL_HEIGHT * 0.9 - 8, VIRTUAL_WIDTH, 'right')
end