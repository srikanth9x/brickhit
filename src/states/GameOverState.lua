GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
  self.score = params.score
  self.highScores = params.highScores
end

function GameOverState:touchpressed(id, x, y)
  if y > screenH * 0.8 then
    local highScore = false
  
    local scoreIndex = 11
  
    for i = 10, 1, -1 do
      local score = self.highScores[i].score or 0
      if self.score > score then
        highScoreIndex = i
        highScore = true
      end
    end
  
    if highScore then
      gSounds['high-score']:play()
      gStateMachine:change('enter-high-score', {
        highScores = self.highScores,
        score = self.score,
        scoreIndex = highScoreIndex
    })
    else
      gStateMachine:change('start', {
      highScores = self.highScores
      })
    end
  end
end

function GameOverState:draw()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Score:' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['small'])
  love.graphics.printf('Tap to Continue', 0, VIRTUAL_HEIGHT * 0.9 - 4, VIRTUAL_WIDTH, 'center')
end