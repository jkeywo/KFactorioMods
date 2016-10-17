
require("config")

if Config.enable_default_momuments then
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
      icon = "__k_monuments__/graphics/pyramid_clean.png",
      flags = {"goes-to-main-inventory"},
      subgroup = "environment",
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
      category = { "restore-pyramid" }
    },
    {
      type = "assembling-machine",
      name = "default-pyramid-vines",
      icon = "__k_monuments__/graphics/pyramid_vines.png",
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
        filename = "__k_monuments__/graphics/pyramid_vines.png",
        priority = "high",
        width = 70,
        height = 77,
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
      icon = "__k_monuments__/graphics/pyramid_clean.png",
      flags = { "placeable-neutral" },
      max_health = 1000,
      corpse = "big-remnants",
      dying_explosion = "medium-explosion",
      collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
      selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
      allowed_effects = {"consumption", "speed", "pollution"},
      base_picture =
      {
        filename = "__k_monuments__/graphics/pyramid_clean.png",
        width = 116,
        height = 93,
        shift = { 0.34, 0.06}
      },
      order = "a-b-a",
      animation =
      {
        filename = "__base__/graphics/entity/beacon/beacon-antenna.png",
        width = 54,
        height = 50,
        line_length = 8,
        frame_count = 32,
        shift = { -0.03, -1.72},
        animation_speed = 0.5
      },
      animation_shadow =
      {
        filename = "__base__/graphics/entity/beacon/beacon-antenna-shadow.png",
        width = 63,
        height = 49,
        line_length = 8,
        frame_count = 32,
        shift = { 3.12, 0.5},
        animation_speed = 0.5
      },
      radius_visualisation_picture =
      {
        filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
        width = 48,
        height = 48
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
    {
      type = "recipe-category",
      name = "restore-statue",
    },
    {
      type = "item",
      name = "restored-statue",
      icon = "__k_monuments__/graphics/statue_clean.png",
      flags = {"goes-to-main-inventory"},
      subgroup = "environment",
      order = "z[restored-statue]",
      stack_size = 1
    },
    {
      type = "recipe",
      name = "restore-statue",
      enabled = true,
      ingredients =
      {
        { "productivity-module-2", 10 },
        { "speed-module-2", 10 },
        { "effectivity-module-2", 10 },
        { "alien-artifact", 100 }
      },
      result = "restored-statue",
      category = { "restore-statue" }
    },
    {
      type = "assembling-machine",
      name = "default-statue-vines",
      icon = "__k_monuments__/graphics/statue_vines.png",
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
      collision_box = {{-1.2, -1.9}, {1.2, 1.9}},
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
        filename = "__k_monuments__/graphics/statue_vines.png",
        priority = "high",
        width = 30,
        height = 82,
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
      crafting_categories = { "restore-statue" },
      crafting_speed = 1.0,
      ingredient_count = 4,
    },
    {
      type = "beacon",
      name = "default-statue",
      icon = "__k_monuments__/graphics/statue_clean.png",
      flags = { "placeable-neutral" },
      max_health = 1000,
      corpse = "big-remnants",
      dying_explosion = "medium-explosion",
      collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
      selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
      allowed_effects = {"consumption", "speed", "pollution"},
      base_picture =
      {
        filename = "__k_monuments__/graphics/statue_clean.png",
        width = 116,
        height = 93,
        shift = { 0.34, 0.06}
      },
      order = "a-b-a",
      animation =
      {
        filename = "__base__/graphics/entity/beacon/beacon-antenna.png",
        width = 54,
        height = 50,
        line_length = 8,
        frame_count = 32,
        shift = { -0.03, -1.72},
        animation_speed = 0.5
      },
      animation_shadow =
      {
        filename = "__base__/graphics/entity/beacon/beacon-antenna-shadow.png",
        width = 63,
        height = 49,
        line_length = 8,
        frame_count = 32,
        shift = { 3.12, 0.5},
        animation_speed = 0.5
      },
      radius_visualisation_picture =
      {
        filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
        width = 96,
        height = 96
      },
      supply_area_distance = 24,
      energy_source =
      {
        type = "electric",
        usage_priority = "secondary-input"
      },
      energy_usage = "1kW",
      vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
      distribution_effectivity = 0.7,
      module_specification =
      {
        module_slots = 2,
        module_info_icon_shift = {0, 0.5},
        module_info_multi_row_initial_height_modifier = -0.3
      }
    },
    {
      type = "recipe-category",
      name = "restore-temple",
    },
    {
      type = "item",
      name = "restored-temple",
      icon = "__k_monuments__/graphics/temple_clean.png",
      flags = {"goes-to-main-inventory"},
      subgroup = "environment",
      order = "z[restored-temple]",
      stack_size = 1
    },
    {
      type = "recipe",
      name = "restore-temple",
      enabled = true,
      ingredients =
      {
        { "productivity-module-3", 20 },
        { "speed-module-3", 20 },
        { "effectivity-module-3", 20 },
        { "alien-artifact", 200 }
      },
      result = "restored-temple",
      category = { "restore-temple" }
    },
    {
      type = "assembling-machine",
      name = "default-temple-vines",
      icon = "__k_monuments__/graphics/temple_vines.png",
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
      collision_box = {{-1.9, -1.2}, {1.9, 1.2}},
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
        filename = "__k_monuments__/graphics/temple_vines.png",
        priority = "high",
        width = 73,
        height = 53,
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
      crafting_categories = { "restore-temple" },
      crafting_speed = 1.0,
      ingredient_count = 4,
    },
    {
      type = "beacon",
      name = "default-temple",
      icon = "__k_monuments__/graphics/temple_clean.png",
      flags = { "placeable-neutral" },
      max_health = 1000,
      corpse = "big-remnants",
      dying_explosion = "medium-explosion",
      collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
      selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
      allowed_effects = {"consumption", "speed", "pollution"},
      base_picture =
      {
        filename = "__k_monuments__/graphics/temple_clean.png",
        width = 116,
        height = 93,
        shift = { 0.34, 0.06}
      },
      order = "a-b-a",
      animation =
      {
        filename = "__base__/graphics/entity/beacon/beacon-antenna.png",
        width = 54,
        height = 50,
        line_length = 8,
        frame_count = 32,
        shift = { -0.03, -1.72},
        animation_speed = 0.5
      },
      animation_shadow =
      {
        filename = "__base__/graphics/entity/beacon/beacon-antenna-shadow.png",
        width = 63,
        height = 49,
        line_length = 8,
        frame_count = 32,
        shift = { 3.12, 0.5},
        animation_speed = 0.5
      },
      radius_visualisation_picture =
      {
        filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
        width = 144,
        height = 144
      },
      supply_area_distance = 36,
      energy_source =
      {
        type = "electric",
        usage_priority = "secondary-input"
      },
      energy_usage = "1kW",
      vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
      distribution_effectivity = 0.5,
      module_specification =
      {
        module_slots = 2,
        module_info_icon_shift = {0, 0.5},
        module_info_multi_row_initial_height_modifier = -0.3
      }
    },
  })
end