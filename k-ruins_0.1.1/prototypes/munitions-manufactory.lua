-- add data for entities
data:extend(
{
  {
    type = "recipe-category",
    name = "restore-munitions-manufactory",
  },
  {
    type = "item",
    name = "restored-munitions-manufactory",
    icon = "__k-ruins__/graphics/manufactory/munitions-manufactory-icon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ruins",
    order = "z[munitions-manufactory]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "restore-munitions-manufactory",
    enabled = true,
    ingredients =
    {
      { "piercing-rounds-magazine", 100 },
      { "alien-artifact", 500 }
    },
    result = "restored-munitions-manufactory",
    category = "restore-munitions-manufactory"
  },
  {
    type = "assembling-machine",
    name = "munitions-manufactory-vines",
    icon = "__k-ruins__/graphics/manufactory/munitions-manufactory-icon.png",
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
      filename = "__k-ruins__/graphics/manufactory/munitions-manufactory-ruined.png",
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
    crafting_categories = { "restore-munitions-manufactory" },
    crafting_speed = 1.0,
    ingredient_count = 2,
  },
  
  {
    type = "recipe-category",
    name = "vanir-ammo",
  },
  {
    type = "ammo",
    name = "vanir-rounds-magazine",
    icon = "__k-ruins__/graphics/manufactory/vanir-ammo-icon.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "bullet",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          source_effects =
          {
              type = "create-explosion",
              entity_name = "explosion-gunshot"
          },
          target_effects =
          {
            {
              type = "create-entity",
              entity_name = "explosion-hit"
            },
            {
              type = "damage",
              damage = { amount = 8, type = "physical"}
            }
          }
        }
      }
    },
    magazine_size = 10,
    subgroup = "ammo",
    order = "a[basic-clips]-b[vanir-rounds-magazine]",
    stack_size = 100
  },
  {
    type = "recipe",
    name = "vanir-rounds-magazine",
    enabled = true,
    ingredients =
    {
      { "piercing-rounds-magazine", 10 },
      { "alien-artifact", 1 }
    },
    result = "vanir-rounds-magazine",
    result_count = 10,
    energy_required = 2,
    category = "vanir-ammo"
  },
  {
    type = "assembling-machine",
    name = "munitions-manufactory",
    icon = "__k-ruins__/graphics/manufactory/munitions-manufactory-icon.png",
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
      filename = "__k-ruins__/graphics/manufactory/munitions-manufactory.png",
      priority = "high",
      width = 182,
      height = 182,
      frame_count = 64,
      line_length = 8,
      shift = {0.4, -0.66}
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    crafting_categories = { "vanir-ammo" },
    crafting_speed = 1.0,
    ingredient_count = 4,
  },
})
