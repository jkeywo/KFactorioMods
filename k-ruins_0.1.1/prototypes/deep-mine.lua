

-- add data for entities
data:extend(
{
  {
    type = "recipe-category",
    name = "restore-deep-mine",
  },
  {
    type = "item",
    name = "restored-deep-mine",
    icon = "__k-ruins__/graphics/deep-mine/deep-mine-icon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ruins",
    order = "z[deep-mine]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "restore-deep-mine",
    enabled = true,
    ingredients =
    {
      { "steel-plate", 500 },
      { "advanced-circuit", 100 }
    },
    result = "restored-deep-mine",
    category = "restore-deep-mine"
  },
  {
    type = "assembling-machine",
    name = "deep-mine-ruined",
    icon = "__k-ruins__/graphics/deep-mine/deep-mine-icon.png",
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
    collision_box = {{-2.1, -2.1}, {2.1, 2.1}},
    selection_box = {{-2.4, -2.4}, {2.4, 2.4}},
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
      filename = "__k-ruins__/graphics/deep-mine/deep-mine-ruined.png",
      priority = "high",
      width = 180,
      height = 180,
      frame_count = 1,
      line_length = 1,
      shift = {0.4, -0.66}
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    crafting_categories = { "restore-deep-mine" },
    crafting_speed = 1.0,
    ingredient_count = 2,
  },
  
  {
    type = "assembling-machine",
    name = "deep-mine",
    icon = "__k-ruins__/graphics/deep-mine/deep-mine-icon.png",
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
    collision_box = {{-1.0, -1.0}, {1.0, 1.0}},
    selection_box = {{-2.4, -2.4}, {2.4, 2.4}},
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
      filename = "__k-ruins__/graphics/deep-mine/deep-mine.png",
      priority = "high",
      width = 180,
      height = 180,
      frame_count = 1,
      line_length = 1,
      shift = {0.4, -0.66}
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    crafting_speed = 1.0,
    crafting_categories = { "restore-deep-mine" },
    ingredient_count = 0,
  },
})
