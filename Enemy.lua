function Enemy(level)
  local dice = math.random(1, 4)
  local _x, _y
  local _radius = 20

  if dice == 1 then
    _x = math.random(_radius, love.graphics.getWidth())
    _y = -_radius * 4
  end

  if dice == 2 then
    _x = -_radius * 4
    _y = math.random(_radius, love.graphics.getHeight())
  end

  if dice == 3 then
    _x = math.random(_radius, love.graphics.getWidth())
    _y = love.graphics.getHeight() + (_radius * 4)
  end

  if dice == 4 then
    _x = love.graphics.getWidth() + (_radius * 4)
    _y = math.random(_radius, love.graphics.getHeight())
  end

  return {
    level = level or 1,
    radius = _radius,
    x = _x,
    y = _y,

    checkTouched = function (self, player_x, player_y, cursor_radius)
      return math.sqrt((self.x - player_x) ^ 2 + (self.y - player_y) ^ 2) <= cursor_radius * 2
    end,

    move = function (self, player_x, player_y)
      if self.x < player_x then
        self.x = self.x + 1
      end

      if self.x > player_x then
        self.x = self.x - 1
      end

      if self.y < player_y then
        self.y = self.y + 1
      end

      if self.y > player_y then
        self.y = self.y - 1
      end
    end,

    draw = function (self)
      love.graphics.setColor(255, 0, 0)
      love.graphics.circle("fill", self.x, self.y, self.radius)

      love.graphics.setColor(255, 255, 255)
    end
  }
end

return Enemy