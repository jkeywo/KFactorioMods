
local function blank_animation() return {
    filename = "__k-core__/graphics/blank.png",
    priority = "high", width = 1, height = 1,
    frame_count = 1, line_length = 1
  } end

local function create_label(width, height, corner_only, minable, suffix )
  local _name = "invisible-label-"..width.."x"..height
  local _collision = {{(width * -0.5) + 0.1, (height * -0.5) + 0.1},
                     {(width * 0.5) - 0.1, (height * 0.5) - 0.1}}
  local _selection = {{(width * -0.5) + 0.1, (height * -0.5) + 0.1},
                     {(width * 0.5) - 0.1, (height * 0.5) - 0.1}}
  if corner_only then
    _name = _name.."c"
    _collision[2][1] = _collision[2][1] + 0.1
    _collision[2][2] = _collision[2][2] + 0.1
  end
  if suffix then
    _name = _name..suffix
  end
  
  data:extend(
  {
    {
      type = "train-stop",
      name = _name,
      icon = "__k-core__/graphics/blank.png",
      flags = {"player-creation", "filter-directions"},
      collision_mask = { "ghost-layer" },
      minable = minable,
      max_health = 150,
      corpse = "medium-remnants",
      order = "a-b-a",
      collision_box = _collision,
      selection_box = _selection,
      tile_width = width,
      tile_height = height,
      color={r=0.95,  g=0.95, b=0, a=0.5},
      
      animation_ticks_per_frame = 1,
      animations = {
        north = blank_animation(),
        east = blank_animation(),
        south = blank_animation(),
        west = blank_animation(),
      },
    }
  })
end

for i = 1, 10 do
  create_label( i, 1, false )
  create_label( i, 1, true )
end
