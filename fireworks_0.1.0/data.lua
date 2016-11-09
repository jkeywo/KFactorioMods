
require("prototypes.capsule")
require("prototypes.projectile")
require("prototypes.recipe")

local _flares = {
    { name="flare-red", light={intensity = 0.8, size = 80, color={r=1.0, g=0.0, b=0.0} } },
    { name="flare-green", light={intensity = 0.8, size = 80, color={r=0.0, g=1.0, b=0.0} } },
    { name="flare-blue", light={intensity = 0.8, size = 80, color={r=0.0, g=0.0, b=1.0} } },
    { name="flare-white", light={intensity = 0.8, size = 80 } }
  }
for _, _data in pairs(_flares) do
  data:extend({
      make_recipe(_data),
      make_capsule(_data),
      make_explosion(_data),
      make_flare_projectile(_data)
    })
end

local _fireworks = {
    { name="firework-red", light={intensity = 0.3, size = 4, color={r=1.0, g=0.0, b=0.0} } },
    { name="firework-green", light={intensity = 0.3, size = 4, color={r=0.0, g=1.0, b=0.0} } },
    { name="firework-blue", light={intensity = 0.3, size = 4, color={r=0.0, g=0.0, b=1.0} } },
    { name="firework-white", light={intensity = 0.3, size = 8 } }
  }
for _, _data in pairs(_fireworks) do
  data:extend({
      make_recipe(_data),
      make_capsule(_data),
      make_explosion(_data),
      make_firework_projectile(_data)
    })
end
