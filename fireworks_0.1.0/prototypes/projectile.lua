
function make_explosion(data)
  return {
    type = "explosion",
    name = "explosion-"..data.name,
    flags = {"not-on-map"},
    animations =
    {
      {
        filename = "__fireworks__/graphics/blank.png",
        priority = "extra-high",
        width = 1,
        height = 1,
        frame_count = 1,
        animation_speed = 1.0/60.0/120.0,
        shift = {0, 0}
      }
    },
    rotate = false,
    light = data.light,
  }
end

function make_flare_projectile(data)
  return {
    type = "projectile",
    name = data.name,
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
          {
            type = "create-entity",
            entity_name = "explosion-"..data.name
          },
        }
      }
    },
    light = data.light,
    animation =
    {
      filename = "__fireworks__/graphics/projectiles/"..data.name..".png",
      frame_count = 1,
      width = 32,
      height = 32,
      priority = "high"
    },
  }
end
function make_firework_projectile(data)
  return {
    type = "projectile",
    name = data.name,
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
          {
            type = "create-entity",
            entity_name = "explosion-"..data.name
          },
        }
      }
    },
    light = data.light,
    animation =
    {
      filename = "__fireworks__/graphics/projectiles/"..data.name..".png",
      frame_count = 1,
      width = 32,
      height = 32,
      priority = "high"
    },
  }
end
