ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.highScores = params.highScores
  self.recoverPoints = params.recoverPoints
  self.score = params.score
  self.level = params.level
  
  self.ball = Ball()
  self.ball.skin = math.random(7)
end

function ServeState:update(dt)
  self.paddle:update(dt)
  self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
  self.ball.y = self.paddle.y - 8
end

function ServeState:touchpressed(id, x, y)
  gStateMachine:change('play', {
    paddle = self.paddle,
    bricks = self.bricks,
    health = self.health,
    score = self.score,
    highScores = self.highScores,
    recoverPoints = self.recoverPoints,
    ball = self.ball,
    level = self.level
  })
end

function ServeState:draw()
  self.paddle:draw()
  self.ball:draw()
  
  for k, brick in pairs(self.bricks) do
    brick:draw()
  end
  
  drawHealth(self.health)
  drawScore(self.score)
  
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Tap to Serve', 0, VIRTUAL_HEIGHT / 2 - 8 , VIRTUAL_WIDTH, 'center')
end