-- testing printing to debug console
print("Started main loop...")

-- add files that are required here

-- Add at top of file after require
local message = "This is a test."

function love.load()
end

function love.draw()
  -- Get window dimensions
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  local font = love.graphics.getFont()

  -- Calculate center positions
  local centerY = windowHeight / 2
  love.graphics.setColor(1, 1, 1)  -- Reset color for other drawing

  -- Center the text on the screen
  local textWidth = font:getWidth(message)
  local centerX = (windowWidth / 2) - (textWidth / 2)

  -- Draw a red circle at the mouse's position
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", x, y, 10)

  -- Draw the message in the center of the screen
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(message, centerX, 32)
end

function love.update(dt)
  -- Gets the x- and y-position of the mouse.
  x, y = love.mouse.getPosition()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

-- Callback function triggered by the default love.run when the game is closed
function love.quit() 
	print("Thanks for playing. Please play again soon!")
end
