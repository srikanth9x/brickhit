--[[
BrickHit
v1.0.0 | May 2026

A reimagining of Breakout (Atari, 1976), built as a learning project following CS50's Introduction to Game Development.
Features multiple levels, particle effects, and high scores.
Adapted for touch input on Android.

Author : Bandari Srikanth (https://github.com/srikanth9x)

Assets : CS50 Game Development — Harvard University
https://github.com/games50

MIT License — Copyright (c) 2026 Bandari Srikanth
]]

require 'src.Dependencies'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  love.window.setTitle('Brickhit')
  
  math.randomseed(os.time())
  
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/pressstart.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/pressstart.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/pressstart.ttf', 32)
  }
  
  love.graphics.setFont(gFonts['small'])
  
  gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['main'] = love.graphics.newImage('graphics/breakout.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png')
  }
  
  gFrames = {
    ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
    ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
    ['balls'] = GenerateQuadsBalls(gTextures['main']),
    ['bricks'] = GenerateQuadsBricks(gTextures['main']),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
  }
  
  gSounds = {
    ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
    ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
    ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
    ['high-score'] = love.audio.newSource('sounds/high-score.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
    ['paddle-hit'] = love.audio.newSource('sounds/paddle-hit.wav', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['wall-hit'] = love.audio.newSource('sounds/wall-hit.wav', 'static'),
    
    ['music'] = love.audio.newSource('sounds/music.wav', 'static')
  }
  
  gStateMachine = StateMachine {
    ['start'] = function() return StartState() end,
    ['play'] = function() return PlayState() end,
    ['serve'] = function() return ServeState() end,
    ['game-over'] = function() return GameOverState() end,
    ['victory'] = function() return VictoryState() end,
    ['high-scores'] = function() return HighScoreState() end,
    ['enter-high-score'] = function() return EnterHighScoreState() end,
    ['paddle-select'] = function() return PaddleSelectState() end
  }
  
  gStateMachine:change('start', {
    highScores = loadHighScores()
  })
  
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    resizable = false,
    vsync = true,
    fullscreen = false
  })

  push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscale = 'normal'})
  
  gSounds['music']:setLooping(true)
  gSounds['music']:play()
end

--[[
function love.resize(w, h)
  push.resize(w, h)
end
]]

function love.update(dt)
  gStateMachine:update(dt)
end

function love.touchpressed(id, x, y)
  gStateMachine:touchpressed(id, x, y)
end

function love.touchreleased(id, x, y)
  gStateMachine:touchreleased(id, x, y)
end

function love.draw()
  push.start()
  
  local backgroundWidth = gTextures['background']:getWidth()
  local backgroundHeight = gTextures['background']:getHeight()
  
  love.graphics.draw(gTextures['background'], 0, 0, 0, VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
  
  gStateMachine:draw()
  
  -- displayFPS()
  
  push.finish()
end

function loadHighScores()
  love.filesystem.setIdentity('breakout')
  
  if not love.filesystem.getInfo('breakout.lst') then
    local scores = ''
    for i = 1, 10 do
      scores = scores .. '---\n'
      scores = scores .. tostring(0) .. '\n'
    end
    
    love.filesystem.write('breakout.lst', scores)
  end 
  
  local name = true
  local counter = 1
  
  local scores = {}
  
  for i = 1, 10 do
    scores[i] = {
      name = nil,
      score = nil
    }
  end
  
  for line in love.filesystem.lines('breakout.lst') do
    if name then
      scores[counter].name = string.sub(line, 1, 3)
    else 
      scores[counter].score = tonumber(line)
      counter = counter + 1
    end
    name = not name
  end
  return scores
end


function drawHealth(health)
  local healthX = VIRTUAL_WIDTH - 44
  
  for i = 1, health do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
    healthX = healthX + 11
  end
  
  for i = 1, 3 - health do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
    healthX = healthX + 11
  end
end

function drawScore(score)
  love.graphics.setFont(gFonts['small'])
  love.graphics.printf('Score:' .. tostring(score), 10, 5, VIRTUAL_WIDTH, 'left')
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
end