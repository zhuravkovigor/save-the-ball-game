local game = {
  state = {
    menu = true,
    paused = false,
    running = false,
    ended = false,
  }
}

local player = {
  x = 0,
  y = 0,
  radius = 20,
}

function love.load()
  love.mouse.setVisible(false)
end

function love.update()
  player.x, player.y = love.mouse.getPosition()
end

function love.draw()
  love.graphics.printf('FPS: ' .. love.timer.getFPS(), 20, love.graphics.getHeight() - 30, love.graphics.getWidth(), "left")

  if not game.state.menu then
    love.graphics.circle('fill', player.x, player.y, player.radius)
  else
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  end

  love.graphics.setColor(255, 255, 255)
end