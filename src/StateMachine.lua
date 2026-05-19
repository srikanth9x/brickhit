StateMachine = Class{}

function StateMachine:init(states)
  self.empty = {
    enter = function() end,
    update = function() end,
    draw = function() end,
    exit = function() end
  }
  
  self.states = states or {}
  self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
  assert(self.states[stateName])
  self.current:exit()
  self.current = self.states[stateName]()
  self.current:enter(enterParams)
end

function StateMachine:update(dt)
  self.current:update(dt)
end

function StateMachine:draw()
  self.current:draw()
end

function StateMachine:touchpressed(id, x, y)
  self.current:touchpressed(id, x, y)
end

function StateMachine:touchreleased(id, x, y)
  self.current:touchreleased(id, x, y)
end