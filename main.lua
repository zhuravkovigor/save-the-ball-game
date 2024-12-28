local enemy = require 'Enemy'
local button = require 'Button'

math.randomseed(os.time())

local game = {
  difficylty  = 1,
  state = {
    menu = true,
    paused = false,
    running = false,
    ended = false,
  }
}

local enemies = {}
local player = {
  x = 0,
  y = 0,
  radius = 20,
}
local buttons = {
  menu_state = {}
}

local function startNewGame()
  game.state.menu = false
  game.state.running = true
end

function love.mousepressed(x, y, button, istouch, presses)
  if not game.state.running then
    if button == 1 then
      if game.state.menu then
        for index in pairs(buttons.menu_state) do
          buttons.menu_state[index]:checkPressed(x, y, player.radius)
        end
      end
    end
  end
end

function love.load()
  love.mouse.setVisible(false)

  table.insert(enemies, 1, enemy())

  buttons.menu_state.play_game = button('Play Game', startNewGame, nil, 120, 40)
  buttons.menu_state.settings = button('Settings', nil, nil, 120, 40)
  buttons.menu_state.exit_game = button('Exit', love.event.quit, nil, 120, 40)
end



function love.update()
  player.x, player.y = love.mouse.getPosition()

  if game.state.running then
    for i = 1, #enemies do
      enemies[i]:move(player.x, player.y)
    end
  end
end

function love.draw()
  love.graphics.printf('FPS: ' .. love.timer.getFPS(), 20, love.graphics.getHeight() - 30, love.graphics.getWidth(), "left")

  if game.state.running then
    love.graphics.circle('fill', player.x, player.y, player.radius)
    for i = 1, #enemies do
      enemies[i]:draw()
    end
  elseif game.state.menu then
    buttons.menu_state.play_game:draw(10, 20, 25, 13)
    buttons.menu_state.settings:draw(10, 70, 25, 13)
    buttons.menu_state.exit_game:draw(10, 120, 25, 13)
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  else
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  end

  love.graphics.setColor(255, 255, 255)
end