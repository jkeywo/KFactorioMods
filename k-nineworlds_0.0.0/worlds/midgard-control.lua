
local M = {
  name = "Midgard",
	surface = nil,
  links = {}
}

Event.register( Event.core_events.init, function()
	M.surface = game.surfaces["midgard"]
	if M.surface == nil then
    local default = game.surfaces["nauvis"].map_gen_settings;
   	local map_gen =
    {
      terrain_segmentation = default and default.terrain_segmentation or "normal",
      water = default and default.water or "normal",
      autoplace_controls = 
      { 
        ["midgard"] = { frequency = "normal", size = "medium", richness = "regular" },
        ["nidavellir"] = { frequency = "none", size = "none", richness = "none" },
        ["svartalfheim"] = { frequency = "none", size = "none", richness = "none" },
        ["crude-oil"] = { frequency = "none", size = "none", richness = "none" }
      },
      seed = default and default.seed or math.random(0, 1000000000),
      shift = default and default.shift or nil,
      width = default and default.width or 0,
      height = default and default.height or 0,
      starting_area = default and default.starting_area or "normal",
      peaceful_mode = default and default.peaceful_mode or false
    }
    
		M.surface = game.create_surface( "midgard", map_gen )
	end
end)

Tunnels.access_worlds["midgard"] = M

Worlds["midgard"] = M
return M
