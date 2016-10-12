local autoplace_utils = require("autoplace_utils")

function world_autoplace_settings(world, noise_layer, rectangles)
  local ret =
  {
    {
      influence = 0.1,
      noise_layer = noise_layer,
      noise_persistence = 0.7,
      octaves_difference = -1
    }
  }

  autoplace_utils.peaks(rectangles, ret)

  return { peaks = ret, control = world }
end

function world_blockage_autoplace_settings(world, noise_layer, from_depth, rectangles)
  local ret =
  {
    {
      influence = 1e3 + from_depth,
      noise_layer = noise_layer,
      elevation_optimal = -5000 - from_depth,
      elevation_range = 5000,
      elevation_max_range = 5000, -- everywhere below elevation 0 and nowhere else
    }
  }

  if rectangles == nil then
    ret[2] = { influence = 1 }
  end

  autoplace_utils.peaks(rectangles, ret)

  return { peaks = ret, control = world }
end

-- technology
data:extend({
  {
    type = "technology",
    name = "nidavellir-access",
    icon = "__nineworlds__/graphics/tech_nif_access.png",
    effects =
    {
      {
          type = "unlock-recipe",
          recipe = "nw-tunnel"
      }
    },
    prerequisites = {},
    unit =
    {
      count = 10,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "svartalfheim-access",
    icon = "__nineworlds__/graphics/tech_nif_access.png",
    prerequisites = {
      "nidavellir-access"
    },
    unit =
    {
      count = 50,
      ingredients =
      {
        {"science-pack-1", 2},
        {"science-pack-2", 1},
      },
      time = 20
    }
  }
})