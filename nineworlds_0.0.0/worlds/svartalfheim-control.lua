
local M = {
  name = "Svartalfheim",
	surface = nil,
  links = {}
}

Event.register( Event.core_events.init, function()
	M.surface = game.surfaces["svartalfheim"]
	if M.surface == nil then
    local nauvis = game.surfaces["nauvis"];
   	local map_gen =
    {
      terrain_segmentation = "very-high",
      water = "none",
      autoplace_controls = 
          { 
            ["midgard"] = { frequency = "none", size = "none", richness = "none" },
            ["nidavellir"] = { frequency = "none", size = "none", richness = "none" },
            ["svartalfheim"] = { frequency = "normal", size = "medium", richness = "regular" } ,
            ["iron"] = { frequency = "none", size = "none", richness = "none" },
            ["coal"] = { frequency = "none", size = "none", richness = "none" },
            ["stone"] = { frequency = "none", size = "none", richness = "none" }
          },
      seed = (nauvis and nauvis.map_gen_settings.seed or 0) + 200,
      shift = nauvis and nauvis.map_gen_settings.shift or nil,
      width = nauvis and nauvis.map_gen_settings.width or 0,
      height = nauvis and nauvis.map_gen_settings.height or 0,
      starting_area = "small",
      peaceful_mode = false
    }   
    
		M.surface = game.create_surface( "svartalfheim", map_gen )
	end
end)

Event.register(defines.events.on_tick, function(event)
	if game.surfaces["svartalfheim"] ~= nil then
		game.surfaces["svartalfheim"].daytime = 0.5
	end
end)

Tunnels.access_worlds["svartalfheim"] = M
Worlds["svartalfheim"] = M
return M
