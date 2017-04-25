
-- At first, we'll try to keep everything commented, but that will be dropped
-- soon enough, so get used to figuring things out!

-- "local" variables mean that they belong only to this code module. More on
-- that later.

-- Window resolution
local W, H

-- Maximum number of obejcts
local MAX_OBJECTS

-- The list of all game objects
local objects

-- Holds the source object containing the "bounce" sound effect
local bounce_sfx

--[[ Auxiliary functions ]]--

--- Creates a new game object.
--  We start with an empty table, then define the 'x' and 'y' fields as the
--  coordinates of the object, and in the end choose a move direction, in
--  radians, that is converted to a unitary directional vector using a little
--  trigonometry.
--  See https://love2d.org/wiki/love.math.random
local function newObject ()
  local new_object = {}
  new_object.x = love.math.random()*W
  
  if new_object.x < W/2 then
  	new_object.x = new_object.x + radius
  else
  	new_object.x = new_object.x - radius
  end
  new_object.y = love.math.random()*H
  if new_object.y < H/2 then
  	new_object.y = new_object.y + radius
  else
  	new_object.y = new_object.y - radius
  end
  local dir = love.math.random()*2*math.pi
  new_object.dir_x = math.cos(dir)
  new_object.dir_y = math.sin(dir)
  new_object.red = love.math.random(255)
  new_object.green = love.math.random(255)
  new_object.blue = love.math.random(255)
  
  return new_object
end

--- Move the given object as if 'dt' seconds had passed. Basically follow
--  the uniform movement equation: S = S0 + v*dt.
local function moveObject (object, dt)
	if object.x < radius or object.x > W-radius then
		love.audio.play(bounce_sfx)
  	object.dir_x = -object.dir_x
  	object.x = math.max(radius, math.min(object.x, W-radius))
end
	if object.y < radius or object.y > H-radius then
		love.audio.play(bounce_sfx)
  	object.dir_y = -object.dir_y
  	object.y = math.max(radius, math.min(object.y, H-radius))
end
  object.x = object.x + OBJECT_SPEED*object.dir_x*dt
  object.y = object.y + OBJECT_SPEED*object.dir_y*dt
  
end

local function handleCollisions(radius)
	
end

--[[ Main game functions ]]--

--- Here we load up all necessary resources and information needed for the game
--  to run. We start by getting the screen resolution (which will be used for
--  drawing) then define the maximum number of objects. Finally we create a
--  list of game objects to draw and interact. Note that we also use a table
--  for the list, but in a different way than above.
--  See https://love2d.org/wiki/love.graphics.getDimensions
function love.load ()
  W, H = love.graphics.getDimensions()
  MAX_OBJECTS = 10
  OBJECT_SPEED = 500
  radius = 19
  bounce_sfx = love.audio.newSource("bounce.wav", "stream")
  objects = {}
  for i=1,MAX_OBJECTS do
  	
    table.insert(objects, newObject())
  end
  --bounce_sfx = nil
end

--- Update the game's state, which in this case means properly moving each
--  game object according to its moving direction and current position.
function love.update (dt)
	for i,object in ipairs(objects) do
    	handleCollisions()
  	end
  for i,object in ipairs(objects) do
    moveObject(object, dt)
  end
  
end

--- Detects when the player presses a keyboard button. Closes the game if it
--  was the ESC button.
--  See https://love2d.org/wiki/love.event.push
function love.keypressed (key)
  if key == 'escape' then
    love.event.push 'quit'
  end
end

--- Draw all game objects as simle white circles. We will improve on that.
--  See https://love2d.org/wiki/love.graphics.circle
function love.draw ()
	
  for i,object in ipairs(objects) do
   	love.graphics.setColor(object.red, object.green, object.blue)
    love.graphics.circle('fill', object.x, object.y, radius, 16)
    
  end
end

