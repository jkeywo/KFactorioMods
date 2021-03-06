
-- add data for entities
data:extend(
{
  {
    type = "recipe-category",
    name = "restore-war-shrine",
  },
  {
    type = "item",
    name = "restored-war-shrine",
    icon = "__k-ruins__/graphics/war-shrine/war-shrine-icon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ruins",
    order = "z[war-shrine]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "restore-war-shrine",
    enabled = true,
    ingredients =
    {
      { "alien-artifact", 1000 }
    },
    result = "restored-war-shrine",
    category = "restore-war-shrine"
  },
  {
    type = "assembling-machine",
    name = "war-shrine-ruined",
    icon = "__k-ruins__/graphics/war-shrine/war-shrine-icon.png",
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
      filename = "__k-ruins__/graphics/war-shrine/war-shrine-ruined.png",
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
    crafting_categories = { "restore-war-shrine" },
    crafting_speed = 1.0,
    ingredient_count = 1,
  },
  {
    type = "tree",
    name = "war-shrine",
    icon = "__base__/graphics/icons/dead-grey-trunk.png",
    flags = {"placeable-neutral"},
    max_health = 1000,
    collision_box = {{-1.6, -1.6}, {1.6, 1.6}},
    selection_box = {{-1.8, -1.8}, {1.8, 1.8}},
    order = "a-b-a",
    vehicle_impact_sound =  { filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0 },
    pictures =
    {
      {
        filename = "__base__/graphics/entity/tree/dead-grey-trunk/dead-grey-trunk-01.png",
        flags = { "mipmap" },
        width = 105,
        height= 96,
        shift = {0.75, -0.46}
      }
    }
  },
})

for i = 0, 3 do
  data:extend({
    {
      type="sprite",
      name="war_shrine_rank_"..i,
      filename = "__k-ruins__/graphics/war-shrine/war_shrine_"..i..".png",
      priority = "extra-high-no-scale",
      width = 32,
      height = 32
    }
  })
end
