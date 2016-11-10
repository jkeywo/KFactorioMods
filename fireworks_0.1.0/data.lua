
require("firework_data")

data:extend({
  -- category
  {
		type = "item-group",
		name = "fireworks",
    icon = "__fireworks__/graphics/blank.png",
		order = "y",
  },  
  {
		type = "item-subgroup",
		name = "fireworks-display",
		group = "fireworks",
		order = "a",
  },
  -- display chest
  {
    type = "item",
    name = "fireworks-display-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    flags = {"goes-to-quickbar"},
    subgroup = "fireworks-display",
    order = "a[items]-c[fireworks-display-chest]",
    place_result = "fireworks-display-chest",
    stack_size = 10
  },
  {
    type = "recipe",
    name = "fireworks-display-chest",
    enabled = false,
    ingredients = {
        {"steel-chest", 1},
        {"advanced-circuit", 1},
      },
    result = "fireworks-display-chest",
    requester_paste_multiplier = 4
  },
  {
    type = "container",
    name = "fireworks-display-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "fireworks-display-chest"},
    max_health = 200,
    corpse = "small-remnants",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    resistances =
    {
      {
        type = "fire",
        percent = 100
      }
    },
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    fast_replaceable_group = "container",
    inventory_size = 30,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture =
    {
      filename = "__base__/graphics/entity/steel-chest/steel-chest.png",
      priority = "extra-high",
      width = 48,
      height = 34,
      shift = {0.1875, 0}
    },
    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0.734375, 0.453125},
        green = {0.609375, 0.515625},
      },
      wire =
      {
        red = {0.40625, 0.21875},
        green = {0.40625, 0.375},
      }
    },
    circuit_connector_sprites = get_circuit_connector_sprites({0.1875, 0.15625}, nil, 18),
    circuit_wire_max_distance = 7.5
  },
})

for _, _colour in pairs(colours) do
  -- order by colour
  data:extend({
    {
      type = "item-subgroup",
      name = "fireworks-".._colour.name,
      group = "fireworks",
      order = "a[".._colour.name.."]",
    },
  })
  
  for _, _firework in pairs(fireworks) do
    local _name = _firework.name.."-".._colour.name
    data:extend({
    {
      -- recipe
      type = "recipe",
      name = _name,
      enabled = true,
      energy_required = 4,
      subgroup = "fireworks-".._colour.name,
      ingredients = _firework.ingredients or { {"grenade", 1}, },
      result = _name
    },
    {
      -- capsule
      type = "capsule",
      name = _name,
      icon = "__fireworks__/graphics/icon/".._name..".png",
      flags = {"goes-to-quickbar"},
      capsule_action =
      {
        type = "throw",
        attack_parameters =
        {
          type = "projectile",
          ammo_category = "capsule",
          cooldown = _firework.cooldown or 30,
          projectile_creation_distance = 0.6,
          range = _firework.range or 50,
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
                projectile = _name,
                starting_speed = _firework.speed or 0.3
              }
            }
          }
        }
      },
      subgroup = "capsule",
      order = "z[".._name.."]",
      stack_size = 100
    }})
    -- stages
    for i = 1, #_firework.stages do
      -- projectile
      local _stage = _firework.stages[i]
      local _stage_name = _name.._stage.suffix
      
      local _action = {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-entity",
              entity_name = "explosion-".._stage_name
            },
          }
        }
      }
      
      if i ~= #_firework.stages then
        local _next_stage_name = _name.._firework.stages[i+1].suffix
        table.insert( _action, 
          {
            type = "cluster",
            cluster_count = _stage.fragments or 8,
            distance = _stage.fragment_distance or 8,
            distance_deviation = 3,
            action_delivery =
            {
              type = "projectile",
              projectile = _next_stage_name,
              direction_deviation = 0.6,
              starting_speed = _stage.fragment_speed or 3,
              starting_speed_deviation = 0.3
            }
          })
      end
      
      data:extend({
        {
          type = "projectile",
          name = _stage_name,
          flags = {"not-on-map"},
          acceleration = 0.05,
          action = _action,
          light = _stage.light,
          animation = _stage.animation or
          {
            filename = "__fireworks__/graphics/projectiles/".._stage_name..".png",
            frame_count = 1,
            width = 64,
            height = 64,
            priority = "high"
          },
        },
        {
          type = "explosion",
          name = "explosion-".._stage_name,
          flags = {"not-on-map"},
          animations =
          {
            {
              filename = "__fireworks__/graphics/blank.png",
              priority = "extra-high",
              width = 1,
              height = 1,
              frame_count = 1,
              animation_speed = 1.0/60.0/_stage.duration,
              shift = {0, 0}
            }
          },
          rotate = false,
          light = _stage.light,
        }
      })
    end      
  end
end

