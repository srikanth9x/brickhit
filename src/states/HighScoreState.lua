HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
  self.highScores = params.highScores
end

function HighScoreState:touchpressed(id, x, y)
  if y > screenH * 0.8 and x < screenW / 2 then
    gSounds['wall-hit']:play()
    
    gStateMachine:change('start', {
      highScores = self.highScores
    })
  end
end

function HighScoreState:draw()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('High Scores', 0, 16, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['medium'])
  
  for i = 1, 10 do
    local name = self.highScores[i].name or '---'
    local score = self.highScores[i].score or '---'
    
    love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4 - 16, 36 + i * 18, 64, 'left')
    
    love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 64, 36 + i * 18, 64, 'center')
    
    love.graphics.printf(score, VIRTUAL_WIDTH / 2 + 64, 36 + i * 18, 96, 'right')
  end
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Back', 10, VIRTUAL_HEIGHT * 0.9 - 8, VIRTUAL_WIDTH, 'left')
end