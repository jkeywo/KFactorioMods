-- add data for entities

data:extend(
{
  {
    type = "recipe-category",
    name = "restore-silo",
  },
  {
    type = "item",
    name = "restored-silo",
    icon = "__base__/graphics/icons/rocket-silo.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ruins",
    order = "z[restored-silo]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "restore-rocket-silo",
    enabled = true,
    ingredients =
    {
      {"steel-plate", 1000},
      {"concrete", 1000},
      {"pipe", 100},
      {"processing-unit", 200},
      {"electric-engine-unit", 200}
    },
    energy_required = 30,
    result = "restored-silo",
    category = "restore-silo"
  },
  {
    type = "assembling-machine",
    name = "rocket-silo-vines",
    icon = "__base__/graphics/icons/rocket-silo.png",
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
    collision_box = {{-4.2, -4.7}, {4.2, 4.7}},
    selection_box = {{-4.5, -5}, {4.5, 5}},
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
      filename = "__k-ruins__/graphics/silo_vines.png",
      priority = "high",
      width = 352,
      height = 384,
      frame_count = 1,
      line_length = 1,
      shift = {0, 0}
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    crafting_categories = { "restore-silo" },
    crafting_speed = 1.0,
    ingredient_count = 5,
  },
})

-- make base rocket recipe very expensive
data.raw["recipe"]["rocket-silo"].ingredients = {
      {"low-density-structure", 100},
      {"rocket-fuel", 100},
      {"rocket-control-unit", 100},
      {"processing-unit", 500},
      {"electric-engine-unit", 500}
    }
