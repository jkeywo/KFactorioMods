

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
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
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

function create_resource(data)
  return {
    type = "resource",
    name = "deep-mine-"..data.name,
    icon = "__k-ruins__/graphics/blank.png",
    flags = {"placeable-neutral"},
    order="a-b-a",
    infinite = true,
    minimum = 100,
    normal = 100,
    minable =
    {
      hardness = 1,
      mining_particle = data.name .. "-particle",
      mining_time = 1,
      result = data.name,
    },
    collision_box = {{ -0.2, -0.2}, {0.2, 0.2}},
    selection_box = {{ -0.2, -0.2}, {0.2, 0.2}},
    stage_counts = {0},
    stages =
    {
      sheet =
      {
        filename = "__k-ruins__/graphics/blank.png",
        priority = "extra-high",
        width = 1,
        height = 1,
        frame_count = 1,
        variation_count = 1
      }
    },
    map_color = {r=0.0, g=0.0, b=0.0},
    map_grid = false
  }
end

data:extend(
{
  create_resource( { name="iron-ore" } ),
  create_resource( { name="copper-ore"} )
})

function create_miner(data)
  return {
    type = "mining-drill",
    name = data.name,
    icon = "__base__/graphics/icons/electric-mining-drill.png",
    flags = {"placeable-neutral"},
    max_health = 300,
    resource_categories = {"basic-solid"},
    order="a-b-a",
    corpse = "big-remnants",
    collision_box = {{ -0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/electric-mining-drill.ogg",
        volume = 0.75
      },
      apparent_volume = 1.5,
    },
    animations =
    {
      north = data.animation,
      east = data.animation,
      south = data.animation,
      west = data.animation
    },
    energy_source =
    {
      type = "electric",
      -- will produce this much * energy pollution units per tick
      emissions = 0.15 / 1.5,
      usage_priority = "secondary-input"
    },
    energy_usage = "45kW",
    mining_speed = 20.0/3.0,
    mining_power = 1,
    resource_searching_radius = 0.49,
    vector_to_place_result = data.vector_to_place_result,
    module_specification =
    {
      module_slots = 3
    },
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
      width = 12,
      height = 12
    },
    fast_replaceable_group = "mining-drill"
    }
end

data:extend(
{
  create_miner(
    {
      name="deep-mine-near-drill",
      animation = {
        priority = "extra-high",
        width = 32,
        height = 32,
        line_length = 1,
        shift = {0.0, -0.0},
        filename = "__base__/graphics/entity/electric-mining-drill/north.png",
        frame_count = 1,
        animation_speed = 0.5,
      },
      vector_to_place_result = {-0.25, -1.1}
    }
  ),
  create_miner(
    {
      name="deep-mine-far-drill",
      animation = {
        priority = "extra-high",
        width = 32,
        height = 32,
        line_length = 1,
        shift = {0.0, -0.0},
        filename = "__base__/graphics/entity/electric-mining-drill/north.png",
        frame_count = 1,
        animation_speed = 0.5,
      },
      vector_to_place_result = {0.25, -2.1}
    }
  ),
})
