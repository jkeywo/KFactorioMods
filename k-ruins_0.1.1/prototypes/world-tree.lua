-- add data for entities

local _tree_cluster = table.deepcopy( data.raw["tree"]["tree-01"] )
_tree_cluster.name = "tree-cluster"
data:extend(
{
  _tree_cluster,
  {
    type = "item",
    name = "fertiliser",
    icon = "__base__/graphics/icons/green-bush-mini.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "intermediate-product",
    order = "z[fertiliser]",
    stack_size = 100
  },
  {
    type = "recipe",
    name = "fertiliser",
    enabled = true,
    ingredients =
    {
      {type="fluid", name="petroleum-gas", amount=1},
      { "stone", 1 }
    },
    result = "fertiliser",
    category = "chemistry",
  },
  {
    type = "recipe-category",
    name = "restore-world-tree",
  },
  {
    type = "item",
    name = "restored-world-tree",
    icon = "__base__/graphics/icons/tree-05.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ruins",
    order = "b[restored-world-tree]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "restore-world-tree",
    enabled = true,
    ingredients =
    {
      { "fertiliser", 1000 }
    },
    result = "restored-world-tree",
    category = "restore-world-tree"
  },
  {
    type = "assembling-machine",
    name = "world-tree-dead",
    icon = "__base__/graphics/icons/tree-05.png",
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
    vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 0.65 },
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
      filename = "__k-ruins__/graphics/world_tree_dead.png",
      priority = "high",
      width = 464,
      height = 384,
      frame_count = 1,
      line_length = 1,
      shift = {-0.0, -4.5}
    },
    open_sound = { filename = "__base__/sound/wooden-chest-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/wooden-chest-close.ogg", volume = 0.75 },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "1kW",
    crafting_categories = { "restore-world-tree" },
    crafting_speed = 1.0,
    ingredient_count = 1,
  },
  {
    type = "item-subgroup",
    name = "capsules",
    group = "monuments",
    order = "d-b",
  },
  {
    type = "capsule",
    name = "seed-pod",
    icon = "__base__/graphics/icons/tree-01.png",
    flags = {"goes-to-quickbar"},
    capsule_action =
    {
      type = "throw",
      attack_parameters =
      {
        type = "projectile",
        ammo_category = "capsule",
        cooldown = 60,
        projectile_creation_distance = 0.6,
        range = 20,
        ammo_type =
        {
          category = "capsule",
          target_type = "position",
          action =
          {
            type = "direct",
            action_delivery =
            {
              type = "projectile",
              projectile = "tree-seed",
              starting_speed = 0.3
            }
          }
        }
      }
    },
    subgroup = "capsules",
    order = "a[grenade]-a[seed-pod]",
    stack_size = 100
  },
  {
    type = "projectile",
    name = "tree-seed",
    flags = {"not-on-map"},
    acceleration = 0.005,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "create-entity",
          entity_name = "tree-cluster",
          trigger_created_entity = true,
          offsets = {{0, 0}}
        }
      }
    },
    light = {intensity = 0.1, size = 1},
    animation =
    {
      filename = "__base__/graphics/entity/acid-projectile-purple/acid-projectile-purple.png",
      frame_count = 33,
      line_length = 5,
      width = 16,
      height = 18,
      priority = "high"
    },
    shadow =
    {
      filename = "__base__/graphics/entity/acid-projectile-purple/acid-projectile-purple-shadow.png",
      frame_count = 33,
      line_length = 5,
      width = 28,
      height = 16,
      priority = "high"
    },
    smoke = capsule_smoke
  },
  {
    type = "recipe-category",
    name = "air-filter"
  },
  {
    type = "recipe",
    name = "filter-air",
    icon = "__base__/graphics/icons/tree-05.png",
    category = "air-filter",
    subgroup = "ruins-products",
    order = "a[filter-air]",
    energy_required = 25,
    ingredients =
    {
      {"fertiliser", 1}
    },
    results = 
    {
      {type = "item", name = "seed-pod", amount = 1 },
     },
  },
  {
    type = "furnace",
    name = "world-tree",
    icon = "__base__/graphics/icons/tree-05.png",
    flags = {"placeable-neutral"},
    max_health = 1500,
    corpse = "big-remnants",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 0.65 },
    order = "a-b-a",
    animation =
    {
      filename = "__k-ruins__/graphics/world_tree.png",
      priority = "high",
      width = 464,
      height = 384,
      frame_count = 1,
      line_length = 1,
      shift = {-0.0, -4.5}
    },
    open_sound = { filename = "__base__/sound/wooden-chest-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/wooden-chest-close.ogg", volume = 0.75 },
    working_sound =
    {
      sound = { { filename = "__base__/sound/electric-furnace.ogg", volume = 0.7 } },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    crafting_categories = {"air-filter"},
    source_inventory_size = 1,
    result_inventory_size = 1,
    crafting_speed = 1.0,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = -10.0
    },
    energy_usage = "1kW",
    ingredient_count = 1,
    module_slots = 0
  }
})
