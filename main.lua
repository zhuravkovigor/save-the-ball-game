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
  },
  points = 0,
  levels = {
    15, 30, 60, 120
  },
}

local fonts = {
  medium = {
    font  = love.graphics.newFont(16),
    size = 16,
  },
  large = {
    font  = love.graphics.newFont(24, 'mono'),
    size = 24,
  },
  massive = {
    font  = love.graphics.newFont(60),
    size = 60,
  },
}

local enemies = {}
local player = {
  x = 0,
  y = 0,
  radius = 20,
}
local buttons = {
  menu_state = {},
  ended_state = {}
}

local function changeGameState(state)
  game.state.menu = state == 'menu'
  game.state.paused = state == 'paused'
  game.state.running = state == 'running'
  game.state.ended = state == 'ended'
end

local function startNewGame()
  changeGameState('running')
  game.points = 0

  table.insert(enemies, 1, enemy())
  enemies = { enemy(1) }
end

function love.keypressed(key)
  if key == 'escape' then
    if not game.state.menu and not game.state.ended then
      if game.state.paused then
        changeGameState('running')
      else
        changeGameState('paused')
      end
    end
  end
end

function love.mousepressed(x, y, button)
  if not game.state.running then
    if button == 1 then
      if game.state.menu then
        for index in pairs(buttons.menu_state) do
          buttons.menu_state[index]:checkPressed(x, y, player.radius)
        end
      elseif game.state.ended then
        for index in pairs(buttons.ended_state) do
          buttons.ended_state[index]:checkPressed(x, y, player.radius)
        end
      end
    end
  end
end

function love.load()
  love.mouse.setVisible(false)

  buttons.menu_state.play_game = button('Play Game', startNewGame, nil, 120, 40)
  buttons.menu_state.settings = button('Settings', nil, nil, 120, 40)
  buttons.menu_state.exit_game = button('Exit', love.event.quit, nil, 120, 40)

  buttons.ended_state.replay_game = button('Replay', startNewGame, nil, 100, 50)
  buttons.ended_state.menu = button('Menu', changeGameState, "menu", 100, 50)
  buttons.ended_state.exit_game = button('Exit', love.event.quit, nil, 100, 50)
end

function love.update(dt)
  player.x, player.y = love.mouse.getPosition()

  if game.state.running then
    for i = 1, #enemies do
      if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
        enemies[i]:move(player.x, player.y)

        for j = 1, #game.levels do  -- Change this to start from 1
          if math.floor(game.points) == game.levels[j] then
            table.insert(enemies, 1, Enemy(game.difficylty * (j)))  -- Pass the level to the Enemy constructor
            game.points = game.points + 1
          end
        end
      else
        changeGameState('ended')
      end
    end

    game.points = game.points + dt
  end
end

function love.draw()
  love.graphics.setFont(fonts.medium.font)
  love.graphics.printf('FPS: ' .. love.timer.getFPS(), 20, love.graphics.getHeight() - 30, love.graphics.getWidth(), "left")

  if game.state.running then
    love.graphics.printf(math.floor(game.points), fonts.large.font, 0, 20, love.graphics.getWidth(), 'center')
    love.graphics.circle('fill', player.x, player.y, player.radius)
    for i = 1, #enemies do
      enemies[i]:draw()
    end
  elseif game.state.menu then
    buttons.menu_state.play_game:draw(10, 20, 25, 13)
    buttons.menu_state.settings:draw(10, 70, 25, 13)
    buttons.menu_state.exit_game:draw(10, 120, 25, 13)
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  elseif game.state.ended then
    love.graphics.setFont(fonts.large.font)

    buttons.ended_state.replay_game:draw(love.graphics.getWidth() / 2.25, love.graphics.getHeight() / 1.8, 10, 10)
    buttons.ended_state.menu:draw(love.graphics.getWidth() / 2.25, love.graphics.getHeight() / 1.54, 17, 10)
    buttons.ended_state.exit_game:draw(love.graphics.getWidth() / 2.25,  love.graphics.getHeight() / 1.33, 22, 10)
    
    love.graphics.printf(math.floor(game.points), fonts.massive.font, 0, love.graphics.getHeight() / 2 - fonts.massive.size, love.graphics.getWidth(), 'center')
    
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  elseif game.state.paused then
    love.graphics.setFont(fonts.large.font)
    love.graphics.printf('Paused', fonts.massive.font, 0, love.graphics.getHeight() / 2 - fonts.massive.size, love.graphics.getWidth(), 'center')
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  else
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  end

  love.graphics.setColor(255, 255, 255)
end