-- add data for entities
data:extend(
{
  {
    type = "recipe-category",
    name = "restore-obelisk",
  },
  {
    type = "item",
    name = "restored-obelisk",
    icon = "__k-ruins__/graphics/obelisk/obelisk_icon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ruins",
    order = "z[restored-obelisk]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "restore-obelisk",
    enabled = true,
    ingredients =
    {
      { "productivity-module", 5 },
      { "speed-module", 5 },
      { "effectivity-module", 5 },
      { "alien-artifact", 50 }
    },
    result = "restored-obelisk",
    category = "restore-obelisk"
  },
  {
    type = "assembling-machine",
    name = "obelisk-ruined",
    icon = "__k-ruins__/graphics/obelisk/obelisk_icon.png",
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
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    vehicle_impact_sound =  { filename = "__base__/sound/car-stone-impact.ogg", volume = 0.65 },
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
      filename = "__k-ruins__/graphics/obelisk/obelisk_ruined.png",
      priority = "high",
      width = 90,
      height = 90,
      frame_count = 1,
      line_length = 1,
      shift = { 0.875, -0.5625},
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    crafting_categories = { "restore-obelisk" },
    crafting_speed = 1.0,
    ingredient_count = 4,
  },
  {
    type = "beacon",
    name = "obelisk",
    icon = "__k-ruins__/graphics/obelisk/obelisk_icon.png",
    flags = { "placeable-neutral" },
    max_health = 1000,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    allowed_effects = {"consumption", "speed", "pollution"},
    base_picture =
    {
      filename = "__k-ruins__/graphics/blank.png",
      width = 1,
      height = 1,
      shift = { 0.0, 0.0}
    },
    order = "a-b-a",
    animation =
    {
      filename = "__k-ruins__/graphics/obelisk/obelisk.png",
      width = 250,
      height = 184,
      line_length = 8,
      frame_count = 32,
      shift = { 2.0, -1.4375},
      animation_speed = 0.25
    },
    animation_shadow =
    {
      filename = "__k-ruins__/graphics/blank.png",
      width = 1,
      height = 1,
      line_length = 8,
      frame_count = 32,
      shift = { 0.0, -0.0},
      animation_speed = 0.25
    },
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
      width = 12,
      height = 12
    },
    supply_area_distance = 18,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    vehicle_impact_sound =  { filename = "__base__/sound/car-stone-impact.ogg", volume = 0.65 },
    distribution_effectivity = 0.9,
    module_specification =
    {
      module_slots = 2,
      module_info_icon_shift = {0, 0.5},
      module_info_multi_row_initial_height_modifier = -0.3
    }
  },
})
