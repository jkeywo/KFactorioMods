
local M = {
  name = "Nidavellir",
	surface = nil,
  links = {}
}

Event.register( Event.core_events.init, function()
	M.surface = game.surfaces["nidavellir"]
	if M.surface == nil then
    local nauvis = game.surfaces["nauvis"];
   	local map_gen =
    {
      terrain_segmentation = "very-high",
      water = "none",
      autoplace_controls = 
      { 
        ["midgard"] = { frequency = "none", size = "none", richness = "none" },
        ["nidavellir"] = { frequency = "normal", size = "medium", richness = "regular" } ,
        ["svartalfheim"] = { frequency = "none", size = "none", richness = "none" } ,
        ["copper"] = { frequency = "none", size = "none", richness = "none" },
        ["coal"] = { frequency = "none", size = "none", richness = "none" },
        ["stone"] = { frequency = "none", size = "none", richness = "none" }
      },
      seed = (nauvis and nauvis.map_gen_settings.seed or 0) + 100,
      shift = nauvis and nauvis.map_gen_settings.shift or nil,
      width = nauvis and nauvis.map_gen_settings.width or 0,
      height = nauvis and nauvis.map_gen_settings.height or 0,
      starting_area = "small",
      peaceful_mode = false
    }   
    
		M.surface = game.create_surface( "nidavellir", map_gen )
	end
end)

Event.register(defines.events.on_tick, function(event)
	if game.surfaces["nidavellir"] ~= nil then
		game.surfaces["nidavellir"].daytime = 0.5
	end
end)

Tunnels.access_worlds["nidavellir"] = M
Worlds["nidavellir"] = M
return M
