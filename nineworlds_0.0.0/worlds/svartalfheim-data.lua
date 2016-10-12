-- tiles
data:extend(
{
  {
    -- https://wiki.factorio.com/index.php?title=Types/AutoplaceSpecification
    type = "autoplace-control",
    name = "svartalfheim",
    order = "b-e"
	},
	{
    type = "noise-layer",
    name = "svartalfheim-floor",
  },
  {
    type = "tile",
    name = "svartalfheim-floor",
    collision_mask = {"ground-tile"},
    layer = 25,
    autoplace = world_autoplace_settings("svartalfheim", "svartalfheim-floor", {{{35, 0.8}, {0, 0.4}}}),
    variants =
    {
      main =
      {
        {
          picture = "__nineworlds__/graphics/terrain/dirt/dirt1.png",
          count = 22,
          size = 1,
          weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045, 0.005, 0.005, 0.005, 0.005, 0.003, 0.005 }
        },
        {
          picture = "__nineworlds__/graphics/terrain/dirt/dirt2.png",
          count = 30,
          size = 2,
          probability = 1,
          weights = {0.070, 0.070, 0.025, 0.070, 0.070, 0.070, 0.007, 0.025, 0.070, 0.050, 0.015, 0.026, 0.030, 0.005, 0.070, 0.027, 0.022, 0.032, 0.020, 0.020, 0.030, 0.005, 0.010, 0.002, 0.013, 0.007, 0.007, 0.010, 0.030, 0.030 }
        },
        {
          picture = "__nineworlds__/graphics/terrain/dirt/dirt4.png",
          count = 21,
          line_length = 11,
          size = 4,
          probability = 1,
          weights = {0.070, 0.070, 0.070, 0.070, 0.070, 0.070, 0.015, 0.070, 0.070, 0.070, 0.015, 0.050, 0.070, 0.070, 0.065, 0.070, 0.070, 0.050, 0.050, 0.050, 0.050 }
        }
      },
      inner_corner =
      {
        picture = "__nineworlds__/graphics/terrain/dirt/dirt-inner-corner.png",
        count = 8
      },
      outer_corner =
      {
        picture = "__nineworlds__/graphics/terrain/dirt/dirt-outer-corner.png",
        count = 8
      },
      side =
      {
        picture = "__nineworlds__/graphics/terrain/dirt/dirt-side.png",
        count = 8
      }
    },
    walking_sound =
    {
      {
        filename = "__base__/sound/walking/dirt-02.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/dirt-03.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/dirt-04.ogg",
        volume = 0.8
      }
    },
    map_color={r=132, g=91, b=34},
    ageing=0.00045,
    vehicle_friction_modifier = dirt_vehicle_speed_modifier
  },
	{
    type = "noise-layer",
    name = "svartalfheim-wall",
  },
  {
    type = "tile",
    name = "svartalfheim-wall",
    collision_mask =
    {
      "ground-tile",
      "water-tile",
      "resource-layer",
      "floor-layer",
      "item-layer",
      "object-layer",
      "player-layer",
      "doodad-layer"
    },
    layer = 70,
    autoplace = world_blockage_autoplace_settings("svartalfheim", "svartalfheim-wall", 250),
    variants =
    {
      main =
      {
        {
          picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-1.png",
          count = 16,
          size = 1
        },
        {
          picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-2.png",
          count = 4,
          size = 2,
          probability = 0.39,
        },
        {
          picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-4.png",
          count = 4,
          size = 4,
          probability = 1,
        },
      },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/stone-path/stone-path-inner-corner.png",
        count = 8
      },
      outer_corner =
      {
        picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-outer-corner.png",
        count = 1
      },
      side =
      {
        picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-side.png",
        count = 10
      },
      u_transition =
      {
        picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-u.png",
        count = 10
      },
      o_transition =
      {
        picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-o.png",
        count = 10
      }
    },
    walking_sound =
    {
      {
        filename = "__base__/sound/walking/dirt-02.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/dirt-03.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/dirt-04.ogg",
        volume = 0.8
      }
    },
    map_color={r=0, g=0, b=0},
    ageing=0.0006
  },
  {
    type = "noise-layer",
    name = "svartalfheim-wall2",
  },
  {
    type = "tile",
    name = "svartalfheim-wall2",
    collision_mask =
    {
      "ground-tile",
      "water-tile",
      "resource-layer",
      "floor-layer",
      "item-layer",
      "object-layer",
      "player-layer",
      "doodad-layer"
    },
    layer = 70,
    autoplace = world_blockage_autoplace_settings("svartalfheim", "svartalfheim-wall2", 250),
    variants =
    {
      main =
      {
        {
          picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-1.png",
          count = 16,
          size = 1
        },
        {
          picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-2.png",
          count = 4,
          size = 2,
          probability = 0.39,
        },
        {
          picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-4.png",
          count = 4,
          size = 4,
          probability = 1,
        },
      },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/stone-path/stone-path-inner-corner.png",
        count = 8
      },
      outer_corner =
      {
        picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-outer-corner.png",
        count = 1
      },
      side =
      {
        picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-side.png",
        count = 10
      },
      u_transition =
      {
        picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-u.png",
        count = 10
      },
      o_transition =
      {
        picture = "__nineworlds__/graphics/terrain/stone-path/stone-path-o.png",
        count = 10
      }
    },
    walking_sound =
    {
      {
        filename = "__base__/sound/walking/dirt-02.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/dirt-03.ogg",
        volume = 0.8
      },
      {
        filename = "__base__/sound/walking/dirt-04.ogg",
        volume = 0.8
      }
    },
    map_color={r=0, g=0, b=0},
    ageing=0.0006
  }
})

-- minerals
data:extend(
{
  {
    type = "item",
    name = "nw-svarite-ore",
    icon = "__nineworlds__/graphics/icons/angels-ore1.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "world-ores",
    order = "a[nw-svarite-ore]",
    stack_size = 200
  },
	{
    type = "noise-layer",
    name = "nw-svarite-ore"
  },
	{
    type = "resource",
    name = "nw-svarite-ore",
    icon = "__nineworlds__/graphics/icons/angels-ore1.png",
    flags = {"placeable-neutral"},
    order="a-b-a",
    map_color = {r=0.1, g=0.1, b=0.1},
    minable =
    {
      hardness = 1,
      mining_particle = "ne-svarite-particle",
      mining_time = 1.5,
      result = "nw-svarite-ore"
    },
    collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
    autoplace =
    {
      control = "svartalfheim",
      sharpness = 1,
      richness_multiplier = 1500,
      richness_multiplier_distance_bonus = 20,
      richness_base = 500,
      tile_restriction = { "svartalfheim-floor" },
      peaks = 
      {
        {
          noise_layer = "nw-svarite-ore",
          noise_octaves_difference = -1.5,
          noise_persistence = 0.2,
          starting_area_weight_optimal = 0,
          starting_area_weight_range = 0,
          starting_area_weight_max_range = 2,
        },
        {
          influence = -0.4,
          max_influence = 0,
          noise_layer = "nw-svarite-ore",
          noise_octaves_difference = -3,
          noise_persistence = 0.3,
          starting_area_weight_optimal = 0,
          starting_area_weight_range = 0,
          starting_area_weight_max_range = 2,
        },
      },
    },
    stage_counts = {1},
    stages =
    {
      sheet =
      {
        filename = "__nineworlds__/graphics/entity/ore-6-inf.png",
        priority = "extra-high",
        tint = {r=0.80, g=0.30, b=0.39},
        width = 38,
        height = 38,
        frame_count = 8,
        variation_count = 1
      }
    },
  },
  {
    type = "particle",
    name = "ne-svarite-particle",
    flags = {"not-on-map"},
    life_time = 180,
    pictures =
    {
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-1.png",
        priority = "extra-high",
        tint = {r=0.21, g=0.25, b=0.24},
        width = 5,
        height = 5,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-2.png",
        priority = "extra-high",
        tint = {r=0.21, g=0.25, b=0.24},
        width = 7,
        height = 5,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-3.png",
        priority = "extra-high",
        tint = {r=0.21, g=0.25, b=0.24},
        width = 6,
        height = 7,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-4.png",
        priority = "extra-high",
        tint = {r=0.21, g=0.25, b=0.24},
        width = 9,
        height = 8,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-5.png",
        priority = "extra-high",
        tint = {r=0.21, g=0.25, b=0.24},
        width = 5,
        height = 5,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-6.png",
        priority = "extra-high",
        tint = {r=0.21, g=0.25, b=0.24},
        width = 6,
        height = 4,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-7.png",
        priority = "extra-high",
        tint = {r=0.21, g=0.25, b=0.24},
        width = 7,
        height = 8,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-8.png",
        priority = "extra-high",
        tint = {r=0.21, g=0.25, b=0.24},
        width = 6,
        height = 5,
        frame_count = 1
      }
    },
    shadows =
    {
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-shadow-1.png",
        priority = "extra-high",
        width = 5,
        height = 5,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-shadow-2.png",
        priority = "extra-high",
        width = 7,
        height = 5,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-shadow-3.png",
        priority = "extra-high",
        width = 6,
        height = 7,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-shadow-4.png",
        priority = "extra-high",
        width = 9,
        height = 8,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-shadow-5.png",
        priority = "extra-high",
        width = 5,
        height = 5,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-shadow-6.png",
        priority = "extra-high",
        width = 6,
        height = 4,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-shadow-7.png",
        priority = "extra-high",
        width = 7,
        height = 8,
        frame_count = 1
      },
      {
        filename = "__nineworlds__/graphics/entity/particle/ore-particle-shadow-8.png",
        priority = "extra-high",
        width = 6,
        height = 5,
        frame_count = 1
      }
    }
  }
})
