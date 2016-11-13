
local magick = require("magick")
local serpent = require("serpent")

local colours = { "red", "green", "blue", "yellow", "magenta", "cyan", "white" }

local function colourise( filename, colour, output_name, size )
	local _colour = magick.load_image("./colours/"..colour..".png")
	local _firework = magick.load_image(filename..".png")
	
	_firework:composite(_colour, 0, 0, "CopyRedCompositeOp")
	_firework:composite(_colour, 0, 0, "CopyGreenCompositeOp")
	_firework:composite(_colour, 0, 0, "CopyBlueCompositeOp")
	
	if size then
		_firework:resize(size.w, size.h)
	end
	
	_firework:write((output_name or filename).."-"..colour..".png")
end

for _, _colour in pairs(colours) do
  -- icons
	colourise( "firework-star", _colour, "./icons/firework-large", {w=32, h=32} )
	colourise( "firework-star", _colour, "./icons/firework-medium", {w=32, h=32} )
	colourise( "firework-star", _colour, "./icons/firework-small", {w=32, h=32} )
	colourise( "flare", _colour, "./icons/flare", {w=32, h=32} )
  
	-- sprites
	colourise( "firework-star", _colour, "./projectiles/firework-star" )
	colourise( "firework-spark", _colour, "./projectiles/firework-spark" )
	colourise( "flare", _colour, "./projectiles/flare" )
end
