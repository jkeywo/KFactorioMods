-- add data for entities
data:extend(
{
  {
    type = "recipe-category",
    name = "restore-steam-geyser",
  },
  {
    type = "item",
    name = "restored-steam-geyser",
    icon = "__k-ruins__/graphics/steam_geyser.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ruins",
    order = "z[restored-steam-geyser]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "restore-steam-geyser",
    enabled = true,
    ingredients =
    {
      { "pumpjack", 10 }
    },
    result = "restored-steam-geyser",
    category = "restore-steam-geyser"
  },
  {
    type = "assembling-machine",
    name = "steam-geyser-bare",
    icon = "__k-ruins__/graphics/steam_geyser.png",
    flags = { "placeable-neutral" },
    max_health = 250,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances =
    {
      {
        type = "fire",
        percent = 70
      }
    },
    order = "a-b-a",
    collision_box = {{-0.0, -0.0}, {0.0, 0.0}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound = {
        {
          filename = "__base__/sound/assembling-machine-t2-1.ogg",
          volume = 0.8
        },
        {
          filename = "__base__/sound/assembling-machine-t2-2.ogg",
          volume = 0.8
        },
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    animation =
    {
      filename = "__k-ruins__/graphics/steam_geyser.png",
      priority = "high",
      width = 96,
      height = 96,
      frame_count = 1,
      line_length = 1,
      shift = {0.0, 0.0}
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    crafting_categories = { "restore-steam-geyser" },
    crafting_speed = 1.0,
    ingredient_count = 4,
  },
  {
    type = "recipe-category",
    name = "steam-pumping",
  },
  {
    type = "recipe",
    name = "steam-pumping",
    enabled = true,
    ingredients = {},
    results = {
      { type="fluid", name="water", amount=60 },
    },
    category = "steam-pumping"
  },
	{
    type = "assembling-machine",
    name = "steam-geyser-pump",
    icon = "__k-ruins__/graphics/steam_geyser_pump.png",
    flags = {"placeable-neutral"},
    max_health = 300,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    crafting_categories = {"steam-pumping"},
    crafting_speed = 1,
    order = "a-b-a",
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.01
    },
    energy_usage = "150kW",
    ingredient_count = 3,
    animation =
    {
      filename = "__k-ruins__/graphics/steam_geyser_pump.png",
      width = 122,
      height = 107,
      frame_count = 1,
      line_length = 1,
      shift = {-0.8, -0.35},
      animation_speed = 0.5
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound = { filename = "__base__/sound/idle1.ogg" },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 2.5,
    },
    fluid_boxes =
    {
      {
        production_type = "output",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 1,
        pipe_connections = {{ type="output", position = {0, 2} }}
      },
    },
    pipe_covers = pipecoverspictures()
  },
})
