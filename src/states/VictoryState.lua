VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
  self.level = params.level
  self.score = params.score
  self.highScores = params.highScores
  self.recoverPoints = params.recoverPoints
  self.paddle = params.paddle
  self.health = params.health
  self.ball = params.ball
end

function VictoryState:update(dt)
  self.paddle:update(dt)
  
  self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
  self.ball.y = self.paddle.y - 8
end

function VictoryState:touchpressed(id, x, y)
  if y > screenH * 0.8 then
    gStateMachine:change('serve', {
      level = self.level + 1,
      bricks = LevelMaker.createMap(self.level + 1),
      paddle = self.paddle,
      health = self.health,
      score = self.score,
      highScores = self.highScores,
      recoverPoints = self.recoverPoints
    })
  end
end

function VictoryState:draw()
  self.paddle:draw()
  self.ball:draw()
  
  drawScore(self.score)
  drawHealth(self.health)
  
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('Level ' .. tostring(self.level) .. ' complete', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['small'])
  love.graphics.printf('Tap to Continue', 0, VIRTUAL_HEIGHT * 0.9 - 4, VIRTUAL_WIDTH, 'center')
end