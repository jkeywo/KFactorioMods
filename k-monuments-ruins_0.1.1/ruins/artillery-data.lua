-- add data for entities
data:extend(
{
  {
    type = "recipe-category",
    name = "restore-pyramid",
  },
  {
    type = "item",
    name = "restored-pyramid",
    icon = "__k-monuments-ruins__/graphics/pyramid_clean.png",
    flags = {"goes-to-main-inventory"},
    order = "z[restored-pyramid]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "restore-pyramid",
    enabled = true,
    ingredients =
    {
      { "productivity-module", 5 },
      { "speed-module", 5 },
      { "effectivity-module", 5 },
      { "alien-artifact", 50 }
    },
    result = "restored-pyramid",
    category = "restore-pyramid"
  },
  {
    type = "assembling-machine",
    name = "default-pyramid-vines",
    icon = "__k-monuments-ruins__/graphics/pyramid_vines.png",
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
    collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
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
      filename = "__k-monuments-ruins__/graphics/pyramid_vines.png",
      priority = "high",
      width = 136,
      height = 103,
      frame_count = 1,
      line_length = 1,
      shift = {0.4, -0.06}
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    crafting_categories = { "restore-pyramid" },
    crafting_speed = 1.0,
    ingredient_count = 4,
  },
  {
    type = "beacon",
    name = "default-pyramid",
    icon = "__k-monuments-ruins__/graphics/pyramid_clean.png",
    flags = { "placeable-neutral" },
    max_health = 1000,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    allowed_effects = {"consumption", "speed", "pollution"},
    base_picture =
    {
      filename = "__k-monuments-ruins__/graphics/pyramid_clean.png",
      width = 136,
      height = 103,
      shift = { 0.34, 0.06}
    },
    order = "a-b-a",
    animation =
    {
      filename = "__k-monuments-ruins__/graphics/restored-anim.png",
      width = 68,
      height = 18,
      line_length = 8,
      frame_count = 32,
      shift = { -0.03, -1.72},
      animation_speed = 0.5
    },
    animation_shadow =
    {
      filename = "__k-monuments-ruins__/graphics/restored-anim-shadow.png",
      width = 68,
      height = 18,
      line_length = 8,
      frame_count = 32,
      shift = { 0.5, -1.2},
      animation_speed = 0.5
    },
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
      width = 12,
      height = 12
    },
    supply_area_distance = 12,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    distribution_effectivity = 0.9,
    module_specification =
    {
      module_slots = 2,
      module_info_icon_shift = {0, 0.5},
      module_info_multi_row_initial_height_modifier = -0.3
    }
  },
})
