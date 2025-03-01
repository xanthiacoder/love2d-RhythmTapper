-- testing printing to debug console
-- print("Started main loop...")

-- add files that are required here

-- Add at top of file after require
local message = "Tap your beat (bpm) with SPACE BAR\nLeft & Right arrows to fine tune\nESC to quit"
local song = {
  tempo = 120,
}
local clock = {
  tick = 1,
  tock = 1,
  time = love.timer.getTime(),
  lapTock = love.timer.getTime(),
}

local tapTempo = love.timer.getTime() -- init to detect delta to change tempo
local tapAlpha = 1 -- alpha value of blinking light synced to tempo

-- print("song.tempo = ".. song.tempo)

function love.load()
  -- load fonts
  monoFont = love.graphics.newFont("assets/JetBrainsMonoNL-Regular.ttf", 13)
  bigFont = love.graphics.newFont("assets/JetBrainsMonoNL-Regular.ttf", 26)
  maxFont = love.graphics.newFont("assets/JetBrainsMonoNL-Regular.ttf", 13*4)

  -- load audio files
  sfx = {
    metronome = love.audio.newSource("assets/metronome-low.ogg", "static"),
  }
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == "space" then
    -- print("keypressed - space")
    -- tapTempo detection
    if (love.timer.getTime() - tapTempo) > 2 then
      -- new attempt to tap tempo detected, recalibrate
      tapTempo = love.timer.getTime()
    else
      song.tempo = math.floor(60 / (love.timer.getTime() - tapTempo))
      tapTempo = love.timer.getTime() -- init for the next detection
    end
    -- print("song.tempo = ".. song.tempo)
  elseif key == "left" then
    song.tempo = song.tempo - 1
  elseif key == "right" then
    song.tempo = song.tempo + 1
  end
end

function love.draw()
  -- Get window dimensions
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  -- Calculate center positions
  local centerY = windowHeight / 2
  love.graphics.setColor(1, 1, 1)  -- Reset color for other drawing

  -- Draw a red circle at the mouse's position
  -- love.graphics.setColor(1, 0, 0)
  -- love.graphics.circle("fill", x, y, 10)

  -- Draw a red circle that blinks according to tempo
  love.graphics.setColor(1, 0, 0, tapAlpha)
  love.graphics.circle("fill", 640/2, (480/2)+34, 80)
  love.graphics.setColor(1, 1, 1)  -- Reset color for other drawing

  -- Draw the message in the center of the screen
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(bigFont)
  love.graphics.printf(message, 0, 5, 640, "center")
  love.graphics.setFont(maxFont)
  love.graphics.printf(song.tempo, 0, 240, 640, "center")

end

function love.update(dt)
  -- Gets the x- and y-position of the mouse.
  x, y = love.mouse.getPosition()

  -- fade blinking dot
  tapAlpha = tapAlpha - 0.02

  -- tempo stuff
  -- get clock.tick and clock.tock to move according to tempo
  clock.time = love.timer.getTime()
	-- check ticks and tocks
  if (clock.time - clock.lapTock) >= ((60 / song.tempo)/4) then
    clock.tock = clock.tock + 1
    clock.lapTock = clock.time -- update lap timer for next tock
    if clock.tock == 5 then
      clock.tick = clock.tick + 1
      tapAlpha = 1 -- reset blinking dot
      -- play metronome
      sfx.metronome:stop()
      sfx.metronome:play()
      if clock.tick == 5 then
        clock.tick = 1
        -- print("tick")
      end
      clock.tock = 1
      -- print("tock")
    end
  end
end

-- Callback function triggered by the default love.run when the game is closed
function love.quit() 
	-- print("Thanks for playing. Please play again soon!")
end
