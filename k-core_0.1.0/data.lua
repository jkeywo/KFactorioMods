
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
      flags = {"placeable-neutral"},
      minable = minable,
      max_health = 150,
      corpse = "medium-remnants",
      order = "a-b-a",
      collision_box = _collision,
      selection_box = _selection,
      tile_width = width,
      tile_height = height,
      color={r=0,  g=0, b=0, a=0},
      
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

for i = 1, 9 do
  create_label( 1, i, false )
  create_label( 1, i, true )
end

create_label( 1, 1, false, {hardness = 0.2, mining_time = 0.5, result = "signpost"}, "-signpost" )
data:extend({
 {
    type = "recipe",
    name = "signpost",
    ingredients =
    {
      {"wood", 2},
      {"copper-cable", 1}
    },
    result = "signpost",
    result_count = 1,
    requester_paste_multiplier = 4
  },
  {
    type = "item",
    name = "signpost",
    icon = "__base__/graphics/icons/small-electric-pole.png",
    flags = {"goes-to-quickbar"},
    subgroup = "energy-pipe-distribution",
    order = "a[energy]-z[small-electric-pole]",
    place_result = "signpost",
    fuel_value = "4MJ",
    stack_size = 50
  },
  {
    type = "electric-pole",
    name = "signpost",
    icon = "__base__/graphics/icons/small-electric-pole.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "signpost"},
    max_health = 35,
    corpse = "small-remnants",
    collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
    drawing_box = {{-0.5, -2.6}, {0.5, 0.5}},
    maximum_wire_distance = 7.5,
    supply_area_distance = 2.5,
    vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 },
    pictures =
    {
      filename = "__base__/graphics/entity/small-electric-pole/small-electric-pole.png",
      priority = "extra-high",
      width = 123,
      height = 124,
      direction_count = 4,
      shift = {1.4, -1.1}
    },
    connection_points =
    {
      {
        shadow =
        {
          copper = {2.7, 0},
          red = {2.3, 0},
          green = {3.1, 0}
        },
        wire =
        {
          copper = {0, -2.7},
          red = {-0.375, -2.625},
          green = {0.40625, -2.625}
        }
      },
      {
        shadow =
        {
          copper = {2.7, -0.05},
          red = {2.2, -0.35},
          green = {3, 0.12}
        },
        wire =
        {
          copper = {-0.04, -2.8},
          red = {-0.375, -2.9375},
          green = {0.1875, -2.5625}
        }
      },
      {
        shadow =
        {
          copper = {2.5, -0.1},
          red = {2.55, -0.45},
          green = {2.5, 0.25}
        },
        wire =
        {
          copper = {-0.15625, -2.6875},
          red = {-0.0625, -2.96875},
          green = {-0.03125, -2.40625}
        }
      },
      {
        shadow =
        {
          copper = {2.30, -0.1},
          red = {2.65, -0.40},
          green = {1.75, 0.20}
        },
        wire =
        {
          copper = {-0.03125, -2.71875},
          red = {0.3125, -2.875},
          green = {-0.25, -2.5}
        }
      }
    },
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
      width = 12,
      height = 12,
      priority = "extra-high-no-scale"
    }
  },
})