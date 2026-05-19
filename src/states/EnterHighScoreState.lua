EnterHighScoreState = Class{__includes = BaseState}

local chars = {
  [1] = 65,
  [2] = 65,
  [3] = 65
}

function EnterHighScoreState:enter(params)
  self.highScores = params.highScores
  self.score = params.score
  self.scoreIndex = params.scoreIndex
end

function EnterHighScoreState:touchpressed(id, x, y)
  if y > screenH * 0.8 then
    gSounds['confirm']:play()
    local name = string.char(chars[1], chars[2], chars[3])
    
    for i = 10, self.scoreIndex, -1 do
      self.highScores[i + 1] = {
        name = self.highScores[i].name,
        score = self.highScores[i].score
      }
    end
    self.highScores[self.scoreIndex].name = name
    self.highScores[self.scoreIndex].score = self.score
    
    local scoresStr = ''
    for i = 1, 10 do
      scoresStr = scoresStr .. self.highScores[i].name .. '\n'
      scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
    end
    love.filesystem.write('breakout.lst', scoresStr)
    
    gStateMachine:change('high-scores', {
      highScores = self.highScores
    })
    return
  end
  
  local colW = screenW / 3
  local col = math.ceil(x / colW)
  
  if y < screenH / 2 then
    gSounds['select']:play()
    chars[col]  = chars[col] + 1
    if chars[col] > 90 then chars[col] = 65
    end
  elseif y >= screenH / 2 and y <= screenH * 0.8 then
    gSounds['select']:play()
    chars[col] = chars[col] - 1
    if chars[col] < 65 then
      chars[col] = 90
    end
  end
end

function EnterHighScoreState:draw()
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Your Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT * 0.1 - 8, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['small'])
  love.graphics.printf('Enter your initials', 0, VIRTUAL_HEIGHT * 0.3 - 8, VIRTUAL_WIDTH, 'center')
  
  
  love.graphics.setFont(gFonts['large'])
  
  love.graphics.printf(string.char(chars[1]), 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH / 3, 'center')
  love.graphics.printf(string.char(chars[2]), VIRTUAL_WIDTH / 3, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH / 3, 'center')
  love.graphics.printf(string.char(chars[3]), VIRTUAL_WIDTH / 3 * 2, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH / 3, 'center')
  
  love.graphics.setFont(gFonts['small'])
  love.graphics.printf('Tap to Confirm', 0, VIRTUAL_HEIGHT * 0.9 - 4, VIRTUAL_WIDTH, 'center')
end